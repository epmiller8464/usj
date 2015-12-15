//
//  CoreDetailsViewController.swift
//  usj
//
//  Created by ghostmac on 12/12/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import UIKit

class CoreDetailsViewController: UIViewController,StaticStoryboardType {

	var typeName : String {
		get{
			return "CoreDetailsViewController"
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	//In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		//	 Get the new view controller using segue.destinationViewController.
//		var nextController = segue.destinationViewController;
		//Pass the selected object to the new view controller.
	}
	override func viewWillDisappear(animated: Bool) {
//		self.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
	}
	
	
	@IBAction func cancel(sender: AnyObject) {
		if((self.presentingViewController) != nil){
			self.dismissViewControllerAnimated(false, completion: nil)
			print("done")
		}
	}
}
