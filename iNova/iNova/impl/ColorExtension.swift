//
//  ColorExtension.swift
//  iNova
//
//  Created by Mason Scherbarth on 5/13/22.
//
//  Used for creating colors with HEX codes

import SwiftUI

extension Color {
    static let example = Color(hexStringToUIColor(hex: "000000"))
    
    static let buttonColor = Color(hexStringToUIColor(hex: "f3f2fb"))
    static let buttonText = Color(hexStringToUIColor(hex: "0079fb"))
}

func hexStringToUIColor(hex: String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

