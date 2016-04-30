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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        print(selectedCity)
        print(selectedCity!.placeID)
        print(selectedCity!.formattedAddress)
        print(selectedCity!.name)
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: "http://localhost:8080/api/locations/google/" + selectedCity!.placeID)
        let request = NSURLRequest(URL: url!)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            //print(data)
            //print(response)
            
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
                    let imageView = UIImageView(image: UIImage(named: "noFoods"))
                    imageView.center.x = self.view.frame.width/2.0
                    imageView.center.y = imageView.center.y + 20.0
                    self.view.addSubview(imageView)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let addFoodVC = segue.destinationViewController as! AddFoodViewController
        addFoodVC.cityName = selectedCity?.name
        addFoodVC.googleId = selectedCity?.placeID
        addFoodVC.googleAddress = selectedCity?.formattedAddress
        //
    }
    
    @IBAction func saveFood(segue:UIStoryboardSegue) {
        if let addFoodVC = segue.sourceViewController as? AddFoodViewController {
            self.tableView.reloadData()
        }
    }
    
    
}
