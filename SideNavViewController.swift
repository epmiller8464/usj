//
//  SideNavViewController.swift
//  usj
//
//  Created by ghostmac on 12/8/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import Foundation
import UIKit

class SideNavViewController: UITableViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
//		if let
//			navigationController = segue.destinationViewController as? UINavigationController,
//			detailViewController = navigationController.topViewController as? DetailViewController
//		{
//			func requestForSegue(segue: UIStoryboardSegue) -> Request? {
//				switch segue.identifier! {
//				case "GET":
//					detailViewController.segueIdentifier = "GET"
//					return Alamofire.request(.GET, "https://httpbin.org/get")
//				case "POST":
//					detailViewController.segueIdentifier = "POST"
//					return Alamofire.request(.POST, "https://httpbin.org/post")
//				case "PUT":
//					detailViewController.segueIdentifier = "PUT"
//					return Alamofire.request(.PUT, "https://httpbin.org/put")
//				case "DELETE":
//					detailViewController.segueIdentifier = "DELETE"
//					return Alamofire.request(.DELETE, "https://httpbin.org/delete")
//				case "DOWNLOAD":
//					detailViewController.segueIdentifier = "DOWNLOAD"
//					let destination = Alamofire.Request.suggestedDownloadDestination(
//						directory: .CachesDirectory,
//						domain: .UserDomainMask
//					)
//					return Alamofire.download(.GET, "https://httpbin.org/stream/1", destination: destination)
//				default:
//					return nil
//				}
//			}
//			
//			if let request = requestForSegue(segue) {
//				detailViewController.request = request
//			}
//		}
	}

}