//
//  KMSAppEngineClient.swift
//  webrtc
//
//  Created by ghostmac on 9/23/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//

import Foundation

public class KMSAppEngineClient : NSObject, KMSSignalingChannel , SRWebSocketDelegate{ //RoomServerClient {
	
	static let kRoomServerHostUrl = "http://192.168.0.6:8181/";
	static let kRoomServerJoinFormat =	"http://192.168.0.6:8181/join/";//%@/%@";
	static let kRoomServerMessageFormat = "http://192.168.0.6:8181/message/";
	static let kRoomServerLeaveFormat = "http://192.168.0.6:8181/leave/%@/%@";
	static let kKurentoAppEngineClientErrorDomain = "KurentoAppEngineClient";
	static let kKurentoAppEngineClientErrorBadResponse = -1;
	
	private var _webSocket : SRWebSocket?;
	private var _state : SignalingChannelState? = nil;
	
	public var id : NSString?;
	public var state : SignalingChannelState? {get{ return self._state;}}
	public var socketUrl : NSURL?;
	public var restUrl : NSURL?;// = nil;
	
	public var delegate : protocol<KMSSignalingChannelDelegate>?;
	override init(){
		super.init();
		
	}
	
	convenience init(id: NSString,delegate:protocol<KMSSignalingChannelDelegate>?){
		self.init();
		
		self.id = id;
		self.delegate = delegate;
		
		if self._webSocket != nil {
			
			self._webSocket!.delegate = nil;
			self._webSocket = nil;
		}
		
		//		self._webSocket = SRWebSocket(URLRequest: NSURLRequest(URL:self.socketUrl!));
		self._webSocket = SRWebSocket(URLRequest: NSURLRequest(URL: NSURL(string: "ws://192.168.0.6:8181/call")!));
		self._webSocket!.delegate = self;
		print("opening web socket");
		//self._webSocket!.close();
		self._webSocket!.open();
	}
	
	deinit{
		self.disconnect();
	}
	
	
	public func register(){
		
		if self._state == SignalingChannelState.kSignalingChannelStateOpen {
			let data : NSDictionary = ["id":"register","name":self.id!];
			
			let msgObj = try? NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.PrettyPrinted);
			let msgStr = NSString(data: msgObj!, encoding: NSUTF8StringEncoding);
			print(NSString(format:"C->WSS: %@", msgStr!));
			self._webSocket?.send(msgStr);
		}
	}
	
	public func registerPresenter(){
		self._state = SignalingChannelState.kSignalingChannelStateRegistered;
		self.delegate!.createOffer();
	}
	
	public func onRegistered(response:String){
		
		if response == "accepted" {
			self._state = SignalingChannelState.kSignalingChannelStateRegistered;
			//self.delegate!.createOffer();
		}
		//		var payload = wssMessage[messageKey] as? String;
		//		var sm = SignalingMessage.messageFromJSONString(payload!);
		//		println("payload: \(payload)");
		//		var desc = RTCSessionDescription(type:"answer", sdp: "");
		//		var message = SessionDescriptionMessage(description: desc);
		//self.delegate!.channel(self, didReceiveMessage: message!);
		
	}
	
	public func call(to:NSString,message:SessionDescriptionMessage){
		
		if self.state == SignalingChannelState.kSignalingChannelStateRegistered {
			
			let messageDict : NSDictionary = ["id": "call" , "to" : to,"from":self.id!, "sdpOffer" : message.sessionDescription.description];
			let msgObj = try? NSJSONSerialization.dataWithJSONObject(messageDict, options: NSJSONWritingOptions.PrettyPrinted);
			let msgStr = NSString(data: msgObj!, encoding: NSUTF8StringEncoding);
			//println(NSString(format:"C->WSS: %@", payload!));
			self._webSocket!.send(msgStr);
		}
	}
	
	public func sendPresenterOffer(message:SessionDescriptionMessage){
		
		if self.state == SignalingChannelState.kSignalingChannelStateRegistered {
			print(message.sessionDescription.description);
			let messageDict : NSDictionary = ["id": "presenter" ,"sdpOffer" : message.sessionDescription.description];
			
			let msgObj = try? NSJSONSerialization.dataWithJSONObject(messageDict, options: NSJSONWritingOptions.PrettyPrinted);
			let msgStr = NSString(data: msgObj!, encoding: NSUTF8StringEncoding);
			//println(NSString(format:"C->WSS: %@", payload!));
			self._webSocket!.send(msgStr);
			
		}
	}
	
	public func incomingCallResponse(message:SessionDescriptionMessage){
		
		if self.state == SignalingChannelState.kSignalingChannelStateRegistered {
			
			let messageDict : NSDictionary = ["id": "incomingCallResponse" , "from" : "e","callResponse": "accept","sdpOffer" : message.sessionDescription.description];
			
			let msgObj = try? NSJSONSerialization.dataWithJSONObject(messageDict, options: NSJSONWritingOptions.PrettyPrinted);
			let msgStr = NSString(data: msgObj!, encoding: NSUTF8StringEncoding);
			//println(NSString(format:"C->WSS: %@", payload!));
			self._webSocket!.send(msgStr);
			
		}
	}
	
	public func onIceCandidate(message:ICECandidateMessage){
		
		//		var messageDict : NSDictionary = ["id": "call" , "to" : to,"from":self.id!, "sdpOffer" : message.sessionDescription.description];
		//		var msgObj = NSJSONSerialization.dataWithJSONObject(messageDict, options: NSJSONWritingOptions.PrettyPrinted, error: nil);
		//		var msgStr = NSString(data: msgObj!, encoding: NSUTF8StringEncoding);
		//		//println(NSString(format:"C->WSS: %@", payload!));
		//		self._webSocket!.send(msgStr);
		//
		//
	}
	
	public func onIncomingCallResponse(message: AnyObject!){
		
	}
	
	
	//	// Sends message over the WebSocket connection if registered, otherwise POSTs to
	//	// the web socket server instead.
	//	- (void)sendMessage:(ARDSignalingMessage *)message;
	public func sendMessage(message: SignalingMessage) -> Void{
		
		let data = message.JSONData();
		let payload = NSString(data: data!, encoding: NSUTF8StringEncoding);
		if self.state == SignalingChannelState.kSignalingChannelStateRegistered {
			
			print(NSString(format:"C->WSS: %@", payload!));
			self._webSocket!.send(payload);
			//
		}else{
			//			println(NSString(format:"C->post: %@", payload!));
			//			var 	urlString = NSString(format:"%@/%@/%@",self._restUrl!.absoluteString!,self._locationId,self._id);
			//			var urls = NSURL(string: urlString as! String )!;
			//			NSURLConnection.sendAsyncPostToURL(urls, withData: data!, completionHandler: nil);
			//
		}
		//
	}
	
	
	public func webSocketDidOpen(webSocket: SRWebSocket!) {
		print("webSocket connection opened");
		self._state = SignalingChannelState.kSignalingChannelStateOpen;
		//		if self.locationId.length > 0 && self.id.length > 0 {
		//			registerWithCollider();
		//		}
		self.delegate!.onChannelReady();
		//		self.delegate!.createOffer();
		//		self._state = SignalingChannelState.kSignalingChannelStateRegistered;
	}
	
	public func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
		
		//		println(message);
		//
		let msgStr = message as! NSString?;
		let jsonObj = NSDictionary.dictionaryWithJSONString(msgStr);
		
		
		let _actionId = jsonObj!["id"] as? String;
		let resp = jsonObj!["response"] as? String;
		
		switch _actionId! {
		case "registerResponse":
			//		resgisterResponse(parsedMessage);
			onRegistered(resp!);
			break;
		case "callResponse":
			let answer = jsonObj!["sdpAnswer"] as? String;
			print(answer);
			var sm = SignalingMessage.messageFromJSONString(answer!);
			sm = SessionDescriptionMessage(description: RTCSessionDescription(type:"answer",sdp:answer))!
			self.delegate!.channel(self, didReceiveMessage: sm!);
			//		callResponse(parsedMessage);
			break;
		case "incomingCall":
			//		incomingCall(parsedMessage);
			
			let answer = jsonObj!["sdpOffer"] as? String;
			print(answer);
			//			var sm = SignalingMessage.messageFromJSONString(answer!);
			//			sm = SessionDescriptionMessage(description: RTCSessionDescription(type:"offer",sdp:answer))!
			//			self.delegate!.channel(self, didReceiveMessage: sm!);
			
			self.delegate!.createOffer();
			//self.delegate!.channel(self, didReceiveMessage: SessionDescriptionMessage(description: RTCSessionDescription(type:"offer",sdp:answer))!);
			//			var messageDict : NSDictionary = ["id": "incomingCallResponse" , "from" : self.id!,"callResponse": "accept","sdpOffer",];
			//
			//			var msgObj = NSJSONSerialization.dataWithJSONObject(messageDict, options: NSJSONWritingOptions.PrettyPrinted, error: nil);
			//			var msgStr = NSString(data: msgObj!, encoding: NSUTF8StringEncoding);
			//			//println(NSString(format:"C->WSS: %@", payload!));
			//			self._webSocket!.send(msgStr);
			
			break;
		case "startCommunication":
			let answer = jsonObj!["sdpAnswer"] as? String;
			self.delegate!.channel(self, didReceiveMessage: SessionDescriptionMessage(description: RTCSessionDescription(type:"answer",sdp:answer))!);
			break;
		case "stopCommunication":
			
			self.disconnect();
			break;
		case "iceCandidate":
			let candidate = jsonObj!["candidate"] as? NSDictionary;
			//var values = NSDictionary.dictionaryWithJSONString(candidate);
			//			if values == nil {
			//				println("Error parsing signaling message JSON.");
			//				return;
			//			}
			// = "candidate:1 1 UDP 2013266431 192.168.0.105 45374 typ host";
			let c =	candidate!["candidate"] as? String;
			let mli = candidate!["sdpMLineIndex"] as? String;
			let mi =	candidate!["sdpMid"] as? String;
			//			"sdpMLineIndex" = 0;
			//			"sdpMid" = audio;
			let mLineIndex = mli == nil ? 0 :Int(mli!);
			let rtcCM =	RTCICECandidate(mid: mi!, index: mLineIndex!, sdp: c!)!;
			self.delegate!.channel(self, didReceiveMessage: ICECandidateMessage(candidate: rtcCM)!);//: RTCSessionDescription(type:"answer",sdp:answer))!);
			break;
		case "onIceCandidate":
			var answer = jsonObj!["candidate"] as? String;
			//self.delegate!.channel(self, didReceiveMessage: ICECandidateMessage(candidate: RTCICECandidate(): RTCSessionDescription(type:"answer",sdp:answer))!);
			break;
		case "presenterResponse":
			let answer = jsonObj!["sdpAnswer"] as? String;
			print(answer);
//			var sm = SignalingMessage.messageFromJSONString(answer!);
//			sm = SessionDescriptionMessage(description: RTCSessionDescription(type:"answer",sdp:answer))!
			self.delegate!.channel(self, didReceiveMessage: SessionDescriptionMessage(description: RTCSessionDescription(type:"answer",sdp:answer))!);
			break;
		case "viewerResponse":
			//		resgisterResponse(parsedMessage);
			onRegistered(resp!);
			break;
		case "startResponse":
			let answer = jsonObj!["sdpAnswer"] as? String;
			self.delegate!.channel(self, didReceiveMessage: SessionDescriptionMessage(description: RTCSessionDescription(type:"offer",sdp:answer))!);
			break;
		default:
			break;
		}
	}
	
	public func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
		print("WebSocket error: \(error)");
		//		self._state = SignalingChannelState.kSignalingChannelStateError;
		//self.connectWebSocket();
		self._webSocket!.close();
	}
	public func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
		//		self._webSocket = webSocket!;
		print("WebSocket closed with code: \(code) reason:\(reason!) wasClean:\(wasClean)")
		self._state = SignalingChannelState.kSignalingChannelStateClosed;
		self._webSocket!.close();
		//self.connectWebSocket();
	}
	
	func disconnect(){
		//		if self.state == SignalingChannelState.kSignalingChannelStateError ||
		//			self.state == SignalingChannelState.kSignalingChannelStateClosed {
		//				return;
		//		}
		self._webSocket?.close();
		//
		//		var urlString = NSString(format:"%@/%@/%@",self._restUrl!.absoluteString!,self.locationId,self.id);
		//		var url = NSURL(string: urlString as! String )!;
		//		var request  = NSMutableURLRequest(URL: url);
		//		request.HTTPMethod = "DELETE";
		//		request.HTTPBody = nil;
		//		NSURLConnection.sendAsyncRequest(request,completionHandler: nil);
		//
	}
	
	
	
	var badErrorResponse : NSError {
		get{
			return NSError(domain: KurentoAppEngineClient.kKurentoAppEngineClientErrorDomain,
				code:KurentoAppEngineClient.kKurentoAppEngineClientErrorBadResponse, userInfo: [ NSLocalizedDescriptionKey: "Error parsing response."])
		}
	}
	
}