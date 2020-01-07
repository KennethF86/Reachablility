//
//  File.swift
//  Reachablility
//
//  Created by Kenneth Frandsen on 17/12/2019.
//  Copyright © 2019 Mustache. All rights reserved.

import UIKit
import Foundation
import SystemConfiguration

public class Reachability: UIResponder, UIApplicationDelegate {
    
    public override init() {}
    
    let appDelegate = UIApplication.shared.delegate
    
    public enum screenType: String {
        case full
        case topBar
    }
    
    public class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
    
    let overlayView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    var alreadyShowing: Bool = false
    var overlayTextView = UILabel()
    let overlayImageView = UIImageView()
    
    public func checkConnection(alertMessages: String, screenType: screenType, backgroundColor: UIColor, textColor: UIColor, textFont: UIFont, alertIcon: UIImage?) {
        
        let time: Double = 2
        
        _ = Timer.scheduledTimer(withTimeInterval: time, repeats: true) {
            (_) in
            
            if Reachability.isConnectedToNetwork(){
                self.showOverlayTopbar(alertMessage: alertMessages, backgroundColor: backgroundColor, textColor: textColor, textFont: textFont, alertIcon: alertIcon)
                //                print("Internet Connection Available!")
                //                self.hideOverlayView()
            }else{
                //                print("Internet Connection not Available!")
                if screenType == .full {
                    self.showOverlayFullScreen(alertMessage: alertMessages, backgroundColor: backgroundColor, textColor: textColor, textFont: textFont, alertIcon: alertIcon)
                } else if screenType == .topBar {
                    self.showOverlayTopbar(alertMessage: alertMessages, backgroundColor: backgroundColor, textColor: textColor, textFont: textFont, alertIcon: alertIcon)
                }
            }
        }
    }
    
    private func showOverlayTopbar(alertMessage: String, backgroundColor: UIColor, textColor: UIColor, textFont: UIFont, alertIcon: UIImage?) {
        
        if #available(iOS 13.0, *) {
            if let window = UIApplication.shared.currentWindow {
                self.alreadyShowing = true
                let screenHeight: CGFloat = 80
                let screenWidth = UIScreen.main.bounds.width
                self.overlayView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                self.overlayView.center = CGPoint(x: screenWidth / 2.0, y: screenHeight)
                self.overlayView.backgroundColor = backgroundColor
                self.overlayView.clipsToBounds = true
                
                if alertIcon != nil {
                    let yourImage = alertIcon
                    self.overlayImageView.image = yourImage
                    self.overlayImageView.translatesAutoresizingMaskIntoConstraints = false
                    self.overlayImageView.setImageColor(color: textColor)
                    self.overlayView.addSubview(overlayImageView)
                    self.overlayImageView.frame = CGRect(x: 50, y: (screenHeight / 2) - 15, width: 30, height: 30)
                }
                
                self.overlayTextView.textColor = textColor
                self.overlayTextView.font = textFont
                self.overlayTextView.backgroundColor = .clear
                self.overlayTextView.textAlignment = .center
                self.overlayTextView.text = alertMessage
                self.overlayTextView.frame = CGRect(x: 0, y: 0, width: overlayView.bounds.width, height: 50)
                self.overlayTextView.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
                self.overlayTextView.clipsToBounds = true
                self.overlayView.addSubview(overlayTextView)
                window.addSubview(overlayView)
            }
        } else {
            
            if let window = UIApplication.shared.keyWindow {
                self.alreadyShowing = true
                let screenHeight: CGFloat = 80
                let screenWidth = UIScreen.main.bounds.width
                self.overlayView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                self.overlayView.center = CGPoint(x: screenWidth / 2.0, y: screenHeight)
                self.overlayView.backgroundColor = backgroundColor
                self.overlayView.clipsToBounds = true
                
                if alertIcon != nil {
                    let yourImage = alertIcon
                    self.overlayImageView.image = yourImage
                    self.overlayImageView.translatesAutoresizingMaskIntoConstraints = false
                    self.overlayImageView.setImageColor(color: textColor)
                    self.overlayView.addSubview(overlayImageView)
                    self.overlayImageView.frame = CGRect(x: 50, y: (screenHeight / 2) - 15, width: 30, height: 30)
                }
                
                self.overlayTextView.textColor = textColor
                self.overlayTextView.font = textFont
                self.overlayTextView.backgroundColor = .clear
                self.overlayTextView.textAlignment = .center
                self.overlayTextView.text = alertMessage
                self.overlayTextView.frame = CGRect(x: 0, y: 0, width: overlayView.bounds.width, height: 50)
                self.overlayTextView.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
                self.overlayTextView.clipsToBounds = true
                self.overlayView.addSubview(overlayTextView)
                window.addSubview(overlayView)
            }
        }
    }
    
    
    private func showOverlayFullScreen(alertMessage: String, backgroundColor: UIColor, textColor: UIColor, textFont: UIFont, alertIcon: UIImage?) {
        
        if #available(iOS 13.0, *) {
            if let window = UIApplication.shared.currentWindow {
                let screenWidth = UIScreen.main.bounds.width
                let screenHeight = UIScreen.main.bounds.height
                self.overlayView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                self.overlayView.center = CGPoint(x: screenWidth / 2.0, y: screenHeight / 2.0)
                self.overlayView.backgroundColor = backgroundColor
                self.overlayView.clipsToBounds = true
                
                if alertIcon != nil {
                    let yourImage = alertIcon
                    self.overlayImageView.image = yourImage
                    self.overlayImageView.translatesAutoresizingMaskIntoConstraints = false
                    self.overlayImageView.setImageColor(color: textColor)
                    self.overlayView.addSubview(overlayImageView)
                    self.overlayImageView.frame = CGRect(x: (screenWidth / 2) - 75, y: (screenHeight / 2) - 75, width: 150, height: 150)
                }
                
                self.overlayTextView.textColor = textColor
                self.overlayTextView.backgroundColor = .clear
                self.overlayTextView.textAlignment = .center
                self.overlayTextView.text = alertMessage
                self.overlayTextView.font = textFont
                self.overlayTextView.frame = CGRect(x: 0, y: 0, width: overlayView.bounds.width, height: 80)
                let offset: CGFloat = overlayImageView.bounds.height / 2.0 + 10
                self.overlayTextView.center = CGPoint(x: overlayView.bounds.width / 2, y: (overlayView.bounds.height / 2) + offset)
                self.overlayTextView.clipsToBounds = true
                self.overlayView.addSubview(overlayTextView)
                
                window.addSubview(overlayView)
            }
            
        } else {
            
            if let window = UIApplication.shared.keyWindow {
                let screenWidth = UIScreen.main.bounds.width
                let screenHeight = UIScreen.main.bounds.height
                self.overlayView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                self.overlayView.center = CGPoint(x: screenWidth / 2.0, y: screenHeight / 2.0)
                self.overlayView.backgroundColor = backgroundColor
                self.overlayView.clipsToBounds = true
                
                if alertIcon != nil {
                    let yourImage = alertIcon
                    self.overlayImageView.image = yourImage
                    self.overlayImageView.translatesAutoresizingMaskIntoConstraints = false
                    self.overlayImageView.setImageColor(color: textColor)
                    self.overlayView.addSubview(overlayImageView)
                    self.overlayImageView.frame = CGRect(x: (screenWidth / 2) - 75, y: (screenHeight / 2) - 75, width: 150, height: 150)
                }
                
                self.overlayTextView.textColor = textColor
                self.overlayTextView.backgroundColor = .clear
                self.overlayTextView.textAlignment = .center
                self.overlayTextView.text = alertMessage
                self.overlayTextView.font = textFont
                self.overlayTextView.frame = CGRect(x: 0, y: 0, width: overlayView.bounds.width, height: 80)
                let offset: CGFloat = overlayImageView.bounds.height / 2.0 + 10
                self.overlayTextView.center = CGPoint(x: overlayView.bounds.width / 2, y: (overlayView.bounds.height / 2) + offset)
                self.overlayTextView.clipsToBounds = true
                self.overlayView.addSubview(overlayTextView)
                
                window.addSubview(overlayView)
            }
        }
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}

@available(iOS 13.0, *)
extension UIApplication {
    var currentWindow: UIWindow? {
        connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    }
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
