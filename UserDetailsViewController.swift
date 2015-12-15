//
//  UserDetailsViewController.swift
//  usj
//
//  Created by ghostmac on 12/12/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController,StaticStoryboardType {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	var typeName : String {
		get{
			return "UserDetailsViewController"
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
//	var last : UINavigationController
	//In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		//	 Get the new view controller using segue.destinationViewController.
		var nextController = segue.destinationViewController;
		//Pass the selected object to the new view controller.
	}

	@IBAction func cancel(sender: AnyObject) {
		if((self.presentingViewController) != nil){
			self.dismissViewControllerAnimated(true, completion: nil)
			print("done")
		}
	}
}
