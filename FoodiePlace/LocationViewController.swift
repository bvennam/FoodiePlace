//
//  ViewController.swift
//  FoodiePlace
//
//  Created by Belinda Vennam on 4/23/16.
//  Copyright © 2016 Belinda Vennam. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var locationText: UITextField!
    
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
        destinationVC.location = locationText.text
    }
}

