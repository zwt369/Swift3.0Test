//
//  ViewController.swift
//  Swift3.0Test
//
//  Created by 百变家装002 on 16/10/7.
//  Copyright © 2016年 百变家装002. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
func COLORWITHSTRING(colorName:String) -> UIColor {
    var cString:String = colorName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) {
        cString = (cString as NSString).substring(from: 1)
    }
    if (colorName.characters.count != 6) {
        return UIColor.gray
    }
    let rString = (cString as NSString).substring(to: 2)
    let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
    let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    /** 数据源*/
    var dataArray: Array<TLatestQuestionsListViewModel> = Array()
    
    /** tableView*/
    var tableView: UITableView = UITableView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        view.addSubview(tableView)
//        makeData()
        uploadPicture()
    }

    func uploadPicture()  {
        networkingManager.uploadPicture(urlStr: "http://120.76.215.116:8030/varyjia-soa/file/upload", image: UIImage.init(named: "demo.jpg")!) { (url) in
            print("+++++++++++\(url)")
        }
    }
    
    func makeData()  {
        let array = questionDataManage.getData()
        if array.count != 0{
            dataArray = array.reversed()
            tableView.reloadData()
        }
//        networkingManager.getQuestionList(parameters: ["pageNo":1 as AnyObject,"pageSize":10 as AnyObject], URLString: "http://120.76.215.116:8030/varyjia-soa/ws/rest/wenwen/new") { (dataArray, error) in
//            if dataArray != nil {
//                self.dataArray = dataArray!
//                self.tableView.reloadData()
//            }
//        }
    }
    
    // MARK: - tableView代理方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell\(String(indexPath.row))"
        var cell  = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = TQustionTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellID)
        }
        let cellT = cell as! TQustionTableViewCell
        let viewModel = dataArray[indexPath.row]
        cellT.model = viewModel
        cellT.selectionStyle = UITableViewCellSelectionStyle.none
        return cellT
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, cellForRowAt: indexPath).frame.size.height
    }


}

