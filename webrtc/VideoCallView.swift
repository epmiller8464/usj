//
//  VideoCallView.swift
//  webrtc
//
//  Created by ghostmac on 8/4/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public protocol VideoCallViewDelegate  {
	
	func videoCallViewDidSwitchCamera(view:VideoCallView);
	func videoCallViewDidHangup(view:VideoCallView);
}

let kButtonPadding : CGFloat = 16;
let kButtonSize : CGFloat = 48;
let kLocalVideoViewSize : CGFloat = 60;
let kLocalVideoViewPadding : CGFloat = 8;


public class VideoCallView : UIView, RTCEAGLVideoViewDelegate {
	
	var statusLabel : UILabel;
	var localVideoView : RTCEAGLVideoView;
	var remoteVideoView : RTCEAGLVideoView;
	var delegate : protocol<VideoCallViewDelegate>?;
	
	private var _cameraSwitchButton: UIButton;
	private var _hangupButton: UIButton;
	private var _localVideoSize : CGSize;
	private var _remoteVideoSize : CGSize;
	private var _useRearCamera : Bool;
	
	public override init(frame: CGRect){
		
		self.remoteVideoView = RTCEAGLVideoView(frame: CGRectZero);
		
		self.localVideoView = RTCEAGLVideoView(frame: CGRectZero);
		
		self.statusLabel = UILabel(frame:frame);
		
		self._hangupButton = UIButton(type: UIButtonType.Custom);
		
		self._cameraSwitchButton = UIButton(type: UIButtonType.Custom);
		
		self._localVideoSize = CGSizeZero;
		self._remoteVideoSize = CGSizeZero;
		self._useRearCamera = false;
		
		super.init(frame: frame);
		
		self.remoteVideoView.delegate = self;
		self.addSubview(self.remoteVideoView);
		
		self.localVideoView.delegate = self;
		self.addSubview(self.localVideoView);
		
		self._cameraSwitchButton.backgroundColor = UIColor.whiteColor()
		self._cameraSwitchButton.layer.cornerRadius = kButtonSize / 2;
		self._cameraSwitchButton.layer.masksToBounds = true;
		
		var image = UIImage(named: "product_logo_24.png");
		self._cameraSwitchButton.setImage(image!, forState: UIControlState.Normal);
		self._cameraSwitchButton.addTarget(self, action:"onCameraSwitch:", forControlEvents: UIControlEvents.TouchUpInside);
		self.addSubview(self._cameraSwitchButton);
		
		
		self._hangupButton.backgroundColor = UIColor.redColor();
		self._hangupButton.layer.cornerRadius = kButtonSize / 2;
		self._hangupButton.layer.masksToBounds = true;
		image = UIImage(named: "product_logo_24.png");
		//		image = UIImage.imageForName("product_logo_24.png",color: UIColor.whiteColor());
		self._hangupButton.setImage(image, forState: UIControlState.Normal);
		self._hangupButton.addTarget(self, action: "onHangup:", forControlEvents: UIControlEvents.TouchUpInside);
		
		self.addSubview(self._hangupButton);
		
		self.statusLabel.font = UIFont(name: "Roboto",size:16);
		self.statusLabel.textColor = UIColor.whiteColor();
		self.addSubview(self.statusLabel);
		
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func layoutSubviews() {
		
		let bounds = self.bounds;
		if self._remoteVideoSize.width > 0 && self._remoteVideoSize.height > 0 {
			var rvFrame = AVMakeRectWithAspectRatioInsideRect(self._remoteVideoSize,bounds);
			var scale : CGFloat = 1.0;
			if rvFrame.size.width > rvFrame.size.height {
				scale = bounds.size.height / rvFrame.size.height;
			} else {
				scale = bounds.size.width / rvFrame.size.width;
			}
			
			rvFrame.size.height *= scale;
			rvFrame.size.width *= scale;
			self.remoteVideoView.frame = rvFrame;
			self.remoteVideoView.center = CGPointMake(CGRectGetMidX(bounds),CGRectGetMidY(bounds));
		} else {
			self.remoteVideoView.frame = bounds;
		}
		
		if self._localVideoSize.width > 0 && self._localVideoSize.height > 0 {
			var localVideoFrame = CGRectMake(0, 0, kLocalVideoViewSize, kLocalVideoViewSize);
			localVideoFrame = AVMakeRectWithAspectRatioInsideRect(_localVideoSize, localVideoFrame);
			
			// Place the view in the bottom right.
			localVideoFrame.origin.x = CGRectGetMaxX(bounds) - localVideoFrame.size.width - kLocalVideoViewPadding;
			localVideoFrame.origin.y = CGRectGetMaxY(bounds) - localVideoFrame.size.height - kLocalVideoViewPadding;
			self.localVideoView.frame = localVideoFrame;
		} else {
			self.localVideoView.frame = bounds;
		}
		
		self._hangupButton.frame = CGRectMake(CGRectGetMinX(bounds) + kButtonPadding, CGRectGetMaxY(bounds) - kButtonPadding - kButtonSize, kButtonSize, kButtonSize);
		
		// Place button to the right of hangup button.
		var	cameraSwitchFrame :CGRect = _hangupButton.frame;
		cameraSwitchFrame.origin.x = CGRectGetMaxX(cameraSwitchFrame) + kButtonPadding;
		self._cameraSwitchButton.frame = cameraSwitchFrame;
		
		self.statusLabel.sizeToFit();
		self.statusLabel.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
		
	}
	
	
	public func videoView(videoView: RTCEAGLVideoView!, didChangeVideoSize size: CGSize) {
		
		if videoView == self.localVideoView {
			self._localVideoSize = size;
			self.localVideoView.hidden = CGSizeEqualToSize(CGSizeZero,self._localVideoSize);
		} else if videoView == self.remoteVideoView {
			self._remoteVideoSize = size;
		}
		self.setNeedsLayout();
	}
	
	//Mark: - Private
	func onCameraSwitch(sender: AnyObject) {
		self.delegate!.videoCallViewDidSwitchCamera(self);
	}
	
	func onHangup(sender: AnyObject) {
		self.delegate!.videoCallViewDidHangup(self);
	}
	
}