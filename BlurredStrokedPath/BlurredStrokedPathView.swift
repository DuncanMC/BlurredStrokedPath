//
//  BlurredStrokedPathView.swift
//  BlurredStrokedPath
//
//  Created by Duncan Champney on 9/9/20.
//  Copyright © 2020 Duncan Champney. All rights reserved.
//

import UIKit

class BlurredStrokedPathView: UIView {
    public var lineWidth: CGFloat = 10 {
        didSet {
            print("lineWidth changed to \(lineWidth)")
            shapeLayer.shadowPath = createFilledPath(curveTop: bounds.height / 2)
        }
    }

    public var blurRadius: CGFloat = 5 {
        didSet {
            shapeLayer.shadowRadius = blurRadius
        }
    }

    private var sourcePath: CGPath?

    private var shapeLayer = CAShapeLayer()
    
    public func animate() {
        let animation = CABasicAnimation(keyPath: "shadowPath")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.duration = 1.0

        //Animate the curve moving up to almost the top of the view and back again
        animation.autoreverses = true
        animation.toValue = createFilledPath(curveTop: lineWidth / 2)
        shapeLayer.add(animation, forKey: nil)
    }

    //Create a cosine curve. If curveTop = 0, it peaks at the top of the view. If it = bounds.height/2, it peaks about halfway up
    func createFilledPath(curveTop: CGFloat) -> CGPath? {
        let animationBox = bounds.insetBy(dx: lineWidth/2 + blurRadius * 2, dy: lineWidth/2 + blurRadius * 2)
        let path = UIBezierPath()
        let halfWidth = animationBox.width / 2
        /* The commented code shows the inset rect that (mostly) keeps the blurred line from going outside the view bounds
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.path = UIBezierPath(rect:animationBox).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        */

        //Move to the lower right corner of the layer (0,0 is in the top left for CGLayers)
        //Draw an approximation of a "half cosine" curve that peaks at "curveTop" (either halfway up the view or all the way up)
        path.move(to: CGPoint(x: animationBox.origin.x + animationBox.width, y: animationBox.origin.y + animationBox.height))
        var controlPoint1 = CGPoint(x: animationBox.origin.x + halfWidth + 0.6366197723675813 * halfWidth, y:  animationBox.origin.y + animationBox.height)
        var controlPoint2 = CGPoint(x: animationBox.origin.x + halfWidth + 0.3633802276324187 * halfWidth, y: curveTop)

        path.addCurve(to: CGPoint(x: animationBox.origin.x + halfWidth, y: curveTop), controlPoint1: controlPoint1, controlPoint2: controlPoint2)

        //Draw the other half of a cosine curve
        controlPoint1 = CGPoint(x: 0.3633802276324187 * halfWidth, y: curveTop)
        controlPoint2 = CGPoint(x: 0.6366197723675813 * halfWidth, y:  animationBox.origin.y + animationBox.height)
        path.addCurve(to: CGPoint(x: animationBox.origin.x, y:  animationBox.origin.y + animationBox.height), controlPoint1: controlPoint1, controlPoint2: controlPoint2)

        sourcePath = path.cgPath

        //Create a filled version of the path
        return createFilledPath()
    }

    func createFilledPath() -> CGPath? {
        return sourcePath?.copy(strokingWithWidth: lineWidth, lineCap: .round, lineJoin: .miter, miterLimit: 0)
    }

    func setup(curveTop: CGFloat) {
        //Our shape layer is actually empty.
        //Set up a shadowPath containing a filled version of our curve path.

        shapeLayer.shadowOffset = CGSize.zero
        shapeLayer.shadowColor = UIColor.blue.cgColor  //Draw the shadow in blue
        shapeLayer.shadowOpacity = 1.0  //Make the shadow fully opaque at it's strongest (inside the path)
        shapeLayer.shadowRadius = blurRadius //This determines the amount of blurring.

        //This is what draws the shadow on the (empty) shape layer.
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
        shapeLayer.fillColor = UIColor.clear.cgColor

        //Start the curve going to about half of the view height
        setup(curveTop: bounds.height / 2)
    }

}
