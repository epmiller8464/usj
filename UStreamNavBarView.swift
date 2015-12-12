//
//  UStreamNavBarView.swift
//  usj
//
//  Created by ghostmac on 12/12/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import UIKit
import MaterialKit
public class UStreamNavBarView: NavigationBarView {
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	//
	//	/**
	//	:name:	init
	//	*/
	public override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	
	convenience init() {
		self.init(frame: CGRectMake(MaterialTheme.navigationBarView.x, MaterialTheme.navigationBarView.y, MaterialTheme.navigationBarView.width, MaterialTheme.navigationBarView.height))
		
		
		
	}
	
	public override func prepareView() {
		super.prepareView()
		backgroundColor = MaterialColor.indigo.darken1
		statusBarStyle = .LightContent
//		titleLabelInsetsRef.bottom -= 0x04
//		contentInsetsRef = MaterialInsetsToValue(.None)

		let titleLabel: UILabel = UILabel()//frame: CGRectMake(15, 15, 60, 30))
		titleLabel.text = "UStream Justice"
		titleLabel.textAlignment = .Center
		titleLabel.textColor = MaterialColor.white
		titleLabel.font = RobotoFont.boldWithSize(14)
		let cancelButton: FlatButton = FlatButton()
		cancelButton.pulseColor = MaterialColor.white
		cancelButton.pulseFill = true
		cancelButton.pulseScale = false
		cancelButton.titleLabel?.font = RobotoFont.regularWithSize(12)
		cancelButton.setTitle("Cancel",  forState: .Normal);
		cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		prepareStaticProperties(titleLabel,  leftButtons: [cancelButton])
//		cancelButton.frame.size.height
//		leftButtonsInsetsRef = (top: 0, left: -4, bottom: 0, right: 0)
//		titleLabelInsetsRef = (top: 16, left: 0, bottom: 0, right: 0)
		var s2 = MaterialInsetsToValue(.Square2);
		s2.left = -4;
//		var x = (top: 16, left: 0, bottom: 0, right: 0)
		leftButtonsInsetsRef = s2;
		print("\(leftButtonsInsetsRef) , \(titleLabelInsetsRef) \(		cancelButton.frame.size.height)")
	}
	
	internal func prepareStaticProperties(titleLabel: UILabel?, detailLabel: UILabel? = nil, leftButtons: Array<UIButton>? = nil, rightButtons: Array<UIButton>? = nil) {
		self.titleLabel = titleLabel
		self.detailLabel = detailLabel
		self.leftButtons = leftButtons
		self.rightButtons = rightButtons
	}
	
	/*
	// Only override drawRect: if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func drawRect(rect: CGRect) {
	// Drawing code
	}
	*/
	
	
	
}
