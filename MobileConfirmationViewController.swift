//
//  MobileConfirmationViewController.swift
//  usj
//
//  Created by ghostmac on 12/12/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import UIKit
import MaterialKit

class MobileConfirmationViewController: UIViewController , StaticStoryboardType{
	
	@IBOutlet weak var navigationBarView: UStreamNavBarView!
	@IBOutlet weak var cancelButton : FlatButton!
	@IBOutlet weak var sendConfirmCodeButton : FlatButton!
	@IBOutlet weak var phoneNumberTextField :UITextField?
	
	var typeName : String {
		get{
			return "MobileConfirmationViewController"
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let border = CALayer()
		let width = CGFloat(1.0)
		let color = UIColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.2)
		border.borderColor = color.CGColor
		border.frame = CGRect(x: 0, y: (self.phoneNumberTextField?.frame.size.height)! - width, width:  (self.phoneNumberTextField?.frame.size.width)!, height: (self.phoneNumberTextField?.frame.size.height)!)
		border.borderWidth = width
		self.phoneNumberTextField?.layer.addSublayer(border)
		self.phoneNumberTextField?.layer.masksToBounds = true
//		self.phoneNumberTextField
		self.sendConfirmCodeButton.pulseColor = MaterialColor.white
		self.sendConfirmCodeButton.pulseFill = true
		self.sendConfirmCodeButton.pulseScale = false
		self.sendConfirmCodeButton.backgroundColor = UIColor(red: 0.30, green: 0.64, blue: 0.75, alpha: 1)
		self.sendConfirmCodeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		prepareNavigationBarView()
	}
	
	/**
	:name:	prepareView
	:description: General preparation statements.
	*/
	private func prepareView() {
		//		view.backgroundColor = MaterialColor.white
	}
	
	/**
	:name:	prepareNavigationBarViewExample
	:description:	General usage example.
	*/
	func prepareNavigationBarView() {
		
		// Stylize.
		//		navigationBarView.backgroundColor = MaterialColor.indigo.darken1
		//
		//		// To lighten the status bar add the "View controller-based status bar appearance = NO"
		//		// to your info.plist file and set the following property.
		//		navigationBarView.statusBarStyle = .LightContent
		//
		//		// Title label.
		//		let titleLabel: UILabel = UILabel(frame: CGRectMake(15, 15, 60, 30))
		//		titleLabel.text = "UStream Justice"
		//		titleLabel.textAlignment = .Center
		//		titleLabel.textColor = MaterialColor.white
		//		titleLabel.font = RobotoFont.regularWithSize(12)
		//		navigationBarView.titleLabel = titleLabel
		////		navigationBarView.titleLabelInsetsRef.left = 64
		//
		//		let cancelButton: FlatButton = FlatButton()
		//		cancelButton.pulseColor = MaterialColor.white
		//		cancelButton.pulseFill = true
		//		cancelButton.pulseScale = false
		//		cancelButton.titleLabel?.font = RobotoFont.boldWithSize(12)
		//		cancelButton.setTitle("Cancel",  forState: .Normal);
		//		navigationBarView.leftButtonsInsets = MaterialInsets.Square2
		
		// Add buttons to left side.
		//		navigationBarView.leftButtons = [cancelButton]
		
		// Add buttons to right side.
		//		navigationBarView.rightButtons = [btn2, btn3]
		
		MaterialLayout.height(view, child: navigationBarView, height: 70)
	}
	@IBAction func cancel(sender: AnyObject) {
		if((self.presentingViewController) != nil){
			self.dismissViewControllerAnimated(true, completion: nil)
			print("done")
		}
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
