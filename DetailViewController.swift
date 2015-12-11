//// DetailViewController.swift
//
import UIKit
import CoreData
//import Alamofire
//
//@objc class AgePickerViewDataSource : NSObject, UIPickerViewDataSource{
//	var maxAge : Int = 100
//	var minAge : Int = 15
//	override init(){
//		super.init()
//	}
//
//	 @objc func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
//		return 1;
//	}
//
//	  @objc func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//
//		return self.maxAge - self.minAge;
//	}
//}

class DetailViewController: UIViewController,UITextFieldDelegate {
	
	@IBOutlet weak var fnTextField :UITextField?
	@IBOutlet weak var lnTextField :UITextField?
	@IBOutlet weak var emailTextField :UITextField?
	@IBOutlet weak var miTextField :UITextField?
	@IBOutlet weak var ageTextField :UITextField?
	//	@IBOutlet weak var agePicker : UIPickerView?
	var userDetail = [NSManagedObject]();
	var map : Dictionary<Int,String>?
	
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
		border.frame = CGRect(x: 0, y: (self.miTextField?.frame.size.height)! - width, width:  (self.miTextField?.frame.size.width)!, height: (self.miTextField?.frame.size.height)!)
		border.borderWidth = width
		self.miTextField?.layer.addSublayer(border)
		self.miTextField?.layer.masksToBounds = true
		
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
		map![fnTextField!.hash] = "fn"
		map![lnTextField!.hash] = "ln"
		map![miTextField!.hash] = "mi"
		map![emailTextField!.hash] = "email"
		map![ageTextField!.hash] = "age"
		// fnTextField?.hash,
		//lnTextField :UITextField?
		//emailTextField :UITextField?
		//miTextField :UITextField?
		// ageTextField :UITextField?
		
		
	}
	
	
	@IBAction func done(sender: AnyObject) {
		if((self.presentingViewController) != nil){
			self.dismissViewControllerAnimated(true, completion: nil)
			print("done")
		}
	}
	
	@IBAction func edit(sender: AnyObject) {
		
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
		//		print(textField);
		
		///TODO: use hash to ID which textfield is calling
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder();
		
		return true;
	}
	
	//
	//#pragma mark - Private
	//
	func textFieldDidChange(sender: AnyObject) {
		
	}
	
	//	let saveAction = UIAlertAction(title: "Save",style: .Default, handler: { (action:UIAlertAction) -> Void in
	//
	//	let textField = alert.textFields!.first
	//	self.saveName(textField!.text!)
	//	self.tableView.reloadData()
	//	})
	
	func saveUserDetails(key: String,value:String) {
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext
		let entity =  NSEntityDescription.entityForName("UserDetail",inManagedObjectContext:managedContext)
		let user = NSManagedObject(entity: entity!,insertIntoManagedObjectContext: managedContext)
		user.setValue(value, forKey: key)
		
		do {
			try managedContext.save()
			userDetail.append(user)
		}
		catch let error as NSError  {
			print("Could not save \(error), \(error.userInfo)")
		}
	}
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



