//
//  FoodieTableViewController.swift
//  FoodiePlace
//
//  Created by Belinda Vennam on 4/24/16.
//  Copyright © 2016 Belinda Vennam. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}
