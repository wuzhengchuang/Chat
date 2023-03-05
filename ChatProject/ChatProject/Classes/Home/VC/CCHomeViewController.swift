//
//  CCHomeViewController.swift
//  ChatProject
//
//  Created by 吴闯 on 2023/2/27.
//

import UIKit
import SGPagingView

let CCHeaderViewHeight: CGFloat = 100
let CCPagingTitleViewHeight: CGFloat = 40

let navHeight: CGFloat = UIScreen.statusBarHeight

class CCHomeViewController: CCBaseViewController{
    lazy var statusView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = .white
        self.view.addSubview(view)
        return view
    }()
    lazy var pagingTitleView: SGPagingTitleView = {
        let configure = SGPagingTitleViewConfigure()
        configure.color = .lightGray
        configure.selectedColor = .black
        configure.indicatorType = .Dynamic
        configure.indicatorColor = .orange
        configure.showBottomSeparator = false
        
        let frame = CGRect.init(x: 0, y: CCHeaderViewHeight+UIScreen.statusBarHeight, width: view.frame.size.width, height: CCPagingTitleViewHeight)
        let titles = ["精选", "微博", "相册"]
        let pagingTitle = SGPagingTitleView(frame: frame, titles: titles, configure: configure)
        pagingTitle.backgroundColor = .white
        pagingTitle.delegate = self
        return pagingTitle
    }()
    
    var tempBaseSubVCs: [CCBaseSubViewController] = []
    
    lazy var pagingContentView: SGPagingContentScrollView = {
        let vc1 = CCHomeSubViewController()
        let vc2 = CCHomeSubViewController()
        let vc3 = CCHomeSubViewController()
        let vcs = [vc1, vc2, vc3]
        tempBaseSubVCs = vcs
        
        let tempRect: CGRect = CGRect.init(x: 0, y: UIScreen.statusBarHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - UIScreen.statusBarHeight - UIScreen.tabBarHeight)
        let pagingContent = SGPagingContentScrollView(frame: tempRect, parentVC: self, childVCs: vcs)
        pagingContent.delegate = self
        return pagingContent
    }()
    
    lazy var headerView: UIView = {
        let headerView: UIView = UIView()
        headerView.backgroundColor = .red
        headerView.frame = CGRect(x: 0, y: UIScreen.statusBarHeight, width: view.frame.width, height: CCHeaderViewHeight)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan_action))
        headerView.addGestureRecognizer(pan)
        let btn = UIButton(type: .custom)
        let btn_width: CGFloat = 200
        let btn_x = 0.5 * (view.frame.width - btn_width)
        btn.frame = CGRect(x: btn_x, y: (CCHeaderViewHeight - 50)/2, width: btn_width, height: 50)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .black
        btn.setTitle("You know？I can click", for: .normal)
        btn.addTarget(self, action: #selector(temp_btn_action), for: .touchUpInside)
        headerView.addSubview(btn)
        return headerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.customNavigationBar.isHidden = true
        view.backgroundColor = .white
        
        view.addSubview(pagingContentView)
        view.addSubview(headerView)
        view.addSubview(pagingTitleView)
        self.statusView.snp.makeConstraints { make in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(UIScreen.statusBarHeight)
        }
        tempLastPagingTitleViewY = CCHeaderViewHeight

        // 监听子视图发出的通知
        NotificationCenter.default.addObserver(self, selector: #selector(subTableViewDidScroll), name: NSNotification.Name(CCSubScrollViewDidScroll), object: nil)
    }
    
    var tempSubScrollView: UIScrollView?
    var tempLastPagingTitleViewY: CGFloat = 0
    var tempLastPoint: CGPoint = .zero

    deinit {
        print("SuspensionProVC")
    }
}
extension CCHomeViewController {
    @objc func pan_action(pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            
        } else if pan.state == .changed {
            let currenrPoint: CGPoint = pan.translation(in: pan.view)
            let distanceY = currenrPoint.y - tempLastPoint.y
            tempLastPoint = currenrPoint
            let baseSubVC = tempBaseSubVCs[pagingTitleView.index]
            var contentOffset: CGPoint = baseSubVC.scrollView!.contentOffset
            contentOffset.y += -distanceY
            if contentOffset.y <= -cc_subScrollViewContentOffsetY {
                contentOffset.y = -cc_subScrollViewContentOffsetY
            }
            baseSubVC.scrollView?.contentOffset = contentOffset
        } else {
            pan.setTranslation(.zero, in: pan.view)
            tempLastPoint = .zero
        }
    }
}

extension CCHomeViewController {
    @objc func subTableViewDidScroll(noti: Notification) {
        let scrollingScrollView = noti.userInfo!["scrollingScrollView"] as! UIScrollView
        let offsetDifference: CGFloat = noti.userInfo!["offsetDifference"] as! CGFloat
        
        var distanceY: CGFloat = 0
        
        let baseSubVC = tempBaseSubVCs[pagingTitleView.index]
        
        // 当前滚动的 scrollView 不是当前显示的 scrollView 直接返回
        guard scrollingScrollView == baseSubVC.scrollView else {
            return
        }
        var pagingTitleViewFrame: CGRect = pagingTitleView.frame
        guard pagingTitleViewFrame.origin.y >= navHeight else {
            return
        }
        
        let scrollViewContentOffsetY = scrollingScrollView.contentOffset.y
        
        // 往上滚动
        if offsetDifference > 0 && scrollViewContentOffsetY + cc_subScrollViewContentOffsetY > 0 {
            if (scrollViewContentOffsetY + cc_subScrollViewContentOffsetY + pagingTitleView.frame.origin.y) > CCHeaderViewHeight || scrollViewContentOffsetY + cc_subScrollViewContentOffsetY < 0 {
                pagingTitleViewFrame.origin.y += -offsetDifference
                if pagingTitleViewFrame.origin.y <= navHeight {
                    pagingTitleViewFrame.origin.y = navHeight
                }
            }
        } else { // 往下滚动
            if (scrollViewContentOffsetY + pagingTitleView.frame.origin.y + cc_subScrollViewContentOffsetY) < CCHeaderViewHeight+UIScreen.statusBarHeight {
                pagingTitleViewFrame.origin.y = -scrollViewContentOffsetY - CCPagingTitleViewHeight + UIScreen.statusBarHeight
                if pagingTitleViewFrame.origin.y >= CCHeaderViewHeight+UIScreen.statusBarHeight {
                    pagingTitleViewFrame.origin.y = CCHeaderViewHeight+UIScreen.statusBarHeight
                }
            }
        }
        
        // 更新 pagingTitleView 的 frame
        pagingTitleView.frame = pagingTitleViewFrame
        
        // 更新 headerView 的 frame
        var headerViewFrame: CGRect = headerView.frame
        headerViewFrame.origin.y = pagingTitleView.frame.origin.y - CCHeaderViewHeight
        headerView.frame = headerViewFrame
        
        distanceY = pagingTitleViewFrame.origin.y - tempLastPagingTitleViewY
        tempLastPagingTitleViewY = pagingTitleView.frame.origin.y
        
        /// 让其余控制器的 scrollView 跟随当前正在滚动的 scrollView 而滚动
        otherScrollViewFollowingScrollingScrollView(scrollView: scrollingScrollView, distanceY: distanceY)
    }
    
    /// 让其余控制器的 scrollView 跟随当前正在滚动的 scrollView 而滚动
    func otherScrollViewFollowingScrollingScrollView(scrollView: UIScrollView, distanceY: CGFloat) {
        var baseSubVC: CCBaseSubViewController
        for (index, _) in tempBaseSubVCs.enumerated() {
            baseSubVC = tempBaseSubVCs[index]
            if baseSubVC.scrollView == scrollView {
                continue
            } else {
                if let tempScrollView = baseSubVC.scrollView {
                    var contentOffSet: CGPoint = tempScrollView.contentOffset
                    contentOffSet.y += -distanceY
                    tempScrollView.contentOffset = contentOffSet
                }
            }
        }
    }
}

extension CCHomeViewController: SGPagingTitleViewDelegate, SGPagingContentViewDelegate {
    func pagingTitleView(titleView: SGPagingTitleView, index: Int) {
        pagingContentView.setPagingContentView(index: index)
    }
    
    func pagingContentView(contentView: SGPagingContentView, progress: CGFloat, currentIndex: Int, targetIndex: Int) {
        pagingTitleView.setPagingTitleView(progress: progress, currentIndex: currentIndex, targetIndex: targetIndex)
    }
    
    func pagingContentViewDidScroll() {
        let baseSubVC: CCBaseSubViewController = tempBaseSubVCs[pagingTitleView.index]
        if let tempScrollView = baseSubVC.scrollView {
            if (tempScrollView.contentSize.height) < UIScreen.main.bounds.size.height {
                tempScrollView.setContentOffset(CGPoint(x: 0, y: -cc_subScrollViewContentOffsetY), animated: false)
            }
        }
    }
}

extension CCHomeViewController {
    @objc func temp_btn_action() {
        Http.manager.get(url: Http.getBannerUrl, params: ["":""], progress: { progress in
            
        } , response: {a,b,c in
            
        })
    }
}
