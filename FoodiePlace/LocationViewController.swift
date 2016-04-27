//
//  ViewController.swift
//  FoodiePlace
//
//  Created by Belinda Vennam on 4/23/16.
//  Copyright © 2016 Belinda Vennam. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationViewController: UIViewController, UISearchBarDelegate {
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var selectedCity:AnyObject?
    var didSelect:Bool?
    //@IBOutlet weak var typeView: UIView!
    
    @IBOutlet weak var locationText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didSelect = false;
        resultsViewController = GMSAutocompleteResultsViewController()
        let filter = GMSAutocompleteFilter()
        
        //set background image
        let image = UIImage(named: "foodPic")
        self.view.backgroundColor = UIColor(patternImage: image!)
        self.navigationItem.rightBarButtonItems = []
        
        //filter by City
        filter.type = GMSPlacesAutocompleteTypeFilter.City
        resultsViewController?.autocompleteFilter = filter
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.placeholder = "Enter a Place"
        searchController?.searchBar.delegate = self
        searchController?.searchBar.barTintColor = UIColor(red: 0.306, green: 0.804, blue: 0.769, alpha: 1.0) /*#4ecdc4*/
        let subView = UIView(frame: CGRectMake(0, 64.0, self.view.frame.width, 45.0))
        subView.addSubview((searchController?.searchBar)!)
        self.view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        self.definesPresentationContext = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC = segue.destinationViewController as! FoodieTableViewController
        destinationVC.selectedCity = self.selectedCity
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        if (self.didSelect == true) {
            self.didSelect = false
            performSegueWithIdentifier("showFoodsSegue", sender: self)
        }
    }
}
// Handle the user's selection.
extension LocationViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    func resultsController(resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWithPlace place: GMSPlace) {
        self.didSelect = true
        searchController?.active = false
        // Do something with the selected place.
        searchController?.searchBar.text = place.name
        self.selectedCity = place
        print(self.selectedCity)
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
    }
    
    func resultsController(resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: NSError){
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}