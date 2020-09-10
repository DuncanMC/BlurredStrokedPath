//
//  ViewController.swift
//  BlurredStrokedPath
//
//  Created by Duncan Champney on 9/9/20.
//  Copyright © 2020 Duncan Champney. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var animationView: BlurredStrokedPathView!
    var targetTextField: UITextField?
    @IBOutlet weak var blurRadiusTextField: UITextField!
    @IBOutlet weak var lineWidthTextField: UITextField!
    @IBOutlet weak var blurRadiusSlider: UISlider!
    @IBOutlet weak var lineWidthSlider: UISlider!

    var blurRadius: Double  = 0{
        didSet {
            if blurRadius < Double(blurRadiusSlider.minimumValue) {
                blurRadius = Double(blurRadiusSlider.minimumValue)
            } else if blurRadius > Double(blurRadiusSlider.maximumValue) {
                blurRadius = Double(blurRadiusSlider.maximumValue)
            }
            blurRadiusSlider.value = Float(blurRadius)
            blurRadiusTextField.text = String(format: "%.1f", blurRadius)
            animationView.blurRadius = CGFloat(blurRadius)
        }
    }

    var lineWidth: Double  = 0 {
        didSet {
            if lineWidth < Double(lineWidthSlider.minimumValue) {
                lineWidth = Double(lineWidthSlider.minimumValue)
            } else if lineWidth > Double(lineWidthSlider.maximumValue) {
                lineWidth = Double(lineWidthSlider.maximumValue)
            }
            lineWidthSlider.value = Float(lineWidth)
            lineWidthTextField.text = String(format: "%.1f", lineWidth)
            animationView.lineWidth = CGFloat(lineWidth)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        blurRadius = 5.0
        lineWidth = 10
    }

    @IBAction func handleAnimateButton(_ sender: UISlider) {
        self.animationView.animate()
    }

    @IBAction func handleblurRadiusSlider(_ sender: UISlider) {
        blurRadius = Double(sender.value)
    }

    @IBAction func handleLineWidthSlider(_ sender: UISlider) {
        lineWidth = Double(sender.value)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if let targetTextField = targetTextField,
                self.view.frame.origin.y == 0  {
                var shiftAmount = view.safeAreaInsets.bottom + 5 + targetTextField.frame.origin.y + targetTextField.frame.height
                shiftAmount -= (view.bounds.height - keyboardSize.height)
                if shiftAmount > 0 {
                    self.view.frame.origin.y -= shiftAmount

                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        targetTextField = textField
        textField.text = ""
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case blurRadiusTextField:
            let radiusValue = Double(blurRadiusTextField.text ?? "")
            blurRadius = radiusValue ?? blurRadius
        case lineWidthTextField:
            let lineWidthValue = Double(lineWidthTextField.text ?? "")
            lineWidth = lineWidthValue ?? lineWidth
            default:
            break
        }
    }
}
