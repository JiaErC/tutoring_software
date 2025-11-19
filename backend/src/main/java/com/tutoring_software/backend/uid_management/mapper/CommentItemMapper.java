package com.tutoring_software.backend.uid_management.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import com.tutoring_software.backend.uid_management.entity.CommentItem;
import java.util.List;

@Mapper
public interface CommentItemMapper extends BaseMapper<CommentItem> {
    //你需要完成的是根据老师UID查询评论的功能
    /**
     * 根据老师UID查询评论列表
     * @param teacherUid 老师的UID
     * @return 该老师收到的所有评论列表
     */
    @Select("SELECT * FROM comments WHERE teacher_uid = #{teacherUid}")
    List<CommentItem> selectByTeacherUid(Long teacherUid);
    //接下来根据学生的UID来查询评论的功能
    /**
     * 根据学生UID查询评论列表
     * @param studentUid 学生的UID
     * @return 该学生发出的所有评论列表
     */
    @Select("SELECT * FROM comments WHERE student_uid = #{studentUid}")
    List<CommentItem> selectByStudentUid(Long studentUid);
}