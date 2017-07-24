//
//  PageContentView.swift
//  DYZB
//
//  Created by Alen on 2017/7/21.
//  Copyright © 2017年 JingKeCompany. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate:class {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}

private let ContentCellID = "contentCellID"

class PageContentView: UIView {

    //定义属性
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var childVcs : [UIViewController]
    fileprivate weak var parentViewController : UIViewController?
    weak var delegate: PageContentViewDelegate?
    fileprivate var isForbidScorllDelegate : Bool = false
    
    //MARK:-懒加载
    lazy var collectionView: UICollectionView = {
        [weak self] in
        //1创建Layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //2创建collectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        return collectionView
    }()
    
    //自定义构造函数
    init(frame: CGRect,childVcs: [UIViewController],parentViewController: UIViewController?) {
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        super.init(frame: frame)
        
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//MARK:-设置UI界面
extension PageContentView{
    fileprivate func setupUI(){
        //1将所有的子控制器添加到父控制器
        for childVc in childVcs {
            parentViewController?.addChildViewController(childVc)
        }
        //2布局界面 （uicollectionView）
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}


//MARK:-遵守UICollectionViewDataSource协议
extension PageContentView:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
      
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

//MARK:-遵守UICollectionViewDelegate协议
extension PageContentView:UICollectionViewDelegate{
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScorllDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isForbidScorllDelegate {
            return
        }
        
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targentIndex : Int = 0
        let scrollViewW = scrollView.frame.width
        let currentOffsetX = scrollView.contentOffset.x
        if currentOffsetX > startOffsetX {
            //左滑
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            sourceIndex = Int(currentOffsetX/scrollViewW)
            targentIndex = sourceIndex + 1;
            if targentIndex>=childVcs.count {
                targentIndex = childVcs.count - 1
            }
            
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targentIndex = sourceIndex
            }
            
        }else{
            //右滑
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            targentIndex = Int(currentOffsetX/scrollViewW)
            sourceIndex = targentIndex + 1;
            if sourceIndex>=childVcs.count {
                sourceIndex = childVcs.count - 1
            }
            
            if startOffsetX - currentOffsetX  == scrollViewW {
                progress = 1
                sourceIndex = targentIndex
            }
        }
        
        // 传递给titleView
        //print(progress,sourceIndex,targentIndex)
        
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targentIndex)
    }
}

//MARK:-对外暴露的方法
extension PageContentView{
    func setCurrentView(currentIndex : Int) {
        print(#function)
        
        isForbidScorllDelegate = true
        
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y:0), animated: true)
        
    }
}

