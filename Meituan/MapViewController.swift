//
//  MapViewController.swift
//  Meituan
//
//  Created by baby on 15/10/17.
//  Copyright © 2015年 baby. All rights reserved.
//

import UIKit
import MapKit

private let dealanno = "dealanno"

class MapViewController: UIViewController,MKMapViewDelegate,DPRequestDelegate{
    
    lazy var geocode = CLGeocoder()
    @IBOutlet weak var mapView: MKMapView!
    var city:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.userTrackingMode = .Follow
        
    }
    
    //MARK: - Map的代理方法
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        geocode.reverseGeocodeLocation(userLocation.location!) { (marks:[CLPlacemark]?, error:NSError?) -> Void in
            if error != nil || marks == nil {return}
            let mark = marks?.first
            self.city = mark?.locality ?? mark?.addressDictionary!["state"] as! String
            self.city = self.city!.substringToIndex(self.city!.endIndex.advancedBy(-1))//最后一个Index-1
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let dpapi = DPAPI()
        let params = NSMutableDictionary()
        if let city = city {
            params["city"] = city
            params["latitude"] = mapView.centerCoordinate.latitude
            params["longitude"] = mapView.centerCoordinate.longitude
            params["radius"] = 5000
            dpapi.requestWithURL("v1/deal/find_deals", params: params, delegate: self)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !annotation.isKindOfClass(DealAnnotation) {return nil}
        let annotation = annotation as! DealAnnotation
        guard let icon = annotation.icon else {return nil}
        var annoView = mapView.dequeueReusableAnnotationViewWithIdentifier(dealanno)
        if annoView == nil{
            annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: dealanno)
        }
        annoView!.image = UIImage(named: icon)
        annoView!.canShowCallout = true
        return annoView
    }
    
    //MARK: - 请求数据完成的回调
    func request(request: DPRequest!, didFailWithError error: NSError!) {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = .Text
        hud.labelText = "数据请求错误，请稍后再试"
        hud.hide(true, afterDelay: 2)
       
    }
    
    func request(request: DPRequest!, didFinishLoadingWithResult result: AnyObject!) {
        
        let deals = DealsModel.objectArrayWithKeyValuesArray(result["deals"])
        for deal in deals {
            let deal = deal as! DealsModel
            let category = MetaDataTool.categoryWithDeal(deal)
            for business in deal.businesses{
                let business = business as! BusinessModel
                let coordinate = CLLocationCoordinate2DMake(business.latitude.doubleValue, business.longitude.doubleValue)
                let title = business.name
                let subtitle = deal.title
                let anno = DealAnnotation(coordinate: coordinate, title: title, subtitle: subtitle)
                if let category = category{
                    anno.icon = category.map_icon
                }
                let annos = mapView.annotations as NSArray
                if annos.containsObject(anno) {break}
                mapView.addAnnotation(anno)
            }
        }
    }

    
    @IBAction func backButtonClick(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func goToCurrentLocation(sender: UIButton) {
        mapView.setUserTrackingMode(.Follow, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
