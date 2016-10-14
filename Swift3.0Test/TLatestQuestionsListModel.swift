//
//  TLatestQuestionsListModel.swift
//  baibianjiajia
//
//  Created by 百变家装002 on 16/8/3.
//  Copyright © 2016年 百变家装001. All rights reserved.
//

import UIKit

class TLatestQuestionsListModel: NSObject {

    /** 标签*/
    var label:JSON = []
    
    /** 用户*/
    var user: JSON = []
    
    /** 创建时间*/
    var creatTimeStr: JSON = []
    
    /** 浏览人数*/
    var browseNumber: JSON = []
    
    /** 标题*/
    var title: JSON = []
    
    /** 问题描述第一条*/
    var firstContent: JSON?
    
    /** 问问描述*/
    var content: JSON = []
    
    /** 回复*/
    var replyNumber: JSON?
    
    /** 问问id*/
    var ID: JSON = []
    
    /** 回答*/
    var questionAnswer: JSON?
   
    /** 内容类型*/
    var ctype: JSON?
    

    class func setValueWithJSON(dataJson:JSON) -> TLatestQuestionsListModel {
        let model = TLatestQuestionsListModel()
        model.label = dataJson["label"]
        model.user = dataJson["user"]
        model.creatTimeStr = dataJson["creatTimeStr"]
        model.browseNumber = dataJson["browseNumber"]
        model.title = dataJson["title"]
        model.firstContent = dataJson["firstContent"]
        model.content = dataJson["content"]
        model.replyNumber = dataJson["replyNumber"]
        model.ID = dataJson["id"]
        model.questionAnswer = dataJson["questionAnswer"]
        model.ctype = dataJson["ctype"]
        return model
    }
    
}
