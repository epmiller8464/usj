//
//  ViewController.swift
//  usj
//
//  Created by ghostmac on 12/8/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import UIKit
import MaterialKit
import CoreData
import Mapbox
import MapKit
public protocol MainViewControllerProtocol {
	func applicationWillResignActive(application: UIApplication) -> Void;
}


class MainViewController: UIViewController , MainViewDelegate, MainViewControllerProtocol, MKMapViewDelegate {
	
	var map: MGLMapView!
	 var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.mapView = MKMapView(frame: CGRectZero);
		self.mapView.delegate = self;
		let center = CLLocationCoordinate2DMake(-37.813611, 144.963056)
		let span = MKCoordinateSpanMake(2, 2);
		self.mapView.region = MKCoordinateRegionMake(center, span)
		// creating an new annotation
		let annotation = MKPointAnnotation()
		annotation.coordinate = center
		annotation.title = "Melbourne"
		annotation.subtitle = "Victoria"
		// adding the annotation to the map
		self.mapView.addAnnotation(annotation);
		

		
		let mainView = MainView(frame: CGRectZero);
		mainView.delegate = self;
//		mainView.addSubview(self.mapView)
		self.view = self.mapView;
//				self.view = mainView;
		// Do any additional setup after loading the view, typically from a nib.
		// Toggle SideNavigationViewController.
		let img: UIImage? = UIImage(named: "ic_menu_white")
		let menuButton: FabButton = FabButton()
		menuButton.setImage(img, forState: .Normal)
		menuButton.setImage(img, forState: .Highlighted)
		menuButton.addTarget(self, action: "showSideMenu", forControlEvents: .TouchUpInside)
		
		view.addSubview(menuButton)
		menuButton.translatesAutoresizingMaskIntoConstraints = false
		//		MaterialLayout.alignFromBottomRight(view, child: menuButton, bottom: 16, right: 16)
		MaterialLayout.alignFromTopLeft(view, child: menuButton, top: 16, left: 16)
		MaterialLayout.size(view, child: menuButton, width: 64, height: 64)
		
		let v: UIImage? = UIImage(named: "unicorn")
		let fabButton: FabButton = FabButton()
		fabButton.setImage(v, forState: .Normal)
		fabButton.setImage(v, forState: .Highlighted)
		fabButton.addTarget(self, action: "showSideMenu", forControlEvents: .TouchUpInside)
		
		view.addSubview(fabButton)
		fabButton.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromBottomRight(view, child: fabButton, bottom: 16, right: 16)
		MaterialLayout.size(view, child: fabButton, width: 64, height: 64)
		
		//		map = MGLMapView(frame: view.bounds)
		//		map.setCenterCoordinate(CLLocationCoordinate2D(latitude: 40.712791, longitude: -73.997848),
		//			zoomLevel: 12,
		//			animated: false)
		//		view.addSubview(map)
			}
	
	//		Excerpt From: Jonathon Manning, Paris Buttfield-Addison, and Tim Nugent. “Swift Development with Cocoa.” iBooks.
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func streamJustice() {
		//		sideNavigationViewController?.toggle()
		launchOnboardingView()
		
	}
	
	func showSideMenu() {
		sideNavigationViewController?.toggle()
		//		launchOnboardingView()
	}
	
	func launchOnboardingView(){
		let navController = self.storyboard!.instantiateViewControllerWithIdentifier("LaunchNavController") as! UINavigationController
		self.presentViewController(navController, animated: true) { () -> Void in
			print("new user flow")
		}
	}
	
	func showOnboardingView() -> Bool{
		let showLaunchScreen = false
		let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
		let fetchRequest = NSFetchRequest(entityName: "UserDetail")
		
		do {
			let results = try managedContext.executeFetchRequest(fetchRequest)
			if results.count > 0 {}
			
		}catch{
			
		}
		return showLaunchScreen
	}
	//	func mainView(mainView: MainView, didCreateIncident incidentId: String) {
	//	}
	func mainView(mainView: MainView, didInputRoom room: String) {
		
		if room.isNilOrEmpty() {
			return;
		}
		
		let trimmedRoom = room.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
		
		let error = NSErrorPointer();// = nil;
		var regex: NSRegularExpression?
		do {
			regex = try NSRegularExpression(pattern: "\\w+", options: NSRegularExpressionOptions.CaseInsensitive)
		} catch let error1 as NSError {
			error.memory = error1
			regex = nil
		};
		
		if error != nil {
			self.showAlertWithMessage("Invalid room name.");
			return;
		}
		
		let matchRange : NSRange = regex!.rangeOfFirstMatchInString(trimmedRoom, options: NSMatchingOptions(), range: NSMakeRange(0,room.length));
		
		if matchRange.location == NSNotFound || matchRange.length != room.length {
			self.showAlertWithMessage("Invalid room name.");
			return;
		}
		
		let videoCallViewController = VideoCallViewController(room: trimmedRoom);
		videoCallViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve;
		self.presentViewController(videoCallViewController, animated: true, completion: nil);
	}
	
	func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
		var renderer = MKOverlayRenderer()
		if (overlay.isKindOfClass(MKCircle))
		{
			renderer = MKCircleRenderer(overlay: overlay)
			(renderer as! MKCircleRenderer).strokeColor = UIColor.greenColor()
			(renderer as! MKCircleRenderer).fillColor = UIColor(
				red: 0,
				green: 1.0,
				blue: 0,
				alpha: 0.5)
			
			//				return circleRenderer
		}
		return renderer
	}
	
	func applicationWillResignActive(application: UIApplication) {
		self.dismissViewControllerAnimated(false, completion: nil);
	}
	
	func showAlertWithMessage(message:NSString){
		let alertView = UIAlertView(title: nil, message: message as String, delegate: nil, cancelButtonTitle: "Ok");
		alertView.show();
	}
}

