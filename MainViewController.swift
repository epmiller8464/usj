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

public protocol MainViewControllerProtocol {
	func applicationWillResignActive(application: UIApplication) -> Void;
}


class MainViewController: UIViewController , MainViewDelegate, MainViewControllerProtocol {
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let mainView = MainView(frame: CGRectZero);
		mainView.delegate = self;
		self.view = mainView;
		// Do any additional setup after loading the view, typically from a nib.
		// Toggle SideNavigationViewController.
//		let img: UIImage? = UIImage(named: "ic_create_white")
//		let fabButton: FabButton = FabButton()
//		fabButton.setImage(img, forState: .Normal)
//		fabButton.setImage(img, forState: .Highlighted)
//		fabButton.addTarget(self, action: "handleFabButton", forControlEvents: .TouchUpInside)
//		
//		view.addSubview(fabButton)
//		fabButton.translatesAutoresizingMaskIntoConstraints = false
//		MaterialLayout.alignFromBottomRight(view, child: fabButton, bottom: 16, right: 16)
//		MaterialLayout.size(view, child: fabButton, width: 64, height: 64)
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func handleFabButton() {
//		sideNavigationViewController?.toggle()
		launchOnboardingView()
		
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
	
	public func mainView(mainView: MainView, didInputRoom room: String) {
		
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
	
	public func applicationWillResignActive(application: UIApplication) {
		self.dismissViewControllerAnimated(false, completion: nil);
	}
	
	func showAlertWithMessage(message:NSString){
		let alertView = UIAlertView(title: nil, message: message as String, delegate: nil, cancelButtonTitle: "Ok");
		alertView.show();
	}
}

