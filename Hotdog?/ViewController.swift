//
//  ViewController.swift
//  Hotdog?
//
//  Created by Aziz Zaynutdinov on 7/16/18.
//  Copyright © 2018 Aziz Zaynutdinov. All rights reserved.
//

import UIKit
import CoreML
import Vision //This framework allows us to perform image analysis requests using the coreML model

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
            //Guard this line from unexpected crashing. Basically try to do this line, if it can't, do the brackets ->
                guard let ciImage = CIImage(image: userPickedImage) else {
                    fatalError("Couldn't convert UIImage to CIImage")
                }
                detect(image: ciImage)
            //Fatal crashing the app should only be done in the production stage, for debugging reasons. Never in the deployment phase.

            }
            else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                userPickedImage = img
                imageView.image = userPickedImage
            //If the guard statement evaluates to true (ciImage = CIImage(image: userPickedImage)) then assign it, proceed and do nothing. If it is false, do the else blocl.
                guard let ciImage = CIImage(image: userPickedImage) else {
                    fatalError("Couldn't convert UIImage to CIImage")
                }
                detect(image: ciImage)
            }
        }
        
        imagePicker.dismiss(animated: true,completion: nil)
    }
    
    func detect(image: CIImage){
        //Tries to set model as VNCoreMLModel(for: Inceptionv3().model). If it does, then it is wrapped as an optional.
        //If it fails, then model is set to nil. But if is nil, then the guard statement protects us and throws a fatal error.
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Model is evaluated to nil") }
            
            let VNrequest = VNCoreMLRequest(model: model) { (request, error) in //The variables in parenthesis is what we will get back from this request.
                //The order of operation is following: 1) We make a handler (with an image). 2) We ask it to perform the request. 3) Request returns either a result or an error.
                //4) We use those to either assign the result to the VNresults or to trigger a fatal error and print it.
                guard let VNresults = request.results as? [VNClassificationObservation] else {
                    fatalError("Model failed to process image \(String(describing: error))")
                }
                
                if let firstResult = VNresults.first {
                    if firstResult.identifier.contains("hotdog") {
                        self.navigationItem.title = "Hotdog!"
                    }
                    else {
                        self.navigationItem.title = "Not Hotdog :("
                    }
                }
                
            }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([VNrequest])
        } catch {
            print("Error performing the request.")
        }
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
}

