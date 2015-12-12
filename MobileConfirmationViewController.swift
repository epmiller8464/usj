//
//  MobileConfirmationViewController.swift
//  usj
//
//  Created by ghostmac on 12/12/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import UIKit
import MaterialKit

class MobileConfirmationViewController: UIViewController {
	@IBOutlet weak var navigationBarView: NavigationBarView!
	@IBOutlet weak var cancelButton : FlatButton!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Examples of using NavigationBarView
		prepareNavigationBarViewExample()
	}
	
	/**
	:name:	prepareView
	:description: General preparation statements.
	*/
	private func prepareView() {
//		view.backgroundColor = MaterialColor.white
	}
	
	/**
	:name:	prepareNavigationBarViewExample
	:description:	General usage example.
	*/
	func prepareNavigationBarViewExample() {
		
		// Stylize.
		navigationBarView.backgroundColor = MaterialColor.indigo.darken1
		
		// To lighten the status bar add the "View controller-based status bar appearance = NO"
		// to your info.plist file and set the following property.
		navigationBarView.statusBarStyle = .LightContent
		
		// Title label.
		let titleLabel: UILabel = UILabel()
		titleLabel.text = "UStream Justice"
		titleLabel.textAlignment = .Center
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.regularWithSize(20)
		navigationBarView.titleLabel = titleLabel
		navigationBarView.titleLabelInsetsRef.left = 64
		
		// Detail label
//		let detailLabel: UILabel = UILabel()
//		detailLabel.text = "UStream Justice"
//		detailLabel.textAlignment = .Left
//		detailLabel.textColor = MaterialColor.white
//		detailLabel.font = RobotoFont.regularWithSize(12)
//		navigationBarView.detailLabel = detailLabel
//		navigationBarView.detailLabelInsetsRef.left = 64
//		
		// Menu button.
//		let cancelLabel: UILabel = UILabel()
//		cancelLabel.text = "Cancel"
//		cancelLabel.textAlignment = .Left
//		cancelLabel.textColor = MaterialColor.white
//		cancelLabel.font = RobotoFont.regularWithSize(12)
//		let cancelButton: FlatButton = FlatButton(frame: CGRectMake(107, 107, 200, 65))
//		cancelButton.pulseColor = MaterialColor.white
//		cancelButton.pulseFill = true
//		cancelButton.pulseScale = false
//		cancelButton.setTitle("Cancel",  forState: .Normal);
//		btn1.setImage(img1, forState: .Normal)
//		btn1.setImage(img1, forState: .Highlighted)
		
		// Star button.
//		let img2: UIImage? = UIImage(named: "ic_star_white")
//		let btn2: FlatButton = FlatButton()
//		btn2.pulseColor = MaterialColor.white
//		btn2.pulseFill = true
//		btn2.pulseScale = false
//		btn2.setImage(img2, forState: .Normal)
//		btn2.setImage(img2, forState: .Highlighted)
//		
//		// Search button.
//		let img3: UIImage? = UIImage(named: "ic_search_white")
//		let btn3: FlatButton = FlatButton()
//		btn3.pulseColor = MaterialColor.white
//		btn3.pulseFill = true
//		btn3.pulseScale = false
//		btn3.setImage(img3, forState: .Normal)
//		btn3.setImage(img3, forState: .Highlighted)
		
		// Add buttons to left side.
//		navigationBarView.leftButtons = [cancelButton]
		
		// Add buttons to right side.
//		navigationBarView.rightButtons = [btn2, btn3]
		
		MaterialLayout.height(view, child: navigationBarView, height: 70)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
