//
//  User_API.swift
//  ZodiMatch
//
//  Created by Hardik on 22/01/18.
//  Copyright © 2018 Theta. All rights reserved.
//

import Foundation
import MagicalRecord

class User_API: API {
    let API_REGISTER_PHONE = "contacts"
    let USER_VEHICLE = "users/vehicles"
    let USER_GET_PRO = "users/prophecies"
//    let API_REGISTER_SOCIAL = "/user/register-social"
//    let API_VALIDATE_OTP = "/user/validate-otp"
//    let API_UPDATE_PROFILE = "/user/update-profile"
//    let API_UPDATE_SETTING = "/user/user-settings"
//    let API_USER_PLAN = "/user/plan"

    fileprivate struct Singleton {
        static let shared = User_API()
    }

    internal class var shared: User_API {
        return Singleton.shared
    }

    @discardableResult
    func validate_otp(block: operationHandler = nil) -> APINetworkOperation {

        return self.operation(API_REGISTER_PHONE, handlerError: true, quality: .userInteractive) { (handler) in

            if handler.0 {

                guard let data = handler.1?.data else {
                    self.parseBlock(handler, returnHandler: block)
                    return
                }
                self.parseBlock(handler, returnHandler: block)
                //Config.user?.setting = User_Setting.mr_import(from: data)
                //                            self.hk_updateCoreData({
                //                                self.parseBlock(handler, returnHandler: block)
                //                            })
            } else {

                self.parseBlock(handler, returnHandler: block)
            }

        }
    }

    @discardableResult
    func update_profile(_ body: String?, block: operationHandler = nil) -> APINetworkOperation {

        return self.operation(USER_VEHICLE, handlerError: true, body: body, quality: .userInteractive )

    }

    @discardableResult
    func get_prophecies(block: operationHandler = nil) -> APINetworkOperation {

        return self.operation(API_REGISTER_PHONE, handlerError: true, quality: .userInteractive ) { (handler) in

                        if handler.0 {

                            guard let data = handler.1?.data else {
                                self.parseBlock(handler, returnHandler: block)
                                return
                            }
                            self.parseBlock(handler, returnHandler: block)
                            //Config.user?.setting = User_Setting.mr_import(from: data)
//                            self.hk_updateCoreData({
//                                self.parseBlock(handler, returnHandler: block)
//                            })
                        } else {

                            self.parseBlock(handler, returnHandler: block)
                        }

                    }

    }

//    @discardableResult
//    func user_setting(_ body: String?, block: operationHandler = nil) -> APINetworkOperation {
//
//        return self.operation(API_UPDATE_SETTING, handlerError: true, body: body, quality: .userInteractive ) { (handler) in
//
//            if handler.0 {
//
//                guard let data = handler.1?.data else {
//                    self.parseBlock(handler, returnHandler: block)
//                    return
//                }
//                Config.user?.setting = User_Setting.mr_import(from: data)
//                self.hk_updateCoreData({
//                    self.parseBlock(handler, returnHandler: block)
//                })
//            } else {
//
//                self.parseBlock(handler, returnHandler: block)
//            }
//
//        }
//
//    }
//

//    @discardableResult
//    func user_plan(_ body: String?, block: operationHandler = nil) -> APINetworkOperation {
//
//        return self.operation(API_USER_PLAN, handlerError: true, body: body, quality: .userInteractive ) { (handler) in
//
//            if handler.0 {
//
//                guard let data = handler.1?.data else {
//                    self.parseBlock(handler, returnHandler: block)
//                    return
//                }
//                Config.user?.setting = User_Setting.mr_import(from: data)
//                self.hk_updateCoreData({
//                    self.parseBlock(handler, returnHandler: block)
//                })
//            } else {
//
//                self.parseBlock(handler, returnHandler: block)
//            }
//
//        }
//
//    }

//    @discardableResult
//    func user_plan(_ body: String?, block: operationHandler = nil) -> APINetworkOperation {
//
//        return self.operation(API_USER_PLAN, handlerError: true, body: body, quality: .userInteractive ) { (handler) in
//
//            if handler.0 {
//
//                MagicalRecord.save({ (local) -> Void in
//
//                    guard let data = handler.1?.data else {
//                        self.parseBlock(handler, returnHandler: block)
//                        return
//                    }
//                    let user = User_Info.mr_import(from: data, in: local)
//
//                    guard let images = handler.1?.data?.value(forKey: "images") as? [String] else {
//                        self.parseBlock(handler, returnHandler: block)
//                        return
//                    }
//
//                    let imageData = images.map({ (url) -> [String:String] in
//                        return ["url":url]
//                    })
//                    User_Images.mr_truncateAll(in: local)
//                    user.images = NSSet(array: User_Images.mr_importAll(imageData, in: local))
//
//                }, completion: { (_, _) -> Void in
//
//                    self.parseBlock(handler, returnHandler: block)
//                })
//            } else {
//
//                self.parseBlock(handler, returnHandler: block)
//            }
//
//        }
//
//    }

}
