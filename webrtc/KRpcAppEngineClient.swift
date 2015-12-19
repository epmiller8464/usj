//
//  KRpc.swift
//  webrtc
//
//  Created by ghostmac on 10/1/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//

import Foundation

public enum RtpEndpointState: Int {
	case CreateMediaPipeline = 1
	case CreateRtpEndpoint = 2
	case ConnectRtpEndpoint = 3
	case ProcessOffer = 4
	case Connected = 5
}

public class KRpcAppEngineClient : NSObject, KMSSignalingChannel , SRWebSocketDelegate{ //RoomServerClient {
	
	static let kRoomServerHostUrl = "http://192.168.0.6:8181/";
	static let kRoomServerJoinFormat =	"http://192.168.0.6:8181/join/";//%@/%@";
	static let kRoomServerMessageFormat = "http://192.168.0.6:8181/message/";
	static let kRoomServerLeaveFormat = "http://192.168.0.6:8181/leave/%@/%@";
	static let kKurentoAppEngineClientErrorDomain = "KurentoAppEngineClient";
	static let kKurentoAppEngineClientErrorBadResponse = -1;
	
	private var _webSocket : SRWebSocket?;
	private var _state : SignalingChannelState? = nil;
	
	public var id : NSString?;
	public var sessionsId : NSString?;
	public var mediaPipeline : NSString?;
	public var state : SignalingChannelState? {get{ return self._state;}}
	public var socketUrl : NSURL?;
	public var restUrl : NSURL?;// = nil;
	public var rtcEndpointState : RtpEndpointState?
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
		self._webSocket = SRWebSocket(URLRequest: NSURLRequest(URL: NSURL(string: "ws://192.168.0.105:8888/kurento")!));
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
	
	public func registerPresenter(message:SessionDescriptionMessage){
		
		if self._state == SignalingChannelState.kSignalingChannelStateOpen {
			let data : NSDictionary = ["id":"presenter","sdpOffer" : message.sessionDescription.description];
			
			let msgObj = try? NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.PrettyPrinted);
			let msgStr = NSString(data: msgObj!, encoding: NSUTF8StringEncoding);
			print(NSString(format:"C->WSS: %@", msgStr!));
			self._webSocket?.send(msgStr);
		}
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
			
			let messageDict : NSDictionary = ["id": "call" , "to" : to,"from":"e", "sdpOffer" : message.sessionDescription.description];
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
	/*
	"id":1,
	"method":"create",
	"params":{
	"type":"MediaPipeline",
	"constructorParams":{}
	},
	"jsonrpc":"2.0"
	*/
	public func createMediaPipeline(){
		
		let msg : NSDictionary = ["id":1,
			"method":"create",
			"sessionId": self.id!,
			"params":["type":"MediaPipeline","constructorParams":[:]],
			"jsonrpc":"2.0"];
		let error = NSErrorPointer();// = nil;
		var data: NSData?
		do {
			data = try NSJSONSerialization.dataWithJSONObject(msg, options: NSJSONWritingOptions())
		} catch let error1 as NSError {
			error.memory = error1
			data = nil
		};
		self._webSocket!.send(NSString(data:data!,encoding:NSUTF8StringEncoding));
	}
	
	public func createRtpEndpoint(){
		
		let msg : NSDictionary = ["id":2,
			"method":"create",
			"sessionId": self.sessionsId!,
			"params":["type":"RtpEndpoint",
				"constructorParams":[
					"mediaPipeline":self.mediaPipeline!]
			],
			"jsonrpc":"2.0"];
		let error = NSErrorPointer();// = nil;
		var data: NSData?
		do {
			data = try NSJSONSerialization.dataWithJSONObject(msg, options: NSJSONWritingOptions())
		} catch let error1 as NSError {
			error.memory = error1
			data = nil
		};
		self._webSocket!.send(NSString(data:data!,encoding:NSUTF8StringEncoding));
	}
	
	public func connectRtpEndpoint(){
		
		let msg : NSDictionary = [
			"id":3,
			"method":"invoke",
			"sessionId": self.sessionsId!,
			"params":[
				"object":self.mediaPipeline!,
				"operation":"connect",
				"operationParams":[
					"sink":self.mediaPipeline!]
			],
			"jsonrpc":"2.0"];
		let error = NSErrorPointer();// = nil;
		var data: NSData?
		do {
			data = try NSJSONSerialization.dataWithJSONObject(msg, options: NSJSONWritingOptions())
		} catch let error1 as NSError {
			error.memory = error1
			data = nil
		};
		self._webSocket!.send(NSString(data:data!,encoding:NSUTF8StringEncoding));
	}
	
	public func processOffer(){
//		v=0
//		o=- 2 3641288714 IN IP4 <server ip here>
//		s=Kurento Media Server
//		c=IN IP4 <server ip here>
//		t=0 0
//		m=video 33908 RTP/AVP 100
//		a=rtpmap:100 H264/90000
//		a=sendonly
//		a=ssrc:2179178691 cname:user900156941@host-e9c3d0c6

//		var msg : NSDictionary = [
//			"id":4,
//			"method":"invoke",
//			"sessionId": self.sessionsId!,
//			"params":[
//				"object":self.mediaPipeline!,
//				"operation":"processOffer",
//				"operationParams":[
//					"offer":createAndSendSDP()]
//			],
//			"jsonrpc":"2.0"];
//		var error = NSErrorPointer();// = nil;
//		var data = NSJSONSerialization.dataWithJSONObject(msg, options: NSJSONWritingOptions.allZeros, error: error);
//		self._webSocket!.send(NSString(data:data!,encoding:NSUTF8StringEncoding));
	}
	
	public func sendOffer(message:SessionDescriptionMessage){
		
	}
	
	public func webSocketDidOpen(webSocket: SRWebSocket!) {
		print("webSocket connection opened");
		self._state = SignalingChannelState.kSignalingChannelStateOpen;
		//		if self.locationId.length > 0 && self.id.length > 0 {
		//			registerWithCollider();
		//		}
		self.createMediaPipeline();
		//		self.delegate!.createOffer();
		//		self._state = SignalingChannelState.kSignalingChannelStateRegistered;
	}
	
	public func processMediaResponse(message: AnyObject!) {
		
		//		println(message);
		//
		let msgStr = message as! NSString?;
		let jsonObj = NSDictionary.dictionaryWithJSONString(msgStr);
		
		
		let _actionState = jsonObj!["id"] as? Int;
	
		let _state = _actionState!;// as RtcEndpointState;
		self.rtcEndpointState = RtpEndpointState(rawValue: _state);
		switch 	self.rtcEndpointState!  {
		case RtpEndpointState.CreateMediaPipeline:
			let result = jsonObj!["result"] as? NSDictionary;
			let val = result!["value"] as? String;
			let _sessionId = result!["sessionId"] as? String;
			self.mediaPipeline = val!;
			self.sessionsId = _sessionId!
			createRtpEndpoint();
			break;
		case RtpEndpointState.CreateRtpEndpoint:
			let result = jsonObj!["result"] as? NSDictionary;
			let val = result!["value"] as? String;
			var _sessionId = result!["sessionId"] as? String;
			self.mediaPipeline = val!;
			connectRtpEndpoint();
			break;
		case RtpEndpointState.ConnectRtpEndpoint:
			let result = jsonObj!["result"] as? NSDictionary;
//			var val = result!["value"] as? String;
			var _sessionId = result!["sessionId"] as? String;
//			self.mediaPipeline = val!;
			processOffer();
			break;
		case RtpEndpointState.ProcessOffer:
			let result = jsonObj!["result"] as? NSDictionary;
			let val = result!["value"] as? String;
//			var _sessionId = result!["sessionId"] as? String;
			var sdp = val!;
//			processOffer();
			break;
		default:
			break;
		}
		
	}
	
	public func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
		
		processMediaResponse(message);
		return;
		
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
			self.delegate!.channel(self, didReceiveMessage: SessionDescriptionMessage(description: RTCSessionDescription(type:"offer",sdp:answer))!);
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
			//		resgisterResponse(parsedMessage);
			//			onRegistered(resp!);
			self._state = SignalingChannelState.kSignalingChannelStateRegistered;
			let answer = jsonObj!["sdpAnswer"] as? String;
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