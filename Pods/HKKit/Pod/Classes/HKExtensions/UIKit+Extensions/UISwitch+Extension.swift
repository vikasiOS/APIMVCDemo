//
//  UISwitch+Extension.swift
//  HKCustomization
//
//  Created by Hardik on 10/18/15.
//  Copyright © 2015 . All rights reserved.
//

import UIKit

extension UISwitch {

    public func hk_toString() -> String {

        if self.isOn {
            return "on"
        }
        return "off"
    }
    public func hk_fromString(value: String?) {
        guard let value = value else {
            self.isOn = false
            return
        }

        self.isOn = value.uppercased() == "ON"
    }

}
