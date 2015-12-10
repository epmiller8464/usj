//
//  MenuViewController.swift
//  usj
//
//  Created by ghostmac on 12/9/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class MenuViewController: UITableViewController {
	
	@IBOutlet weak var titleImageView: UIImageView!
	
	var detailViewController: DetailViewController? = nil
	var objects = NSMutableArray()
	
	// MARK: - View Lifecycle
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		navigationItem.titleView = titleImageView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let split = splitViewController {
			let controllers = split.viewControllers
			
			if let
				navigationController = controllers.last as? UINavigationController,
				topViewController = navigationController.topViewController as? DetailViewController
			{
				detailViewController = topViewController
			}
		}
	}
	
	// MARK: - UIStoryboardSegue
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let
			navigationController = segue.destinationViewController as? UINavigationController,
			detailViewController = navigationController.topViewController as? DetailViewController
		{
			func requestForSegue(segue: UIStoryboardSegue) -> Request? {
				switch segue.identifier! {
				case "GET":
					detailViewController.segueIdentifier = "GET"
					return Alamofire.request(.GET, "https://httpbin.org/get")
				case "POST":
					detailViewController.segueIdentifier = "POST"
					return Alamofire.request(.POST, "https://httpbin.org/post")
				case "PUT":
					detailViewController.segueIdentifier = "PUT"
					return Alamofire.request(.PUT, "https://httpbin.org/put")
				case "DELETE":
					detailViewController.segueIdentifier = "DELETE"
					return Alamofire.request(.DELETE, "https://httpbin.org/delete")
				case "DOWNLOAD":
					detailViewController.segueIdentifier = "DOWNLOAD"
					let destination = Alamofire.Request.suggestedDownloadDestination(
						directory: .CachesDirectory,
						domain: .UserDomainMask
					)
					return Alamofire.download(.GET, "https://httpbin.org/stream/1", destination: destination)
				default:
					return nil
				}
			}
			
			if let request = requestForSegue(segue) {
				detailViewController.request = request
			}
		}
	}
}

