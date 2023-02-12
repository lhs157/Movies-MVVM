//
//  UIView+.swift
//  MovieListMVVM
//
//  Created by mac on 12/02/2023.
//

import UIKit

extension UIView {
        
    public func addBorderTop(size: CGFloat, color: UIColor) {
        addBorderUtility(xValue: 0, yValue: 0, width: frame.width, height: size, color: color)
    }
    
    public func addBorderBottom(size: CGFloat, color: UIColor) {
        addBorderUtility(xValue: 0, yValue: frame.height - size, width: frame.width, height: size, color: color)
    }
   
    public func addBorderLeft(size: CGFloat, color: UIColor) {
        addBorderUtility(xValue: 0, yValue: 0, width: size, height: frame.height, color: color)
    }
  
    public func addBorderRight(size: CGFloat, color: UIColor) {
        addBorderUtility(xValue: frame.width - size, yValue: 0, width: size, height: frame.height, color: color)
    }
    //add border to custom edge
    fileprivate func addBorderUtility(xValue: CGFloat, yValue: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: xValue, y: yValue, width: width, height: height)
        layer.addSublayer(border)
    }
    
    @IBInspectable
    var cornerRadiusView: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidthView: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColorView: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}
