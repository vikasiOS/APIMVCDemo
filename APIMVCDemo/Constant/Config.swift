//
//  Config.swift
//  ZodiMatch
//
//  Created by Hardik on 18/01/18.
//  Copyright © 2018 Maitrey. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import AFDateHelper

class Config {

    static var app_name: String = "ACMA Event"
    static var db = app_name
    static var db_context: NSManagedObjectContext!
    static var db_memory_context: NSManagedObjectContext!

    static var api_logging_enable = false

    static var api_url_dev = "https://acma.elegant-media.com/api/v1/"
    static var api_url_prod = "https://acma.elegant-media.com/api/v1/"
    static var api_url_contact = "https://api.androidhive.info/"

    static var firebase_url = "https://acma-dev.firebaseio.com/acma/app"
    static var corner_radius: CGFloat = 4.0
    static var google_map_key = "AIzaSyBXlOIxzf2Khcc0obpdOjcXrH6_d2I6qfo"
    static var delegate = UIApplication.shared.delegate as! AppDelegate
    static var room_allocation_url = "https://www.apt.int/2018-APG19-3-Rooms"

    struct Custom_DateFormatter {

        static let event_start_date = DateFormatType.custom("dd-MM-yyyy")
        static let event_start_time = DateFormatType.custom("hh:mm a")
        static let event_start_date_detail = DateFormatType.custom("dd MMMM yyyy")

    }

//    static func getString(_ key: String, defaultString: String = "") -> String {
//        return Config.delegate.dictLanguage[key] as? String ?? defaultString
//    }

}

//var getLanguage: String{
//    get{
//        return BasicFunctions.getPreferences(userPrefrences.Language.rawValue) as? String ?? enumLanaguage.English.keyValue
//    }
//}
