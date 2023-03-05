//
//  CCPersonDetailViewController.swift
//  ChatProject
//
//  Created by 吴闯 on 2023/3/2.
//

import UIKit

class CCPersonDetailViewController: CCBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人详情"
        self.view.backgroundColor = .white
    }
    deinit{
        debugPrint("个人详情销毁了")
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
