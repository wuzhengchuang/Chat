//
//  CCNavigationController.swift
//  ChatProject
//
//  Created by 吴闯 on 2023/3/4.
//

import UIKit

class CCNavigationController: UINavigationController {

    override var childForStatusBarStyle: UIViewController?{
        return topViewController
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
