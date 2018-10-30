//
//  HKoperationQueue.swift
//  Genemedics
//
//  Created by Praxinfo on 6/2/16.
//  Copyright © 2016 Praxinfo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import HKKit

open class APINetworkOperation: HKOperation {

    let URLString: String

    typealias handler = (([String: Any]?, NSError?, APINetworkOperation) -> Void?)?
    let responseHandler: handler
    var perams: [String: Any]?
    let method: Alamofire.HTTPMethod
    var body: String?
    weak var request: Alamofire.Request?
    fileprivate var maxRetry: Int = 2
    fileprivate var currentRetry = 0
    var base: APIWebserviceURL

    init(base: APIWebserviceURL,
         URLString: String,
         perams: [String: Any?]? = nil,
         method: Alamofire.HTTPMethod = .post,
         body: String? = nil, quality: QualityOfService?,
         block: (([String: Any]?, NSError?, APINetworkOperation) -> Void?)? = nil) {

        self.URLString = URLString
        self.responseHandler = block
        self.method = method
        self.base = base
        super.init()
        self.perams = self.updatePerams(perams)
        self.body = body
        self.qualityOfService = quality ?? .background
        if self.qualityOfService != .background {
            self.queuePriority = .veryHigh
        } else {
            self.queuePriority = .veryLow

        }

    }

    func updatePerams(_ perams: [String: Any?]?) -> [String: Any]? {

        return perams?.reduce([String: Any]()) { (dict, e) in

            guard let data = e.1, let value = JSON(data).rawValue as Any? else { return dict}
            var dict = dict
            dict[e.0] = value
            return dict

        }
    }

    override open func main() {

        let requestConvertible: URLRequestConvertible = APIRequestConvertible.construct(base: base, method, URLString, headers: self.getRequestHeaders(), perms: perams, body: body)

        self.request = API.sessionManger.request(requestConvertible).response { response in

            self.validateResponseError(response: response)

            }.debugLog().responseSwiftyJSON {(_, _, json, error) -> Void in

                if Config.api_logging_enable {
                    debugPrint(json)
                }
                self.mainHandler(json.dictionaryObject, error: error)

        }

    }

    class func headers() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]

        return headers
    }

    func getRequestHeaders() -> [String: String] {

//        guard let token = Config.user?.access_token else {
//            return [:]
//        }

       return ["Content-Type": "application/json"]
       // return ["httpx-thetatech-accesstoken": token]
    }

    func validateResponseError(response: DefaultDataResponse) {

        if let code = response.response?.statusCode, code == 401 {
            API.sharedInstance.operationsQueue.cancelAllOperations()
            HKQueue.main.execute({ () -> Void in

            })
        }
    }

    func restart() {
        self.start()
    }

    fileprivate func mainHandler(_ response: [String: Any]?, error: NSError?) {

        currentRetry += 1
        if error != nil  && currentRetry < maxRetry {
            self.restart()
        } else {
            self.responseHandler?(response, error, self)

        }

    }
    private func getRunningAPI(_ url: String) -> APINetworkOperation? {

        return API.sharedInstance.operationsQueue.operations.filter({($0 as? APINetworkOperation)?.URLString == url}).first as? APINetworkOperation
    }
    override open func cancel() {
        currentRetry = maxRetry
        request?.cancel()
        super.cancel()

    }
}

extension DataRequest {
    public func debugLog() -> Self {
        #if DEBUG
            if Config.api_logging_enable {
                debugPrint("API Name ::::::::::::::::::", self.request!.url!, terminator: "\n\n")
                debugPrint(self)
                debugPrint(terminator: "\n\n")
            }

        #endif
        return self
    }

    @discardableResult
    public func responseSwiftyJSON(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        _ completionHandler:@escaping (URLRequest, HTTPURLResponse?, SwiftyJSON.JSON, NSError?) -> Void)
        -> Self {

            return response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer(options: options), completionHandler: { (response) in

                DispatchQueue.global(qos: .default).async(execute: {

                    var responseJSON: JSON
                    if response.result.isFailure {
                        responseJSON = JSON.null
                    } else {
                        responseJSON = SwiftyJSON.JSON(response.result.value!)
                        responseJSON.dictionaryObject!["requestID"] = response.request?.url?.lastPathComponent

                    }
                    (queue ?? DispatchQueue.main).async(execute: {
                        completionHandler(response.request!, response.response, responseJSON, response.result.error as NSError?)
                    })
                })

            })
    }

}
