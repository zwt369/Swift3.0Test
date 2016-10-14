//
//  CacheDataManageTool.swift
//  Swift3.0Test
//
//  Created by 百变家装002 on 16/10/13.
//  Copyright © 2016年 百变家装002. All rights reserved.
//

import UIKit

let questionDataManage = CacheDataManageTool()

class CacheDataManageTool: NSObject {

    /** dataBase*/
    var dataBase:FMDatabase?
    
    override init () {
        let path = "\(NSHomeDirectory())/Library/Caches/Data.db"
        print("+++++++++++\(path)")
        dataBase = FMDatabase(path: path)
        dataBase?.open()
    }
    
    /**
     数据库存储数据
     */
      func saveCacheData(data:Dictionary<String,AnyObject>)  {
        dataBase?.executeStatements(" create table if not exists table0 (id integer primary key  not null,itemDict blob NOT NULL,idStr text NOT NULL)")
        dataBase?.executeStatements("create unique index IX_GoodsMade_Labour on table0(idStr)")
        let dataCode = NSKeyedArchiver.archivedData(withRootObject: data)
        do {
            try dataBase?.executeUpdate("replace into table0 (itemDict, idStr) VALUES (?, ?)", values: [dataCode,data["questionID"]!])
        }catch{}
    }
    
    func getData() -> Array<TLatestQuestionsListViewModel> {
//        NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM t_item LIMIT %lu, %lu",range.location, range.length];
//        FMResultSet *set = [_db executeQuery:SQL];
//        NSMutableArray *list = [NSMutableArray array];
//        
//        while (set.next) {
//            // 获得当前所指向的数据
//            
//            NSData *dictData = [set objectForColumnName:@"itemDict"];
//            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:dictData];
//            [list addObject:[Item mj_objectWithKeyValues:dict]];
//        }
//        return list;
        var array:Array<TLatestQuestionsListViewModel> = Array()
        let searchSql = "SELECT * FROM table0"
        let resultSet = dataBase?.executeQuery(searchSql, withArgumentsIn: [""])
        while resultSet?.next() == true {
            let data = resultSet?.object(forColumnName: "itemDict")
            let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! Dictionary<String,AnyObject>
            let viewModel = TLatestQuestionsListViewModel()
            viewModel.setValueWithDictionary(dictionray: dictionary)
            array.append(viewModel)
        }
        return array
    }
    
    
}
