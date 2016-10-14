//
//  TLatestQuestionsListViewModel.swift
//  baibianjiajia
//
//  Created by 百变家装002 on 16/8/3.
//  Copyright © 2016年 百变家装001. All rights reserved.
//

import UIKit

class TLatestQuestionsListViewModel: NSObject {

    /** model*/
    var model: TLatestQuestionsListModel?
    
    /** 问问回复*/
    var replyContent: Dictionary<String,AnyObject>?
  
    override init() {
        super.init()
    }
    
    
    init(model:TLatestQuestionsListModel) {
        self.model = model
        //用户
        if model.user["nickName"] != nil {
            userNameStr = model.user["nickName"].stringValue
        }else{
            userNameStr = "侠名"
        }
       
        if model.user["headUrl"] != nil{
            headImageURL = NSURL(string: model.user["headUrl"].stringValue)
        }
        timeStr = model.creatTimeStr.stringValue
        let textStr = model.content.stringValue
        var contentArray:Array<Dictionary<String,AnyObject>> = Array()
        let data:NSData = textStr.data(using: String.Encoding.utf8)! as NSData
        do {
            contentArray  = try JSONSerialization.jsonObject(with: data as Data, options: .mutableLeaves) as! Array<Dictionary<String,AnyObject>>
        } catch {
            let dict = ["text":textStr,"type":"text"]
            contentArray.append(dict as [String : AnyObject])
        }
        let dictionary = contentArray.first
        replyContent = ["content":dictionary! as AnyObject,"likeNumber":model.questionAnswer!["likeNumber"].stringValue as AnyObject]
        for item:Dictionary<String,AnyObject> in contentArray {
            let urlStr = item["type"]!
            if urlStr as! String == "image" {
               questionImageURL = NSURL(string: item["content"]! as! String)
//                if item["HtoW"] != nil {
//                     htow = CGFloat(Float(item["HtoW"]! as! String)!)
//                }else{
//                     htow = CGFloat(131/360)
//                }
                break
            }
        }
        qustionStr = model.title.stringValue
        let array = model.label.arrayValue
        var string = ""
        for labelJson:JSON in array {
            string += labelJson["label"].stringValue + " | "
        }
        markStr = string.substring(to: string.index(string.endIndex, offsetBy: -2))
        browseNum = String(model.browseNumber.intValue)
        questionID = model.ID.intValue
        if model.questionAnswer != nil {
            let dic = model.questionAnswer!.dictionaryValue
            answerID = dic["id"]?.intValue
            if let diction = dic["content"]?.stringValue {
                var contentArray:Array<Dictionary<String,String>> = Array()
                let data:NSData = diction.data(using: String.Encoding.utf8)! as NSData
                do {
                    contentArray  = try JSONSerialization.jsonObject(with: data as Data, options: .mutableLeaves) as! Array<Dictionary<String,String>>
                } catch {
                    let dict = ["text":diction]
                    contentArray.append(dict)
                }
                let dictionary = contentArray.first
                replyContent = ["content":dictionary! as AnyObject,"likeNumber":model.questionAnswer!["likeNumber"].stringValue as AnyObject]
            }
        }
    }
    
    func transViewModelToDictionary() -> Dictionary<String,AnyObject> {
        var dictionary:Dictionary<String,AnyObject> = Dictionary()
        if headImageURL != nil {
            dictionary.updateValue(headImageURL! as AnyObject, forKey: "headImageURL")
        }
        if questionImageURL != nil {
             dictionary.updateValue(questionImageURL! as AnyObject, forKey: "questionImageURL")
        }
        if answerID != nil {
            dictionary.updateValue(answerID! as AnyObject, forKey: "headImageURL")
        }
        dictionary.updateValue(userNameStr as AnyObject, forKey: "userNameStr")
        dictionary.updateValue(timeStr as AnyObject, forKey: "timeStr")
        dictionary.updateValue(qustionStr as AnyObject, forKey: "qustionStr")
        dictionary.updateValue(markStr as AnyObject, forKey: "markStr")
        dictionary.updateValue(browseNum as AnyObject, forKey: "browseNum")
        dictionary.updateValue(questionID as AnyObject, forKey: "questionID")
        return dictionary
    }

    func setValueWithDictionary(dictionray:Dictionary<String,AnyObject>) {
        headImageURL = dictionray["headImageURL"] as? NSURL
        userNameStr = dictionray["userNameStr"] as! String
        timeStr = dictionray["timeStr"] as! String
        questionImageURL = dictionray["questionImageURL"] as! NSURL?
        qustionStr = dictionray["qustionStr"] as! String
        browseNum = dictionray["browseNum"] as! String
        questionID = dictionray["questionID"] as! Int
        answerID = dictionray["answerID"] as! Int?
    }
    
    /** 头像*/
    var headImageURL: NSURL?
    
    /** 名字*/
    var userNameStr: String = ""
    
    /** 发布时间*/
    var timeStr: String = ""
    
    /** 问题图片*/
    var questionImageURL: NSURL?
    
    /** 问题标题*/
    var qustionStr: String = ""
    
    /** 标签*/
    var markStr: String = ""
    
    /** 浏览人数*/
    var browseNum: String = ""
    
    /** 问问ID*/
    var questionID: Int = 0
    
    /** 回答id*/
    var answerID: Int?
    
}
