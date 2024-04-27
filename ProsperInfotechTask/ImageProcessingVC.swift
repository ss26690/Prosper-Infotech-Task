//
//  ImageProcessingVC.swift
//  ProsperInfotechTask
//
//  Created by Saurav Sagar on 27/04/24.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class ImageProcessingVC: UIViewController {

    @IBOutlet weak private var backgroundView: UIView!
    @IBOutlet weak private var actionImageView: UIImageView!
    @IBOutlet weak private var backIV: UIImageView!
    
    var capturedImage: UIImage?
    var currentFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let image = capturedImage {
            actionImageView.image = image
        }
    }
    
    //MARK: IBAction Buttons
    
    @IBAction func addOverlayImageActionBtn(_ sender: UIButton) {
        openGallery()
    }
    
    @IBAction func addBackgroundActionBtn(_ sender: UIButton) {
        // Set the background image
        backIV.image = UIImage(named: "bg")
    }
    
    @IBAction func addFilterOnImageActionBtn(_ sender: UIButton) {
        if let image = capturedImage {
            
            // Ensure the orientation is fixed before creating the CIImage
            let fixedImage = fixImageOrientation(image)
            
            guard let beginImage = CIImage(image: fixedImage) else { return }
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    @IBAction func addTextActionBtn(_ sender: UIButton) {
        
        let ac = UIAlertController(title: "Enter Your Message", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let message = ac.textFields![0]
            self.addCaptionText(message: message.text ?? "")
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        let image = captureImage(from: backgroundView)
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)

//        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact, .openInIBooks]
//                
//        if let popoverController = activityViewController.popoverPresentationController {
//            popoverController.sourceView = sender
//            popoverController.sourceRect = sender.bounds
//        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        let image = captureImage(from: backgroundView)
                
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    //MARK: Class private methods
    
    // Fix Input Photo alligment
    private func fixImageOrientation(_ image: UIImage) -> UIImage {
        if image.imageOrientation == .up {
            return image
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let fixedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return fixedImage ?? image
    }
    
    // Apply Filtter on input Image
    private func applyProcessing() {

        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

        actionImageView.image = UIImage(cgImage: cgImage)
    }
    
    // Open Gallery and pick Image
    private func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Add Caption over Image
    private func addCaptionText(message: String) {
        // find co-ordinate of actionImageView
        let x = Int(actionImageView.frame.maxX) / 2
        let y = Int(actionImageView.frame.maxY) / 2
        
        // create random view on screen for add overlay iamge
        let messageLbl: UILabel = UILabel(frame: CGRect(origin: CGPoint(x: Int.random(in: 0..<x), y: Int.random(in: 0..<y)), size: CGSize(width: actionImageView.frame.size.width, height: 50)))
        
        messageLbl.text = message
        messageLbl.textColor = UIColor.orange
        messageLbl.font = .systemFont(ofSize: 30)
        
        
        actionImageView.addSubview(messageLbl)
    }
    
    // convert UIView to image
    func captureImage(from view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // Save Photo in Photos
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if let error = error {
                showToast(message: "Error saving image: \(error.localizedDescription)")
            } else {
                showToast(message: "Image saved successfully")
            }
        }
}


//MARK: UIImagePickerController Delegate
extension ImageProcessingVC : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                addOverlay(pickedImage: pickedImage)
            }
            
            picker.dismiss(animated: true, completion: nil)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
    }
    
    func addOverlay(pickedImage: UIImage) {
        // generate random width and height
        let width = Int.random(in: 150..<200)
        let height = Int.random(in: 150..<200)
        
        // find co-ordinate of backgroundView
        let minX = Int(backgroundView.frame.minX)
        let maxX = Int(backgroundView.frame.maxX) - height
        let minY = Int(backgroundView.frame.minY)
        let maxY = Int(backgroundView.frame.maxY) - width
        
        // create random view on screen for add overlay iamge
        let overlayImageView: UIImageView = UIImageView(frame: CGRect(x: Int.random(in: minX..<maxX), y: Int.random(in: minY..<maxY), width: width, height: height))
        
        overlayImageView.image = pickedImage
        
        backgroundView.addSubview(overlayImageView)
    }
}
