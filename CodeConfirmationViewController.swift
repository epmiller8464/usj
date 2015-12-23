//
//  CodeConfirmationViewController.swift
//  usj
//
//  Created by ghostmac on 12/12/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import UIKit
import MaterialKit
import CoreData
class CodeConfirmationViewController: UIViewController {
 
	@IBOutlet weak var navigationBarView: UStreamNavBarView!
	@IBOutlet weak var cancelButton : FlatButton!
	@IBOutlet weak var continueButton : FlatButton!
	@IBOutlet weak var confirmCodeTextField :UITextField?
	var userDetail : UserDetail?
	let dataStore: DataStore = DataStore.sharedInstance
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

		self.continueButton.pulseColor = MaterialColor.white
		self.continueButton.pulseFill = true
		self.continueButton.pulseScale = false
		self.continueButton.backgroundColor = UIColor(red: 0.30, green: 0.64, blue: 0.75, alpha: 1)
		self.continueButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		userDetail = dataStore.getCurrentUser()

	}
	
	//In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		//	 Get the new view controller using segue.destinationViewController.
//		var nextController = segue.destinationViewController;
		//Pass the selected object to the new view controller.
//		cancel(self);
	}
	override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
		var performSegue = false
		if identifier == "coreDetailsSegue"{
			if !isNilOrEmpty(confirmCodeTextField!.text){
				performSegue = true//isValidCode(confirmCodeTextField!.text!)
				//TODO: temp
			}
		}
		
		if !performSegue{
			let alert = UIAlertView()
			alert.title = "Invalid Code"
			alert.message = "Please Enter a valid code"
			alert.addButtonWithTitle("Ok")
			alert.show()
		}
		
		return performSegue
	}
	
	func isValidCode(code:String) -> Bool{
		return true
	}
//	override
	
	@IBAction func cancel(sender: AnyObject) {
		if((self.presentingViewController) != nil){
			self.dismissViewControllerAnimated(true, completion: nil)
			print("done")
		}
	}
	
	@IBAction func confirm(sender: AnyObject) {
		print("confirming code");
		var code = confirmCodeTextField?.text;
		//send code to server and wait for a response before segue

//		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//		let managedContext = appDelegate.managedObjectContext
		
		userDetail!.setValue(1, forKey: "verified")
		dataStore.saveContext()
	}
	//
	//MARK: - UITextFieldDelegate
	//
	
//	func textFieldDidBeginEditing(textField: UITextField) {
//		//		print(textField.hash);
//		//		print(self.ageTextField?.hash);
//	}
//	func textFieldDidEndEditing(textField:UITextField) -> Void {
//		//		print(textField);
//		///TODO: use hash to ID which textfield is calling
//		saveUserDetails("phone",value: textField.text!);
//	}
//	
//	func textFieldShouldReturn(textField: UITextField) -> Bool {
//		textField.resignFirstResponder();
//		
//		return true;
//	}
//	
//	//
//	//#pragma mark - Private
//	//
//	@IBAction func textFieldDidChange(sender: AnyObject) {
//		print(sender);
//	}
	
//	func saveUserDetails(key: String,value:String) {
//		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//		let managedContext = appDelegate.managedObjectContext
//		
//		userDetail!.setValue(value, forKey: key)
//		
//		do {
//			print(userDetail?.objectID.description)
//			try managedContext.save()
//		}
//		catch  {
//			print("Could not save \(error)")
//		}
//		
//	}

}
