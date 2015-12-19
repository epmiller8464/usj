//
//  UserDetailsViewController.swift
//  usj
//
//  Created by ghostmac on 12/12/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import UIKit
import MaterialKit
import CoreData
import Alamofire
class UserDetailsViewController: UIViewController,UITextFieldDelegate {
	@IBOutlet weak var activityIndicator : UIActivityIndicatorView?
	@IBOutlet weak var continueButton : FlatButton!
	@IBOutlet weak var lastNameTextField :UITextField?
	@IBOutlet weak var firstNameTextField :UITextField?
	@IBOutlet weak var ageTextField :UITextField?
	var userDetail : UserDetail?
	var map : Dictionary<Int,String>?
	
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
		
		self.lastNameTextField?.delegate = self
		self.firstNameTextField?.delegate = self
		self.ageTextField?.delegate = self
		map = Dictionary<Int,String>()//((fnTextField?.hash)!,""));
		map![firstNameTextField!.hash] = "firstName"
		map![lastNameTextField!.hash] = "lastName"
		map![ageTextField!.hash] = "age"
		
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		let fetchRequest = NSFetchRequest(entityName: "UserDetail")
		
		do {
			let results = try managedContext.executeFetchRequest(fetchRequest)
			
			if results.count > 0{
				userDetail = (results[0] as? NSManagedObject) as? UserDetail
				self.firstNameTextField?.text = userDetail?.firstName;
				self.lastNameTextField?.text = userDetail?.lastName;
				self.ageTextField?.text = userDetail?.age;
			}else{
				let entity =  NSEntityDescription.entityForName("UserDetail",inManagedObjectContext:managedContext)
				userDetail = NSManagedObject(entity: entity!,insertIntoManagedObjectContext: managedContext) as? UserDetail
			}
			
		}catch{
			print(error);
		}
		
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
	
	
	override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
		var performSegue = false
		//		if identifier == "userDetailSegue"{
		//			if !isNilOrEmpty(self.emailTextField?.text) && isValidEmail(self.emailTextField!.text!){
		//				if !isNilOrEmpty(self.self.usernameTextField?.text) && isValidEmail(self.self.usernameTextField!.text!){
		//					performSegue = true
		//				}else{
		//					let alert = UIAlertView()
		//					alert.title = "Invalid Username"
		//					alert.message = "Please Enter a valid Username"
		//					alert.addButtonWithTitle("Ok")
		//					alert.show()
		//				}
		//			}else{
		//				let alert = UIAlertView()
		//				alert.title = "Invalid Email"
		//				alert.message = "Please Enter a valid email"
		//				alert.addButtonWithTitle("Ok")
		//				alert.show()
		//
		//			}
		//		}
		return performSegue
	}
	
	var alert : UIAlertView?
	
	//	let a = { } //in print("ho")
	@IBAction func done(sender: AnyObject) {
		self.activityIndicator?.startAnimating()
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		
		userDetail!.setValue(firstNameTextField!.text, forKey: "firstName")
		userDetail!.setValue(lastNameTextField!.text, forKey: "lastName")
		userDetail!.setValue(ageTextField!.text, forKey: "age")
		let device = UIDevice.currentDevice();
		userDetail!.setValue(device.identifierForVendor!.description, forKey: "uuid")
		//		print(device.identifierForVendor!);
		
		do {
			if userDetail!.hasChanges{
				print(userDetail!)
				try managedContext.save()
			}
		}
		catch  {
			print("Could not save \(error)")
		}
		
		let data = self.userDetail!.toDict()
		print(data)
		Alamofire.request(.POST, "http://192.168.0.6:9000/api/v1/users", parameters: data,encoding: .JSON)
			.responseObject{ (response: Response<UserDetailMap, NSError>) in
				if let mappedUser = response.result.value {
					print("JSON: \(mappedUser)")
					do {
						self.userDetail!.createDate = mappedUser.createDate! as NSNumber
						self.userDetail!.id = mappedUser._id
						
						if self.userDetail!.hasChanges{
							//								print(self.userDetail!)
							try managedContext.save()
							print("added new user!!!")
							self.activityIndicator?.stopAnimating()
							self.alert = UIAlertView()
							self.alert!.title = "Account Added"
							self.alert!.message = "Please Enter a valid code"
							//alert.addButtonWithTitle("Ok")
							//									alert.userActivity
							self.alert!.show()
							dispatch_after(2000,dispatch_get_main_queue() ,{ () -> Void in
								self.alert!.dismissWithClickedButtonIndex(0,animated: true)
							})
						}
					}
					catch  {
						print("Could not save \(error)")
					}
				}
				if((self.presentingViewController) != nil){
					self.dismissViewControllerAnimated(true, completion: nil)
					print("done")
				}
		}

		print("leaving")
	}
	
	func textFieldDidBeginEditing(textField: UITextField) {
		//		print(textField.hash);
		//		print(self.ageTextField?.hash);
	}
	func textFieldDidEndEditing(textField:UITextField) -> Void {
		//		print(textField);
		///TODO: use hash to ID which textfield is calling
		saveUserDetails(map![textField.hash]!,value: textField.text!);
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder();
		
		return true;
	}
	//called when users tap out of textfield
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.view.endEditing(true)
	}
	//
	//#pragma mark - Private
	//
	@IBAction func textFieldDidChange(sender: AnyObject) {
		print(sender);
	}
	
	func saveUserDetails(key: String,value:String) {
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		
		userDetail!.setValue(value, forKey: key)
		
		do {
			//			print(userDetail?.objectID.description)
			try managedContext.save()
		}
		catch  {
			print("Could not save \(error)")
		}
		
	}
	
}
