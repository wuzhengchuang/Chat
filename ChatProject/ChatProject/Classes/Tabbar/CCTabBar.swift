//
//  CCTabBar.swift
//  ChatProject
//
//  Created by 吴闯 on 2023/2/27.
//

import UIKit

@objc
protocol CCTabBarDelegate : NSObjectProtocol{
    @objc optional func cc_tabBar(_ tabBar: CCTabBar, didSelect item: CCTabBarItem)
}

class CCTabBar: UIView {
    weak var delegate : CCTabBarDelegate?
    var tabbars : Array<UITabBarItem>?{
        didSet{
            self.initTabBarItems()
        }
    }
    
    lazy var stackView : UIStackView = {
        let stackView : UIStackView = UIStackView(frame: CGRect.zero)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initUI()
    }
    func initUI() {
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints({ make in
            make.left.right.top.equalTo(self)
            make.height.equalTo(TABBAR_HEIGHT)
        })
        self.backgroundColor = .white
    }
    func initTabBarItems(){
        for subView in self.stackView.arrangedSubviews {
            self.stackView.removeArrangedSubview(subView)
        }
        if let tabbars = self.tabbars {
            for (tag,item) in tabbars.enumerated() {
                let barItem = CCTabBarItem()
                barItem.button.tag = tag
                barItem.data = item
                self.stackView.addArrangedSubview(barItem)
                barItem.addTarget(target: self, action: #selector(tapClick), event:UIControl.Event.touchUpInside)
            }
        }
        let barItem : CCTabBarItem = self.stackView.arrangedSubviews.first as! CCTabBarItem
        self.tapClick(button: barItem.button)
    }
    @objc func tapClick(button: UIButton){
        if ((self.delegate?.responds(to: #selector(self.delegate?.cc_tabBar(_:didSelect:)))) != nil) {
            for item in self.stackView.arrangedSubviews {
                let barItem = item as! CCTabBarItem
                if barItem.button.tag == button.tag {
                    barItem.selected = true
                    self.delegate?.cc_tabBar?(self, didSelect: self.stackView.arrangedSubviews[button.tag] as! CCTabBarItem)
                }else{
                    barItem.selected = false
                }
            }
            
        }
    }
}

class CCTabBarItem: UIView {
    var data : UITabBarItem? {
        didSet {
            self.setDefaultState()
        }
    }
    var selected : Bool = false{
        didSet {
            if selected == false {
                //未选中状态
                self.setDefaultState()
            } else {
                //选中状态
                self.setSelectedState()
            }
        }
    }
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "PingFangSC-Medium", size: 10)
        self.addSubview(label)
        return label
        
    }()
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        self.addSubview(imageView)
        return imageView
    }()
    lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        self.addSubview(button)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initUI()
    }
    func initUI() {
        self.imageView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(5.0)
            make.width.height.equalTo(22)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.imageView.snp_bottom).offset(2)
            make.centerX.equalTo(self.imageView)
        }
        self.button.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    func setDefaultState(){
        //设置默认状态
        self.titleLabel.text = self.data?.title
        self.imageView.image = self.data?.image
        self.titleLabel.textColor = UIColor(hexStr: "#97A7B3")
    }
    func setSelectedState(){
        //设置选中状态
        self.titleLabel.text = self.data?.title
        self.imageView.image = self.data?.selectedImage
        self.titleLabel.textColor = .black
    }
    func addTarget(target: Any?, action: Selector, event: UIControl.Event){
        self.button.addTarget(target, action: action, for: event)
    }
}
