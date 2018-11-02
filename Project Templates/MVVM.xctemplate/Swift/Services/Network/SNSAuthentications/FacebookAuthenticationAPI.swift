//
//  FacebookAuthenticationAPI.swift
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import UIKit

import FBSDKLoginKit
import FBSDKCoreKit
import Alamofire
import RxSwift

enum FacebookError: Error {
    case cancelled
    case loginFailed(Error)
    case cannotGetInfo

}

extension FacebookError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cancelled:
            return "The login was cancelled by the user"

        case .loginFailed(let error):
            return error.localizedDescription

        case .cannotGetInfo:
            return "Failed to to get facebook information"
        }
    }
}

class FacebookAuthenticationAPI {
    class func requestFacebookPermission(fromViewController viewController: UIViewController) -> Observable<Void> {
        let permision = ["public_profile", "email"]
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        return Observable<Void>.create { (observer) -> Disposable in
            loginManager.logIn(withReadPermissions: permision, from: viewController) { (result, error) in
                if let error = error {
                    observer.onError(FacebookError.loginFailed(error))

                } else {
                    if result?.isCancelled == true {
                        observer.onError(FacebookError.cancelled)

                    } else {
                        observer.onNext(())
                    }
                }

                observer.onCompleted()
            }

            return Disposables.create()
        }
    }

    /** Return Facebook token */
    class func getFacebookUserToken() -> Observable<String> {
        let param = ["fields": "id, name, email, birthday, first_name, last_name, picture.type(large)"]
        guard let request = FBSDKGraphRequest(graphPath: "me", parameters: param) else {
            return Observable<String>.error(FacebookError.cannotGetInfo)
        }
        return Observable<String>.create { (observer) -> Disposable in
            request.start { (_, result, error) in
                if let error = error {
                    observer.onError(FacebookError.loginFailed(error))

                } else {
                    guard let json = result as? [String: Any], let token = FBSDKAccessToken.current().tokenString else { return }

                    guard let email = json["email"] as? String, email.isNotEmpty else {
                        return observer.onError(FacebookError.cannotGetInfo)
                    }

                    let pictureDict = json["picture"] as? [String: Any]
                    let pictureData = pictureDict?["data"] as? [String: Any]
                    let pictureURL = pictureData?["url"] as? String

                    #if DEBUG
                        debugPrint("Token \(token), email \(email), profile picture \(pictureURL ?? "emptyURL")")
                    #endif

                    observer.onNext(token)
                }

                observer.onCompleted()
            }

            return Disposables.create()
        }
    }

}
