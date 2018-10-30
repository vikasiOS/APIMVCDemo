//
//  File.swift
//  ZodiMatch
//
//  Created by Hardik on 18/01/18.
//  Copyright © 2018 Maitrey. All rights reserved.
//

import Foundation
import Alamofire

enum APIRequestConvertible: URLRequestConvertible {

    case construct(base:APIWebserviceURL, Alamofire.HTTPMethod, String, headers:[String:String], perms:[String: Any]?, body:String?)

    func asURLRequest() throws -> URLRequest {
        let construct:(base: APIWebserviceURL,
            method: Alamofire.HTTPMethod,
            endPoint: String,
            encoding: Alamofire.ParameterEncoding,
            headers: [String: String],
            perms: [String: Any]?) = {

                switch self {
                case .construct(let base, let method, let endPoint, let header, let perms, let body):
                    return parseRequest(base: base, method: method, endPoint: endPoint, headers: header, perms: perms, body: body)

                }

        }()

        let url = try construct.base.baseURL.asURL()

        var urlRequest =  NSMutableURLRequest(url: url.appendingPathComponent(construct.endPoint))
        urlRequest.httpMethod = construct.method.rawValue
        urlRequest.allHTTPHeaderFields = construct.headers

        urlRequest = try! (construct.encoding.encode(urlRequest, with: construct.perms) as NSURLRequest).mutableCopy() as! NSMutableURLRequest

        if urlRequest.httpBody != nil {
            URLProtocol.setProperty(urlRequest.httpBody!, forKey: "NFXBodyData", in: urlRequest)
        }

        return urlRequest as URLRequest

    }

    private func parseRequest(base: APIWebserviceURL,
                              method: Alamofire.HTTPMethod,
                              endPoint: String,
                              headers: [String: String],
                              perms: [String: Any]?,
                              body: String?) -> (base: APIWebserviceURL, method: Alamofire.HTTPMethod, endPoint: String, encoding: Alamofire.ParameterEncoding, headers: [String: String], perms: [String: Any]?) {

        if body != nil {
            return (base, method, endPoint, StringBodyEncoding(string: body!), headers, perms)
        } else if method == .post || method == .put {
            return (base, method, endPoint, JSONEncoding.default, headers, perms)
        } else {
            return (base, method, endPoint, URLEncoding.default, headers, perms)
        }

    }

}

struct StringBodyEncoding: ParameterEncoding {
    private let string: String

    init(string: String) {
        self.string = string
    }

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest.urlRequest

        if var urlComponents = URLComponents(url: urlRequest!.url!, resolvingAgainstBaseURL: false), parameters?.isEmpty == false {
            let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters!)
            urlComponents.percentEncodedQuery = percentEncodedQuery
            urlRequest?.url = urlComponents.url
        }
        urlRequest?.httpBody = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        return urlRequest!
    }

    func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += URLEncoding.default.queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }

}
extension NSMutableURLRequest: URLRequestConvertible {

    public func asURLRequest() throws -> URLRequest {

        return self as URLRequest

    }

}
