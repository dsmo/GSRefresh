//
//  RefreshCircleLayer.swift
//  AIPhoto
//
//  Created by shiyu on 2023/9/11.
//

import UIKit

class RefreshCircleLayer: CALayer {
    
    var progress: Double = 0.0 {
        didSet {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            let start = 0.3
            let total = 1 - start
            let current = progress - start
            let fraction = max(0, current / total)
            let strokeEnd = min(0.9, 0.9 * fraction)
            circleShape.strokeEnd = strokeEnd
            CATransaction.commit()
            
            if fraction == 1 && oldValue < 1 {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
    }
    
    private lazy var backgroundLayer = CAShapeLayer()
    private lazy var circleGradient = CAGradientLayer()
    private lazy var circleShape = CAShapeLayer()
    
    override init() {
        super.init()
        commomInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commomInit()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    private func commomInit() {
        addBackground()
        addCircleGradient()
        maskCircleGradient()
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        layoutBackground(frame: bounds)
        layoutCircleGradient(frame: bounds)
        layoutCircleShape(frame: bounds)
    }
    
    private func addBackground() {
        backgroundLayer.lineWidth = 3.0
        backgroundLayer.strokeColor = UIColor(hexString: "#F6F6F6")!.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        addSublayer(backgroundLayer)
    }
    
    private func addCircleGradient() {
        circleGradient.colors = [UIColor(hexString: "#FFE03D")!.cgColor, UIColor(hexString: "#FFE03D")!.cgColor]
        circleGradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        circleGradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        addSublayer(circleGradient)
    }
    
    private func maskCircleGradient() {
        circleShape.lineCap = .round
        circleShape.lineWidth = 3.0
        circleShape.strokeColor = UIColor.red.cgColor
        circleShape.fillColor = UIColor.clear.cgColor
        circleShape.strokeEnd = 0.0
        circleGradient.mask = circleShape
    }
    
    private func layoutBackground(frame: CGRect) {
        backgroundLayer.frame = frame
        backgroundLayer.path = circle(for: frame).cgPath
    }
    
    private func layoutCircleGradient(frame: CGRect) {
        circleGradient.frame = frame
    }
    
    private func layoutCircleShape(frame: CGRect) {
        circleShape.frame = frame
        circleShape.path = circle(for: frame).cgPath
    }
    
    private func circle(for frame: CGRect) -> UIBezierPath {
        let width = frame.size.width
        let height = frame.size.height
        
        let radius = min(width, height) * 0.5 - circleShape.lineWidth * 0.5
        let center = CGPoint(x: width / 2.0, y: height / 2.0)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        return path
    }
    
    func startAnimation() {
        let fadeOutAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        fadeOutAnimation.repeatCount = .greatestFiniteMagnitude
        fadeOutAnimation.fromValue = 0
        fadeOutAnimation.byValue = CGFloat.pi * 2
        fadeOutAnimation.duration = RefreshView.circleRotationAnimationDuration
        fadeOutAnimation.beginTime = convertTime(CACurrentMediaTime(), from: nil)
        fadeOutAnimation.fillMode = .forwards
        add(fadeOutAnimation, forKey: nil)
    }
    
    func endAnimation() {
        removeAllAnimations()
    }
}

extension UIColor {
    convenience init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        guard red >= 0 && red <= 255 else { return nil }
        guard green >= 0 && green <= 255 else { return nil }
        guard blue >= 0 && blue <= 255 else { return nil }

        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }
    
    convenience init?(hex: Int, transparency: CGFloat = 1) {
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }

        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = hex & 0xff
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }
    
    convenience init?(hexString: String, transparency: CGFloat = 1) {
        var string = ""
        if hexString.lowercased().hasPrefix("0x") {
            string =  hexString.replacingOccurrences(of: "0x", with: "")
        } else if hexString.hasPrefix("#") {
            string = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            string = hexString
        }

        if string.count == 3 { // convert hex to 6 digit format if in short format
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }

        guard let hexValue = Int(string, radix: 16) else { return nil }

        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }

        let red = (hexValue >> 16) & 0xff
        let green = (hexValue >> 8) & 0xff
        let blue = hexValue & 0xff
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }
}
