//
//  SecondViewController.swift
//  Global Anti-Allergy
//
//  Created by Sarah Pisini on 10/27/17.
//  Copyright © 2017 Sarah Pisini. All rights reserved.
//
import UIKit
import AVFoundation










class SecondViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var theScanview: UIImageView!
    var mySession = AVCaptureSession()
    var screen = AVCaptureVideoPreviewLayer()
    var barcode:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //let mySession = AVCaptureSession()
        let theDivice = AVCaptureDevice.default(for: AVMediaType.video)
        do{
            let input = try AVCaptureDeviceInput(device: theDivice!)
            mySession.addInput(input)
        }
        catch{
            print("Can not find product")
        }
        let output = AVCaptureMetadataOutput()
        mySession.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.upce]
        screen = AVCaptureVideoPreviewLayer(session: mySession)
        screen.frame = view.layer.bounds
        view.layer.addSublayer(screen)
        self.view.bringSubview(toFront: theScanview)
        mySession.startRunning()
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0{
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                if (output.metadataObjectTypes.contains(object.type)) {
                    barcode = object.stringValue
                    self.performSegue(withIdentifier: "theScanDetial", sender: self)
                    //let popup = UIAlertController(title: "my message", message: object.stringValue, preferredStyle: UIAlertControllerStyle.alert)
                    //self.present(popup, animated: true, completion: nil)
                    mySession.stopRunning()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "theScanDetial" {
            let aimVC: ScanResultVC = (segue.destination as? ScanResultVC)!
            aimVC.theBarcodeString = barcode
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        mySession.startRunning()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

