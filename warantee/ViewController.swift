//
//  ViewController.swift
//  warantee
//
//  Created by student on 07/12/2019.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import CoreData

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UNUserNotificationCenterDelegate {

   
    @IBOutlet weak var picker: UIPickerView!
    //logout
    @IBAction func signOut(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            print("user logged out")
            self.deleteAllData(entity: "Waranty")
            //dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
        //logs out google account
        GIDSignIn.sharedInstance().signOut()
        
    }
    func deleteAllData(entity: String)
       {
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           let context = appDelegate.persistentContainer.viewContext
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
           fetchRequest.returnsObjectsAsFaults = false
           do {
               let results = try context.fetch(fetchRequest)
               for object in results {
                   guard let objectData = object as? NSManagedObject else {continue}
                   context.delete(objectData)
               }
           } catch let error {
               print("Detele all data in \(entity) error :", error)
           }
       }
    struct Warantee: Codable { // or Decodable
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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //if user logs out
        Auth.auth().addStateDidChangeListener
        { (auth, user) in
            
            if user == nil {
              self.goToLogin()
            }
            
        }
        picker.delegate = self
        picker.dataSource = self

        // set UNUserNotificationCenter delegate to self
        UNUserNotificationCenter.current().delegate = self
        setNotification()
        
    }
    // sets notification for 10:00 am everyday
    func setNotification() {
        let notificationOptions: UNAuthorizationOptions = [.alert, .sound];
        UNUserNotificationCenter.current().requestAuthorization(options: notificationOptions) { (granted, error) in
            if !granted {
                print("Something went wrong")
            } else {
                let content = UNMutableNotificationContent()
                content.body = "pls work"
                content.sound = UNNotificationSound.default

                let date = DateComponents(hour: 10, minute: 00)
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)

                let request = UNNotificationRequest(identifier: "Daily String", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.

        completionHandler([.alert, .badge, .sound])
    }

    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        switch response.actionIdentifier {
        case "action1":
            print("Action First Tapped")
        case "action2":
            print("Action Second Tapped")
        default:
            break
        }
        completionHandler()
    }
    // redirects user to login screen
    func goToLogin(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC:LoginController = storyboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        
        //go to new screen in fullscreen
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    // UIPickerViewDatasource
    // how many pickers do you have
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // number of options in picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 6
    }
    // height of each picker
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    // UIPickerViewDelegate
    // set attributes of each picker cell
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let myView = UIView()
        myView.frame = CGRect(x:0, y:0, width:pickerView.bounds.width - 30, height:60)
        let myImageView = UIImageView()
        myImageView.frame = CGRect(x:0, y:0, width:50, height:50)
       var rowString = String()
       // set image based on row selected
       switch row {
        case 0:
            rowString = "all"
            myImageView.image = UIImage(named:"warantee")
       case 1:
           rowString = "food"
           myImageView.image = UIImage(named:"food")
       case 2:
           rowString = "grocery"
           myImageView.image = UIImage(named:"grocery")
        case 3:
            rowString = "travel"
            myImageView.image = UIImage(named:"travel")
        case 4:
            rowString = "electronics"
            myImageView.image = UIImage(named:"electronics")
        case 5:
            rowString = "others"
            myImageView.image = UIImage(named:"others")
        
       default:
           rowString = "Error: too many rows"
           myImageView.image = nil
       }
       let myLabel = UILabel()
        myLabel.frame = CGRect(x:60, y:0, width:pickerView.bounds.width - 90, height:60 )
       myLabel.font = UIFont(name:"Helvetica", size: 18)
       myLabel.text = rowString

       myView.addSubview(myLabel)
       myView.addSubview(myImageView)

       return myView
    }
    // Query coredata on cell selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let tv = self.children[0] as! WaranteeTableViewController
        tv.WaranteeList.removeAll()
        tv.tableView.reloadData()
        print(tv.WaranteeList.isEmpty)
        let thisAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = thisAppDelegate.persistentContainer.viewContext
        //load core data
        let req:NSFetchRequest<Waranty> = Waranty.fetchRequest()
        if(row != 0) {
            //query category
            req.predicate = NSPredicate(format: "category = %@", NSNumber(integerLiteral:row - 1))
        }
        do{
            // set warantee list after retrieving data
            let warantees = try context.fetch(req)
            print(warantees.count)
            for w in warantees {
                tv.WaranteeList.append(WaranteeTableViewController.Warantee(id: Int(w.id), uid: w.uid!, date: w.date!, amount: w.amount, category: Int(w.category), warantyPeriod: Int(w.warantyPeriod), sellerName: w.sellerName!, sellerPhone: w.sellerPhone!, sellerEmail: w.sellerEmail!, location: w.location!, createdAt: w.createdAt!, updatedAt: w.updatedAt!))
            }
            tv.tableView.reloadData()
        }
        catch let error {
           print(error)
        }
        
    }
// switch scenes when add button is pressed
    @IBAction func addButtonPressed(_ sender: Any) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let form1:AddWaranteeController = storyboard.instantiateViewController(withIdentifier: "WaranteeForm1") as! AddWaranteeController
        //go to new screen in fullscreen
        form1.modalPresentationStyle = .fullScreen
        self.present(form1, animated: true, completion: nil)
    }
    
}

