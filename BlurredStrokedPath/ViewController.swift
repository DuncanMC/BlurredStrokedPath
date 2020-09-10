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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func handleAnimateButton(_ sender: Any) {
        self.animationView.animate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }


}

