//
//  ViewController.swift
//  ProsperInfotechTask
//
//  Created by Saurav Sagar on 26/04/24.
//

import UIKit
import AVFoundation

class Dashboard: CameraPermission {
    
    @IBOutlet weak private var captureBtn: UIButton!
    @IBOutlet weak private var cancelBtn: UIButton!
    @IBOutlet weak private var editBtn: UIButton!
    @IBOutlet weak private var resultImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func captureActionBtn(_ sender: UIButton) {
        
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            if self.checkCameraPermission() {
                self.openCamera()
            }
        }
                
        let galleryAction = UIAlertAction(title: "Choose Photo", style: .default) { (action) in
            self.openGallery()
        }
                
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func editActionBtn(_ sender: UIButton) {
        if let imageProcessingVC = storyboard?.instantiateViewController(identifier: "ImageProcessingVC") as? ImageProcessingVC {
            imageProcessingVC.capturedImage = resultImg.image
            self.navigationController?.pushViewController(imageProcessingVC, animated: true)
        }
    }
    
    
    @IBAction func cancelActionBtn(_ sender: UIButton) {
        resultImg.image = nil
        resultImg.isHidden = true
        cancelBtn.isHidden = true
        editBtn.isHidden = true
        
    }
    
    // Open Camera and take Image
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            showToast(message: "Camera not available")
        }
    }
    
    // Open Gallery and pick Image
    private func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}

//MARK: UIImagePickerController Delegate
extension Dashboard : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                resultImg.isHidden = false
                cancelBtn.isHidden = false
                editBtn.isHidden = false
                resultImg.image = pickedImage
            }
            
            picker.dismiss(animated: true, completion: nil)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
    }
}

