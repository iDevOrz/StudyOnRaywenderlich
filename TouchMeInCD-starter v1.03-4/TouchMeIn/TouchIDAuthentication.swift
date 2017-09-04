//
//  TouchIDAuthentication.swift
//  TouchMeIn
//
//  Created by 张建宇 on 2017/9/3.
//  Copyright © 2017年 iT Guy Technologies. All rights reserved.
//

import Foundation
import LocalAuthentication

class TouchIDAuth{
    let context = LAContext()
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }
    
    func authenticateUser(completion: @escaping(String?) -> Void) {
        guard canEvaluatePolicy() else{
            completion("Touch ID not available")
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Logging in with Touch Id") { (success, evaluateError) in
            
            if success {
                DispatchQueue.main.async{
                    completion(nil)
                }
            }else{
                // TODO: deal with LAerror cases
                let message:String
                switch evaluateError{
                case LAError.authenticationFailed?:
                    message = "There was a problem verifying your identity."
                case LAError.userCancel?:
                    message = "You pressed cancal."
                case LAError.userCancel?:
                    message = "You pressed password."
                default:
                    message = "Touch ID may not be cofigured"
                }
                completion(message)
            }
            
        }
    }
}
