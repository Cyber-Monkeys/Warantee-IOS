//
//  AddWaranteeController.swift
//  warantee
//
//  Created by Mahmoud Elmohtasseb on 2019-12-17.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

// form page 1
class AddWaranteeController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource{
    // form ui
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    
    @IBOutlet weak var txtPeriod: UITextField!

    @IBOutlet weak var picker: UIPickerView!
    //Creating a table view
    let tableView = UITableView()
    //to make the screen shaded when selecting category
    let transparentView = UIView()
    var selectedButton = UIButton()
    var dataSource = [String]()
    var category = 0
    @IBOutlet weak var categorySelect: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create custom category picker
       picker.delegate = self
        picker.dataSource = self
        // create custom date picker
        //this is to pick on the text field and shows the calander
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action:#selector(AddWaranteeController.dateChanged(datePicker:)), for: .valueChanged)
        
        //this is to recognize when you click anywhewre on the screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddWaranteeController.viewTapped(gestureRecognaizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        //Display the date in the text field
        txtDate.inputView = datePicker
        
    }
    
    
    //Functtion to go to the next page
    // send all form data to next page
    @IBAction func NextPage(_ sender: Any) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC:Image_VideoController = storyboard.instantiateViewController(withIdentifier: "WaranteeForm2") as! Image_VideoController
        menuVC.warantyDate = txtDate.text ?? "17/12/2019"
        menuVC.warantyAmount = Float(self.txtAmount.text ?? "5.5")!
        menuVC.warantyCategory = self.category
        menuVC.warantyPeriod = Int(Int64(self.txtPeriod.text ?? "3")!)
        menuVC.warantySellerName = txtName.text ?? "John"
        menuVC.warantySellerPhone = txtPhone.text ?? "992424"
        menuVC.warantySellerEmail = txtEmail.text ?? "jonfh@hc.com"
        menuVC.warantyLocation = txtLocation.text ?? "Burj al arab"
        //go to new screen in fullscreen
        menuVC.modalPresentationStyle = .fullScreen
        self.present(menuVC, animated: true, completion: nil)
    }
    
   private var datePicker: UIDatePicker?
    
    
    
    
    
    //function to dismiss the datepicker when click on the screen
    @objc func viewTapped(gestureRecognaizer: UITapGestureRecognizer){
         view.endEditing(true)
     }
     
    //to get and display the date after it is has been changed
    @objc func dateChanged(datePicker: UIDatePicker)
     {
         let dateFormater = DateFormatter()
         dateFormater.dateFormat = "MM/dd/yyyy"
         
         txtDate.text = dateFormater.string(from: datePicker.date)
         view.endEditing(true)
         
     }
    
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return 6
       }
       func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
           return 60
       }
       // UIPickerViewDelegate
       
       func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
           let myView = UIView()
           myView.frame = CGRect(x:0, y:0, width:pickerView.bounds.width - 30, height:60)
           let myImageView = UIImageView()
           myImageView.frame = CGRect(x:0, y:0, width:50, height:50)
          var rowString = String()
          switch row {
          case 0:
              rowString = "food"
              myImageView.image = UIImage(named:"food")
          case 1:
              rowString = "grocery"
              myImageView.image = UIImage(named:"grocery")
           case 2:
               rowString = "travel"
               myImageView.image = UIImage(named:"travel")
           case 3:
               rowString = "electronics"
               myImageView.image = UIImage(named:"electronics")
           case 4:
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
    // select category value when selecting a row
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           self.category = row
    }
    
}


