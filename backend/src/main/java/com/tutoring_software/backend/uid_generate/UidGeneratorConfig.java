package com.tutoring_software.backend.uid_generate;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import com.tutoring_software.backend.uid_generate.UidGenerator;
import com.tutoring_software.backend.uid_generate.impl.DefaultUidGenerator;
import com.tutoring_software.backend.uid_generate.worker.WorkerIdAssigner;

@Configuration
public class UidGeneratorConfig {

    @Bean
    public UidGenerator uidGenerator(WorkerIdAssigner workerIdAssigner) {
        DefaultUidGenerator uidGenerator = new DefaultUidGenerator();
        uidGenerator.setWorkerIdAssigner(workerIdAssigner);
        // 可以根据需要调整位分配策略
        uidGenerator.setTimeBits(28);    // 时间位数
        uidGenerator.setWorkerBits(22);  // 工作节点位数
        uidGenerator.setSeqBits(13);     // 序列号位数
        uidGenerator.setEpochStr("2024-01-01"); // 设置纪元时间
        return uidGenerator;
    }
}