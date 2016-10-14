//
//  NetWorkingManager.swift
//  Swift3.0Test
//
//  Created by 百变家装002 on 16/10/8.
//  Copyright © 2016年 百变家装002. All rights reserved.
//

import UIKit

/**
 网络请求单例
 */
let networkingManager = NetWorkingManager()

class NetWorkingManager: NSObject {

    /** 网络请求request*/
    var netRequest = NetworkingRequestTool()
 
    /**
     获取问问
     */
    typealias questionReturnBackData = (Array<TLatestQuestionsListViewModel>?,NSError?)-> Void
    func getQuestionList(parameters:Dictionary<String,AnyObject>?,URLString:String,returnData:@escaping questionReturnBackData) {
        netRequest.postRequest(url: URLString, params: parameters, success: { (response) in
            if let j = response as? NSDictionary{
//                print("+++++++++++\(response)")
                let json:JSON = JSON(j)
                let array = json["data"]["result"].arrayValue
                var dataArray:Array<TLatestQuestionsListViewModel> = Array()
                for data:JSON in array{
                    let model:TLatestQuestionsListModel = TLatestQuestionsListModel.setValueWithJSON(dataJson: data)
                    let modelView:TLatestQuestionsListViewModel = TLatestQuestionsListViewModel(model: model)
                    let dictionary = modelView.transViewModelToDictionary()
                    questionDataManage.saveCacheData(data: dictionary)
                    dataArray.append(modelView)
                }
                returnData(dataArray,nil)
            }
            }) { (error) in
                 self.SHOWMESSAGE(message: "网络加载失败")
        }
    }
    
    /**
     上传图片
     */
    typealias urlStringReback = (String) -> Void
    func uploadPicture(urlStr:String,image:UIImage,returnData:@escaping urlStringReback)  {
        let imageData:Data = UIImageJPEGRepresentation(image, 1)!
        let imageName = String(describing: NSDate())+".jpg"
        let fileConfig = FileConfigTool.initWithFileData(fileData: imageData, name: "file", fileName: imageName, mimeType: "image/jpg")
        netRequest.updateRequest(url: urlStr, params: nil, fileConfig: fileConfig, successAndProgress: { (progress) in
            print("+++++++++++progress\(progress)")
            }) { (response, error) in
                if let diction = response as? NSDictionary {
                    let json:JSON = JSON(diction)
                    returnData(json["data"]["domain"].stringValue+json["data"]["imgPath"].stringValue)
                }
        }
    }
    
    /**
     消息提醒
     */
    func SHOWMESSAGE(message:String){
        let hud:MBProgressHUD = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 12)
        hud.detailsLabel.text = message as String
        hud.detailsLabel.textColor = UIColor.black
        hud.margin=15
        hud.bezelView.layer.cornerRadius = 10.0
        hud.removeFromSuperViewOnHide=true
        hud.hide(animated: true, afterDelay: 2)
    }
    
}
