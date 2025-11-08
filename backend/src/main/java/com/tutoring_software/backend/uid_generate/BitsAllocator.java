package com.tutoring_software.backend.uid_generate;

/*这个类的基本信息
* 用途：用于分配和管理64位UID的各个组成部分呢
* 位分配策略：符号位(1位)->时间戳->工作节点ID->序列号
* */

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.springframework.util.Assert;

public class BitsAllocator {

    //总位数，固定为64位
    public static final int TOTAL_BITS = 1<<6;

    //符号位数，1位。时间戳位数，工作节点ID位数，序列号位数(这三个都由构造函数传入)
    private int signBits = 1;
    private final int timestampBits;
    private final int workerIdBits;
    private final int sequenceBits;

    //最大值计算，最大时间戳值，最大工作节点ID值，最大序列号值
    private final long maxDeltaSeconds;
    private final long maxWorkerId;
    private final long maxSequence;

    //位移计算，时间戳左移位数，工作节点ID左移位数
    private final int timestampShift;
    private final int workerIdShift;

    //构造函数
    public BitsAllocator(int timestampBits, int workerIdBits, int sequenceBits) {
        // 验证总位数必须等于64位
        int allocateTotalBits = signBits + timestampBits + workerIdBits + sequenceBits;
        Assert.isTrue(allocateTotalBits == TOTAL_BITS, "allocate not enough 64 bits");

        // 初始化各部分位数
        this.timestampBits = timestampBits;
        this.workerIdBits = workerIdBits;
        this.sequenceBits = sequenceBits;

        // 计算各部分最大值
        this.maxDeltaSeconds = ~(-1L << timestampBits);
        this.maxWorkerId = ~(-1L << workerIdBits);
        this.maxSequence = ~(-1L << sequenceBits);

        // i初始化位移量
        this.timestampShift = workerIdBits + sequenceBits;
        this.workerIdShift = sequenceBits;
    }

    //将时间戳、工作节点、序列号组合成64位UID
    public long allocate(long deltaSeconds, long workerId, long sequence) {
        return (deltaSeconds << timestampShift) | (workerId << workerIdShift) | sequence;
    }

    //getter方法
    public int getSignBits() {
        return signBits;
    }
    public int getTimestampBits() {
        return timestampBits;
    }
    public int getWorkerIdBits() {
        return workerIdBits;
    }
    public int getSequenceBits() {
        return sequenceBits;
    }
    public long getMaxDeltaSeconds() {
        return maxDeltaSeconds;
    }
    public long getMaxWorkerId() {
        return maxWorkerId;
    }
    public long getMaxSequence() {
        return maxSequence;
    }
    public int getTimestampShift() {
        return timestampShift;
    }
    public int getWorkerIdShift() {
        return workerIdShift;
    }

    //重写toString方法()
    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.SHORT_PREFIX_STYLE);
    }
}
