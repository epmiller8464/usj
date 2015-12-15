//
//  CoreDetailsViewController.swift
//  usj
//
//  Created by ghostmac on 12/12/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import UIKit
import MaterialKit
class CoreDetailsViewController: UIViewController,StaticStoryboardType {

//	@IBOutlet weak var navigationBarView: UStreamNavBarView!
//	@IBOutlet weak var cancelButton : FlatButton!
	@IBOutlet weak var continueButton : FlatButton!
	@IBOutlet weak var emailTextField :UITextField?
	@IBOutlet weak var usernameTextField :UITextField?
	
	var typeName : String {
		
		get{
			return "CoreDetailsViewController"
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		var border = CALayer()
		var width = CGFloat(1.0)
		let color = UIColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.2)
		border.borderColor = color.CGColor
		border.frame = CGRect(x: 0, y: (self.emailTextField?.frame.size.height)! - width, width:  (self.emailTextField?.frame.size.width)!, height: (self.emailTextField?.frame.size.height)!)
		border.borderWidth = width
		self.emailTextField?.layer.addSublayer(border)
		self.emailTextField?.layer.masksToBounds = true
		
		border = CALayer()
		border.borderColor = color.CGColor
		border.frame = CGRect(x: 0, y: (self.usernameTextField?.frame.size.height)! - width, width:  (self.usernameTextField?.frame.size.width)!, height: (self.usernameTextField?.frame.size.height)!)
		border.borderWidth = width
		self.usernameTextField?.layer.addSublayer(border)
		self.usernameTextField?.layer.masksToBounds = true
		
		self.continueButton.pulseColor = MaterialColor.white
		self.continueButton.pulseFill = true
		self.continueButton.pulseScale = false
		self.continueButton.backgroundColor = UIColor(red: 0.30, green: 0.64, blue: 0.75, alpha: 1)
		self.continueButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)

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
