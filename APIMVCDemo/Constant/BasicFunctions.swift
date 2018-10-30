//
//  BasicFunctions.swift
//  Boo'sBaar
//
//  Created by Maitrey on 10/02/16.
//  Copyright © 2016 Maitrey. All rights reserved.
//

import Foundation
import UIKit

class BasicFunctions: NSObject {

    class func setPreferences(_ value: Any!, key: String) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }

    class func getPreferences(_ key: String!) -> Any! {
        let defaults: UserDefaults = UserDefaults.standard
        return defaults.object(forKey: key) as Any!
    }

    class func removePreferences(_ key: String!) {
        let userDefault: UserDefaults = UserDefaults.standard
        userDefault.removeObject(forKey: key)
        userDefault.synchronize()
    }

    class func setBoolPreferences(_ val: Bool, forkey key: String!) {
        let userDefault: UserDefaults = UserDefaults.standard
        userDefault.set(val, forKey: key)
        userDefault.synchronize()
    }

    class func getBoolPreferences(_ key: String!) -> Bool {
        let userDefault: UserDefaults = UserDefaults.standard
        return userDefault.bool(forKey: key)
    }

    class func maskImage(_ originalImage: UIImage!, maskImage: UIImage!) -> UIImage! {

        let mask: CGImage = CGImage(maskWidth: originalImage.cgImage!.width,
            height: originalImage.cgImage!.height,
            bitsPerComponent: originalImage.cgImage!.bitsPerComponent,
            bitsPerPixel: originalImage.cgImage!.bitsPerPixel,
            bytesPerRow: originalImage.cgImage!.bytesPerRow,
            provider: originalImage.cgImage!.dataProvider!, decode: nil, shouldInterpolate: true)!

        let maskedImageRef: CGImage = maskImage.cgImage!.masking(mask)!
        let finalImage: UIImage? = UIImage(cgImage: maskedImageRef)

        return finalImage

    }

    class func imageWithColor(_ color1: UIColor, img: UIImage) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)

        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: img.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height) as CGRect
        context.clip(to: rect, mask: img.cgImage!)
        color1.setFill()
        context.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()

        return newImage

    }

    class func imageFromColor(_ color: UIColor, size: CGSize) -> UIImage {

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image

    }

    class func heightOfLabelWithWidth(_ titleText: NSString, font: UIFont, width: CGFloat) -> CGFloat {

        let maxSize: CGSize = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let labelRect: CGRect = titleText.boundingRect(with: maxSize, options: ([NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading]), attributes: [NSAttributedStringKey.font: font], context: nil)
        return labelRect.size.height

    }

    class func getProperSize(_ image: UIImage!, withWidth width: CGFloat, withHeight height: (CGFloat)) -> UIImage {

        var newSize: CGSize = CGSize(width: width, height: height)
        let widthRatio: CGFloat = newSize.width/image.size.width
        let heightRatio: CGFloat = newSize.height/image.size.height

        if(widthRatio > heightRatio) {
            newSize = CGSize(width: image.size.width*widthRatio, height: image.size.height*widthRatio)

        } else {
            newSize=CGSize(width: image.size.width*heightRatio, height: image.size.height*heightRatio)
        }

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    // MARK: Convert Obj to Dict
//    class func Object_TO_Dict(_ obj:AnyObject)->NSMutableDictionary{
//        
//        var propertiesCount : CUnsignedInt = 0
//        let propertiesInAClass : UnsafeMutablePointer<Category> = class_copyPropertyList(obj.classForCoder, &propertiesCount)
//        let propertiesDictionary : NSMutableDictionary = NSMutableDictionary()
//        
//        for i in 0 ..< Int(propertiesCount) {
//            let strKey : NSString? = NSString(cString: property_getName(propertiesInAClass[i]), encoding: String.Encoding.utf8.rawValue)
//            propertiesDictionary.setValue(obj.value(forKey: strKey! as String), forKey: strKey! as String)
//        }
//        
////        for var i = 0; i < Int(propertiesCount); i++ {
////            let strKey : NSString? = NSString(CString: property_getName(propertiesInAClass[i]), encoding: NSUTF8StringEncoding)
////            propertiesDictionary.setValue(obj.valueForKey(strKey! as String), forKey: strKey! as String)
////        }
//        return propertiesDictionary
//    }

    // MARK: Convert Dict to Obj
    class func Dict_to_object(_ dict: Dictionary<String, AnyObject?>, obj: AnyObject) -> AnyObject {
        for (key, value) in dict {

            if (obj.responds(to: NSSelectorFromString(key))) {
                obj.setValue(value, forKey: key)
            }
        }
        return obj
    }

    // MARK: Global Dialog display mentod
    class func displayAlert(_ msg: String!, needDismiss: Bool = false, title: String = Config.app_name) {

        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Temp", style: .cancel) { (_) in
            if needDismiss {
                UIViewController.hk_currentViewController()!.dismiss(animated: true, completion: nil)
            }
        }
        alertController.addAction(defaultAction)

        UIViewController.hk_currentViewController()!.present(alertController, animated: true, completion: nil)
    }

    class func contains(_ text: String, substring: String,
                        ignoreCase: Bool = true,
                        ignoreDiacritic: Bool = true) -> Bool {

        var options = NSString.CompareOptions()

        if ignoreCase { _ = options.insert(NSString.CompareOptions.caseInsensitive) }
        if ignoreDiacritic { _ = options.insert(NSString.CompareOptions.diacriticInsensitive) }

        return text.range(of: substring, options: options) != nil
    }

    class func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName )
            print("Font Names = [\(names)]")
        }
    }

    class func redirectToStoryboard (_ strStoryBoardName: String) {
        let mainStoryboard: UIStoryboard? = UIStoryboard(name: strStoryBoardName, bundle: nil)
        let rootController = mainStoryboard!.instantiateInitialViewController()
        Config.delegate.window?.rootViewController = rootController
    }

    class func imageSizeAspectFit(imgview: UIImageView) -> CGSize {

        var newwidth: CGFloat
        var newheight: CGFloat
        let image: UIImage = imgview.image!

        if image.size.height >= image.size.width {
            newheight = imgview.frame.size.height
            newwidth = (image.size.width / image.size.height) * newheight
            if newwidth > imgview.frame.size.width {
                let diff: CGFloat = imgview.frame.size.width - newwidth
                newheight = newheight + diff / newheight * newheight
                newwidth = imgview.frame.size.width
            }
        } else {
            newwidth = imgview.frame.size.width
            newheight = (image.size.height / image.size.width) * newwidth
            if newheight > imgview.frame.size.height {
                let diff: CGFloat = imgview.frame.size.height - newheight
                newwidth = newwidth + diff / newwidth * newwidth
                newheight = imgview.frame.size.height
            }
        }

        print(newwidth, newheight)
        //adapt UIImageView size to image size
        return CGSize(width: newwidth, height: newheight)
    }

    class func convertTimestampToDate(_ timestamp: Double, dateformate: String) -> String {

        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateformate
        let strDate = dateFormatter.string(from: date)
        return strDate
    }

    class func convertDateToString(_ date: Date, dateformate: String) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateformate
        let strDate = dateFormatter.string(from: date)
        return strDate
    }

    class func convertStringToDate(_ date: String, dateformate: String) -> Date {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateformate
        let reDate: Date = dateFormatter.date(from: date)!
        return reDate
    }

}
