package com.tutoring_software.backend.uid_management.service;

import com.tutoring_software.backend.uid_management.entity.CommentItem;
import java.util.List;

/**
 * 评论服务接口
 */
public interface CommentItemService {
    
    /**
     * 根据老师UID查询评论列表
     * @param teacherUid 老师的UID
     * @return 该老师收到的所有评论列表
     */
    List<CommentItem> getCommentsByTeacherUid(Long teacherUid);
    
    /**
     * 根据学生UID查询评论列表
     * @param studentUid 学生的UID
     * @return 该学生发出的所有评论列表
     */
    List<CommentItem> getCommentsByStudentUid(Long studentUid);
    
    /**
     * 保存评论
     * @param commentItem 评论对象
     * @return 保存成功返回true，否则返回false
     */
    boolean saveComment(CommentItem commentItem);
}