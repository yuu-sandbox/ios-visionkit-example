//
//  DetailViewController.swift
//  visionkit-example
//
//  Created by 14-0254 on 2019/11/07.
//  Copyright © 2019 Yusuke Binsaki. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var textView: UITextView!

    var msg: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        if let msg = msg {
            textView.text = msg
        } else {
            textView.text = "not recognize"
        }
    }
}
