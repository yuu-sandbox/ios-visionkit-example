//
//  ViewController.swift
//  visionkit-example
//
//  Created by 14-0254 on 2019/10/31.
//  Copyright © 2019 Yusuke Binsaki. All rights reserved.
//

import UIKit
import VisionKit
import Vision
import PKHUD

class ViewController: UIViewController {

    let docCamera = VNDocumentCameraViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.docCamera.delegate = self
    }

    @IBAction func onTapped(_ sender: Any) {
        present(self.docCamera, animated: true, completion: nil)
    }
}

// OCR: https://developer.apple.com/videos/play/wwdc2019/234/
extension ViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        debugPrint("titile=\(scan.title), pageCount=\(scan.pageCount)")

        let vc = self.storyboard!.instantiateViewController(identifier: "DetailViewController") as! DetailViewController

        HUD.show(.progress)
        DispatchQueue.global().async {
            let cgimg = scan.imageOfPage(at: 0).cgImage
            guard let img = cgimg else {
                HUD.hide()
                print("failed convert to cgImage")
                return
            }

            let rh = VNImageRequestHandler(cgImage: img, options: [:])
            let req = VNRecognizeTextRequest { (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    print("observations error")
                    return
                }
                for obs in observations {
                    let topCandidates = obs.topCandidates(1)
                    if let text = topCandidates.first {
                        print(text.string)
                        vc.msg.append(text.string)
                    }
                }
                DispatchQueue.main.async {
                    HUD.hide()
                    controller.present(vc, animated: true, completion: nil)
                }
            }
            req.recognitionLevel = .accurate
            try? rh.perform([req])
        }
    }
}
