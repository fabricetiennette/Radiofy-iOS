//
//  RadioStation.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 09/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

//import UIKit
//
//struct RadioStation: Codable {
//    let name: String
//    let imageURL: String
//    let streamURL: String
//    let unformattedColor: String
//
//    init(name: String, imageURL: String, streamURL: String, unformattedColor: String) {
//        self.name = name
//        self.imageURL = imageURL
//        self.streamURL = streamURL
//        self.unformattedColor = unformattedColor
//    }
//}
//
//extension RadioStation {
//
//    var color: UIColor {
//        var colorString: String = unformattedColor
//
//        if colorString.hasPrefix("#") {
//            colorString.remove(at: colorString.startIndex)
//        }
//
//        if (colorString.count) != 6 {
//            return UIColor.gray
//        }
//
//        var rgbValue: UInt64 = 0
//        Scanner(string: colorString).scanHexInt64(&rgbValue)
//
//        return UIColor(
//            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//            alpha: CGFloat(1.0)
//        )
//    }
//}
