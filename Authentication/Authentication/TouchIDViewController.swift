//
//  TouchIDViewController.swift
//  Authentication
//
//  Created by Sim Jin on 2016/12/22.
//  Copyright © 2016年 UFunNetwork. All rights reserved.
//

import UIKit
import LocalAuthentication

class TouchIDViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        touchIDAuthentication()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTappedUnlockButton(_ sender: Any) {
		touchIDAuthentication()
    }

    func touchIDAuthentication() {
        let context = LAContext()
        let reason = "通过Home键验证已有手机指纹"
        context.localizedFallbackTitle = "验证登录密码" // 输入错误的时候显示，默认是"输入密码"

        var error: NSError? = nil
        if #available(iOS 8.0, OSX 10.12, *) {
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, evaluateError) in
                    if (success) {
                        print("success")
                    } else {
                        switch (error! as NSError).code { // or error!._code
                        case LAError.authenticationFailed.rawValue:
                            print("密码错误")
                        case LAError.userCancel.rawValue:
                            print("用户取消")
                        case LAError.systemCancel.rawValue:
                            print("系统取消")
                        case LAError.userFallback.rawValue:
                            print("点击了验证登录密码")
                        default: break
                        }


                    }
                }
            } else {
                var message: String? = nil
                switch error!.code {
                case LAError.touchIDLockout.rawValue:
                    message = "错误次数过多，请尝试其他登录方式"
                case LAError.touchIDNotEnrolled.rawValue:
					message = "尚未设置指纹密码"
                case LAError.touchIDNotAvailable.rawValue:
                    message = "暂不支持使用指纹密码"
                case LAError.passcodeNotSet.rawValue:
                    message = "尚未设置密码"
                default:
                    message = ""
                }
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "验证失败", message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                   	self.present(alertController, animated: true, completion: nil)
                }
            }
        } else {
            let alertController = UIAlertController(title: "验证失败", message: "当前系统版本不支持手势密码", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

