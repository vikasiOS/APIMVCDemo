/*
Copyright (C) 2015 to 2017 Praxinfo

This program not be modified unless it written permission is received from Praxinfo.

NOTE: This license agreement does not cover third-party components bundled with this software, which have their own license agreement with them. A list of included third-party components with references to their license files is provided with this distribution.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*/

import UIKit
import MagicalRecord
import SwiftyJSON
import Alamofire
import AFDateHelper
import HKKit
import netfox

open class API: NSObject {

    fileprivate struct Singleton {
        static let sharedInstance = API(queue: "App-operations-Queue")
    }

    open class var sharedInstance: API {
        return Singleton.sharedInstance
    }

    public static let sessionManger: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses?.insert(NFXProtocol.self, at: 0)
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 40
        configuration.timeoutIntervalForResource = 40
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }()

    var operationsQueue: OperationQueue!

    public typealias operationHandler = (((Bool, APIResponseHandler?, APINetworkOperation?)) -> Void)?

    override init() {
        super.init()

    }

    init(queue: String) {

        operationsQueue = OperationQueue()
        operationsQueue.maxConcurrentOperationCount =  4
        operationsQueue.name = queue

    }

    @discardableResult
    internal func operation(base: APIWebserviceURL = .rest,
                            _ endpoint: String,
                            perameters: [String: Any?]? = nil,
                            method: Alamofire.HTTPMethod = .post,
                            handlerError: Bool = false,
                            autoComplete: Bool = true,
                            body: String? = nil,
                            quality: QualityOfService? = nil,
                            queue: OperationQueue = API.sharedInstance.operationsQueue,
                            block: operationHandler = nil) -> APINetworkOperation {

        let operation = APINetworkOperation(base: base, URLString: endpoint, perams: perameters, method: method, body: body, quality: quality) { (json, error, op) -> Void in
            if error != nil {

                if handlerError {
                    self.displayError(error)
                }
                op.completeOperation()
                self.parseBlock(returnHandler: block)

            } else {
                let responseHandler = self.getResponseHandler(json)
                print(json)
                print(responseHandler.status)
                if  (!responseHandler.status) {
                    if let json = json {
                        if let reqId = (json)["requestID"] as? String {
                            if let errorDict = (json["error"] as? [String: Any]) {
                                if let errorCode = errorDict["code"] as? Int {
                                    if errorCode == 400 && (reqId == "zodiac-match-list" || reqId == "users") {
                                        block?((false, nil, op))
                                        op.completeOperation()
                                        return
                                    }
                                }
                            }
                        }
                    }

                    if autoComplete {
                        op.completeOperation()
                    }
                    block?((true, responseHandler, op))
//                    self.handleError(responseHandler, errorAlert: handlerError)
//                    block?((false, nil, op))
//                    op.completeOperation()

                } else {

                    if autoComplete {
                        op.completeOperation()
                    }
                    block?((true, responseHandler, op))

                }
            }

        }

        queue.addOperation(operation)
        return operation
    }

}

extension API {

    internal func displayError(_ error: NSError!, needDismiss: Bool = false) {

        if error != nil {

            if error.code != NSURLErrorCancelled {
                if error.code == -1009 || error.code == -1001 {
                    BasicFunctions.displayAlert(Strings.ErrorMessage.nonInternet, needDismiss: needDismiss)
                } else {
                    BasicFunctions.displayAlert(Strings.ErrorMessage.serverError, needDismiss: needDismiss)
                }
            }

        }

    }

    internal func handleError(_ obj: APIResponseHandler, errorAlert: Bool = true) {

        if obj.status == false {

            if errorAlert {
                BasicFunctions.displayAlert(obj.message_description ?? Strings.ErrorMessage.serverError)
            }
        }

    }

    internal func getResponseHandler(_ dictTemp: Dictionary<String, Any?>!) -> APIResponseHandler {

        let obj: APIResponseHandler = APIResponseHandler(dictionary: dictTemp)
        return obj

    }

    internal func parseBlock(_ handler:(sucess: Bool, responseHandler: APIResponseHandler?, op: APINetworkOperation?)? = nil, returnHandler: operationHandler?) {
        if handler?.sucess == true || returnHandler == nil {

            handler?.op?.completeOperation()

        }

        HKQueue.main.execute {
            returnHandler??((handler?.sucess ?? false, handler?.responseHandler, handler?.op))
        }

    }
    internal func isAPIRunning(_ url: String) -> Bool {

        return API.sharedInstance.operationsQueue.operations.filter({($0 as? APINetworkOperation)?.URLString == url}).count > 0
    }
}
