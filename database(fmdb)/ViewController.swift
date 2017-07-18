//
//  ViewController.swift
//  database(fmdb)
//
//  Created by Abdul Ahad on 7/14/17.
//  Copyright © 2017 plash. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    var databasePath = String()
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var phoneNo: UITextField!
    
    @IBOutlet weak var status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        databasePath = dirPaths[0].appendingPathComponent("contacts.db").path
        
        if !filemgr.fileExists(atPath: databasePath as String) {
            
            let contactDB = FMDatabase(path: databasePath as String)
            
            if contactDB == nil {
                print("Error: \(contactDB.lastErrorMessage())")
            }
            
            if (contactDB.open()) {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
                if !(contactDB.executeStatements(sql_stmt)) {
                    print("Error: \(contactDB.lastErrorMessage())")
                }
                contactDB.close()
            } else {
                print("Error: \(contactDB.lastErrorMessage())")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveBtn(_ sender: Any) {
       
        let contactDB = FMDatabase(path: databasePath as String)
        
        if (contactDB.open()) {
            
            
            let insertSQL = "INSERT INTO CONTACTS (name, address, phone) VALUES ('\(name.text!)', '\(address.text!)', '\(phoneNo.text!)')"
            //also used for delete,update
            let result = contactDB.executeUpdate(insertSQL,
                                                  withArgumentsIn: [])
            
            if !result {
                status.text = "Failed to add contact"
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                status.text = "Contact Added"
                name.text = ""
                address.text = ""
                phoneNo.text = ""
            }
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }
    
    @IBAction func findBtn(_ sender: Any) {
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        if (contactDB.open()) {
            let querySQL = "SELECT address, phone FROM CONTACTS WHERE name = '\(name.text!)'"
            
            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                                                               withArgumentsIn: [])
            
            if results?.next() == true {
                address.text = results?.string(forColumn: "address")
                phoneNo.text = results?.string(forColumn: "phone")
                status.text = "Record Found"
            } else {
                status.text = "Record not found"
                address.text = ""
                phoneNo.text = ""
            }
            contactDB.close()
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
    }
    
    
    @IBAction func update(_ sender: UIButton) {
        
        //optionals in swift
        //var ds:String? = "ssds"
       
        let contactDB = FMDatabase(path: databasePath as String)
        
        if (contactDB.open()) {
            
            
            let updateSQL = "UPDATE CONTACTS SET name = 'sohail', address = 'gulshan' WHERE phone = '\(phoneNo.text!)'"
            //also used for update
            let result = contactDB.executeUpdate(updateSQL,
                                                 withArgumentsIn: [])
            
            if !result {
                status.text = "Failed to update contact"
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                status.text = "Contact updated"
                name.text = ""
                address.text = ""
                phoneNo.text = ""
            }
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }
    
    
    
    @IBAction func delBtn(_ sender: UIButton) {
        let contactDB = FMDatabase(path: databasePath as String)
        
        if (contactDB.open()) {
            
            
            let updateSQL = "DELETE FROM CONTACTS WHERE name = '\(name.text!)'"
            //also used for delete
            let result = contactDB.executeUpdate(updateSQL,
                                                 withArgumentsIn: [])
            
            if !result {
                status.text = "Failed to delete contact"
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                status.text = "Contact deleted"
                name.text = ""
                address.text = ""
                phoneNo.text = ""
            }
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }

    

}

