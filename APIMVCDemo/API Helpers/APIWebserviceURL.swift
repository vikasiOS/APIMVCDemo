//
//  File.swift
//  ZodiMatch
//
//  Created by Hardik on 18/01/18.
//  Copyright © 2018 Maitrey. All rights reserved.
//

import Foundation
public enum APIWebserviceURL {

    case rest
    case socket

    public var baseURL: String {

        switch self {
        case .rest:

          //  #if DEV || R_DEV

                return Config.api_url_contact

           // #elseif PROD || R_PROD

               // return Config.api_url_contact
          //  #endif

        case .socket:
            return ""

        }

        return ""
    }

    public var host: String {

        guard  let host = self.baseURL.components(separatedBy: "://").last else {
            return ""
        }

        return host

    }

}
