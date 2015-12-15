//
//  MobileConfirmationViewController.swift
//  usj
//
//  Created by ghostmac on 12/12/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import UIKit
import MaterialKit
import CoreData
class MobileConfirmationViewController: UIViewController , UITextFieldDelegate{
	
	@IBOutlet weak var navigationBarView: UStreamNavBarView!
	@IBOutlet weak var sendConfirmCodeButton : FlatButton!
	@IBOutlet weak var phoneNumberTextField :UITextField?
	var userDetail : UserDetail?
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
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		let fetchRequest = NSFetchRequest(entityName: "UserDetail")
		
		do {
			let results = try managedContext.executeFetchRequest(fetchRequest)
			if results.count > 0{
				userDetail = (results[0] as? NSManagedObject) as? UserDetail
				phoneNumberTextField!.text = userDetail?.valueForKey("phoneNumber") as? String;
				
			}else{
				let entity =  NSEntityDescription.entityForName("UserDetail",inManagedObjectContext:managedContext)
				userDetail = NSManagedObject(entity: entity!,insertIntoManagedObjectContext: managedContext) as? UserDetail
			}
			
		}
		catch let e as NSError {
			print(e)
		}catch{
			
		}
	}
	
	
	@IBAction func cancel(sender: AnyObject) {
		if((self.presentingViewController) != nil){
			self.dismissViewControllerAnimated(true, completion: nil)
			print("done")
		}
	}

	
	//MARK: - Navigation
	
//	//In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		//Get the new view controller using segue.destinationViewController.
		var nextController = segue.destinationViewController;
		//Pass the selected object to the new view controller.
	}
	@IBAction func save(sender: AnyObject) {
		print("saving");
		saveUserDetails("phoneNumber",value: phoneNumberTextField!.text!);
	}
	//
	//MARK: - UITextFieldDelegate
	//
	
	func textFieldDidBeginEditing(textField: UITextField) {
		//		print(textField.hash);
		//		print(self.ageTextField?.hash);
	}
	func textFieldDidEndEditing(textField:UITextField) -> Void {
		//		print(textField);
		///TODO: use hash to ID which textfield is calling
		saveUserDetails("phoneNumber",value: textField.text!);
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
