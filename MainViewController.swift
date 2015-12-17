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
class MainViewController: UIViewController {
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		// Toggle SideNavigationViewController.
		let img: UIImage? = UIImage(named: "ic_create_white")
		let fabButton: FabButton = FabButton()
		fabButton.setImage(img, forState: .Normal)
		fabButton.setImage(img, forState: .Highlighted)
		fabButton.addTarget(self, action: "handleFabButton", forControlEvents: .TouchUpInside)
		
		view.addSubview(fabButton)
		fabButton.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromBottomRight(view, child: fabButton, bottom: 16, right: 16)
		MaterialLayout.size(view, child: fabButton, width: 64, height: 64)
		
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
		var showLaunchScreen = false
		let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
		let fetchRequest = NSFetchRequest(entityName: "UserDetail")
		
		do {
			let results = try managedContext.executeFetchRequest(fetchRequest)
			if results.count > 0 {}
			
		}catch{
			
		}
		return showLaunchScreen
	}
	
}

