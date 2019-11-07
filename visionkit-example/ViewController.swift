//
//  ViewController.swift
//  visionkit-example
//
//  Created by 14-0254 on 2019/10/31.
//  Copyright © 2019 Yusuke Binsaki. All rights reserved.
//

import UIKit
import VisionKit
import SwiftOCR
import PKHUD

class ViewController: UIViewController {

    let docCamera = VNDocumentCameraViewController()
    let ocr = SwiftOCR()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.docCamera.delegate = self
    }

    @IBAction func onTapped(_ sender: Any) {
        present(self.docCamera, animated: true, completion: nil)
    }
}

extension ViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        debugPrint("titile=\(scan.title), pageCount=\(scan.pageCount)")
        let vc = self.storyboard!.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        HUD.show(.progress)
        self.ocr.recognize(scan.imageOfPage(at: 0)) { (msg) in
            print("recognize:", msg)
            DispatchQueue.main.async {
                HUD.hide()
                vc.msg = msg
                controller.present(vc, animated: true, completion: nil)
            }
        }
    }
}
