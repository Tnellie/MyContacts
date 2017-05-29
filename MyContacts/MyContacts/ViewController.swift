//
//  ViewController.swift
//  MyContacts
//
//  Created by Trevor Nelson on 5/28/17.
//  Copyright © 2017 Trevor Nelson. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var status: UILabel!
    
    @IBAction func btnEdit(_ sender: UIButton) {
        
        // Edit contact
        fullname.isEnabled = true
        email.isEnabled = true
        phone.isEnabled = true
        btnSave.isHidden = false
        btnEdit.isHidden = true
        fullname.becomeFirstResponder()
    }
    
    @IBAction func btnCall(_ sender: UIButton) {
        
        // Call Number
        
        // If number not null
        if (phone.text != "") {
            let formatedNumber = phone.text!.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
            print("calling \(formatedNumber)")
            let phoneURL = "tel://\(formatedNumber)"
            let url:URL = URL(string: phoneURL)!
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func btnSave(_ sender: AnyObject) {
        
        // Add save logic
        if (contactdb != nil) {
            contactdb.setValue(fullname.text, forKey: "fullname")
            contactdb.setValue(email.text, forKey: "email")
            contactdb.setValue(phone.text, forKey: "phone")
        }
        else {
            let entityDescription = NSEntityDescription.entity(forEntityName: "Contact", in: managedObjectContext)
            let contact = Contact(entity: entityDescription!, insertInto: managedObjectContext)
            
            contact.fullname = fullname.text!
            contact.email = email.text!
            contact.phone = phone.text!
        }
        var error: NSError?
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
        }
        
        if let err = error {
            // If error occurs
            status.text = err.localizedFailureReason
        } else {
            self.dismiss(animated: false, completion: nil)
        }
    }

    @IBAction func btnBack(_ sender: AnyObject) {
        // Dismiss view controller
        self.dismiss(animated: false, completion: nil)
    }

    // Add managedObject data context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Add variable contactdb
    var contactdb:NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add logic to load db. If contactdb has content that means a row was tapped on UITableView
        
        if (contactdb != nil)
        {
            fullname.text = contactdb.value(forKey: "fullname") as? String
            email.text = contactdb.value(forKey: "email") as? String
            phone.text = contactdb.value(forKey: "phone") as? String
            btnSave.setTitle("Update", for: UIControlState())
            btnCall.isHidden = false
            btnEdit.isHidden = false
            fullname.isEnabled = false
            email.isEnabled = false
            phone.isEnabled = false
            btnSave.isHidden = true
        } else {
            btnCall.isHidden = true
            btnEdit.isHidden = true
            fullname.isEnabled = true
            email.isEnabled = true
            phone.isEnabled = true
        }
        fullname.becomeFirstResponder()
        // Do any additional setup after loading the view.
        
        // Looks for single or multiple taps
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.DismissKeyboard))
        
        // Adds tap gesture to view
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Hide the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches , with:event)
        if (touches.first as UITouch!) != nil {
            DismissKeyboard()
        }
    }
    
    func DismissKeyboard(){
        // Forces resign first responder and hides keyboard
        fullname.endEditing(true)
        email.endEditing(true)
        phone.endEditing(true)
        
    }
    
    // Hide keyboard
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool     {
        textField.resignFirstResponder()
        return true;
    }
    
}

