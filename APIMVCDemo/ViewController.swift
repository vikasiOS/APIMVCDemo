//
//  ViewController.swift
//  APIMVCDemo
//
//  Created by theta-5-vikas on 06/04/18.
//  Copyright © 2018 Theta Technolabs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var dictRequest = [String: Any?]()

        dictRequest.updateValue("1234567890", forKey: "phone")

        User_API.shared.validate_otp { (handler) in

            if handler.0 {
                let data =  handler.1?.data
                if let data = data as? [[String: Any]] {
                   print(data)
                }
            } else {

            }

        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
