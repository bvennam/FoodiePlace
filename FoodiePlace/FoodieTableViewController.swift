//
//  FoodieTableViewController.swift
//  FoodiePlace
//
//  Created by Belinda Vennam on 4/24/16.
//  Copyright © 2016 Belinda Vennam. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class FoodieTableViewController: UITableViewController {
    
    var location:String?
    var foods:NSArray?
    var selectedCity:GMSPlace?
    var foodName: String?
    var foodImage: String?
    var noFoodsImageView:UIImageView?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: "http://localhost:8080/api/locations/google/" + selectedCity!.placeID)
        let request = NSURLRequest(URL: url!)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func displayError(error:String) {
                performUIUpdatesOnMain({ 
                    let errorTextView = UITextView(frame: CGRectMake(0, 64.0, self.view.frame.width, 45.0))
                    errorTextView.text = error
                    self.view.addSubview(errorTextView)
                })
            }
            
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
                performUIUpdatesOnMain({
                    self.noFoodsImageView = UIImageView(image: UIImage(named: "noFoods"))
                    self.noFoodsImageView!.center.x = self.view.frame.width/2.0
                    self.noFoodsImageView!.center.y = self.noFoodsImageView!.center.y + 20.0
                    self.view.addSubview(self.noFoodsImageView!)
                })
                return
            }
            self.foods = foodsDictionary as? NSArray
            self.tableView.reloadData()
            
        }
        task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(FoodieTableViewController.addNewFood))]
        print(foods)

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.foods == nil) {
            return 0
        } else {
            return self.foods!.count
        }
    }
    
    //fill in the tableViewCells with foods from the API
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(self.foods)
        let cell = tableView.dequeueReusableCellWithIdentifier("foodtotry") as! FoodTableViewCell
        let foodObject = self.foods![indexPath.row]
        let foodName = foodObject["name"] as! String
        performUIUpdatesOnMain { 
            cell.foodLabel.text = foodName
        }

        let foodImageURL = foodObject["image"] as! String
        if let url  = NSURL(string: foodImageURL),
            data = NSData(contentsOfURL: url)
        {
            performUIUpdatesOnMain{ 
                cell.foodImage.image = UIImage(data: data)
            }
        }
        return cell
    }
    
    func addNewFood() {
        performSegueWithIdentifier("addFoods", sender: self)
    }
    
    //saveFood unwind segue action from adding a food panel
    //TODO: Add more error checking
    @IBAction func saveFood(segue:UIStoryboardSegue) {
        if (segue.sourceViewController.isKindOfClass(AddFoodViewController)) {
            let session = NSURLSession.sharedSession()
            let url = NSURL(string:"http://localhost:8080/api/locations/")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            let foodparams = ["name":self.foodName!, "image":self.foodImage!] as Dictionary<String, String>
            if let selectedCity = self.selectedCity {
                let params = ["google_address":selectedCity.formattedAddress!, "google_id":selectedCity.placeID, "name": selectedCity.name, "foods":foodparams] as Dictionary<String, AnyObject>
                do {
                    request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
                } catch {
                    print ("there was an error")
                }
            }
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = session.dataTaskWithRequest(request) { (data, response, error) in
                if (self.noFoodsImageView != nil) {
                    self.noFoodsImageView!.hidden = true
                }
                self.tableView.reloadData()
            }
            
            task.resume()
            
        }
    }
    
    @IBAction func cancelFood(segue:UIStoryboardSegue) {
//        if let addFoodVC = segue.sourceViewController as? AddFoodViewController {
//            self.tableView.reloadData()
//        }
    }
    
    
}
