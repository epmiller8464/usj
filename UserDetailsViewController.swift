//
//  UserDetailsViewController.swift
//  usj
//
//  Created by ghostmac on 12/12/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import UIKit
import MaterialKit
class UserDetailsViewController: UIViewController,StaticStoryboardType {

	@IBOutlet weak var continueButton : FlatButton!
	@IBOutlet weak var lastNameTextField :UITextField?
	@IBOutlet weak var firstNameTextField :UITextField?
	@IBOutlet weak var ageTextField :UITextField?
	var userDetail : UserDetail?

	override func viewDidLoad() {
		super.viewDidLoad()
		var border = CALayer()
		let width = CGFloat(1.0)
		let color = UIColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.2)
		border.borderColor = color.CGColor
		border.frame = CGRect(x: 0, y: (self.firstNameTextField?.frame.size.height)! - width, width:  (self.firstNameTextField?.frame.size.width)!, height: (self.firstNameTextField?.frame.size.height)!)
		border.borderWidth = width
		self.firstNameTextField?.layer.addSublayer(border)
		self.firstNameTextField?.layer.masksToBounds = true
		
		border = CALayer()
		border.borderColor = color.CGColor
		border.frame = CGRect(x: 0, y: (self.lastNameTextField?.frame.size.height)! - width, width:  (self.lastNameTextField?.frame.size.width)!, height: (self.lastNameTextField?.frame.size.height)!)
		border.borderWidth = width
		self.lastNameTextField?.layer.addSublayer(border)
		self.lastNameTextField?.layer.masksToBounds = true
		
		border = CALayer()
		border.borderColor = color.CGColor
		border.frame = CGRect(x: 0, y: (self.ageTextField?.frame.size.height)! - width, width:  (self.ageTextField?.frame.size.width)!, height: (self.ageTextField?.frame.size.height)!)
		border.borderWidth = width
		self.ageTextField?.layer.addSublayer(border)
		self.ageTextField?.layer.masksToBounds = true
		
		self.continueButton.pulseColor = MaterialColor.white
		self.continueButton.pulseFill = true
		self.continueButton.pulseScale = false
		self.continueButton.backgroundColor = UIColor(red: 0.30, green: 0.64, blue: 0.75, alpha: 1)
		self.continueButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
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
	@IBAction func done(sender: AnyObject) {
		if((self.presentingViewController) != nil){
			self.dismissViewControllerAnimated(true, completion: nil)
			print("done")
		}
	}
}
