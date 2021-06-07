//
//  AppModel.swift
//  NFAToolkit
//
//  Created by 聂飞安 on 2021/6/7.
//

import UIKit

//[(String , UIColor , UIFont)]
//解决OC不能用元组的问题
@objc open class AppModel: NSObject {
    
    @objc var string : String! = "";
    @objc var color : UIColor! = UIColor.white;
    @objc var font : UIFont! = UIFont.systemFont(ofSize: 14)
    
    @objc public class func create(_ string : NSString ,_ color : UIColor , font : UIFont ) -> AppModel{
        let model = AppModel()
        model.string = string as String
        model.color = color
        model.font = font
        return  model;
    }

}
