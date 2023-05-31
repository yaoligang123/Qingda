//
//  MapViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/11.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var data: StoreData? = nil
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAnnotaionToMapView()
    }

    func addAnnotaionToMapView() {
        if let data = data,
           let latitude = Double(data.latitude),
           let longitude = Double(data.longitude),
           latitude >= -90 && latitude <= 90,
           longitude >= -180 && longitude <= 180
        {
            let coorinate2D = CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
            
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = coorinate2D
            pointAnnotation.title = data.name
            pointAnnotation.subtitle = data.businessHours
            self.mapView.addAnnotation(pointAnnotation)
            
            let span = MKCoordinateSpan(latitudeDelta:0.005, longitudeDelta:0.005)
            let region = MKCoordinateRegion(center: coorinate2D, span: span)
            self.mapView.setRegion(region, animated:true)
        }
    }
}
