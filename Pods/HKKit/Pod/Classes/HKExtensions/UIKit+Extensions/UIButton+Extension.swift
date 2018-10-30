//
//  UIButton+Extension.swift
//  HKCustomization
//
//  Created by Hardik on 10/18/15.
//  Copyright © 2015 . All rights reserved.
//

import UIKit

extension UIButton {

    public func hk_toggleOnOff() {
        self.isSelected = !self.isSelected
    }
    public func hk_setDisableWithAlpha(_ isDisable: Bool) {
        if isDisable {
            self.isEnabled = false
            self.alpha = 0.5
        } else {
            self.isEnabled = true
            self.alpha = 1.0
        }
    }
    public func hk_appleBootStrapTheme(_ color: UIColor = HKConstant.sharedInstance.main_color) {

        self.layer.borderWidth = 1
        self.layer.cornerRadius = 2
        self.layer.borderColor = color.cgColor
        self.setTitleColor(color, for: UIControlState())
    }

    public func hk_setAttributeString(_ mainString: String, attributeString: String, attributes: [NSAttributedStringKey: Any]) {

        let result = hk_getAttributeString(mainString, attributeString: attributeString, attributes: attributes)
        self.setAttributedTitle(result, for: .normal)

    }

    public func hk_setAttributesString(_ mainString: String, attributeStrings: [String], total_attributes: [[NSAttributedStringKey: Any]]) {

        let result = hk_getMultipleAttributesString(mainString, attributeStrings: attributeStrings, total_attributes: total_attributes)
        self.setAttributedTitle(result, for: .normal)

    }
}
