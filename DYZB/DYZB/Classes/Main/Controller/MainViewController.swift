//
//  MainViewController.swift
//  DYZB
//
//  Created by Alen on 2017/7/20.
//  Copyright © 2017年 JingKeCompany. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addChildViewVC("Home")
        addChildViewVC("Live")
        addChildViewVC("Follow")
        addChildViewVC("Profile")
        
    }
    
    
    
    private func addChildViewVC(_ storyName: String){
        //1.通过StoryBoard 获取控制器
        let childVC = UIStoryboard(name:storyName, bundle: nil).instantiateInitialViewController()!
        //2.将childVC为子控制器
        addChildViewController(childVC)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
