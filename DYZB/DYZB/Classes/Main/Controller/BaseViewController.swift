//
//  BaseViewController.swift
//  DYZB
//
//  Created by Alen on 2017/7/24.
//  Copyright © 2017年 JingKeCompany. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    
    //MARK:定义属性
    var contentView : UIView?
    fileprivate lazy var animImageView: UIImageView = {
        
        let imageView = UIImageView(image: UIImage(named: "img_loading_1"))
        imageView.center = self.view.center
        imageView.animationImages = [UIImage(named: "img_loading_1")!,UIImage(named: "img_loading_2")!]
        imageView.animationDuration = 0.5
        imageView.animationRepeatCount = LONG_MAX
        imageView.autoresizingMask = [.flexibleTopMargin,.flexibleBottomMargin]
        return imageView
    }()
    
    //MARK:系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension BaseViewController{
    func setupUI() {
        
        contentView?.isHidden = true
        
        view.addSubview(animImageView)
        animImageView.startAnimating()
        view.backgroundColor = UIColor(r: 250, g: 250, b: 250)
    }
    
    func loadDataFinisher(){
        animImageView.stopAnimating()
        animImageView.isHidden = true
        contentView?.isHidden = false
    }



}
