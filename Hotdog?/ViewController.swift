//
//  ViewController.swift
//  Hotdog?
//
//  Created by Aziz Zaynutdinov on 7/16/18.
//  Copyright © 2018 Aziz Zaynutdinov. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate { //Delegation - In the class, we "nominate the class to be a delegate."
    
    @IBOutlet var imageView: UIImageView!
    //We then create an object of the delegate class (UIImagePickerController)
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //And we accept the nomination and say that the delegate of this object (of UIImageController class) is going to be self (this ViewController)
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }

    //MARK: image picker delegate method
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if var userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //if the info[UIImagePickerControllerOriginalImage] exists (not nil)
            //And can be downcasted to UIImage, then continue ->
            if let img = info[UIImagePickerControllerEditedImage] as? UIImage
            {
                userPickedImage = img
                imageView.image = userPickedImage
            }
            else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                userPickedImage = img
                imageView.image = userPickedImage
            }
        }
        
        imagePicker.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func cameraTapped(sender: AnyObject) {
        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default , handler:{ (UIAlertAction)in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
//    @IBAction func cameraTapped(_ sender: Any) {
//        present(imagePicker, animated: true, completion: nil)
//    }
    
}

