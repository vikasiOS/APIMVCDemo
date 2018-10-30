//
//  UIImage+Extension.swift
//  HKCustomization
//
//  Created by Hardik on 10/18/15.
//  Copyright © 2015 . All rights reserved.
//

import UIKit
extension UITableViewCell {
   public func hk_removeAllGestures() {
        if let recognizers = self.contentView.gestureRecognizers {
            for recognizer in recognizers {
                self.contentView.removeGestureRecognizer(recognizer )
            }
        }
    }

}
extension UITableViewCell {

    public func hk_setSepratorInsetZero() {
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false

    }

    public func hk_enable(_ on: Bool) {
        self.isUserInteractionEnabled = on
        for view in contentView.subviews {
            view.isUserInteractionEnabled = on
            view.alpha = on ? 1 : 0.5
        }
    }
}
