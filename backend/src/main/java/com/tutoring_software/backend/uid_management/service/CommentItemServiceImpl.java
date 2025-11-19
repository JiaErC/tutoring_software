package com.tutoring_software.backend.uid_management.service.impl;

import com.tutoring_software.backend.uid_management.entity.CommentItem;
import com.tutoring_software.backend.uid_management.mapper.CommentItemMapper;
import com.tutoring_software.backend.uid_management.service.CommentItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 评论服务实现类
 */
@Service
public class CommentItemServiceImpl implements CommentItemService {

    @Autowired
    private CommentItemMapper commentItemMapper;
    
    @Override
    public List<CommentItem> getCommentsByTeacherUid(Long teacherUid) {
        return commentItemMapper.selectByTeacherUid(teacherUid);
    }
    
    @Override
    public List<CommentItem> getCommentsByStudentUid(Long studentUid) {
        return commentItemMapper.selectByStudentUid(studentUid);
    }
    
    @Override
    public boolean saveComment(CommentItem commentItem) {
        // 直接使用继承自ServiceImpl的save方法
        return save(commentItem);
    }
}