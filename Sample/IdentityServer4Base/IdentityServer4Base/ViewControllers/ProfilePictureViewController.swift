//
//  ProfilePictureViewController.swift
//  IdentityServer4Base
//
//  Created by Robert Brown on 12/15/18.
//  Copyright © 2018 Robert Brown. All rights reserved.
//

import UIKit

class ProfilePictureViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    var currentImage: UIImage!
    
    @IBOutlet weak var displayImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func takeSelfieClick(_ sender: UIButton) {
        takeSelfie()
    }
    
    func takeSelfie() -> Void{
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        present(vc, animated: true)
    }
    
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true)
//
//        //guard let image = info[.editedImage] as? UIImage else {
//
//        /*
//        guard let image = info[UIImagePickerControllerEditedImage] as UIImage else {
//            print("No image found")
//            return
//        }
//
//        guard let selectedImage = info[.originalImage] as? UIImage else {
//            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//        }
//        */
//        currentImage = info[UIImagePickerControllerOriginalImage] as? UIImage
//        displayImage.image = currentImage
//
//        // print out the image size as a test
//        print(currentImage.size)
//    }
//
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }

        currentImage = pickedImage
        displayImage.contentMode = .scaleAspectFit
        displayImage.image = currentImage
        
        
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            // imageViewPic.contentMode = .scaleToFill
//        }
        picker.dismiss(animated: true, completion: nil)
    }

}
