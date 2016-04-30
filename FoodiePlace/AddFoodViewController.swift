//
//  ViewController.swift
//  FoodiePlace
//
//  Created by Belinda Vennam on 4/23/16.
//  Copyright © 2016 Belinda Vennam. All rights reserved.
//

import Foundation
import UIKit

class AddFoodViewController: UIViewController {
    
    @IBOutlet weak var foodName: UITextField!
    @IBOutlet weak var foodImage: UITextField!
    var cityName:String?
    var googleId:String?
    var googleAddress:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didAddFood(sender: AnyObject) {
        
        let session = NSURLSession.sharedSession()
        let url = NSURL(string:"http://localhost:8080/api/locations/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        print(foodName.text!)
        print(foodImage.text!)
        let foodparams = ["name":foodName.text!, "image":foodImage.text!] as Dictionary<String, String>
        let params = ["google_address":googleAddress!, "google_id":googleId!, "name": cityName!, "foods":foodparams] as Dictionary<String, AnyObject>
        do {
            print(params)
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
            print(request.HTTPBody)
            print(request.HTTPBody!)
        } catch {
            print ("there was an error")
        }

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(request.HTTPBody!.description)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            print(data)
        }
        
        task.resume()
        
    }
    
}

