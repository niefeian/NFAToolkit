//
//  ChineseConvert.swift
//  NFAToolkit
//
//  Created by 聂飞安 on 2020/11/25.
//

import UIKit

@objc open class ChineseConvert: NSObject {
 
    public static let instance = ChineseConvert()
    var simplifiedCode = ""
    var traditionalCode = ""
    
    
    public func initCode(){
        if let path = Bundle.main.resourcePath?.appending("/SimplifiedCode.txt")
        , let traditionalPath = Bundle.main.resourcePath?.appending("/TraditionalCode.txt"){
            do {
                simplifiedCode = try String.init(contentsOfFile: path, encoding: .utf8)
                traditionalCode = try String.init(contentsOfFile: traditionalPath, encoding: .utf8)
            } catch {
            }
        }
    }
    
    public func convert(_ simpString : String , isTraditional : Bool) -> String{
        if simpString.count == 0
        {
            return simpString
        }
        if  simplifiedCode.count == 0
        {
            initCode()
            return convert(simpString, isTraditional: isTraditional)
        }
        var resultString = ""
        let formString : NSString = ( isTraditional ? simplifiedCode : traditionalCode)  as NSString
        let toString = isTraditional ? traditionalCode : simplifiedCode
        for i in 0 ..< simpString.count
        {
            let simCharString = simpString.subString(start: i, length: 1)
            let charRange = formString.range(of: simCharString)
            if  charRange.location >= 0 &&  charRange.location < toString.count
            {
                let tradCharString = toString.subString(start: charRange.location, length: 1)
                resultString += tradCharString
            }
            else{
                resultString += simCharString
            }
        }
        
        return resultString
    }
    
}
public extension String {
    
    var toCNString: String {
        return ChineseConvert.instance.convert(self, isTraditional: ("en".localized == "zh-HK" || "en".localized == "zh-TW"))
    }
    
    var toTWString: String {
        return ChineseConvert.instance.convert(self, isTraditional: true)
    }
    
    var toSimpString: String {
        return ChineseConvert.instance.convert(self, isTraditional: false)
    }
    
}
