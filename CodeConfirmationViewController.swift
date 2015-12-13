//
//  CodeConfirmationViewController.swift
//  usj
//
//  Created by ghostmac on 12/12/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import UIKit
import MaterialKit
class CodeConfirmationViewController: UIViewController,StaticStoryboardType {
 
	@IBOutlet weak var navigationBarView: UStreamNavBarView!
	@IBOutlet weak var cancelButton : FlatButton!
	@IBOutlet weak var continueButton : FlatButton!
	@IBOutlet weak var confirmCodeTextField :UITextField?
	
	var typeName : String {
		get{
			return "CodeConfirmationViewController"
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let border = CALayer()
		let width = CGFloat(1.0)
		let color = UIColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.2)
		border.borderColor = color.CGColor
		border.frame = CGRect(x: 0, y: (self.confirmCodeTextField?.frame.size.height)! - width, width:  (self.confirmCodeTextField?.frame.size.width)!, height: (self.confirmCodeTextField?.frame.size.height)!)
		border.borderWidth = width
		self.confirmCodeTextField?.layer.addSublayer(border)
		self.confirmCodeTextField?.layer.masksToBounds = true
		//		self.phoneNumberTextField
		self.continueButton.pulseColor = MaterialColor.white
		self.continueButton.pulseFill = true
		self.continueButton.pulseScale = false
		self.continueButton.backgroundColor = UIColor(red: 0.30, green: 0.64, blue: 0.75, alpha: 1)
		self.continueButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
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
				
		MaterialLayout.height(view, child: navigationBarView, height: 70)
	}
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	@IBAction func cancel(sender: AnyObject) {
		if((self.presentingViewController) != nil){
			self.dismissViewControllerAnimated(true, completion: nil)
			print("done")
		}
	}
}
