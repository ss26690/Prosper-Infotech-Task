//
//  CameraPermission.swift
//  ProsperInfotechTask
//
//  Created by Saurav Sagar on 27/04/24.
//

import UIKit
import AVFoundation

class CameraPermission: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // Open Camerra Setting
    func presentCameraSettings() {
        let alertController = UIAlertController(title: "Error", message: "Camera access is denied", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel){ _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                })
            }
        })
        
        present (alertController, animated: true)
    }
    
    // Open Camera Permittion
    func checkCameraPermission() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        var auth: Bool = false
        
        switch status {
        case .denied:
            auth = false
            presentCameraSettings()
            break
        case .restricted:
            auth = false
            break
        case .authorized:
            auth = true
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video){ (success) in
                if success {
                    debugPrint("Permission Granted")
                    auth = true
                } else {
                    debugPrint("Permittion not granted")
                    auth = false
                }
            }
            break
        @unknown default:
            break
        }
        
        return auth
    }
}
