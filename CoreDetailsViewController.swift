//
//  CoreDetailsViewController.swift
//  usj
//
//  Created by ghostmac on 12/12/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import UIKit
import CoreData
import MaterialKit
class CoreDetailsViewController: UIViewController,UITextFieldDelegate {
	let dataStore: DataStore = DataStore.sharedInstance
	var userDetail : UserDetail?
	@IBOutlet weak var continueButton : FlatButton!
	@IBOutlet weak var emailTextField :UITextField?
	@IBOutlet weak var usernameTextField :UITextField?
	
	var map : Dictionary<Int,String>?
	var typeName : String {
		
		get{
			return "CoreDetailsViewController"
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var border = CALayer()
		let width = CGFloat(1.0)
		let color = UIColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.2)
		border.borderColor = color.CGColor
		border.frame = CGRect(x: 0, y: (self.emailTextField?.frame.size.height)! - width, width:  (self.emailTextField?.frame.size.width)!, height: (self.emailTextField?.frame.size.height)!)
		border.borderWidth = width
		self.emailTextField?.layer.addSublayer(border)
		self.emailTextField?.layer.masksToBounds = true
		
		border = CALayer()
		border.borderColor = color.CGColor
		border.frame = CGRect(x: 0, y: (self.usernameTextField?.frame.size.height)! - width, width:  (self.usernameTextField?.frame.size.width)!, height: (self.usernameTextField?.frame.size.height)!)
		border.borderWidth = width
		self.usernameTextField?.layer.addSublayer(border)
		self.usernameTextField?.layer.masksToBounds = true
		
		self.continueButton.pulseColor = MaterialColor.white
		self.continueButton.pulseFill = true
		self.continueButton.pulseScale = false
		self.continueButton.backgroundColor = UIColor(red: 0.30, green: 0.64, blue: 0.75, alpha: 1)
		self.continueButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		self.emailTextField?.delegate = self
		self.usernameTextField?.delegate = self
		
		map = Dictionary<Int,String>()//((fnTextField?.hash)!,""));
		map![emailTextField!.hash] = "email"
		map![usernameTextField!.hash] = "username"
		
		 userDetail = dataStore.getCurrentUser()
		self.emailTextField?.text =  userDetail!.email
		self.usernameTextField?.text = userDetail!.username
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	//
	
	override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
		var performSegue = false
		if identifier == "userDetailSegue"{
			if !isNilOrEmpty(self.emailTextField?.text) && isValidEmail(self.emailTextField!.text!){
				if !isNilOrEmpty(self.usernameTextField?.text) && isValidUsernameCode(self.usernameTextField!.text!){
					performSegue = true
				}else{
					let alert = UIAlertView()
					alert.title = "Invalid Username"
					alert.message = "Please Enter a valid Username"
					alert.addButtonWithTitle("Ok")
					alert.show()
				}
			}else{
				let alert = UIAlertView()
				alert.title = "Invalid Email"
				alert.message = "Please Enter a valid email"
				alert.addButtonWithTitle("Ok")
				alert.show()
				
			}
		}
		return performSegue
	}
	
	func isValidEmail(code:String) -> Bool{
		return code =~ ".+\\@.+\\..+"
	}
	
	func isValidUsernameCode(code:String) -> Bool{
		return true
	}
	
	@IBAction func next(sender: AnyObject) {
		
//		let currentUser = dataStore.getCurrentUser()
		if emailTextField!.text != userDetail!.email {
			userDetail!.setValue(emailTextField!.text, forKey: "email")
		}
		
		if usernameTextField!.text != userDetail!.username {
			userDetail!.setValue(usernameTextField!.text, forKey: "username")
		}
		
		//		do {
		dataStore.saveContext()
		//		}
		//		catch  {
		//			print("Could not save \(error)")
		//		}
	}
	
	func textFieldDidBeginEditing(textField: UITextField) {
		//		print(textField.hash);
		//		print(self.ageTextField?.hash);
	}
	func textFieldDidEndEditing(textField:UITextField) -> Void {
		//		print(textField);
		///TODO: use hash to ID which textfield is calling

		userDetail!.setValue(textField.text!, forKey: map![textField.hash]!)
		dataStore.saveContext()
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder();
		
		return true;
	}
	//called when users tap out of textfield
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.view.endEditing(true)
	}
}
