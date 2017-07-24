//
//  UIBarButtonItem-Extension.swift
//  DYZB
//
//  Created by Alen on 2017/7/21.
//  Copyright © 2017年 JingKeCompany. All rights reserved.
//

import Foundation
import UIKit

//对UIBarButtonItem扩展
extension UIBarButtonItem{
    
    class func createItem(imageName: String, hightImageName: String, size: CGSize) -> UIBarButtonItem{
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: hightImageName), for: .highlighted)
        btn.frame = CGRect(origin: CGPoint.zero, size: size)
        return UIBarButtonItem(customView: btn)
    }
    
    //便利构造函数
    //1》 convenience开头
    //2》 在构造函数中必须明确调用一个设计构造函数（self）
    convenience init(imageName: String, hightImageName: String = "", size: CGSize = CGSize.zero) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        if hightImageName != "" {
            btn.setImage(UIImage(named: hightImageName), for: .highlighted)
        }
        
        if size == CGSize.zero {
            btn.sizeToFit()
        } else{
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        self.init(customView: btn)
    }
    
}
