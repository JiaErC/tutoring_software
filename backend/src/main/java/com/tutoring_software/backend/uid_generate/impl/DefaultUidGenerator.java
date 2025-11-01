package com.tutoring_software.backend.uid_generate.impl;

import java.util.Date;
import java.util.concurrent.TimeUnit;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.apache.commons.lang3.StringUtils;

import com.tutoring_software.backend.uid_generate.UidGenerator;
import com.tutoring_software.backend.uid_generate.exception.UidGenerateException;
import com.tutoring_software.backend.uid_generate.BitsAllocator;
import com.tutoring_software.backend.uid_generate.worker.WorkerIdAssigner;
import com.tutoring_software.backend.uid_generate.utils.UidDateUtils;

public class DefaultUidGenerator implements UidGenerator, InitializingBean {
    private static final Logger LOGGER = LoggerFactory.getLogger(DefaultUidGenerator.class);

    //时间位数、工作区位数、序列位数
    protected int timeBits = 28;
    protected int workerBits = 22;
    protected int seqBits = 13;

    //时间戳计算
    protected String epochStr = "2016-05-20";
    protected long epochSeconds = TimeUnit.MILLISECONDS.toSeconds(1463673600000L);

    //位分配器和工作节点
    protected BitsAllocator bitsAllocator;
    protected long workerId;

    //序列号和上次生成ID的时间戳(秒)
    protected long sequence = 0L;
    protected long lastSecond = -1L;

    //工作节点ID分配器，Spring注入
    protected WorkerIdAssigner workerIdAssigner;

    @Override
    public void afterPropertiesSet() throws Exception {
        //初始化位分配器
        bitsAllocator = new BitsAllocator(timeBits, workerBits, seqBits);

        //初始化工作节点ID
        workerId = workerIdAssigner.assignWorkerId();
        if (workerId > bitsAllocator.getMaxWorkerId()) {
            throw new RuntimeException("Worker id " + workerId + " exceeds the max " + bitsAllocator.getMaxWorkerId());
        }

        LOGGER.info("初始化位分配器(1, {}, {}, {}) 作为工作节点ID:{}", timeBits, workerBits, seqBits, workerId);
    }

    //重写getUID()方法，获取下一个ID
    @Override
    public long getUID() throws UidGenerateException {
        try {
            return nextId();
        } catch (Exception e) {
            LOGGER.error("产生唯一一个ID失败 ", e);
            throw new UidGenerateException(e);
        }
    }
    //重写parseUID()方法，解析ID
    @Override
    public String parseUID(long uid) {
        long totalBits = BitsAllocator.TOTAL_BITS;
        long signBits = bitsAllocator.getSignBits();
        long timestampBits = bitsAllocator.getTimestampBits();
        long workerIdBits = bitsAllocator.getWorkerIdBits();
        long sequenceBits = bitsAllocator.getSequenceBits();

        //解析UID
        long sequence = (uid << (totalBits - sequenceBits)) >>> (totalBits - sequenceBits);
        long workerId = (uid << (timestampBits + signBits)) >>> (totalBits - workerIdBits);
        long deltaSeconds = uid >>> (workerIdBits + sequenceBits);

        Date thatTime = new Date(TimeUnit.SECONDS.toMillis(epochSeconds + deltaSeconds));
        String thatTimeStr = UidDateUtils.formatByDateTimePattern(thatTime);

        //使用JSON格式返回解析结果
        return String.format("{\"UID\":\"%d\",\"timestamp\":\"%s\",\"workerId\":\"%d\",\"sequence\":\"%d\"}",
                uid, thatTimeStr, workerId, sequence);
    }

    //寻找下一个 ID
    protected synchronized long nextId() {
        //获取当前时间戳
        long currentSecond = getCurrentSecond();
        // 处理时钟回拨异常
        if (currentSecond < lastSecond) {
            long refusedSeconds = lastSecond - currentSecond;
            throw new UidGenerateException("Clock moved backwards. Refusing for %d seconds", refusedSeconds);
        }
        // 同一秒内递增序列号，达到阈值则等待下一秒，否则重置为0
        if (currentSecond == lastSecond) {
            sequence = (sequence + 1) & bitsAllocator.getMaxSequence();
            // 等待下一秒
            if (sequence == 0) {
                currentSecond = getNextSecond(lastSecond);
            }
            // 在不同的秒内，序列号重置为0
        } else {
            sequence = 0L;
        }
        lastSecond = currentSecond;
        // 分配UID
        return bitsAllocator.allocate(currentSecond - epochSeconds, workerId, sequence);
    }

    //获取下一个可用秒数，处理序列号溢出情况
    private long getNextSecond(long lastTimestamp) {
        long timestamp = getCurrentSecond();
        while (timestamp <= lastTimestamp) {
            timestamp = getCurrentSecond();
        }
        return timestamp;
    }

    //获取当前时间戳(秒)，检查是否超出时间位数限制
    private long getCurrentSecond() {
        long currentSecond = TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis());
        if (currentSecond - epochSeconds > bitsAllocator.getMaxDeltaSeconds()) {
            throw new UidGenerateException("Timestamp bits is exhausted. Refusing UID generate. Now: " + currentSecond);
        }
        return currentSecond;
    }

    //设置工作节点ID分配器
    public void setWorkerIdAssigner(WorkerIdAssigner workerIdAssigner) {
        this.workerIdAssigner = workerIdAssigner;
    }

    //设置时间位数
    public void setTimeBits(int timeBits) {
        if (timeBits > 0) {
            this.timeBits = timeBits;
        }
    }

    //设置工作节点位数
    public void setWorkerBits(int workerBits) {
        if (workerBits > 0) {
            this.workerBits = workerBits;
        }
    }

    //设置序列号位数
    public void setSeqBits(int seqBits) {
        if (seqBits > 0) {
            this.seqBits = seqBits;
        }
    }

    //设置纪元时间字符串
    public void setEpochStr(String epochStr) {
        if (StringUtils.isNotBlank(epochStr)) {
            this.epochStr = epochStr;
            this.epochSeconds = TimeUnit.MILLISECONDS.toSeconds(UidDateUtils.parseByDayPattern(epochStr).getTime());
        }
    }
}
