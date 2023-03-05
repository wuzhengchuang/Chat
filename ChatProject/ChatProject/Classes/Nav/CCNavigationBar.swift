//
//  CCNavigationBar.swift
//  ChatProject
//
//  Created by 吴闯 on 2023/3/1.
//

import UIKit

@objc
protocol CCNavigationBarDelegate : NSObjectProtocol {
    @objc optional func backViewController()
    @objc optional func hiddenBackButton() -> Bool
}
class CCNavigationBar: UIView {
    weak var delegate: CCNavigationBarDelegate?
    lazy var customView: UIView = {
        let view = UIView(frame: CGRect.zero)
        self.addSubview(view)
        return view
    }()
    lazy var leftStackView: UIStackView = {
        let stackView = UIStackView(frame: CGRect.zero)
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .horizontal
        self.customView.addSubview(stackView)
        return stackView
    }()
    lazy var rightStackView: UIStackView = {
        let stackView = UIStackView(frame: CGRect.zero)
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .horizontal
        self.customView.addSubview(stackView)
        return stackView
    }()
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back_black"), for: .normal)
        button.setImage(UIImage(named: "back_black"), for: .highlighted)
        button.addTarget(self, action: #selector(backClick), for: UIControl.Event.touchUpInside)
        self.leftStackView.addArrangedSubview(button)
        return button
    }()
    lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel(frame: CGRect.zero)
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        self.customView.addSubview(label)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initUI()
    }
    func initUI(){
        self.backgroundColor = .white
        self.customView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(UIScreen.navBarHeight)
        }
        self.leftStackView.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(self.customView)
        }
        self.rightStackView.snp.makeConstraints { make in
            make.top.bottom.right.equalTo(self.customView)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.center.equalTo(self.customView)
        }
        self.backButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
    }
    func reloadBar(){
        if let delegate = self.delegate {
            if let isHidden = delegate.hiddenBackButton?() {
                self.backButton.isHidden = isHidden
            }
        }
    }
    @objc func backClick(){
        if self.delegate?.responds(to: #selector(self.delegate?.backViewController)) != nil {
            self.delegate?.backViewController?()
        }
    }
}
