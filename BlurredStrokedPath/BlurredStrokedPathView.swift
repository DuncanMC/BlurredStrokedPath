//
//  BlurredStrokedPathView.swift
//  BlurredStrokedPath
//
//  Created by Duncan Champney on 9/9/20.
//  Copyright © 2020 Duncan Champney. All rights reserved.
//

import UIKit

class BlurredStrokedPathView: UIView {
    var shapeLayer = CAShapeLayer()
    var lineWidth: CGFloat = 5
    var blurRadius: CGFloat = 2.5

    public func animate() {
        let animation = CABasicAnimation(keyPath: "shadowPath")
        animation.duration = 1.0
        animation.autoreverses = true
        animation.toValue = createFilledPath(curveTop: lineWidth / 2)
        shapeLayer.add(animation, forKey: nil)
    }

    func createFilledPath(curveTop: CGFloat) -> CGPath {
        let animationBox = bounds.insetBy(dx: lineWidth/2, dy: lineWidth/2)
        let path = UIBezierPath()
        let halfWidth = animationBox.width / 2
//        shapeLayer.strokeColor = UIColor.red.cgColor
//        shapeLayer.lineWidth = 1
//        shapeLayer.path = UIBezierPath(rect:animationBox).cgPath
//        shapeLayer.fillColor = UIColor.clear.cgColor
        path.move(to: CGPoint(x: animationBox.origin.x + animationBox.width, y: animationBox.origin.y + animationBox.height))
        var controlPoint1 = CGPoint(x: animationBox.origin.x + halfWidth + 0.6366197723675813 * halfWidth, y:  animationBox.origin.y + animationBox.height)
        var controlPoint2 = CGPoint(x: animationBox.origin.x + halfWidth + 0.3633802276324187 * halfWidth, y: curveTop)
        path.addCurve(to: CGPoint(x: animationBox.origin.x + halfWidth, y: curveTop), controlPoint1: controlPoint1, controlPoint2: controlPoint2)

        controlPoint1 = CGPoint(x: 0.3633802276324187 * halfWidth, y: curveTop)
        controlPoint2 = CGPoint(x: 0.6366197723675813 * halfWidth, y:  animationBox.origin.y + animationBox.height)
        path.addCurve(to: CGPoint(x: animationBox.origin.x, y:  animationBox.origin.y + animationBox.height), controlPoint1: controlPoint1, controlPoint2: controlPoint2)

//        path.move(to: controlPoint1)
//        path.addArc(withCenter: controlPoint1, radius: 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
//        path.move(to: controlPoint2)
//        path.addArc(withCenter: controlPoint2, radius: 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)

        let filledPath = path.cgPath.copy(strokingWithWidth: lineWidth, lineCap: .round, lineJoin: .miter, miterLimit: 0)
        return filledPath
    }
    func setup(curveTop: CGFloat) {
        shapeLayer.shadowOffset = CGSize.zero
        shapeLayer.shadowColor = UIColor.blue.cgColor
        shapeLayer.shadowOpacity = 1.0
        shapeLayer.shadowRadius = blurRadius
        shapeLayer.shadowPath = createFilledPath(curveTop: curveTop)

        self.layer.addSublayer(shapeLayer)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSublayers(of layer: CALayer) {
        assert(layer === self.layer)
        shapeLayer.frame = layer.bounds
        shapeLayer.fillColor = UIColor.blue.cgColor
        setup(curveTop: bounds.height / 2)
    }

}
