//
//  MainView.swift
//  webrtc
//
//  Created by ghostmac on 8/4/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//

import Foundation
import UIKit
import MaterialKit
import Fabric
//import Mapbox

// TODO(tkchin): retrieve status bar height dynamically.
let kStatusBarHeight : CGFloat = 20;
let kRoomTextButtonSize : CGFloat = 40;
let kRoomTextFieldHeight : CGFloat = 40;
let kRoomTextFieldMargin : CGFloat = 8;
let kAppLabelHeight : CGFloat = 20;

//class ARDRoomTextField;
protocol ARDRoomTextFieldDelegate{
	func roomTextField(roomTextField:ARDRoomTextField,didInputRoom room: NSString) -> Void;
}
//
//// Helper view that contains a text field and a clear button.
protocol ARDRoomTextFieldProtocol : class ,UITextFieldDelegate {
	var delegate: protocol<ARDRoomTextFieldDelegate>? {get set}
	//	typealias iARDRoomTextField : ARDRoomTextField;
}
//
public class  ARDRoomTextField : UIView, ARDRoomTextFieldProtocol {
	var roomText : UITextField;
	var clearButton :UIButton;
	var delegate : protocol<ARDRoomTextFieldDelegate>?;
	
	public override init(frame: CGRect){
		self.roomText  = UITextField(frame: CGRectZero);
		self.roomText.borderStyle = UITextBorderStyle.None;
		self.roomText.font  = UIFont(name:"CGFloat", size:36);
		self.roomText.placeholder = "Room name";
		///
		self.roomText.text = arc4random().description.subString(0, length: 5);
		self.clearButton = UIButton(type: UIButtonType.Custom);
		self.delegate = nil;
		super.init(frame: frame);
//		ic_call_end_black_24dp
		let image : UIImage = UIImage(named: "ic_clear_black_24dp")!;
		//var color : UIColor = UIColor(white: 0, alpha: 0.4);
		self.clearButton.setImage(image, forState: UIControlState.Normal)
		self.clearButton.addTarget(self, action: "onClear", forControlEvents: UIControlEvents.TouchUpInside);
		self.clearButton.hidden = true;
		self.addSubview(self.clearButton);
		self.roomText.delegate = self;
		self.roomText.addTarget(self,action:"textFieldDidChange:",forControlEvents: UIControlEvents.EditingChanged);
		self.addSubview(self.roomText);
		
		self.layer.borderWidth = 1;
		//		self.layer.borderColor = UIColor.lightGrayColor();
		self.layer.cornerRadius = 2;
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func sizeThatFits(size: CGSize) -> CGSize {
		return CGSize(width: size.width, height: kRoomTextFieldHeight);
	}
	
	public override func layoutSubviews() {
		let bounds : CGRect = self.bounds;
		self.clearButton.frame = CGRectMake(CGRectGetMaxX(bounds) - kRoomTextButtonSize,CGRectGetMinY(bounds),kRoomTextButtonSize, kRoomTextButtonSize);
		self.roomText.frame = CGRectMake(CGRectGetMinX(bounds) + kRoomTextButtonSize,CGRectGetMinY(bounds),
			CGRectGetMinX(self.clearButton.frame) - CGRectGetMinX(bounds) - kRoomTextFieldMargin, kRoomTextButtonSize);
	}
	
	//
	//#pragma mark - UITextFieldDelegate
	//
	public func textFieldDidEndEditing(textField:UITextField) -> Void {
		self.delegate?.roomTextField(self, didInputRoom: textField.text!);
	}
	
	public func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder();
		return true;
	}
	
	//
	//#pragma mark - Private
	//
	func textFieldDidChange(sender: AnyObject) {
		
		self.updateClearButton();
	}
	//
	func onClear(sender: AnyObject){
		self.roomText.text = "";
		self.updateClearButton();
		self.roomText.resignFirstResponder();
	}
	
	func updateClearButton() {
		
		self.clearButton.hidden = self.roomText.text!.length == 0;
	}
	
}


public protocol MainViewDelegate: AnyObject {
	func mainView(mainView:MainView,didInputRoom room:String);
//		func mainView(mainView:MainView,didCreateIncident incidentId:String);
}


public class MainView : UIView, ARDRoomTextFieldDelegate {
	
	var  appLabel : UILabel;
	var  roomText : ARDRoomTextField;
//	var map: MGLMapView!
	var delegate : protocol<MainViewDelegate>?;
	
	public override init(frame: CGRect){
		self.roomText = ARDRoomTextField(frame:frame);
		self.appLabel = UILabel(frame: frame);
//		self.appLabel.font = UIFont(name: "Roboto", size: 24.0);
		self.appLabel.textAlignment = .Center
		self.appLabel.textColor = MaterialColor.white
		self.appLabel.font = RobotoFont.boldWithSize(24)

		self.appLabel.textColor = UIColor(white: 0, alpha:0.2);
		print(self.roomText.roomText.text);
		self.appLabel.text = self.roomText.roomText.text;
		self.appLabel.sizeToFit();
		print(self.appLabel.text);
		super.init(frame: frame);
		self.addSubview(self.appLabel);
		
		self.roomText.delegate = self;
		self.addSubview(self.roomText);
		
//		self.backgroundColor = UIColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 0.2)
//		self.backgroundColor = UIColor.whiteColor();
		self.backgroundColor = UIColor.clearColor();
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func roomTextField(roomTextField: ARDRoomTextField,didInputRoom room : NSString) {
		self.delegate?.mainView(self, didInputRoom:	room as String);
	}
	
	
	public override func layoutSubviews() {
		let bounds : CGRect = self.bounds;
		let roomTextWidth : CGFloat = bounds.width - 2 * kRoomTextFieldMargin;
		let roomTextHeight : CGFloat = self.roomText.sizeThatFits(bounds.size).height;
		
		self.roomText.frame = CGRectMake(kRoomTextFieldMargin,(kStatusBarHeight + kRoomTextFieldMargin) ,roomTextWidth,roomTextHeight);
		
		self.appLabel.center = CGPointMake(CGRectGetMidX(bounds),CGRectGetMidY(bounds));
	}
	
}
//implementation ARDMainView {
//	UILabel *self.appLabel;
//	ARDRoomTextField *self.roomText;
//}
//
//synthesize delegate = self.delegate;
//
//- (instancetype)initWithFrame:(CGRect)frame {
//	if (self = super initWithFrame:frame()) {
//		self.appLabel = UILabel alloc() initWithFrame:CGRectZero();
//		self.appLabel.text = "AppRTCDemo";
//		self.appLabel.font = UIFont fontWithName:"Roboto" size:34();
//		self.appLabel.textColor = UIColor colorWithWhite:0 alpha:.2();
//		self.appLabel sizeToFit();
//		self addSubview:self.appLabel();
//
//		self.roomText = ARDRoomTextField alloc() initWithFrame:CGRectZero();
//		self.roomText.delegate = self;
//		self addSubview:self.roomText();
//
//		self.backgroundColor = UIColor whiteColor();
//	}
//	return self;
//	}
//
//	func layoutSubviews {
//  CGRect bounds = self.bounds;
//  CGFloat roomTextWidth = bounds.size.width - 2 * kRoomTextFieldMargin;
//  CGFloat roomTextHeight = self.roomText sizeThatFits:bounds.size().height;
//  self.roomText.frame = CGRectMake(kRoomTextFieldMargin,
//		kStatusBarHeight + kRoomTextFieldMargin,
//		roomTextWidth,
//		roomTextHeight);
//  self.appLabel.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
//}
//
//#pragma mark - ARDRoomTextFieldDelegate
//
//func roomTextField:(ARDRoomTextField *)roomTextField
//didInputRoom:(NSString *)room {
//	self.delegate mainView:self didInputRoom:room();
//}
//
//end
