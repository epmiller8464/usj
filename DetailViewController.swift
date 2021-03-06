//// DetailViewController.swift
//
import UIKit
import CoreData

class DetailViewController: UIViewController,UITextFieldDelegate {
	
	@IBOutlet weak var fnTextField :UITextField?
	@IBOutlet weak var lnTextField :UITextField?
	@IBOutlet weak var emailTextField :UITextField?
	@IBOutlet weak var usernameTextField :UITextField?
	@IBOutlet weak var ageTextField :UITextField?
	@IBOutlet weak var editSwitch : UISwitch?
	//	@IBOutlet weak var agePicker : UIPickerView?
	var userDetail : UserDetail?
	var map : Dictionary<Int,String>?
	let dataStore: DataStore = DataStore.sharedInstance
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//		fnTextField?.borderStyle
		var border = CALayer()
		let width = CGFloat(1.0)
		let color = UIColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.2)
		border.borderColor = color.CGColor
		border.frame = CGRect(x: 0, y: (self.fnTextField?.frame.size.height)! - width, width:  (self.fnTextField?.frame.size.width)!, height: (self.fnTextField?.frame.size.height)!)
		border.borderWidth = width
		self.fnTextField?.layer.addSublayer(border)
		self.fnTextField?.layer.masksToBounds = true
		
		border = CALayer()
		border.borderColor = color.CGColor
		border.frame = CGRect(x: 0, y: (self.usernameTextField?.frame.size.height)! - width, width:  (self.usernameTextField?.frame.size.width)!, height: (self.usernameTextField?.frame.size.height)!)
		border.borderWidth = width
		self.usernameTextField?.layer.addSublayer(border)
		self.usernameTextField?.layer.masksToBounds = true
		
		border = CALayer()
		border.borderColor = color.CGColor
		border.frame = CGRect(x: 0, y: (self.lnTextField?.frame.size.height)! - width, width:  (self.lnTextField?.frame.size.width)!, height: (self.lnTextField?.frame.size.height)!)
		border.borderWidth = width
		self.lnTextField?.layer.addSublayer(border)
		self.lnTextField?.layer.masksToBounds = true
		
		border = CALayer()
		border.borderColor = color.CGColor
		border.frame = CGRect(x: 0, y: (self.emailTextField?.frame.size.height)! - width, width:  (self.emailTextField?.frame.size.width)!, height: (self.emailTextField?.frame.size.height)!)
		border.borderWidth = width
		self.emailTextField?.layer.addSublayer(border)
		self.emailTextField?.layer.masksToBounds = true
		border = CALayer()
		border.borderColor = color.CGColor
		border.frame = CGRect(x: 0, y: (self.ageTextField?.frame.size.height)! - width, width:  (self.ageTextField?.frame.size.width)!, height: (self.ageTextField?.frame.size.height)!)
		border.borderWidth = width
		self.ageTextField?.layer.addSublayer(border)
		self.ageTextField?.layer.masksToBounds = true
		map = Dictionary<Int,String>()//((fnTextField?.hash)!,""));
		map![fnTextField!.hash] = "firstName"
		map![lnTextField!.hash] = "lastName"
		map![usernameTextField!.hash] = "username"
		map![emailTextField!.hash] = "email"
		map![ageTextField!.hash] = "age"
		
		userDetail = dataStore.getCurrentUser()
		fnTextField!.text = userDetail?.valueForKey("firstName") as? String;
		lnTextField!.text = userDetail?.valueForKey("lastName") as? String;
		usernameTextField!.text = userDetail?.valueForKey("username") as? String;
		emailTextField!.text = userDetail?.valueForKey("email") as? String;
		ageTextField!.text = userDetail?.valueForKey("age") as? String;
	}
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	@IBAction func done(sender: AnyObject) {
		if((self.presentingViewController) != nil){
			self.dismissViewControllerAnimated(true, completion: nil)
			print("done")
		}
	}
	
	@IBAction func toggleEdit(sender: UISwitch) {
		print(sender.on);
	}
	
	@IBAction func save(sender: AnyObject) {
		print("saving");
		
	}
	
	//
	//MARK: - UITextFieldDelegate
	//
	
	func textFieldDidBeginEditing(textField: UITextField) {
		//		print(textField.hash);
		//		print(self.ageTextField?.hash);
	}
	func textFieldDidEndEditing(textField:UITextField) -> Void {

		userDetail?.setValue(textField.text!, forKey: map![textField.hash]!)
		dataStore.saveContext()
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



/*




*/

//	var maxAge : Int = 100
//	var minAge : Int = 15
//	var ageRange : [String] = [];
//
//	func loadAgeRange() -> [String] {
//		var range : [String] = [];
//		for  index in minAge...maxAge{
//			range.insert(index.description, atIndex: index - minAge)
//		}
//		return range;
//	}

//	@objc func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
//		return 1;
//	}
//
//	@objc func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//
//		return self.ageRange.count;
//	}
//
//	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//		return self.ageRange[row]
//	}



