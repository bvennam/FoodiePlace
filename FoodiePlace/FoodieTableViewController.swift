//
//  FoodieTableViewController.swift
//  FoodiePlace
//
//  Created by Belinda Vennam on 4/24/16.
//  Copyright © 2016 Belinda Vennam. All rights reserved.
//

import Foundation
import UIKit

class FoodieTableViewController: UITableViewController {
    
    var location:String?
    var foods:NSArray?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //print(location)
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: "http://localhost:8080/api/locations/571b9a5dce4f53f52b85bd03")
        let request = NSURLRequest(URL: url!)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            //print(data)
            //print(response)
            
            guard (error == nil) else {
                print(error)
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("status code not 2xx!")
                return
            }
            
            guard let data = data else {
                print("there was no data returned")
                return
            }
            let serializedData:AnyObject!
            do {
                serializedData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                print ("there was an issue with serialization")
                return
            }
            guard let foodsDictionary = serializedData["foods"] else {
                print("cannot find foods key")
                return
            }
            self.foods = foodsDictionary as? NSArray
            self.tableView.reloadData()
            
        }
        task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(foods)

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.foods == nil) {
            return 0
        } else {
            return self.foods!.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(self.foods)
        let cell = tableView.dequeueReusableCellWithIdentifier("foodtotry")
        let foodObject = self.foods![indexPath.row]
        let foodName = foodObject["name"] as! String
        cell?.textLabel?.text = foodName
        
        //create image from data
        let foodImageURL = foodObject["image"] as! String
        if let url  = NSURL(string: foodImageURL),
            data = NSData(contentsOfURL: url)
        {
            cell?.imageView?.image = UIImage(data: data)
        }
        return cell!
    }
    
    
    
    
}
