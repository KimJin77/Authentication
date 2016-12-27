//
//  PatternLockViewController.swift
//  Authentication
//
//  Created by Sim Jin on 2016/12/25.
//  Copyright © 2016年 UFunNetwork. All rights reserved.
//

import UIKit

enum PatterLockType {
    case set, login, verify
}

class PatternLockViewController: UIViewController {

    private let passwordLength = 4
    private var setTime = 0
    private var password: String? = nil

    let touchView: CirclesView = CirclesView()
    let infoView: CircleInfoView = CircleInfoView()
    var tipsLabel: UILabel = UILabel()
    var type: PatterLockType

    let firstSetTipText = "绘制解锁图案"
    let atLeast4PointTipText = "至少连接4个点，请重新输入"
	let redrawTipText = "再次绘制解锁图案"
    let differentFromPreTipText = "与上一次绘制不一致，请重新绘制"

    convenience init() {
        self.init(type: .set)
    }

    init(type theType: PatterLockType) {
        type = theType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
		type = .set
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(touchView)
        view.addSubview(infoView)
        touchView.getPasswordClosure = { [unowned self](password) in
            if self.type == .set {
                if (password.characters.count < self.passwordLength) && (self.setTime == 0) {
                    self.touchView.clean()
                    self.showError(self.atLeast4PointTipText)
                } else {
                    if self.setTime == 0 {
						self.password = password
                        self.tipsLabel.text = self.redrawTipText
                        self.setTime += 1
                        self.touchView.clean()
                        self.infoView.fillCircles(withNumber: password)
                    } else {
                        if self.password! == password {
                            // TODO: Save password here
                            print(self.password!)
                        } else {
                            self.showError(self.differentFromPreTipText)
                            self.touchView.showError()
                        }
                    }
                }
                // TODO: Other type can add your code here
            } else if self.type == .verify {

            } else if self.type == .login {

            }
        }

        tipsLabel.bounds = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 15)
        tipsLabel.center = CGPoint(x: infoView.center.x, y: infoView.center.y + 40)
        tipsLabel.textColor = Color.grayColor
        tipsLabel.font = UIFont.systemFont(ofSize: 15)
        tipsLabel.textAlignment = .center
		tipsLabel.text = type == .set ? firstSetTipText : ""
        view.addSubview(tipsLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showError(_ text: String) {
        let center = tipsLabel.center
		tipsLabel.text = text
        tipsLabel.textColor = Color.destructiveColor
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: { 
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: {
                self.tipsLabel.center = CGPoint(x: center.x - 10, y: center.y)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.2, animations: {
                self.tipsLabel.center = CGPoint(x: center.x + 10, y: center.y)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3, animations: {
                self.tipsLabel.center = CGPoint(x: center.x - 10, y: center.y)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.4, animations: {
                self.tipsLabel.center = CGPoint(x: center.x + 10, y: center.y)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1, animations: {
                self.tipsLabel.center = CGPoint(x: center.x, y: center.y)
            })
        }, completion: nil)
    }
}

class PatternLockSettingViewController: UIViewController {
    let touchView: CirclesView = CirclesView()
    let infoView: CircleInfoView = CircleInfoView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(touchView)
        view.addSubview(infoView)
    }
}
