package com.tutoring_software.backend.uid_management.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.tutoring_software.backend.uid_management.entity.TSRelationship;
import com.tutoring_software.backend.uid_management.mapper.TSRelationshipMapper;

/**
 * 师生关系服务实现类
 */
@Service
public class TSRelationshipServiceImpl extends ServiceImpl<TSRelationshipMapper, TSRelationship> implements TSRelationshipService {

    @Autowired
    private TSRelationshipMapper tsRelationshipMapper;
    
    @Override
    public boolean saveRelationship(TSRelationship tsRelationship) {
        // 先检查关系是否已存在
        TSRelationship existing = tsRelationshipMapper.selectByStudentAndTeacherUid(
            tsRelationship.getStudentUid(), 
            tsRelationship.getTeacherUid()
        ); 
        if (existing != null) {
            // 关系已存在，返回成功
            return true;
        }  
        // 使用继承自ServiceImpl的save方法保存新关系
        return save(tsRelationship);
    }
    
    @Override
    public boolean deleteRelationship(Long studentUid, Long teacherUid) {
        // 调用mapper的删除方法
        int result = tsRelationshipMapper.deleteByStudentAndTeacherUid(studentUid, teacherUid);
        // 返回是否成功删除（删除记录数大于0表示成功）
        return result > 0;
    }
    
    @Override
    public List<TSRelationship> selectByStudentUid(Long studentUid) {
        return tsRelationshipMapper.selectByStudentUid(studentUid);
    }
    
    @Override
    public List<TSRelationship> selectByTeacherUid(Long teacherUid) {
        return tsRelationshipMapper.selectByTeacherUid(teacherUid);
    }
    
    @Override
    public TSRelationship selectByStudentAndTeacherUid(Long studentUid, Long teacherUid) {
        return tsRelationshipMapper.selectByStudentAndTeacherUid(studentUid, teacherUid);
    }
}