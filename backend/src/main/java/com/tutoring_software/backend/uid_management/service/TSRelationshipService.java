package com.tutoring_software.backend.uid_management.service;

import java.util.List;

import com.tutoring_software.backend.uid_management.entity.TSRelationship;

/**
 * 师生关系服务接口
 */
public interface TSRelationshipService {
    
    /**
     * 保存师生关系
     * @param tsRelationship 师生关系对象
     * @return 保存成功返回true，否则返回false
     */
    boolean saveRelationship(TSRelationship tsRelationship);
    
    /**
     * 根据学生UID和老师UID删除师生关系
     * @param studentUid 学生的UID
     * @param teacherUid 老师的UID
     * @return 删除成功返回true，否则返回false
     */
    boolean deleteRelationship(Long studentUid, Long teacherUid);
    
    /** 
     * 根据学生UID查询师生关系 
     * @param studentUid  学生的UID 
     * @return  该学生的所有师生关系列表 
     */ 
    List<TSRelationship> selectByStudentUid(Long studentUid); 
    
    /** 
     * 根据老师UID查询师生关系 
     * @param teacherUid  老师的UID 
     * @return  该老师的所有师生关系列表 
     */ 
    List<TSRelationship> selectByTeacherUid(Long teacherUid); 
    
    /** 
     * 根据学生UID和老师UID查询特定师生关系 
     * @param studentUid  学生的UID 
     * @param teacherUid  老师的UID 
     * @return  特定的师生关系，如果不存在则返回null 
     */ 
    TSRelationship selectByStudentAndTeacherUid(Long studentUid, Long teacherUid);
}