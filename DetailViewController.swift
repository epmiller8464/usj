//// DetailViewController.swift
//
import UIKit
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

class DetailViewController: UIViewController {//,UIPickerViewDelegate,UIPickerViewDataSource{
	
	@IBOutlet weak var fnTextField :UITextField?
	@IBOutlet weak var lnTextField :UITextField?
	@IBOutlet weak var emailTextField :UITextField?
	@IBOutlet weak var miTextField :UITextField?
	@IBOutlet weak var ageTextField :UITextField?
//	@IBOutlet weak var agePicker : UIPickerView?
	
	
//	init(){
//		super.init(;
//	}
//
//	required init?(coder aDecoder: NSCoder) {
//	    fatalError("init(coder:) has not been implemented")
//	}
	
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
	var maxAge : Int = 100
	var minAge : Int = 15
	var ageRange : [String] = [];
	
	func loadAgeRange() -> [String] {
		var range : [String] = [];
		for  index in minAge...maxAge{
		range.insert(index.description, atIndex: index - minAge)
		}
		return range;
	}
	
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
}
//class DetailViewController: UITableViewController {
//
//	enum Sections: Int {
//		case Headers, Body
//	}
//
//	var request: Alamofire.Request? {
//		didSet {
//			oldValue?.cancel()
//
//			title = request?.description
//			refreshControl?.endRefreshing()
//			headers.removeAll()
//			body = nil
//			elapsedTime = nil
//		}
//	}
//
//	var headers: [String: String] = [:]
//	var body: String?
//	var elapsedTime: NSTimeInterval?
//	var segueIdentifier: String?
//
//	static let numberFormatter: NSNumberFormatter = {
//		let formatter = NSNumberFormatter()
//		formatter.numberStyle = .DecimalStyle
//		return formatter
//	}()
//
//	// MARK: View Lifecycle
//
//	override func awakeFromNib() {
//		super.awakeFromNib()
//		refreshControl?.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
//
//	}
//
//	override func viewDidAppear(animated: Bool) {
//		super.viewDidAppear(animated)
//
//		refresh()
//	}
//
//	// MARK: IBActions
//
//	@IBAction func refresh() {
//		guard let request = request else {
//			return
//		}
//
//		refreshControl?.beginRefreshing()
//
//		let start = CACurrentMediaTime()
//		request.responseString { response in
//			let end = CACurrentMediaTime()
//			self.elapsedTime = end - start
//
//			if let response = response.response {
//				for (field, value) in response.allHeaderFields {
//					self.headers["\(field)"] = "\(value)"
//				}
//			}
//
//			if let segueIdentifier = self.segueIdentifier {
//				switch segueIdentifier {
//				case "GET", "POST", "PUT", "DELETE":
//					self.body = response.result.value
//				case "DOWNLOAD":
//					self.body = self.downloadedBodyString()
//				default:
//					break
//				}
//			}
//
//			self.tableView.reloadData()
//			self.refreshControl?.endRefreshing()
//		}
//	}
//
//	private func downloadedBodyString() -> String {
//		let fileManager = NSFileManager.defaultManager()
//		let cachesDirectory = fileManager.URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)[0]
//
//		do {
//			let contents = try fileManager.contentsOfDirectoryAtURL(
//				cachesDirectory,
//				includingPropertiesForKeys: nil,
//				options: .SkipsHiddenFiles
//			)
//
//			if let
//				fileURL = contents.first,
//				data = NSData(contentsOfURL: fileURL)
//			{
//				let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
//				let prettyData = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
//
//				if let prettyString = NSString(data: prettyData, encoding: NSUTF8StringEncoding) as? String {
//					try fileManager.removeItemAtURL(fileURL)
//					return prettyString
//				}
//			}
//		} catch {
//			// No-op
//		}
//
//		return ""
//	}
//}
//
//// MARK: - UITableViewDataSource
//
//extension DetailViewController {
//	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		switch Sections(rawValue: section)! {
//		case .Headers:
//			return headers.count
//		case .Body:
//			return body == nil ? 0 : 1
//		}
//	}
//
//	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//		switch Sections(rawValue: indexPath.section)! {
//		case .Headers:
//			let cell = tableView.dequeueReusableCellWithIdentifier("Header")!
//			let field = headers.keys.sort(<)[indexPath.row]
//			let value = headers[field]
//
//			cell.textLabel?.text = field
//			cell.detailTextLabel?.text = value
//
//			return cell
//		case .Body:
//			let cell = tableView.dequeueReusableCellWithIdentifier("Body")!
//			cell.textLabel?.text = body
//
//			return cell
//		}
//	}
//}
//
//// MARK: - UITableViewDelegate
//
//extension DetailViewController {
//	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//		return 2
//	}
//
//	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		if self.tableView(tableView, numberOfRowsInSection: section) == 0 {
//			return ""
//		}
//
//		switch Sections(rawValue: section)! {
//		case .Headers:
//			return "Headers"
//		case .Body:
//			return "Body"
//		}
//	}
//
//	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//		switch Sections(rawValue: indexPath.section)! {
//		case .Body:
//			return 300
//		default:
//			return tableView.rowHeight
//		}
//	}
//
//	override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//		if Sections(rawValue: section) == .Body, let elapsedTime = elapsedTime {
//			let elapsedTimeText = DetailViewController.numberFormatter.stringFromNumber(elapsedTime) ?? "???"
//			return "Elapsed Time: \(elapsedTimeText) sec"
//		}
//
//		return ""
//	}
//}
