//
//  PageTitleView.swift
//  DYZB
//
//  Created by Alen on 2017/7/21.
//  Copyright © 2017年 JingKeCompany. All rights reserved.
//

import UIKit


protocol PageTitleViewDelegate:class {
    func pageTitleView(titleView: PageTitleView, selectIndex: Int)
}


//MARK:-定义常亮
private let kScrollLineH : CGFloat = 2
private let kNormalColor : (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectColor : (CGFloat,CGFloat,CGFloat) = (255,128,0)




class PageTitleView: UIView {

    //MARK:-自定义属性
    fileprivate var currentIndex : Int = 0
    fileprivate var titles : [String]
    weak var delegate : PageTitleViewDelegate?
    
    
    
    //MARK:-懒加载
    lazy var titleLabels : [UILabel] = [UILabel]()
    lazy var scrollView :UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    //MARK: - 自定义构造函数
    init(frame: CGRect ,titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        
        //设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//MARK:设置UI界面
extension PageTitleView{
   
    fileprivate func setupUI(){
        //添加scrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        //添加Title对应的lab
        setupTitleLabels()
        
        //设置底线和活动模块
        setupBottonMenuAndScrollLine()
    }

    private func setupTitleLabels(){
        //确定lab 的一些Frame
        let labW : CGFloat = frame.width/CGFloat(titles.count)
        let labH : CGFloat = frame.height - kScrollLineH
        let labY : CGFloat = 0
        
        for (index,title) in titles.enumerated() {
            //创建Lab
            let lab = UILabel()
            
            //设置lab属性
            lab.text = title
            lab.tag = index
            lab.font = UIFont.systemFont(ofSize: 14)
            lab.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            lab.textAlignment = .center
            
            //设置frame
            let labX : CGFloat = labW * CGFloat(index)
            lab.frame = CGRect(x: labX, y: labY, width: labW, height: labH)
            titleLabels.append(lab)
            //将lab添加到scrollview
            scrollView.addSubview(lab)
            
            
            //添加手势
            lab.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target:self, action: #selector(self.titleLabClick(tapGes:)))
            lab.addGestureRecognizer(tapGes)
        }
    }
    
    private func setupBottonMenuAndScrollLine(){
        //添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        //添加线
        guard let firstLab = titleLabels.first else {
            return
        }
        firstLab.textColor =  UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLab.frame.origin.x, y: frame.height - kScrollLineH, width: firstLab.frame.width, height: kScrollLineH)
    }
    
}


extension PageTitleView{
    //事件处理 需要@OBJC
    @objc fileprivate func titleLabClick(tapGes: UITapGestureRecognizer) {
        print("------")
        //获取当前lab的下标
        guard let currentLab = tapGes.view as? UILabel else {
            return
        }
        let oldLab = titleLabels[currentIndex]
        
        if oldLab.tag != currentLab.tag {
            currentLab.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
            oldLab.textColor     = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        }
        
        //保存lab的下标
        currentIndex = currentLab.tag
        
        //滑动line位置
        let scrollLineX = CGFloat(currentLab.tag) * scrollLine.frame.width
        
        UIView.animate(withDuration: 0.25) { 
            [weak self] in
            self?.scrollLine.frame.origin.x = scrollLineX
        }
        
        //通知 代理做事情
        delegate?.pageTitleView(titleView: self, selectIndex: currentIndex)
        
    }
}


extension PageTitleView{
    func setTitleViewProgess(progess: CGFloat, sourceInde: Int,  targetIndex: Int) {
        print(#function)
        let sourceLab = titleLabels[sourceInde]
        let targetLab = titleLabels[targetIndex]
        
        //处理滑块
        let moveTotalX = targetLab.frame.origin.x - sourceLab.frame.origin.x
        let moveX = moveTotalX * progess
        
        scrollLine.frame.origin.x = sourceLab.frame.origin.x + moveX

        
        //处理颜色渐变
        //1取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0,kSelectColor.1 - kNormalColor.1,kSelectColor.2 - kNormalColor.2)
        sourceLab.textColor = UIColor(r: kSelectColor.0 - colorDelta.0*progess, g: kSelectColor.1 - colorDelta.1*progess, b: kSelectColor.2 - colorDelta.2*progess)
        targetLab.textColor = UIColor(r: kNormalColor.0 + colorDelta.0*progess, g: kNormalColor.1 + colorDelta.1*progess, b: kNormalColor.2 + colorDelta.2*progess)
        //记录最新的
        currentIndex = targetIndex
        
    }
}
