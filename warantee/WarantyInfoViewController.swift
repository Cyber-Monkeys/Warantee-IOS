//
//  WarantyInfoViewController.swift
//  warantee
//
//  Created by Humaid Khan on 14/12/2019.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import AVKit
import AVFoundation
import MapKit
// display waranty information
class WarantyInfoViewController: UIViewController {

    var warantyId = -1
    @IBOutlet weak var sellerNameLabel: UILabel!
    
    @IBOutlet weak var sellerPhoneLabel: UILabel!
    
    @IBOutlet weak var sellerEmailLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var warantyPeriodLabel: UILabel!
    
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    @IBOutlet weak var warantyImage: UIImageView!
    
    
    @IBOutlet weak var warantyAvPlayer: UIView!
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var warantyUId = ""
    var avPlayer: AVPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        // load data from coredata
        let thisAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = thisAppDelegate.persistentContainer.viewContext
        
        let req:NSFetchRequest<Waranty> = Waranty.fetchRequest()
        req.predicate = NSPredicate(format: "id = %@", String(self.warantyId))
        do{
            let warantees = try context.fetch(req)
            // do something with data
            let waranty = warantees[0]
            sellerNameLabel.text = waranty.sellerName
            sellerPhoneLabel.text = waranty.sellerPhone
            sellerEmailLabel.text = waranty.sellerEmail
            amountLabel.text = String(waranty.amount)
            dateLabel.text = waranty.date
            warantyPeriodLabel.text = String(waranty.warantyPeriod)
            switch waranty.category {
            case 0:
                categoryLabel.text = "Food"
            case 1:
                categoryLabel.text = "Grocery"
             case 2:
                categoryLabel.text = "Travel"
             case 3:
                categoryLabel.text = "Electronics"
             case 4:
                categoryLabel.text = "Others"
            default:
                categoryLabel.text = "None"
            }
            self.warantyUId = waranty.uid ?? ""
            
            // search map for location and display it
            
            
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = waranty.location
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start{ response, _ in
                guard let respone = response else {
                    return
                }
                let placemark = response?.mapItems[0].placemark
                self.mapView.removeAnnotations(self.mapView.annotations)
                let annotation = MKPointAnnotation()
                annotation.coordinate = placemark!.coordinate
                annotation.title = placemark?.name
                if let city = placemark?.locality,
                    let state = placemark?.administrativeArea {
                    annotation.subtitle = "(city) (state)"
                }
                self.mapView.addAnnotation(annotation)
                let span = MKCoordinateSpan(latitudeDelta:0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: placemark!.coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                
            }
            
            
            // verify user login and download video on complete
            Auth.auth().currentUser?.getIDToken(completion: warantyVideoRequest)
            
            // load image from retrieved url from coredata
            let documentsUrl:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsUrl.appendingPathComponent(String(waranty.id) + ".jpg")
            do{
                let imageData = try Data(contentsOf: fileURL)
                warantyImage.image = UIImage(data: imageData)
            } catch {
                print("Error loading image: \(error)")
            }
        }
        catch{
            print("CoreData request failed")
        }
        // Do any additional setup after loading the view.
    }
    
    
    // load video from server
    func warantyVideoRequest(token:String?, error: Error?) {
        let documentsUrl:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationFileUrl = documentsUrl.appendingPathComponent(String(self.warantyId) + ".mp4")
        if let url = URL(string: "https://www.vrpacman.com/s3proxy?fileKey=" + self.warantyUId + String(self.warantyId) + ".mp4") {
            var request = URLRequest(url: url)
            request.setValue(token, forHTTPHeaderField:"AuthToken")
            request.httpMethod = "GET"
            URLSession.shared.downloadTask(with: request) { localURL, response, error in
            if let localURL = localURL {
                  do {
                    try? FileManager.default.removeItem(at: destinationFileUrl)
                    try FileManager.default.moveItem(at: localURL, to: destinationFileUrl)
                    DispatchQueue.main.async {
                        self.avPlayer = AVPlayer(url: destinationFileUrl)
                                                      let avPlayerController = AVPlayerViewController()
                        avPlayerController.player = self.avPlayer
                                                      avPlayerController.view.frame = CGRect(x: 0, y: 70, width: UIScreen.main.bounds.size.width, height: 196)

                                                      // Turn on video controlls
                                                      avPlayerController.showsPlaybackControls = true

                                                      // play video
                                                      avPlayerController.player?.play()
                                                      self.view.addSubview(avPlayerController.view)
                                                      self.addChild(avPlayerController)
                                           }
                    
                  } catch let error {
                     print(error)
                  }
               }
           }.resume()
        }
    }
    
   // go back is pressed
    @IBAction func backButtonPressed(_
        sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
