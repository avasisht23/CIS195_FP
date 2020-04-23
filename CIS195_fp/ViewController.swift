//
//  ViewController.swift
//  CIS195_fp
//
//  Created by Ajay Vasisht on 4/22/20.
//  Copyright © 2020 Ajay Vasisht. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class ViewController: UIViewController, UISearchBarDelegate, AddPinDelegate {
    func didCreate(_ yes: Bool) {
        dismiss(animated: true, completion: nil)
        if (yes) {
            self.mapView.reloadInputViews()
        }
    }
    
    // set up Firebase variables (ref, refHandle)
    var ref : DatabaseReference!
    var refHandle : DatabaseHandle!
    
    // ib variables for storyboard
    @IBOutlet var mapView: MKMapView!
    
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }

    //
    var pins = [PinAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // TODO: set up Firebase ref
        ref = Database.database().reference()
        
        // set 'refHandle' up to observe(.value) changes inside the Firebase database. Each time a change is observed, the closure will be called. Inside this closure you should:
        refHandle = ref.child("pins").observe(DataEventType.value, with: { (snapshot) in
            //    - Decode the 'snapshot' (Firebase data) into an array of NSDictionary objects
            
            if let values = snapshot.value as? NSArray {
                var pinsToMark = [PinAnnotation]()

                for val in values {
//                    dump(type(of : val))
                    //    - Decode the array of dictionaries into an array of PinAnnotations
                    if let pin = val as? NSDictionary {
                        let pinId = pin["id"] as! Int

                        let lat = pin["lat"] as! Double
                        let long = pin["long"] as! Double
                        let name = pin["name"] as! String

                        let pinLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)

                        let pinAnnotation = PinAnnotation(coordinate: pinLocation, id: pinId, name: name)
                        pinAnnotation.coordinate = pinLocation
                        pinsToMark.append(pinAnnotation)
                    }
                }
                
                DispatchQueue.main.async {
                    //    - Remove all existing from the Map
                    let allAnnotations = self.mapView.annotations
                    self.mapView.removeAnnotations(allAnnotations)

                    //    - Add the updated to the Map
                    print("here")
                    self.mapView.addAnnotations(pinsToMark)
                }
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centerMapOnPennCampus()
    }
    
    // init on Penn's Campus
    func centerMapOnPennCampus() {
        let coords = CLLocationCoordinate2D(latitude: 39.951389, longitude: -75.193775)
        let regionRadius : CLLocationDistance = 2000
        
        let region = MKCoordinateRegion(center: coords, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        mapView.setRegion(region, animated: true)
    }

    
    // search bar function to add a pin
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // activity indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        // hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        // create search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request : searchRequest)
        
        activeSearch.start { (response, error) in
            activityIndicator.stopAnimating()
            
            if response == nil {
                print("ERROR")
            } else {
                // get data long/lat
                let lat = response?.boundingRegion.center.latitude
                let long = response?.boundingRegion.center.longitude
                
                // create annotation
                let annotation = MKPointAnnotation()
                let title : String = searchBar.text! + "\nlat: \(lat!)\nlong: \(long!)"
                annotation.title = title
                annotation.coordinate = CLLocationCoordinate2DMake(lat!, long!)
                
                self.mapView.addAnnotation(annotation)
                
                // zoom in on annotation
                let coords : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                
                // set zoom
                let regionRadius : CLLocationDistance = 2000
                let region = MKCoordinateRegion(center: coords, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                
                self.mapView.setRegion(region, animated: true)
                
            }
        }
    }

}


// MARK: MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    
    // TODO: Implement
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView : MKAnnotationView?
        
        let identifier = "PinAnnotationIdentifier"
        guard let pinAnnotation = annotation as? PinAnnotation else { return nil }
        
        // TODO:
        // - Try to dequeue an Annotation view with the identifier
        //   - If successful, just update the annotation
        //   - If unsuccessful, make a new MKAnnotationView
        // - Configure the callout view
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView = dequeuedView
            annotationView?.annotation = pinAnnotation
        } else {
            annotationView = MKPinAnnotationView(annotation: pinAnnotation, reuseIdentifier: identifier)
        }
        
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            annotationView.detailCalloutAccessoryView = getCalloutLabel(withId: pinAnnotation.id, withName: pinAnnotation.name)
           
            let rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)

            annotationView.rightCalloutAccessoryView = rightButton as? UIView
        }
        
        // TODO: don't return nil
        return annotationView
    }
    
//     TODO: Implement
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {

        if let _ = view.rightCalloutAccessoryView as? UIButton {
            if let pinAnnotation = view.annotation as? PinAnnotation {
                // Segue to TableViewController
                performSegue(withIdentifier: "0", sender: pinAnnotation)
            }
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "0" )
        {
            let pinAnnotation = sender as? PinAnnotation
            dump(pinAnnotation?.id)
            
            let destination : UINavigationController = segue.destination as! UINavigationController
            let tableview : TableViewController = destination.topViewController as! TableViewController

            tableview.pinAnnotation = pinAnnotation
        } else if (segue.identifier == "1" )
        {
            
        }

    }
    
    
    // This function should not require modification
    private func getCalloutLabel(withId id: Id, withName name: String) -> UILabel {
        let label = UILabel()
        label.text = "Pin \(id): \(name)"
        return label
    }
}
