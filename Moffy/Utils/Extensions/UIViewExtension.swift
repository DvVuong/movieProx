//
//  UIViewExtension.swift
//  Moffy
//
//  Created by macbook on 14/12/2023.
//

import UIKit

extension UIView {
  @objc func push(to viewController: UIViewController, animated: Bool) {
    guard let topViewController = UIApplication.topViewController() else {
      return
    }
    topViewController.navigationController?.pushViewController(viewController, animated: animated)
  }
  
  @objc func pod(animated: Bool) {
    guard let topViewController = UIApplication.topViewController() else {
      return
    }
    topViewController.navigationController?.popToViewController(topViewController, animated: animated)
  }
  
  @objc func present(to viewController: UIViewController, animated: Bool) {
    guard let topviewController = UIApplication.topViewController() else {
      return
    }
    topviewController.present(topviewController, animated: animated)
  }
  
  func nearestAncestor<T>(ofType type: T.Type) -> T? {
    if let view = self as? T {
      return view
    }
    return superview?.nearestAncestor(ofType: type)
  }
  
  class func loadNib() -> Self {
    return Bundle.main.loadNibNamed(String(describing: Self.className), owner: nil)?.first as! Self
  }
}

extension UIView {
  
  func applyGradient(colors: [CGColor],
                     locations: [NSNumber],
                     affineTransform: CGAffineTransform,
                     bounds: CGRect
  ) {
    let gradient = CAGradientLayer()
    gradient.colors = colors
    gradient.locations = locations
    gradient.startPoint = CGPoint(x: 1, y: 1)
    gradient.endPoint = CGPoint(x: 0, y: 0)
    gradient.transform = CATransform3DMakeAffineTransform(affineTransform)
    gradient.bounds = bounds.insetBy(dx: -0.5 * bounds.size.width, dy: -0.5 * bounds.size.height)
    gradient.position = CGPoint(x: bounds.midX, y: bounds.midY)
    
    self.layer.addSublayer(gradient)
  }
  
  func gradienBorder(_ colors: [UIColor],
                     lineHeight: CGFloat = 0,
                     location: [NSNumber] = [0, 1],
                     startPoint: CGPoint = CGPoint(x: 0.75, y: 0.5),
                     endPoint: CGPoint = CGPoint(x: 0, y: 0),
                     cornerRadius: CGFloat = 18)  {
    let gradient = CAGradientLayer()
    
    gradient.frame = self.bounds
    gradient.colors = colors.map(\.cgColor)
    gradient.locations = location
    gradient.startPoint = startPoint
    gradient.endPoint = endPoint
    gradient.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
    let shape = CAShapeLayer()
    shape.lineWidth = lineHeight
    shape.path = UIBezierPath(roundedRect: self.frame, cornerRadius: cornerRadius).cgPath
    gradient.mask = shape
    self.layer.addSublayer(gradient)
    self.layer.borderColor = UIColor.clear.cgColor
  }
}

extension UIView {
  func conerRadius(with number: CGFloat = 20) {
    
    self.layer.cornerRadius = number
    self.layer.masksToBounds = true
  }
  
  func setBoderWidth(with numberBoder: CGFloat = 1, numberRadius: CGFloat = 18) {
    self.layer.cornerRadius = numberRadius
    self.layer.masksToBounds = true
    self.layer.borderWidth = numberBoder
    self.layer.borderColor = UIColor(rgb: 0xFFFFFF, alpha: 0.3).cgColor
  }
  
  func setShadow() {
    self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    self.layer.shadowOpacity = 1
    self.layer.shadowOffset = CGSize(width: 0, height: 4)
    self.layer.shadowRadius = 25
  }
  
  func setBlur() {
    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.frame = self.bounds
    self.addSubview(blurView)
  }
}

extension UIView {
  
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    } set {
      layer.cornerRadius = newValue
    }
  }
  
  @IBInspectable var shadowRadius: CGFloat {
    get {
      return layer.shadowRadius
    } set {
      layer.shadowRadius = newValue
    }
  }
  
  @IBInspectable var shadowOpacity: CGFloat {
    get {
      return CGFloat(layer.shadowOpacity)
    } set {
      layer.shadowOpacity = Float(newValue / 100)
    }
  }
  
  @IBInspectable var shadowOffset: CGSize {
    get {
      return layer.shadowOffset
    } set {
      layer.shadowOffset = newValue
    }
  }
  
  @IBInspectable var shadowColor: UIColor? {
    get {
      guard let cgColor = layer.shadowColor else {
        return nil
      }
      return UIColor(cgColor: cgColor)
    } set {
      layer.shadowColor = newValue?.cgColor
    }
  }
  
  @IBInspectable var borderColor: UIColor? {
    get {
      guard let cgColor = layer.borderColor else {
        return nil
      }
      return UIColor(cgColor: cgColor)
    } set {
      layer.borderColor = newValue?.cgColor
    }
  }
  
  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    } set {
      layer.borderWidth = newValue
    }
  }
}


extension UIView {
  func addDashedBorder() {
    let gradient = CAGradientLayer()
    let frameSize = self.frame.size
    let shapeMask = CAShapeLayer()
    
    gradient.frame = bounds
    gradient.colors = [UIColor(rgb: 0x2385EC).cgColor, UIColor(rgb: 0x7E4CE3).cgColor ]
    gradient.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
    
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
    shapeMask.bounds = shapeRect
    shapeMask.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
    shapeMask.strokeColor = UIColor.black.cgColor
    shapeMask.fillColor = nil
    shapeMask.lineWidth = 3
    shapeMask.lineJoin = CAShapeLayerLineJoin.round
    shapeMask.lineDashPattern = [ 3, 3 ]
    shapeMask.path = UIBezierPath( roundedRect: shapeRect, cornerRadius: 10).cgPath
    gradient.mask = shapeMask
    layer.addSublayer( gradient )
  }
  
  func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tap.cancelsTouchesInView = false
    addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    endEditing(true)
  }
}
