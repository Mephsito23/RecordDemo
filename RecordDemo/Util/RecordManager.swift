//
//  RecordManager.swift
//  RecordDemo
//
//  Created by Mephisto on 2022/3/16.
//  打卡记录查询管理类

import Foundation

class RecordManager {
    static let share = RecordManager()
    private init() {}
    
    /// 根据日期查询数据
    func queryRecordList(date: Date) -> QueryModel {
        // 查询当前日期列表
        let list = SQLiteDao.share.queryRecord(date)
        // 查询打卡总数数据
        let (count, days) = SQLiteDao.share.queryTotalData()
        // 查询连续打卡数据
        let (continuousDay, maxContinuousDay) = SQLiteDao.share.queryContinuousCount()
        
        return QueryModel(totalCount: count,
                          totalDays: days,
                          continuousDays: continuousDay,
                          maxContinuousDays: maxContinuousDay,
                          list: list)
    }
    
    /// 添加打卡数据
    func insertRecord(content: String, date: Date) -> QueryModel {
        SQLiteDao.share.insertRecord(content, date: date)
        return queryRecordList(date: date)
    }
    
    /// 删除打卡数据
    func deleteRecord(id: Int, date: Date) -> QueryModel {
        SQLiteDao.share.deleteRecord(id: id)
        return queryRecordList(date: date)
    }
}
