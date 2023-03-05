//
//  CCBaseViewController.swift
//  ChatProject
//
//  Created by 吴闯 on 2023/2/28.
//

import UIKit

class CCBaseViewController: UIViewController , CCNavigationBarDelegate{
    lazy var customNavigationBar: CCNavigationBar = {
        let navigationBar: CCNavigationBar = CCNavigationBar()
        navigationBar.delegate = self
        self.view.addSubview(navigationBar)
        return navigationBar
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        self.view.backgroundColor = .white
        self.customNavigationBar.snp.makeConstraints { make in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(UIScreen.navBarHeight)
        }
        self.customNavigationBar.titleLabel.text = self.title
        self.customNavigationBar.reloadBar()
        self.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let path = keyPath ?? ""
        if "title".elementsEqual(path) {
            let title = change?[NSKeyValueChangeKey.newKey] as! String
            self.customNavigationBar.titleLabel.text = title
        }
    }
    func leftAction() {
        self.pop()
    }
    func pop() {
        if let nvc = self.navigationController {
            var controllers = nvc.viewControllers
            controllers.removeLast()
            if let lastVC = controllers.last{
                self.navigationController?.popToViewController(lastVC, animated: true)
            }
        }
    }
    func backViewController() {
        self.leftAction()
    }
    func hiddenBackButton() -> Bool {
        if let nvc = self.navigationController {
            let controllers = nvc.viewControllers
            let count = controllers.count
            if count < 2 || nvc.visibleViewController == controllers.first {
                return true
            }
        }
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
