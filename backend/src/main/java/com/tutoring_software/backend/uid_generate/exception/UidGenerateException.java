package com.tutoring_software.backend.uid_generate.exception;

import java.io.Serial;

public class UidGenerateException extends RuntimeException{
    //序列化版本标识符，用于确保序列化和反序列化的版本兼容性
    @Serial
    private static final long serialVersionUID = -27048199131316992L;

    //父类无参构造方法
    public UidGenerateException() {
        super();
    }

    //带错误消息和原因的构造函数
    public UidGenerateException(String message, Throwable cause) {
        super(message, cause);
    }

    //支持带有错误消息的构造函数
    public UidGenerateException(String message) {
        super(message);
    }

    //支持消息格式化的构造函数
    public UidGenerateException(String msgFormat, Object... args) {
        super(String.format(msgFormat, args));
    }

    //仅仅带有异常原因的构造函数
    public UidGenerateException(Throwable cause) {
        super(cause);
    }

}
