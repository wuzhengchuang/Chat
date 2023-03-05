//
//  CCHomeSubViewController.swift
//  ChatProject
//
//  Created by 吴闯 on 2023/3/2.
//

import UIKit
import MJRefresh
class CCHomeSubViewController: CCBaseSubViewController,UICollectionViewDelegateFlowLayout {
    let leftRightSpace: CGFloat = 10
    let rowSpace: CGFloat = 8
    let columnSpace: CGFloat = 8
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.size.width, height: SCREEN_HEIGHT - UIScreen.statusBarHeight - UIScreen.tabBarHeight)),collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView.contentInset = UIEdgeInsets(top: cc_subScrollViewContentOffsetY, left: 0, bottom: 0, right: 0)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.collectionView)
        
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        addRefresh()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width: CGFloat = (collectionView.width - leftRightSpace*2 - columnSpace)/2
        let height: CGFloat = width+50
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: leftRightSpace, bottom: 0, right: leftRightSpace)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return rowSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return columnSpace
    }

}
extension CCHomeSubViewController {
    func addRefresh() {
        self.collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(header_refresh))
    }
    @objc func header_refresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(2)) { [self] in
            self.collectionView.mj_header?.endRefreshing()
        }
    }
}
extension CCHomeSubViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        subScrollViewDidScroll(scrollView)
    }
}

extension CCHomeSubViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 37
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        if indexPath.row % 3 == 0 {
            cell.backgroundColor = .green
        }else if indexPath.row % 3 == 1 {
            cell.backgroundColor = .orange
        }else{
            cell.backgroundColor = .purple
        }
        return cell
    }
}

extension CCHomeSubViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        37
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .green
        } else {
            cell.backgroundColor = .orange
        }
        return cell
    }
}
