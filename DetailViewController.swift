//// DetailViewController.swift
//
import UIKit
//import Alamofire

class DetailViewController: UIViewController {
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}

	
	@IBAction func done(sender: AnyObject) {
		if((self.presentingViewController) != nil){
			self.dismissViewControllerAnimated(true, completion: nil)
			print("done")
		}
	}
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
