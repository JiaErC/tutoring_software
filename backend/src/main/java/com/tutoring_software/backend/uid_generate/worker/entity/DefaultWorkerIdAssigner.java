package com.tutoring_software.backend.uid_generate.worker.entity;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.tutoring_software.backend.uid_generate.worker.WorkerIdAssigner;

@Component
public class DefaultWorkerIdAssigner implements WorkerIdAssigner {
    private static final Logger LOGGER = LoggerFactory.getLogger(DefaultWorkerIdAssigner.class);

    // 固定的工作节点ID，单机环境下可以使用固定值
    private static final long WORKER_ID = 1L;

    @Override
    public long assignWorkerId() {
        LOGGER.info("Assigned worker ID: {}", WORKER_ID);
        return WORKER_ID;
    }
}