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
	
	//	override func viewWillDisappear(animated: Bool) {
	//		//			self.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
	//		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	//		let managedContext = appDelegate.managedObjectContext
	//
	//		do {
	//
	//			try managedContext.save()
	//		}
	//		catch  {
	//			print("Could not save \(error)")
	//		}
	//		print("\(userDetail?.valueForKey("firstName"))\(userDetail?.valueForKey("lastName"))\(userDetail?.valueForKey("username"))\(userDetail?.valueForKey("email"))\(userDetail?.valueForKey("age"))");
	//
	//	}
	
	//	var last : UINavigationController
	//In a storyboard-based application, you will often want to do a little preparation before navigation
	//	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	//		//	 Get the new view controller using segue.destinationViewController.
	//		var nextController = segue.destinationViewController;
	//		//Pass the selected object to the new view controller.
	//	}
//	var request: Alamofire.Request? {
//		didSet {
//			oldValue?.cancel()
//			title = request?.description
//			activityIndicator?.stopAnimating()
//			headers.removeAll()
//			body = nil
//			elapsedTime = nil
//		}
//	}
	
	var headers: [String: String] = [:]
	var body: String?
	var elapsedTime: NSTimeInterval?
	var segueIdentifier: String?
	
//	static let numberFormatter: NSNumberFormatter = {
//		let formatter = NSNumberFormatter()
//		formatter.numberStyle = .DecimalStyle
//		return formatter
//	}()
	
	// MARK: View Lifecycle
	
//	override func awakeFromNib() {
//		super.awakeFromNib()
//		refreshControl?.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
//		
//	}
	
	@IBAction func done(sender: AnyObject) {
		
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
		
		
		do{
			let data = userDetail!.toDict()
			Alamofire.request(.POST, "http://localhost:9000/api/v1/users", parameters: data,encoding: .JSON)
				.responseObject{ (response: Response<UserDetailMap, NSError>) in
					if let mappedUser = response.result.value {
						print("JSON: \(mappedUser)")
						do {
							self.userDetail!.createDate = mappedUser.createDate! as NSNumber
							self.userDetail!.id = mappedUser._id
							
							if self.userDetail!.hasChanges{
//								print(self.userDetail!)
								try managedContext.save()
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
		}catch{
			
		}
		
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
