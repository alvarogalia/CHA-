//
//  funciones.swift
//  Chauchas
//
//  Created by Alvaro Galia Valenzuela on 04-03-18.
//  Copyright © 2018 Alvaro Galia Valenzuela. All rights reserved.
//

import Foundation
import Security
import UIKit
import SystemConfiguration.CaptiveNetwork
import GoogleMobileAds

extension UIView {
    func addBannerViewToView(bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bannerView)
        self.addConstraints([NSLayoutConstraint(item: bannerView,attribute: .top,relatedBy: .equal,toItem: self,attribute: .top,multiplier: 1,constant: 0),NSLayoutConstraint(item: bannerView,attribute: .centerX,relatedBy: .equal,toItem: self,attribute: .centerX,multiplier: 1,constant: 0)])
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

func hmac(hashName:String, message:Data, key:Data) -> Data? {
    let algos = ["SHA1":   (kCCHmacAlgSHA1,   CC_SHA1_DIGEST_LENGTH),
                 "MD5":    (kCCHmacAlgMD5,    CC_MD5_DIGEST_LENGTH),
                 "SHA224": (kCCHmacAlgSHA224, CC_SHA224_DIGEST_LENGTH),
                 "SHA256": (kCCHmacAlgSHA256, CC_SHA256_DIGEST_LENGTH),
                 "SHA384": (kCCHmacAlgSHA384, CC_SHA384_DIGEST_LENGTH),
                 "SHA512": (kCCHmacAlgSHA512, CC_SHA512_DIGEST_LENGTH)]
    guard let (hashAlgorithm, length) = algos[hashName]  else { return nil }
    var macData = Data(count: Int(length))
    
    macData.withUnsafeMutableBytes {macBytes in
        message.withUnsafeBytes {messageBytes in
            key.withUnsafeBytes {keyBytes in
                CCHmac(CCHmacAlgorithm(hashAlgorithm),
                       keyBytes,     key.count,
                       messageBytes, message.count,
                       macBytes)
            }
        }
    }
    return macData
}

func getRequest(body:[String : String]) -> URLRequest{
    let timestamp = NSDate().timeIntervalSince1970
    let timestamp2 = timestamp*1000
    let timestamp3 = Int(timestamp2)
    let timestamp4 = Double(timestamp3) / 1000.0
    let timestamp5 = Int(timestamp4)
    
    let standard = UserDefaults.standard
    
    var apiKey = ""
    var secret = ""
    
    if let ApiKeySession = standard.object(forKey: "ApiKey") as? String {apiKey = ApiKeySession}
    if let SecretKeySession = standard.object(forKey: "SecretKey") as? String {secret = SecretKeySession}
    
    let requestURL = URL(string: "https://api2.orionx.io/graphql")
    var request = URLRequest(url: requestURL!)

    let jsonData = try? JSONSerialization.data(withJSONObject: body)
    let bodyStr = String(data: jsonData!, encoding: String.Encoding.utf8)
    let signature = hmac(hashName: "SHA512", message: "\(timestamp5)\(bodyStr ?? "")".data(using: String.Encoding.utf8)!, key: secret.data(using: String.Encoding.utf8)!)
    
    let headers: [String:String] = [
            "Content-Type":"application/json",
            "X-ORIONX-TIMESTAMP":"\(timestamp5)",
            "X-ORIONX-APIKEY":apiKey,
            "X-ORIONX-SIGNATURE":(signature?.hexEncodedString())!,
            "Content-Length":"\(bodyStr!.count)"]
    request.allHTTPHeaderFields = headers
    request.httpMethod = "POST"
    request.httpBody = jsonData
    
    request.timeoutInterval = 60
    
    return request
}

func getRequestInicial(ApiKey:String, SecretKey:String, body:[String : String]) -> URLRequest{
    let timestamp = NSDate().timeIntervalSince1970
    let timestamp2 = timestamp*1000
    let timestamp3 = Int(timestamp2)
    let timestamp4 = Double(timestamp3) / 1000.0
    let timestamp5 = Int(timestamp4)
    let apiKey = ApiKey
    let secret = SecretKey
    
    let requestURL = URL(string: "https://api2.orionx.io/graphql")
    var request = URLRequest(url: requestURL!)
    let jsonData = try? JSONSerialization.data(withJSONObject: body)
    let bodyStr = String(data: jsonData!, encoding: String.Encoding.utf8)
    
    let signature = hmac(hashName: "SHA512", message: "\(timestamp5)\(bodyStr ?? "")".data(using: String.Encoding.utf8)!, key: secret.data(using: String.Encoding.utf8)!)
    
    let headers: [String:String] = ["Content-Type":"application/json","X-ORIONX-TIMESTAMP":"\(timestamp5)","X-ORIONX-APIKEY":apiKey,"X-ORIONX-SIGNATURE":(signature?.hexEncodedString())!,"Content-Length":"\(bodyStr!.count)"]
    
    request.allHTTPHeaderFields = headers
    request.httpMethod = "POST"
    request.httpBody = jsonData
    
    request.timeoutInterval = 60
    
    return request
}


extension Double {
    func toString(Decimales:Int) -> String {
        return String(format: "%.\(Decimales)f",self)
    }
    func toStringTrail(Decimales:Int) -> String{
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = Decimales
        formatter.minimumIntegerDigits = 1
        return formatter.string(from: NSNumber(value: self)) ?? "0.0"
    }
}

func getWiFiSsid() -> String? {
    var ssid: String?
    if let interfaces = CNCopySupportedInterfaces() as NSArray? {
        for interface in interfaces {
            if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                break
            }
        }
    }
    return ssid
}

extension String {
    var floatValue: Float {
        let nf = NumberFormatter()
        nf.decimalSeparator = "."
        if let result = nf.number(from: self) {
            return result.floatValue
        } else {
            nf.decimalSeparator = ","
            if let result = nf.number(from: self) {
                return result.floatValue
            }
        }
        return 0
    }
    
    var doubleValue:Double {
        let nf = NumberFormatter()
        nf.decimalSeparator = "."
        if let result = nf.number(from: self) {
            return result.doubleValue
        } else {
            nf.decimalSeparator = ","
            if let result = nf.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}
