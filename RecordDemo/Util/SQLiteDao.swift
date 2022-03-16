//
//  SQLiteDao.swift
//  RecordDemo
//
//  Created by Mephisto on 2022/3/15.
//  数据库工具类

import FMDB
import Foundation
import SwiftDate

class SQLiteDao {
    static let share = SQLiteDao()
    private init() {
        connectSQLite()
    }

    /// 数据库
    var db: FMDatabase?

    /// 插入记录 content:打卡内容 date:打卡时间
    func insertRecord(_ content: String, date: Date) -> Bool {
        guard let database = db else {
            return false
        }
        do {
            let date = date.toFormat("yyyy-MM-dd HH:mm:ss")
            try database.executeUpdate("insert into record (content, creatDate) values (?, ?)", values: [content, date])
            return true
        } catch {
            print("failed: \(error.localizedDescription)")
            return false
        }
    }

    /// 根据日期查询打卡记录
    func queryRecord(_ date: Date) -> [Record] {
        guard let database = db else {
            return []
        }

        let queryDate = date.toFormat("yyyy-MM-dd")
        var list = [Record]()
        do {
            let sql = "select * from record where creatDate>=datetime('\(queryDate)','start of day','+0 day') and creatDate<datetime('\(queryDate)','start of day','+1 day')"
            let rs = try database.executeQuery(sql, values: nil)
            while rs.next() {
                let id = rs.long(forColumn: "id")
                if let content = rs.string(forColumn: "content"),
                   let creatDate = rs.string(forColumn: "creatDate")
                {
                    let record = Record(id: id, content: content, dateStr: creatDate)
                    list.append(record)
                }
            }
        } catch {
            print("select failed: \(error.localizedDescription)")
        }
        return list
    }

    /// 删除打卡数据
    func deleteRecord(id: Int) {
        guard let database = db else {
            return
        }
        do {
            try database.executeUpdate("delete from record where id=\(id)", values: nil)
        } catch {}
    }

    /// 查询连续打卡天数， 历史最高连续打卡天数，返回结果(续打卡天数, 历史最高连续打卡天数)
    func queryContinuousCount() -> (Int, Int) {
        guard let database = db else {
            return (0, 0)
        }

        do {
            let sql = """
              select day_cha,
                  count(strftime('%Y-%m-%d', creatDate)) flag_days
              from (
                      select creatDate,
                          date_rank,
                          (strftime('%d', creatDate) - date_rank) as day_cha
                      from (
                              select strftime('%Y-%m-%d', creatDate) as creatDate,
                                  row_number() over(
                                      order by creatDate
                                  ) date_rank
                              from record
                              group by creatDate
                          ) t1
                  ) t2
              group by day_cha
            """
            let rs = try database.executeQuery(sql, values: nil)

            var list = [Continuous]()
            while rs.next() {
                let day_cha = rs.long(forColumn: "day_cha")
                let flag_days = rs.long(forColumn: "flag_days")
                let model = Continuous(diffDay: day_cha, flag: flag_days)
                list.append(model)
            }

            let continuousDay = list.max { $0.diffDay < $1.diffDay }
            let maxFlag = list.max { $0.flag < $1.flag }

            print("last count==>\(continuousDay?.flag), maxCount==>\(maxFlag?.flag)")
            return (continuousDay?.flag ?? 0, maxFlag?.flag ?? 0)
        } catch {
            print("query statistic fail")
            return (0, 0)
        }
    }

    // 查询总打卡数， 总打卡天数
    // 返回结果 (总打卡数,总打卡天数)
    func queryTotalData() -> (Int, Int) {
        guard let database = db else {
            return (0, 0)
        }

        do {
            let countSql = "select count(*) count from record"
            let daySql = "select  strftime('%Y-%m-%d',creatDate) days from record GROUP BY days"
            let rs = try database.executeQuery(countSql, values: nil)
            let rs2 = try database.executeQuery(daySql, values: nil)

            var count = 0
            var days = [Int]()
            while rs.next() {
                count = rs.long(forColumn: "count")
            }
            while rs2.next() {
                let dayCount = rs2.long(forColumn: "days")
                days.append(dayCount)
            }
            print("count, days==>\(count),\(days)")
            return (count, days.count)
        } catch {
            print("queryTotalData fail")
            return (0, 0)
        }
    }
}

//: MARK - 数据库建立连接，创建表
extension SQLiteDao {
    private func connectSQLite() {
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let path = "\(filePath)/db.sqlite3"
        print("path==>\(path)")
        let database = FMDatabase(path: path)
        db = database

        guard database.open() else {
            print("Unable to open database")
            return
        }

        do {
            let sql = """
            CREATE TABLE IF NOT EXISTS `record`(
               `id` INTEGER PRIMARY KEY NOT NULL,
               `content` TEXT,
               `creatDate` TEXT
            );
            """
            try database.executeUpdate(sql, values: nil)
        } catch {}
    }
}
