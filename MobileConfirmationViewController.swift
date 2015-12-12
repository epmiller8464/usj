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
		prepareNavigationBarView()
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
	func prepareNavigationBarView() {
		
		// Stylize.
		navigationBarView.backgroundColor = MaterialColor.indigo.darken1
		
		// To lighten the status bar add the "View controller-based status bar appearance = NO"
		// to your info.plist file and set the following property.
		navigationBarView.statusBarStyle = .LightContent
		
		// Title label.
		let titleLabel: UILabel = UILabel(frame: CGRectMake(15, 15, 60, 30))
		titleLabel.text = "UStream Justice"
		titleLabel.textAlignment = .Center
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.regularWithSize(12)
		navigationBarView.titleLabel = titleLabel
//		navigationBarView.titleLabelInsetsRef.left = 64

		let cancelButton: FlatButton = FlatButton()
		cancelButton.pulseColor = MaterialColor.white
		cancelButton.pulseFill = true
		cancelButton.pulseScale = false
		cancelButton.titleLabel?.font = RobotoFont.boldWithSize(12)
		cancelButton.setTitle("Cancel",  forState: .Normal);
		navigationBarView.leftButtonsInsets = MaterialInsets.Square2

		
		// Add buttons to left side.
		navigationBarView.leftButtons = [cancelButton]
		
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
