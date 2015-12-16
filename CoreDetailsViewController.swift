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

//	@IBOutlet weak var navigationBarView: UStreamNavBarView!
//	@IBOutlet weak var cancelButton : FlatButton!
	@IBOutlet weak var continueButton : FlatButton!
	@IBOutlet weak var emailTextField :UITextField?
	@IBOutlet weak var usernameTextField :UITextField?
	var userDetail : UserDetail?
var map : Dictionary<Int,String>?
	var typeName : String {
		
		get{
			return "CoreDetailsViewController"
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		var border = CALayer()
		var width = CGFloat(1.0)
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
		
		map = Dictionary<Int,String>()//((fnTextField?.hash)!,""));
		map![emailTextField!.hash] = "email"
		map![usernameTextField!.hash] = "username"
		
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		let fetchRequest = NSFetchRequest(entityName: "UserDetail")
		
		do {
			let results = try managedContext.executeFetchRequest(fetchRequest)
			
			if results.count > 0{
				userDetail = (results[0] as? NSManagedObject) as? UserDetail
				self.emailTextField?.text =  userDetail?.email
				self.usernameTextField?.text = userDetail?.username
//				self.emailTextField?.text =  userDetail?.valueForKey("email") as? String
//				self.usernameTextField?.text = userDetail?.valueForKey("username") as? String
			}else{
				let entity =  NSEntityDescription.entityForName("UserDetail",inManagedObjectContext:managedContext)
				userDetail = NSManagedObject(entity: entity!,insertIntoManagedObjectContext: managedContext) as? UserDetail
			}
			
		}catch{
			print(error);
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func next(sender: AnyObject) {
		
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext

		userDetail!.setValue(emailTextField!.text, forKey: "email")
		userDetail!.setValue(usernameTextField!.text, forKey: "username")
		do {
			print(userDetail?.objectID.description)
			try managedContext.save()
		}
		catch  {
			print("Could not save \(error)")
		}
//		
//		if((self.presentingViewController) != nil){
//			self.dismissViewControllerAnimated(false, completion: nil)
//			print("done")
//		}
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
			print(userDetail?.objectID.description)
			try managedContext.save()
		}
		catch  {
			print("Could not save \(error)")
		}
		
	}

}
