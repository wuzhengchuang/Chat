//
//  CCTabBarController.swift
//  ChatProject
//
//  Created by 吴闯 on 2023/2/27.
//

import UIKit

class CCTabBarController: UITabBarController , CCTabBarDelegate{
    var customTabBar: CCTabBar?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTabBar()
    }
    //初始化TabBar
    func initTabBar() {
        
        let homeNC = initItems(vc:CCHomeViewController(),title: "首页", imageName: "tabbar_home_n", selectImageName: "tabbar_home_s")
        let dynamicNC = initItems(vc:CCDynamicViewController(),title: "动态", imageName: "tabbar_dynamic_n", selectImageName: "tabbar_dynamic_s")
        let chatNC = initItems(vc:CCChatViewController(),title: "聊天", imageName: "tabbar_msg_n", selectImageName: "tabbar_msg_s")
        let mineNC = initItems(vc:CCMineViewController(),title: "我的", imageName: "tabbar_mine_n", selectImageName: "tabbar_mine_s")
        self.viewControllers = [homeNC,dynamicNC,chatNC,mineNC]
        
        for subView in self.tabBar.subviews {
            subView.removeFromSuperview()
        }
        
        self.customTabBar = CCTabBar(frame: CGRect.zero)
        self.customTabBar?.delegate = self
        self.tabBar.addSubview(self.customTabBar!)
       
        self.customTabBar?.snp.makeConstraints({ make in
            make.left.top.right.equalTo(self.tabBar)
            make.height.equalTo(TABBAR_HEIGHT)
        })
        self.customTabBar?.tabbars=self.tabBar.items!
    }
    func initItems(vc:CCBaseViewController,title: String,imageName:String,selectImageName:String)->(CCNavigationController){
        vc.tabBarItem.imageInsets=UIEdgeInsets(top: 5.0, left: 0.0, bottom: 3.0, right: 0.0)
        vc.tabBarItem.image=UIImage(named: imageName)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        vc.tabBarItem.selectedImage=UIImage(named: selectImageName)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        vc.title = title
        vc.tabBarItem.title=title
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.purple,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)], for: UIControl.State.normal)
        let nvc = CCNavigationController(rootViewController: vc)
        return nvc
    }
    
    func cc_tabBar(_ tabBar: CCTabBar, didSelect item: CCTabBarItem) {
        self.selectedIndex = item.button.tag
    }

}
