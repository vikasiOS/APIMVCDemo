//
//  APIResponseHandler.swift
//  ProfessionalDating
//
//

import UIKit
import Foundation
@objc

open class APIResponseHandler: NSObject {

    var status: Bool = false
    var message: String?
    var message_description: String?
    var code: Int?
    var data: AnyObject?
    var isMatched: Bool = false
    var requestID: String?
    var error: [String: Any]?

    public init(dictionary: [String: Any?]) {
        super.init()

        self.error = dictionary["error"] as? [String: Any]
        self.code = dictionary["code"] as? Int ?? 0
        self.data = dictionary["response_data"] as AnyObject
        self.message = dictionary["message"] as? String ??  self.error?["message"] as? String
        self.message_description = dictionary["description"] as? String ?? self.error?["description"] as? String
        self.status = self.code == 200 || self.code == 201

    }

}
