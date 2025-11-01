package com.tutoring_software.backend.uid_generate;

import com.tutoring_software.backend.uid_generate.exception.UidGenerateException;

public interface UidGenerator {
    //获取一个唯一的ID
    long getUID() throws UidGenerateException;

    //将生成的UID解析为构成元素的详细信息
    String parseUID(long uid);

}
