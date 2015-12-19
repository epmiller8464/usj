//
//  VideoCallViewController.swift
//  webrtc
//
//  Created by ghostmac on 8/4/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//

import Foundation
import UIKit




public class VideoCallViewController : UIViewController , AppClientDelegate , VideoCallViewDelegate {
	
	
	private var _remoteVideoTrack : RTCVideoTrack?;
	private var _localVideoTrack : RTCVideoTrack?;
	var  remoteVideoTrack :RTCVideoTrack? {
		get{return self._remoteVideoTrack;}
		
		set(newRemoteVideoTrack){
			if self._remoteVideoTrack == newRemoteVideoTrack {
				return;
			}
			self._remoteVideoTrack?.removeRenderer(_videoCallView!.localVideoView);
			self._remoteVideoTrack = nil;
			self._videoCallView?.remoteVideoView.renderFrame(nil);//.remoteVideoView();
			self._remoteVideoTrack = newRemoteVideoTrack;
			self._remoteVideoTrack?.addRenderer(_videoCallView!.remoteVideoView);
		}
	}
	
	var  localVideoTrack:RTCVideoTrack? {
		get{return self._localVideoTrack;}
		
		set(newLocalVideoTrack){
			if self._localVideoTrack == newLocalVideoTrack {
				return;
			}
			self._localVideoTrack?.removeRenderer(_videoCallView!.localVideoView);
			self._localVideoTrack = nil;
			self._videoCallView?.localVideoView.renderFrame(nil);//.remoteVideoView();
			self._localVideoTrack = newLocalVideoTrack;
			self._localVideoTrack?.addRenderer(_videoCallView!.localVideoView);
		}
	}
	
	
	private var _videoCallView : VideoCallView?;
	private var _client : AppClient?;
	
	public convenience init(room: NSString) {
		
		self.init();
		self._client = AppClient(delegate: self);
		self._client!.connectToRoomWithId(room, options: nil);//(roomId:room as String, options: nil);
	}
	override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	// SWIFT REQUIREMENTS
	
	init() {
		super.init(nibName:nil,bundle:nil);
	}
	
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func loadView() {
		self._videoCallView = VideoCallView(frame:CGRectZero);
		self._videoCallView!.delegate = self;
		self._videoCallView!.statusLabel.text = self.statusTextForState(RTCICEConnectionNew) as? String;
		self.view = _videoCallView;
		
	}
	
	///MARK:
	
	
	public func appClient(client: AppClient, didChangeState state: AppClientState) {
		
		switch state {
		case AppClientState.kAppClientStateConnected:
			NSLog("Client connected.");
			break;
		case AppClientState.kAppClientStateConnecting:
			NSLog("Client connecting.");
			break;
		case AppClientState.kAppClientStateDisconnected:
			NSLog("Client disconnected.");
			self.hangup();
			break;
		default:
			break;
		}
	}
	
	public func appClient(client: AppClient, didChangeConnectionState state: RTCICEConnectionState) {
		NSLog("ICE state changed: %d", state.rawValue);
		//		RTCLog(@"ICE state changed: %d", state);
		weak var weakSelf  = self;
		dispatch_async(dispatch_get_main_queue(), { () -> Void in
			var strongSelf = weakSelf;
			self._videoCallView!.statusLabel.text = self.statusTextForState(state) as? String;
		});
	}
	
	public func appClient(client: AppClient, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack) {
		self.localVideoTrack = localVideoTrack;
	}
	
	public func appClient(client: AppClient, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack) {
		self.remoteVideoTrack = remoteVideoTrack;
		self._videoCallView!.statusLabel.hidden = true;
	}
	
	public func appClient(client: AppClient, didError error: NSError?) {
		let message = NSString(format:"%@", error!.localizedDescription);
		self.showAlertWithMessage(message);
		self.hangup();
	}
	
	public func videoCallViewDidHangup(view: VideoCallView) {
		self.hangup();
	}
	
	public func videoCallViewDidSwitchCamera(view: VideoCallView) {
		self.switchCamera();
	}
	
	
	func hangup(){
		self.remoteVideoTrack = nil;
		self.localVideoTrack = nil;
		self._client!.disconnect();
		if self.isBeingDismissed() {
			self.presentedViewController?.dismissViewControllerAnimated(true, completion:nil);
		}
	}
	
	func switchCamera(){
		let source = self.localVideoTrack!.source;
		if source is RTCAVFoundationVideoSource {
			let avSource = source as! RTCAVFoundationVideoSource;
			avSource.useBackCamera = !avSource.useBackCamera;
			self._videoCallView!.localVideoView.transform = avSource.useBackCamera ? CGAffineTransformIdentity : CGAffineTransformMakeScale(-1, 1);
		}
	}
	
	func statusTextForState(state:RTCICEConnectionState) -> NSString? {
		var status : NSString?;
		
		switch state.rawValue {
			
		case RTCICEConnectionNew.rawValue,
		RTCICEConnectionChecking.rawValue:
			status = "Connecting...";
			break
		default:
			break;
		}
		return status;
	}
	
	func showAlertWithMessage(message:NSString){
		let alertView = UIAlertView(title: nil, message: message as String, delegate: nil, cancelButtonTitle: "Ok");
		alertView.show();
	}
	
}






