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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as! FoodieTableViewController
        destinationVC.foodImage = foodImage.text
        destinationVC.foodName = foodName.text
    }
    
}

