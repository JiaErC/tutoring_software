package com.tutoring_software.backend.uid_management.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tutoring_software.backend.uid_management.entity.TSRelationship;

@Mapper
public interface TSRelationshipMapper extends BaseMapper<TSRelationship> {
    
    /**
     * 根据学生UID查询师生关系
     * @param studentUid 学生的UID
     * @return 该学生的所有师生关系列表
     */
    @Select("SELECT * FROM teacher_student_relationship WHERE student_uid = #{studentUid}")
    List<TSRelationship> selectByStudentUid(Long studentUid);
    
    /**
     * 根据老师UID查询师生关系
     * @param teacherUid 老师的UID
     * @return 该老师的所有师生关系列表
     */
    @Select("SELECT * FROM teacher_student_relationship WHERE teacher_uid = #{teacherUid}")
    List<TSRelationship> selectByTeacherUid(Long teacherUid);
    
    /**
     * 根据学生UID和老师UID查询特定师生关系
     * @param studentUid 学生的UID
     * @param teacherUid 老师的UID
     * @return 特定的师生关系，如果不存在则返回null
     */
    @Select("SELECT * FROM teacher_student_relationship WHERE student_uid = #{studentUid} AND teacher_uid = #{teacherUid}")
    TSRelationship selectByStudentAndTeacherUid(Long studentUid, Long teacherUid);
    
    /**
     * 根据学生UID和老师UID删除师生关系
     * @param studentUid 学生的UID
     * @param teacherUid 老师的UID
     * @return 删除的记录数
     */
    @Delete("DELETE FROM teacher_student_relationship WHERE student_uid = #{studentUid} AND teacher_uid = #{teacherUid}")
    int deleteByStudentAndTeacherUid(Long studentUid, Long teacherUid);
}