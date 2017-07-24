//
//  HomeViewController.swift
//  DYZB
//
//  Created by Alen on 2017/7/20.
//  Copyright © 2017年 JingKeCompany. All rights reserved.
//

import UIKit

private let kTitleViewH :CGFloat = 40

class HomeViewController: UIViewController {

    //MARK:-懒加载
    fileprivate lazy var pageTitleView:PageTitleView = {
        [weak self] in
        let titleFrame = CGRect(x: 0, y: kStatuesBarH + kNavgationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView  = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    
    fileprivate lazy var pageContentView: PageContentView = {
        [weak self] in
        //1确定内容的Frame
        let contentH = kScreenH - kNavgationBarH - kStatuesBarH - kTitleViewH - kTabbarH
        let contentFrame = CGRect(x: 0, y: kStatuesBarH + kNavgationBarH + kTitleViewH, width: kScreenW, height: contentH)
        
        //2确定内容的所有子控制器
        var childVcs = [UIViewController]()
        childVcs.append(RecommendViewController())
        for _ in 0..<3 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        
        contentView.delegate = self
        
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置UI界面
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK:-设置UI
extension HomeViewController{
    fileprivate func setupUI(){
        
        automaticallyAdjustsScrollViewInsets = false
        
        //设置导航栏
        setupNavigationBar()
        
        //添加TIT了View
        view.addSubview(pageTitleView)
        
        //添加ContentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.red
    }
    
    private func setupNavigationBar(){
        //1.设置左侧的Item
         navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        //2.设置右侧的Item
        let size = CGSize(width: 40, height: 40)
        let historyItem = UIBarButtonItem(imageName: "Image_my_history", hightImageName: "Image_my_history_click", size: size)
        let searchItem  = UIBarButtonItem(imageName: "btn_search", hightImageName: "btn_search_clicked", size: size)
        let qrcodeItem  = UIBarButtonItem(imageName: "Image_scan", hightImageName: "Image_scan_click", size: size)
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
    }
    
}


//MARK:-遵循 PageTitleViewDelegate 代理协议
extension HomeViewController : PageTitleViewDelegate{
    func pageTitleView(titleView: PageTitleView, selectIndex: Int){
        print(selectIndex)
        pageContentView.setCurrentView(currentIndex: selectIndex)
    }
}

//MARK:-遵循 PageTitleViewDelegate 代理协议
extension HomeViewController : PageContentViewDelegate{
    
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleViewProgess(progess: progress, sourceInde: sourceIndex, targetIndex: targetIndex)
    }
}
