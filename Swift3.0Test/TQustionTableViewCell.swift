//
//  TQustionTableViewCell.swift
//  baibianjiajia
//
//  Created by 百变家装002 on 16/8/3.
//  Copyright © 2016年 百变家装001. All rights reserved.
//

import UIKit

class TQustionTableViewCell: UITableViewCell {

    /** 头像*/
    var headImageView: UIImageView = UIImageView(frame:CGRect(x: 10, y: 8, width: 25, height: 25))
    /** 名字*/
    var userNameLab: UILabel = UILabel()
    /** 发布时间*/
    var timeLab: UILabel = UILabel()
    /** 问题图片*/
    var questionImageView: UIImageView?
    /** 问题标题*/
    var qustionLab: UILabel = UILabel()
    /** 标签*/
    var markLab: UILabel = UILabel()
    /** 浏览人数*/
    var browseLab: UILabel = UILabel()
    /** 背影*/
    var backView: UIView = UIView()
    
    /** model*/
    var model: TLatestQuestionsListViewModel?
    {
        didSet{
            if model?.headImageURL != nil {
                headImageView.sd_setImage(with: model?.headImageURL as URL!)
            }
            userNameLab.text = model?.userNameStr
            let size1 :CGSize = (userNameLab.sizeThatFits((userNameLab.frame.size)))
            userNameLab.frame = CGRect(x:headImageView.frame.maxX+9, y: headImageView.frame.height/2+8-size1.height/2, width: size1.width, height: size1.height)
            timeLab.text = model?.timeStr
            let size2 :CGSize = (timeLab.sizeThatFits((timeLab.frame.size)))
            timeLab.frame = CGRect(x: userNameLab.frame.maxX+8, y: headImageView.frame.height/2+8-size2.height/2, width: size2.width, height: size2.height)
            qustionLab.text = model?.qustionStr
            let size3 :CGSize = (qustionLab.sizeThatFits((qustionLab.frame.size)))
            if model?.questionImageURL != nil {
                questionImageView = UIImageView(frame: CGRect(x: 0, y: headImageView.frame.maxY+8, width: SCREEN_WIDTH, height: SCREEN_WIDTH*131/360))
                questionImageView?.sd_setImage(with: model?.questionImageURL as URL!)
                questionImageView?.contentMode = UIViewContentMode.scaleAspectFill
                questionImageView?.clipsToBounds = true
                backView.addSubview(questionImageView!)
                qustionLab.frame = CGRect(x:10,y:questionImageView!.frame.maxY+10,width: size3.width,height:size3.height)
            }else{
                qustionLab.frame = CGRect(x:10,y:headImageView.frame.maxY+11,width: size3.width,height:size3.height)
            }
            markLab.text = model?.markStr
            let size4 :CGSize = (markLab.sizeThatFits((markLab.frame.size)))
            markLab.frame = CGRect(x:10,y:qustionLab.frame.maxY+13,width:size4.width,height:size4.height)
           //创建富文本
            let string = "  " + model!.browseNum
            let textStr = NSMutableAttributedString(string: string)
            let attch = NSTextAttachment()
            attch.image = #imageLiteral(resourceName: "眼睛")
//            attch.image = UIImage(named: "眼睛")
            attch.bounds = CGRect(x:0,y:-1.5,width:13,height:9.5)
            let imageStr = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attch))
            imageStr.append(textStr)
            browseLab.attributedText = imageStr
            let size5 :CGSize = (browseLab.sizeThatFits((browseLab.frame.size)))
            browseLab.frame = CGRect(x:SCREEN_WIDTH-size5.width-11,y:qustionLab.frame.maxY+14,width:size5.width,height:size5.height)
            let line = UILabel(frame: CGRect(x: 0, y: markLab.frame.maxY+16, width: SCREEN_WIDTH, height: 1))
            line.backgroundColor = COLORWITHSTRING(colorName: "e1e5ec")
            backView.addSubview(line)
            let grayLab = UIView(frame:CGRect(x: 0, y: line.frame.maxY, width: SCREEN_WIDTH, height: 14 ))
            grayLab.backgroundColor = COLORWITHSTRING(colorName: "f7fafc")
            backView.addSubview(grayLab)
            backView.frame = CGRect(x:0,y: 0,width:SCREEN_WIDTH,height: grayLab.frame.maxY)
            self.frame = backView.frame
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        backgroundColor = UIColor.gray
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addViews(){
        
        backView.backgroundColor = UIColor.white
        self.addSubview(backView)
        
        headImageView.layer.cornerRadius = 12.5
        headImageView.layer.masksToBounds = true
        backView.addSubview(headImageView)
        
        userNameLab.font = UIFont(name: "Helvetica-Bold", size: 12)
        userNameLab.textColor = COLORWITHSTRING(colorName: "b8b8b8")
        backView.addSubview(userNameLab)
        
        timeLab = UILabel(frame: CGRect.zero)
        timeLab.font = UIFont.systemFont(ofSize: 10)
        timeLab.textColor = COLORWITHSTRING(colorName: "cdcdcd")
        backView.addSubview(timeLab)
        
        qustionLab.frame = CGRect(x:10,y:0,width:SCREEN_WIDTH-21,height:0)
        qustionLab.font = UIFont(name: "Helvetica-Bold", size: 15)
        qustionLab.textColor = COLORWITHSTRING(colorName: "7e7e7e")
        qustionLab.numberOfLines = 0
        backView.addSubview(qustionLab)
        
        browseLab = UILabel(frame: CGRect.zero)
        browseLab.font = UIFont.systemFont(ofSize: 10)
        browseLab.textColor = COLORWITHSTRING(colorName: "cdcdcd")
        backView.addSubview(browseLab)
        
        markLab = UILabel(frame: CGRect.zero)
        markLab.font = UIFont.systemFont(ofSize: 12)
        markLab.textColor = COLORWITHSTRING(colorName: "b8b8b8")
        backView.addSubview(markLab)
        
    }
}
