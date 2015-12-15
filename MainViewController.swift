//
//  ViewController.swift
//  usj
//
//  Created by ghostmac on 12/8/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import UIKit
import MaterialKit

class MainViewController: UIViewController {

	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		// Toggle SideNavigationViewController.
		let img: UIImage? = UIImage(named: "ic_create_white")
		let fabButton: FabButton = FabButton()
		fabButton.setImage(img, forState: .Normal)
		fabButton.setImage(img, forState: .Highlighted)
		fabButton.addTarget(self, action: "handleFabButton", forControlEvents: .TouchUpInside)
		
		view.addSubview(fabButton)
		fabButton.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromBottomRight(view, child: fabButton, bottom: 16, right: 16)
		MaterialLayout.size(view, child: fabButton, width: 64, height: 64)

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func handleFabButton() {
//		sideNavigationViewController?.toggle()

		var navController = self.storyboard!.instantiateViewControllerWithIdentifier("LaunchNavController") as! UINavigationController
//		navController.navigationBar//title = "UStream Justice";
//		navController.navigatio
	self.presentViewController(navController, animated: true) { () -> Void in
		print("handleFabButton")
		}

//		showViewController(vc, sender: self)
//		let secondController: SecondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SecondViewController") as! SecondViewController
//		secondController.data = "Text from superclass"
//		//who is it delegate
//		secondController.delegate = self
//		//we do push to navigate
//		self.navigationController?.pushViewController(secondController,
//			animated: true)

	}


}

