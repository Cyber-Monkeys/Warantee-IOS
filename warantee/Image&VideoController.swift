//
//  Image&VideoController.swift
//  warantee
//
//  Created by Mahmoud Elmohtasseb on 2019-12-17.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices
import Firebase
// form page 2
class Image_VideoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // load default data
    var warantyDate:String = "16/12/2019"
    var warantyAmount:Float = 25.5
    var warantyCategory:Int = 2
    var warantyPeriod:Int = 20
    var warantySellerName:String = "John"
    var warantySellerPhone:String = "Doe"
    var warantySellerEmail:String = "jon@cud.ae"
    var warantyLocation:String = "Candian University of Dubai"
    
    
    var videoAndImageReview = UIImagePickerController()
    var videoURL: URL?
    
    
    var avPlayer: AVPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    enum ImageSource {
        case photoLibrary
        case camera
    }

    //Submit Button
    @IBAction func Submit(_ sender: Any) {
        Auth.auth().currentUser?.getIDToken(completion: postRequest)
    }
    
    //VideoViewer
    @IBOutlet weak var VideoViewer: UIImageView!
    var isMovie = false
 
    // record video
    @IBAction func recordvideo(_ sender: Any) {
        isMovie = true
        // load from camera if available
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                          
                       let imagePicker = UIImagePickerController()
                           imagePicker.delegate = self
                           imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            
                   
                           imagePicker.allowsEditing = false
                          self.present(imagePicker, animated: true, completion: nil)
        // go to gallery if camera is not available
        } else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                                
                             let imagePicker = UIImagePickerController()
                                 imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                  imagePicker.mediaTypes = [kUTTypeMovie as String]
                  
                         
                                 imagePicker.allowsEditing = false
                                self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("camera and photo library not available")
        }
    }
    
    
   @IBOutlet weak var myImage: UIImageView!
    
// function to take photo from camera
   @IBAction func takePhoto(_ sender: Any) {
             // check if the camera is available
            isMovie = false
            // load photo from camera if available
              if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                    
                 let imagePicker = UIImagePickerController()
                     imagePicker.delegate = self
                     imagePicker.sourceType = UIImagePickerController.SourceType.camera
             
                     imagePicker.allowsEditing = false
                    self.present(imagePicker, animated: true, completion: nil)
            }
                // load photo from gallery if camera is not available
              else if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)){
                    print("photo library")
                              let imagePicker = UIImagePickerController()
                                  imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                          
                                  imagePicker.allowsEditing = false
                                 self.present(imagePicker, animated: true, completion: nil)
                         //if camera is not availabe print this message
                
              } else {
                print("photo library and camera unavailable")
            }
    }
    // json parsed warantee
    struct Warantee: Codable {
        let date:String
        let amount:Float
        let category:Int
        let warantyPeriod:Int
        let sellerName:String
        let sellerPhone:String
        let sellerEmail:String
        let location:String
    }
    // json decodable waranty
   struct Waranty: Codable { // or Decodable
       let id: Int
       let uid: String
       let date: String
       let amount: Float
       let category: Int
       let warantyPeriod: Int
       let sellerName: String
       let sellerPhone: String
       let sellerEmail: String
       let location: String
       let createdAt: String
       let updatedAt: String
   }
    // post request to server
    func postRequest(token:String?, error: Error?) {
        // ...
        // create waranty codable
        let waranty = Warantee(date: self.warantyDate, amount: self.warantyAmount, category: self.warantyCategory, warantyPeriod: self.warantyPeriod, sellerName: self.warantySellerName, sellerPhone: self.warantySellerPhone, sellerEmail: self.warantySellerEmail, location: self.warantyLocation)
       //encode codable to json
       guard let uploadData = try? JSONEncoder().encode(waranty) else {
           return
       }
       //set url
       let url = URL(string: "https://www.vrpacman.com/waranty")!
        // create request for that url
       var request = URLRequest(url: url)
       request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField:"AuthToken")
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // upload waranty info to server
       let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
           if let error = error {
               print ("error: \(error)")
               return
           }
           guard let response = response as? HTTPURLResponse,
               (200...299).contains(response.statusCode) else {
               print ("server error")
               return
           }
           if let mimeType = response.mimeType,
               mimeType == "application/json",
               let data = data,
               let dataString = String(data: data, encoding: .utf8) {
               print ("got data: \(dataString)")
                do {
                  _ = String(data: data,encoding:String.Encoding.utf8) as String?
                   let res = try JSONDecoder().decode(Waranty.self, from: data)
                    self.uploadImage(token: token, warantyId: res.id)
                } catch let error {
                   print(error)
                }
            
           }
       }
       task.resume()

    }
    // upload image to server
    func uploadImage(token:String?, warantyId:Int) {
        // load file from storage
        let documentsUrl:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsUrl.appendingPathComponent("image.jpg")
        do{
            let imageData = try Data(contentsOf: fileURL)
                    // create multipart request
                   let filename = "image.jpg"
                   let lineEnd = "\r\n"
                   let twoHyphens = "--"
                   let boundary = "*****"

                   let config = URLSessionConfiguration.default
                   let session = URLSession(configuration: config)

                   // Set the URLRequest to POST and to the specified URL
                   var urlRequest = URLRequest(url: URL(string: "https://www.vrpacman.com/photo")!)
                   urlRequest.httpMethod = "POST"

                   // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
                   // And the boundary is also set here
            urlRequest.setValue(token, forHTTPHeaderField: "AuthToken")
                   urlRequest.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
                   urlRequest.setValue("multipart/form-data", forHTTPHeaderField: "ENCTYPE")
                   urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                    
                   
                   urlRequest.setValue(filename, forHTTPHeaderField: "myFile")
                   
                   urlRequest.setValue(String(warantyId), forHTTPHeaderField: "WarantyId")
                    // CREATE DATA TO SET
                   var data = Data()
            
                   // Add the reqtype field and its value to the raw http request data
                   data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                   data.append("Content-Disposition: form-data; name=\"myFile\";filename=\"\(filename)\"\r\n\r\n".data(using: .utf8)!)
                    // add image data to the request
                   data.append(imageData)

                    data.append("\r\n".data(using: .utf8)!)
                    data.append("--\(boundary)--".data(using: .utf8)!)
            // add content length to request
            urlRequest.setValue(String(data.count), forHTTPHeaderField: "Content-Length")
                   // Send a POST request to the URL, with the data we created earlier
                   session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
                       
                       if(error != nil){
                           print("\(error!.localizedDescription)")
                       }
                       
                       guard let responseData = responseData else {
                           print("no response data")
                           return
                       }
                    // start upload video task
                    self.uploadVideo(token: token, warantyId: warantyId)
                       if let responseString = String(data: responseData, encoding: .utf8) {
                           print("uploaded to: \(responseString)")
                       }
                   }).resume()
        } catch {
            print("Error loading image: \(error)")
        }
       
       
    }
    // start upload video task to server
    func uploadVideo(token:String?, warantyId:Int) {
        // load video from file manager
          let documentsUrl:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
          let fileURL = documentsUrl.appendingPathComponent("video.MOV")
          do{
            // create upload video request to server
              let imageData = try Data(contentsOf: fileURL)

                     let filename = "video.MOV"
                     let lineEnd = "\r\n"
                     let twoHyphens = "--"
                     let boundary = "*****"

                     let config = URLSessionConfiguration.default
                     let session = URLSession(configuration: config)

                     // Set the URLRequest to POST and to the specified URL
                     var urlRequest = URLRequest(url: URL(string: "https://www.vrpacman.com/video")!)
                     urlRequest.httpMethod = "POST"

                     // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
                     // And the boundary is also set here
              urlRequest.setValue(token, forHTTPHeaderField: "AuthToken")
                     urlRequest.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
                     urlRequest.setValue("multipart/form-data", forHTTPHeaderField: "ENCTYPE")
                     urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                     
                     urlRequest.setValue(filename, forHTTPHeaderField: "myFile")
                     
                     urlRequest.setValue(String(warantyId), forHTTPHeaderField: "WarantyId")

                     var data = Data()

                     // Add the reqtype field and its value to the raw http request data
                     data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                     data.append("Content-Disposition: form-data; name=\"myFile\";filename=\"\(filename)\"\r\n\r\n".data(using: .utf8)!)

                     data.append(imageData)
                    data.append("\r\n".data(using: .utf8)!)
                    data.append("--\(boundary)--".data(using: .utf8)!)
            
            urlRequest.setValue(String(data.count), forHTTPHeaderField: "Content-Length")
                     // Send a POST request to the URL, with the data we created earlier
                     session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
                         
                         if(error != nil){
                             print("\(error!.localizedDescription)")
                         }
                         
                         guard let responseData = responseData else {
                             print("no response data")
                             return
                         }
                         // go to next page when upload is complete
                         if let responseString = String(data: responseData, encoding: .utf8) {
                             DispatchQueue.main.async {
                                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let menuVC:ViewController = storyboard.instantiateViewController(withIdentifier: "MenuVC") as! ViewController
                                
                                //go to new screen in fullscreen
                                menuVC.modalPresentationStyle = .fullScreen
                                self.present(menuVC, animated: true, completion: nil)
                            }
                        }
                     }).resume()
          } catch {
              print("Error loading image: \(error)")
          }
         
         
      }
    func image(_ image:UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer){
        if let error = error {
            //we got back an error
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            
                ac.addAction(UIAlertAction(title: "Ok", style: .default ))
                present(ac, animated: true)
             }
        else {
            
            let ac = UIAlertController(title: "Saved!", message: "Your Alertered image has been saved to your photos", preferredStyle: .alert)
            
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
    }
   
    
    
 // function to view the picture in the image view
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
    // if the saved image is an image; load it to the imageview
    if !isMovie {
    guard let mediaType = info[UIImagePickerController.InfoKey.mediaURL] as? String,
        mediaType == (kUTTypeMovie as String),
        let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
        UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
        else {
            print("please run")
                   if let pickedImage = info[.originalImage] as? UIImage {
                       myImage.contentMode = .scaleToFill
                       myImage.image = pickedImage
                       let data = pickedImage.jpegData(compressionQuality: 1.0)
                        let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL
                       do{
                           try data!.write(to: directory!.appendingPathComponent("image.jpg")!)
                           print("file stored")
                       } catch {
                           print(error.localizedDescription)
                       }
                   }
              
                  //  this allows the user to edit the picture
                  picker.dismiss(animated: true, completion: nil)
            return
        }
        // if saved file is of type movie
        // show video in video player
    } else {
        let mediaType = info[UIImagePickerController.InfoKey.mediaURL] as? String
        let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url!.path)
        let documentsUrl:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationFileUrl = documentsUrl.appendingPathComponent("video.MOV")
        do {
            try? FileManager.default.removeItem(at: destinationFileUrl)
            try FileManager.default.moveItem(at: url!, to: destinationFileUrl)
            self.avPlayer = AVPlayer(url: destinationFileUrl)
                                          let avPlayerController = AVPlayerViewController()
            avPlayerController.player = self.avPlayer
                                          avPlayerController.view.frame = CGRect(x: 0, y: 450, width: UIScreen.main.bounds.size.width, height: 196)

                                          // Turn on video controlls
                                          avPlayerController.showsPlaybackControls = true

                                          // play video
                                          avPlayerController.player?.play()
                                          self.view.addSubview(avPlayerController.view)
                                          self.addChild(avPlayerController)
                picker.dismiss(animated: true, completion: nil)
        } catch let error {
           print(error)
        }
    }
                       
    }
    
}
         
    
    
    
   
                
   
