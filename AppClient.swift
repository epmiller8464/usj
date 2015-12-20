//
//  AppClient.swift
//  webrtc
//
//  Created by ghostmac on 8/4/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//

import Foundation
//import Alamofire
import CoreData;


public enum AppClientState : Int {
	
	case kAppClientStateUnknown;
	case kAppClientStateDisconnected;
	case kAppClientStateConnecting;
	case kAppClientStateConnected;
	
	
	public func getState(state:AppClientState) -> String {
		switch state {
			// State when disconnected.
		case kAppClientStateUnknown:
			return String("State:Unknown");
			// State when connection is established but not ready for use.
		case	kAppClientStateDisconnected:
			// State when connection is established and registered.
			return String("State:Disconnected");
		case kAppClientStateConnecting:
			return String("State:Connecting");
			// State when connection encounters a fatal error.
		case kAppClientStateConnected:
			return String("Connected");
		}
	}
}

public protocol AppClientDelegate {
	
	//func appClient(RTCAppClient
	
	func appClient(client: AppClient,didChangeState state: AppClientState) -> Void;
	
	func appClient(client: AppClient,didChangeConnectionState state: RTCICEConnectionState) -> Void;
	
	func appClient(client: AppClient,didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack) -> Void;
	
	func appClient(client: AppClient,didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack) -> Void;
	
	func appClient(client: AppClient,didError error: NSError?) -> Void;
}

//public protocol AppClientProtocol :  AnyObject, RTCPeerConnectionDelegate , RTCSessionDescriptionDelegate {
public protocol AppClientProtocol :  SignalingChannelDelegate , RTCPeerConnectionDelegate , RTCSessionDescriptionDelegate {
	
	var roomServerClient: protocol<RoomServerClient>?  {get }
	var channel: protocol<SignalingChannel>?  {get }
	var turnClient: protocol<TurnClientProtocol>?  {get }
	
	var peerConnection : RTCPeerConnection?{get }
	var factory : RTCPeerConnectionFactory?{get }
	var messageQueue : NSMutableArray?{get }
	var iceServers : NSMutableArray?{get }
	
	var isTurnComplete: Bool {get }
	var hasReceivedSdp: Bool {get }
	var hasJoinedRoomServer: Bool {get}
	var isInitiator: Bool {get }
	var locationId : String {get }
	var id : String {get }
	
	var webSocketURL : NSURL? {get }
	var webSocketRestURL : NSURL? {get }
	//	var defaultPeerConnectionConstraints : RTCMediaConstraints? {get}
	
	//MARK:
	var state : AppClientState {get}
	
	var delegate: protocol<AppClientDelegate>?  {get}
	
	init(delegate:protocol<AppClientDelegate>?);
	init(rsClient:protocol<RoomServerClient>?, channel: protocol<SignalingChannel>?, tc: protocol<TurnClientProtocol>?,delegate:protocol<AppClientDelegate>?);
	func connectToRoomWithId(roomId:NSString,options:NSDictionary?) -> Void;
	
	func disconnect();
	
}
//
public  let kDefaultSTUNServerUrl : NSString = "stun:stun.l.google.com:19302";
// TODO(tkchin): figure out a better username for CEOD statistics.
/*EPM(look for other public turn servers for backup)*/
public  let kTurnRequestUrl : String = "https://computeengineondemand.appspot.com/turn?username=iapprtc&key=4080218913";

public let kAppClientErrorDomain : NSString = "AppClient";
public let kAppClientErrorUnknown = -1;
public let kAppClientErrorRoomFull = -2;
public let kAppClientErrorCreateSDP = -3;
public let kAppClientErrorSetSDP = -4;
public let kAppClientErrorInvalidClient = -5;
public let kAppClientErrorInvalidRoom = -6;

public class AppClient : NSObject, AppClientProtocol ,KMSSignalingChannelDelegate,RTCDataChannelDelegate{
	
	private var _defaultPeerConnectionConstraints : RTCMediaConstraints? = nil;
	
	
	public var state : AppClientState;
	public var delegate : protocol<AppClientDelegate>?;
	public var roomServerClient: protocol<RoomServerClient>?;
	
	public var channel: protocol<SignalingChannel>?;
	public var turnClient: protocol<TurnClientProtocol>?;
	public var peerConnection : RTCPeerConnection?;
	public var dataChannel : RTCDataChannel?;
	public var factory : RTCPeerConnectionFactory?;
	public var messageQueue : NSMutableArray?;
	public var iceServers : NSMutableArray?;
	public var isTurnComplete: Bool;
	public var hasReceivedSdp: Bool;
	public var hasJoinedRoomServer: Bool { get{ return !self.id.isNilOrEmpty(); }}
	public var isInitiator: Bool;
	public var locationId : String;
	public var id : String;
	public var webSocketURL : NSURL?;
	public var webSocketRestURL : NSURL?;
	
	var engineClient: KMSAppEngineClient?;
	public var rpcServerClient: KRpcAppEngineClient?;
	let _fileLogger = RTCFileLogger();
	
	override init(){
		self.state = AppClientState.kAppClientStateUnknown;
		self.delegate = nil;
		self.roomServerClient = KurentoAppEngineClient();
		
		//		self.roomServerClient = AppEngineClient();
		self.turnClient = TurnClient(url:NSURL(string: kTurnRequestUrl)!);
		self.isTurnComplete = false;
		self.hasReceivedSdp = false;
		//self.hasJoinedRoomServer = false;
		self.isInitiator = false;
		self.locationId = "";
		self.id = "";
		
		super.init();
		
		configure();
	}
	
	required public convenience init(delegate: protocol<AppClientDelegate>?) {
		//<#code#>
		self.init();
		self.delegate = delegate;
		//self.configure();
	}
	
	public required convenience init(
		rsClient:protocol<RoomServerClient>?,
		channel: protocol<SignalingChannel>?,
		tc: protocol<TurnClientProtocol>?,
		delegate:protocol<AppClientDelegate>?){
			
			self.init(delegate: delegate);
			self.roomServerClient = rsClient;
			self.channel = channel;
			self.turnClient = tc;
			//self.configure();
	}
	
	deinit{
		self.disconnect();
	}
	
	func configure(){
		self.factory = RTCPeerConnectionFactory();
		self.messageQueue = NSMutableArray();
		self.iceServers = NSMutableArray(object: self.defaultSTUNServer!);
		//self._fileLogger = RTCFileLogger();
		//self._fileLogger.start();
	}
	func setState(state:AppClientState){
		
		if self.state == state {
			return;
		}
		self.state = state;
		self.delegate?.appClient(self, didChangeState: self.state);
	}
	
	
	public func connectToRoomWithId(roomId: NSString, options: NSDictionary?) {
		self.state = AppClientState.kAppClientStateConnecting;
		
		weak var weakSelf = self;
		self.turnClient?.requestServersWithCompletionHandler({ (turnServers, error) -> Void in
			
			if error != nil {
				//self._fileLogger!
				print(String(format:"Error retrieving TURN servers: %@",error!.localizedDescription));
			}
			
			let strongSelf = weakSelf;
			//			strongSelf?.iceServers?.addObjectsFromArray(turnServers! as [AnyObject]);
			strongSelf?.isTurnComplete = true;
			//strongSelf?.startSignalingIfReady();
			self.id = roomId as String;
			self.engineClient = KMSAppEngineClient(id:roomId,delegate: self);
			//			self.rpcServerClient = KRpcAppEngineClient(id:roomId,delegate: self);
		});
		//		self.isTurnComplete = true;
		//		self.engineClient!.register(roomId);
		//		self.id = roomId as String;
		//		self.engineClient = KMSAppEngineClient(id:roomId,delegate: self);
		//		self.engineClient!.id = roomId;
		//		self.roomServerClient?.joinRoomWithRoomId(roomId as String, completionHandler: { (response, error) -> Void in
		//			var strongSelf = weakSelf!;
		//
		//			if error != nil {
		//				strongSelf.delegate?.appClient(strongSelf, didError: error);
		//				return;
		//			}
		//
		//			var joinError = strongSelf.errorForJoinResultType(response!.result);
		//			if joinError != nil {
		//				println(String(format:"failed to join room %@",roomId));
		//				strongSelf.disconnect();
		//				strongSelf.delegate?.appClient(strongSelf, didError: joinError);
		//				return;
		//			}
		//			println(String(format:"Joined room %@",roomId));
		//			strongSelf.locationId = response!.roomId as String;
		//			strongSelf.id = response!.clientId as String;
		//			strongSelf.isInitiator = response!.isInitiator;
		//			for temp in response!.messages {
		//				//message.
		//				var message =  temp as! SignalingMessage;
		//				if message.type == SignalingMessageType.kSignalingMessageTypeOffer ||
		//					message.type == SignalingMessageType.kSignalingMessageTypeAnswer {
		//						strongSelf.hasReceivedSdp = true;
		//						strongSelf.messageQueue?.insertObject(message, atIndex: 0);
		//				}else{
		//					strongSelf.messageQueue?.addObject(message);
		//				}
		//			}
		//			strongSelf.webSocketURL = response!.webSocketURL;
		//			strongSelf.webSocketRestURL = response!.webSocketRestURL;
		//			strongSelf.registerWithColliderIfReady();
		//			strongSelf.startSignalingIfReady();
		//		});
	}
	
	public func onChannelReady(){
		//		self.engineClient!.register();
		self.engineClient!.registerPresenter();
		
	}
	
	
	public func createOffer() {
		//		self.isInitiator = true;
		//self.engineClient!.register();
		//self.startSignalingIfReady();
		self.state = AppClientState.kAppClientStateConnected;
		let constraints = self.defaultPeerConnectionConstraints!;
		//bombs here
		let config = RTCConfiguration();
		config.iceServers = self.iceServers! as [AnyObject];
		//var pc : RTCPeerConnection;
		config.iceTransportsType = RTCIceTransportsType.All;
		config.bundlePolicy = RTCBundlePolicy.Balanced;
		config.rtcpMuxPolicy = RTCRtcpMuxPolicy.Negotiate;// kRTCR
		self.peerConnection = self.factory!.peerConnectionWithConfiguration(config, constraints: constraints, delegate:self)!;
		let localStream = self.createLocalMediaStream();
		self.peerConnection!.addStream(localStream);
		let dcCOnfig = RTCDataChannelInit();
		dcCOnfig.isOrdered = true;
		self.dataChannel = self.peerConnection!.createDataChannelWithLabel("presenter", config: dcCOnfig);
		self.peerConnection!.createOfferWithDelegate(self, constraints: self.defaultOfferConstraints());
		
	}
	
	
	public func makeCall(to: String) {
		
		self.isInitiator = true;
		self.startSignalingIfReady();
	}
	
	var hasJoinedRoomServerRoom : Bool {
		return !self.id.isNilOrEmpty();
	}
	
	public func disconnect() {
		if self.state == AppClientState.kAppClientStateDisconnected {
			return;
		}
		if self.hasJoinedRoomServerRoom {
			self.roomServerClient?.leaveRoomWithRoomId(locationId,clientId:id,completionHandler:nil);
		}
		
		if self.channel != nil {
			if self.channel!.state == SignalingChannelState.kSignalingChannelStateRegistered {
				// Tell the other client we're hanging up.
				let byeMessage = ByeMessage();
				self.channel!.sendMessage(byeMessage!);
			}
			// Disconnect from collider.
			self.channel = nil;
		}
		self.engineClient!.disconnect();
		self.id = "";
		self.locationId = "";
		self.isInitiator = false;
		self.hasReceivedSdp = false;
		self.messageQueue = NSMutableArray();
		self.peerConnection = nil;
		self.state = AppClientState.kAppClientStateDisconnected;
		
	}
	
	public func channel<T : SignalingChannel>(channel: T?, didStateChange state:SignalingChannelState) -> Void{
		switch (state) {
			
		case SignalingChannelState.kSignalingChannelStateError,
		SignalingChannelState.kSignalingChannelStateClosed:
			self.disconnect();
			break;
		default:
			print(state.getState(state));
			break;
		}
	}
	public func channel<T : SignalingChannel>(channel: T?, didReceiveMessage message: SignalingMessage) {
		
		switch (message.type) {
		case SignalingMessageType.kSignalingMessageTypeOffer,
		SignalingMessageType.kSignalingMessageTypeAnswer:
			// Offers and answers must be processed before any other message, so we
			// place them at the front of the queue.
			self.hasReceivedSdp = true;
			self.messageQueue!.insertObject(message, atIndex:0);
			break;
		case SignalingMessageType.kSignalingMessageTypeCandidate:
			self.messageQueue!.addObject(message);
			break;
		case SignalingMessageType.kSignalingMessageTypeBye:
			// Disconnects can be processed immediately.
			self.processSignalingMessage(message);
			return;
		default:
			print(String(format:"channel : %@", "something isnt right bruh"));
			break;
		}
		self.drainMessageQueueIfReady();
	}
	
	public func channel<T : KMSSignalingChannel>(channel: T?, didStateChange state:SignalingChannelState) -> Void{
		switch (state) {
			
		case SignalingChannelState.kSignalingChannelStateError,
		SignalingChannelState.kSignalingChannelStateClosed:
			self.disconnect();
			break;
		default:
			print(state.getState(state));
			break;
		}
	}
	public func channel<T : KMSSignalingChannel>(channel: T?, didReceiveMessage message: SignalingMessage) {
		
		switch (message.type) {
		case SignalingMessageType.kSignalingMessageTypeOffer,
		SignalingMessageType.kSignalingMessageTypeAnswer:
			// Offers and answers must be processed before any other message, so we
			// place them at the front of the queue.
			self.hasReceivedSdp = true;
			self.messageQueue!.insertObject(message, atIndex:0);
			break;
		case SignalingMessageType.kSignalingMessageTypeCandidate:
			self.messageQueue!.addObject(message);
			break;
		case SignalingMessageType.kSignalingMessageTypeBye:
			// Disconnects can be processed immediately.
			self.processSignalingMessage(message);
			return;
		default:
			print(String(format:"channel : %@", "something isnt right bruh"));
			break;
		}
		self.drainMessageQueueIfReady();
	}
	
	
	//	// Triggered when renegotiation is needed, for example the ICE has restarted.
	//	- (void)peerConnectionOnRenegotiationNeeded:(RTCPeerConnection *)peerConnection;
	public func peerConnectionOnRenegotiationNeeded(peerConnection: RTCPeerConnection) -> Void {
		print("WARNING: Renegotiation needed but unimplemented.");
		//		peerConnection.
	}
	
	// Called when creating a session.
	public func peerConnection(peerConnection: RTCPeerConnection,didCreateSessionDescription sdp:RTCSessionDescription,error: NSError?) -> Void {
		print("didCreateSessionDescription");
		//		println(error?.debugDescription);
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			
			if error != nil {
				print("disconnecting");
				self.disconnect();
				let userInfo = [NSLocalizedDescriptionKey:"Failed to create session description."];
				let sdpError = NSError(domain: kAppClientErrorDomain as String, code: kAppClientErrorCreateSDP, userInfo: userInfo);
				self.delegate!.appClient(self, didError: sdpError);
				return;
			}
			
			//			var _sdp = sdp.description.replace("VP8", withString: "H264");
			//			var sdpH264 = RTCSessionDescription(type:"offer",sdp:_sdp);
			let sdpH264 = SDPUtils.descriptionForDescription(sdp, preferredVideoCodec: "H264");
			self.peerConnection!.setLocalDescriptionWithDelegate(self, sessionDescription: sdpH264);
			let sessionDescriptionMessage = SessionDescriptionMessage(description: sdpH264);
			print(sessionDescriptionMessage?.sessionDescription.description);			//sdpH264.description
			//self.sendSignalingMessage(sessionDescriptionMessage!);
			//			self.engineClient!.registerPresenter(sessionDescriptionMessage!);
			//			self.engineClient!.call("e", message: sessionDescriptionMessage!);
			//			self.engineClient!.incomingCallResponse(sessionDescriptionMessage!);
			self.engineClient!.sendPresenterOffer(sessionDescriptionMessage!);
		}
	}
	
	public func peerConnection(peerConnection: RTCPeerConnection,didSetSessionDescriptionWithError error: NSError?) -> Void {
		print("didSetSessionDescriptionWithError");
		//		println(error?.debugDescription);
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			
			if error != nil {
				print(String(format:"Failed to set session description. Error: %@",error!));
				self.disconnect();
				let userInfo = [NSLocalizedDescriptionKey:"Failed to set session description."];
				let sdpError = NSError(domain: kAppClientErrorDomain as String, code: kAppClientErrorSetSDP, userInfo: userInfo);
				self.delegate!.appClient(self, didError: sdpError);
				return;
			}
			
			if !self.isInitiator && self.peerConnection!.localDescription == nil {
				//self.peerConnection!.localDescription
				self.peerConnection!.createAnswerWithDelegate(self, constraints: self.defaultAnswerConstraints());
			}
		}
	}
	
	// Triggered when the SignalingState changed.
	//	- (void)peerConnection:(RTCPeerConnection *)peerConnection
	// signalingStateChanged:(RTCSignalingState)stateChanged;
	public func peerConnection(peerConnection: RTCPeerConnection,signalingStateChanged stateChanged: RTCSignalingState) -> Void {
		print("WARNING: Renegotiation needed but unimplemented.");
		/*
		RTCSignalingStable,
		RTCSignalingHaveLocalOffer,
		RTCSignalingHaveLocalPrAnswer,
		RTCSignalingHaveRemoteOffer,
		RTCSignalingHaveRemotePrAnswer,
		RTCSignalingClosed,
		*/
		if stateChanged.rawValue == RTCSignalingStable.rawValue {
			print("RTCSignalingStable.");
		}else if stateChanged.rawValue == RTCSignalingHaveLocalOffer.rawValue  {
			print("RTCSignalingHaveLocalOffer.");
		}else if stateChanged.rawValue == RTCSignalingHaveLocalPrAnswer.rawValue  {
			print("RTCSignalingHaveLocalPrAnswer.");
		}else if stateChanged.rawValue == RTCSignalingHaveRemoteOffer.rawValue  {
			print("RTCSignalingHaveRemoteOffer.");
		}else if stateChanged.rawValue == RTCSignalingHaveRemotePrAnswer.rawValue  {
			print("RTCSignalingHaveRemotePrAnswer.");
		}else{
			print("RTCSignalingClosed.");
		}
		
	}
	
	//	// Triggered when media is received on a new stream from remote peer.
	//	- (void)peerConnection:(RTCPeerConnection *)peerConnection
	//	addedStream:(RTCMediaStream *)stream;
	public func peerConnection(peerConnection: RTCPeerConnection,addedStream stream: RTCMediaStream) -> Void {
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			print(String(format:"video: %@ Audio:%@",stream.videoTracks.count.description,stream.videoTracks.count.description));
			if stream.videoTracks.count > 0 {
				print("Stream was added.");
				let vt = stream.videoTracks[0] as! RTCVideoTrack;
				self.delegate!.appClient(self, didReceiveRemoteVideoTrack: vt);
			}
		}
	}
	
	//	// Triggered when a remote peer close a stream.
	//	- (void)peerConnection:(RTCPeerConnection *)peerConnection
	//	removedStream:(RTCMediaStream *)stream;
	public func peerConnection(peerConnection: RTCPeerConnection,removedStream stream: RTCMediaStream) -> Void {
		print("Stream was removed.");
	}
	//	// Called any time the ICEConnectionState changes.
	//	- (void)peerConnection:(RTCPeerConnection *)peerConnection
	//	iceConnectionChanged:(RTCICEConnectionState)newState;
	//
	public func peerConnection(peerConnection: RTCPeerConnection,iceConnectionChanged newState: RTCICEConnectionState) -> Void {
		//RTCLogEx(RTCLoggingSeverity.Verbose, String(format: "peerConnection(peerConnection: RTCPeerConnection,iceConnectionChanged newState: RTCICEConnectionState) -> Void {"));//, arguments:
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			print("iceConnectionChanged.");
			/*
			RTCICEConnectionNew,
			RTCICEConnectionChecking,
			RTCICEConnectionConnected,
			RTCICEConnectionCompleted,
			RTCICEConnectionFailed,
			RTCICEConnectionDisconnected,
			RTCICEConnectionClosed,
			
			*/
			if newState.rawValue == RTCICEConnectionNew.rawValue {
				print("RTCICEConnectionNew.");
			}else if newState.rawValue == RTCICEConnectionChecking.rawValue  {
				print("RTCICEConnectionChecking.");
			}else if newState.rawValue == RTCICEConnectionConnected.rawValue  {
				print("RTCICEConnectionConnected.");
			}else if newState.rawValue == RTCICEConnectionCompleted.rawValue  {
				print("RTCICEConnectionCompleted.");
			}else if newState.rawValue == RTCICEConnectionFailed.rawValue  {
				print("RTCICEConnectionFailed.");
			}else if newState.rawValue == RTCICEConnectionDisconnected.rawValue  {
				print("RTCICEConnectionDisconnected.");
			}else if newState.rawValue == RTCICEConnectionClosed.rawValue  {
				print("RTCICEConnectionClosed.");
			}
			
			self.delegate!.appClient(self, didChangeConnectionState: newState);
		}
	}
	
	//	// Called any time the ICEGatheringState changes.
	//	- (void)peerConnection:(RTCPeerConnection *)peerConnection
	//	iceGatheringChanged:(RTCICEGatheringState)newState;
	//
	public func peerConnection(peerConnection: RTCPeerConnection,iceGatheringChanged newState: RTCICEGatheringState) -> Void {
		print("iceGatheringChanged.");
		if newState.rawValue == RTCICEGatheringComplete.rawValue {
			print("RTCICEGatheringComplete.");
		}else if newState.rawValue == RTCICEGatheringNew.rawValue  {
			print("RTCICEGatheringNew.");
		}else if newState.rawValue == RTCICEGatheringGathering.rawValue  {
			print("RTCICEGatheringGathering.");
		}
	}
	//	// New Ice candidate have been found.
	//	- (void)peerConnection:(RTCPeerConnection *)peerConnection
	//	gotICECandidate:(RTCICECandidate *)candidate;
	//
	public func peerConnection(peerConnection: RTCPeerConnection,gotICECandidate candidate: RTCICECandidate) -> Void {
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			print("gotICECandidate.");
			//			self.sendSignalingMessage(ICECandidateMessage(candidate: candidate)!);
			self.onIceCandidate(ICECandidateMessage(candidate: candidate)!);
		}
		
	}
	
	//	// New data channel has been opened.
	//	- (void)peerConnection:(RTCPeerConnection*)peerConnection
	//	didOpenDataChannel:(RTCDataChannel*)dataChannel;
	
	public func peerConnection(peerConnection: RTCPeerConnection,didOpenDataChannel dataChannel: RTCDataChannel) -> Void {
		print("didOpenDataChannel.");
		
	}
	public func channel(channel: RTCDataChannel!, didReceiveMessageWithBuffer buffer: RTCDataBuffer!) {
		print("didreceiveDataChannel.");
	}
	public func channelDidChangeState(channel: RTCDataChannel!) {
		
	}
	// Called when the data channel state has changed.
	
	public func channel(channel: RTCDataChannel!, didChangeBufferedAmount amount: UInt) {
		
	}
	//
	public func onIceCandidate(message:ICECandidateMessage){
		
		self.engineClient!.sendMessage(message);
		
		//self.peerConnection!.addICECandidate(message.candidate);
	}
	
	
	// Begins the peer connection connection process if we have both joined a room
	// on the room server and tried to obtain a TURN server. Otherwise does nothing.
	// A peer connection object will be created with a stream that contains local
	// audio and video capture. If this client is the caller, an offer is created as
	// well, otherwise the client will wait for an offer to arrive.
	func startSignalingIfReady() {
		if !self.isTurnComplete || !self.hasJoinedRoomServer {
			return;
		}
		self.state = AppClientState.kAppClientStateConnected;
		let constraints = self.defaultPeerConnectionConstraints!;
		//bombs here
		let config = RTCConfiguration();
		config.iceServers = self.iceServers! as [AnyObject];
		//var pc : RTCPeerConnection;
		config.iceTransportsType = RTCIceTransportsType.All;
		config.bundlePolicy = RTCBundlePolicy.Balanced;
		config.rtcpMuxPolicy = RTCRtcpMuxPolicy.Negotiate;// kRTCRtcpMuxPolicyNegotiate
		self.peerConnection = self.factory!.peerConnectionWithConfiguration(config, constraints: constraints, delegate:self)!;
		let localStream = self.createLocalMediaStream();
		self.peerConnection!.addStream(localStream);
		
		if self.isInitiator {
			self.peerConnection!.createOfferWithDelegate(self, constraints: self.defaultOfferConstraints());
		}
		else {
			self.drainMessageQueueIfReady();
		}
		
	}
	
	func drainMessageQueueIfReady() {
		
		if self.peerConnection == nil || !self.hasReceivedSdp {
			print("self.peerConnection == nil || !self.hasReceivedSdp");
		}
		for message in self.messageQueue! {
			//message.
			self.processSignalingMessage(message as! SignalingMessage);
		}
		self.messageQueue?.removeAllObjects();
	}
	//
	
	func processSignalingMessage(message:SignalingMessage) -> Void {
		
		switch message.type {
		case SignalingMessageType.kSignalingMessageTypeAnswer,
		SignalingMessageType.kSignalingMessageTypeOffer:
			
			//			if self.peerConnection!.remoteDescription == nil {
			let sdp = message as! SessionDescriptionMessage;
			let description = sdp.sessionDescription;
			let sdpH264 = SDPUtils.descriptionForDescription(description, preferredVideoCodec: "H264");
			self.peerConnection!.setRemoteDescriptionWithDelegate(self, sessionDescription: sdpH264);
			print(sdpH264.description);
			//			}
			break;
			
		case SignalingMessageType.kSignalingMessageTypeCandidate:
			let cm = message as! ICECandidateMessage;
			print(cm.description);
			self.peerConnection!.addICECandidate(cm.candidate);
			break;
		case SignalingMessageType.kSignalingMessageTypeBye:
			self.disconnect();
			break;
		default:
			print("processSignalingMessage fall through");
			break;
		}
	}
	
	func sendSignalingMessage(message:SignalingMessage) {
		//		if self.isInitiator {
		//			weak var weakSelf = self;
		//			self.roomServerClient?.sendMessage(message, forRoomId: self.locationId, clientId: self.id,
		//				completionHandler: {
		//					(message, error) -> Void in
		//
		//					var strongSelf = weakSelf;
		//					if error != nil {
		//						strongSelf?.delegate?.appClient(strongSelf!, didError: error);
		//						return;
		//					}
		//					var messageError = strongSelf?.errorForMessageResultType(message!.result);
		//					if messageError != nil {
		//						strongSelf?.delegate?.appClient(strongSelf!, didError: messageError);
		//						return;
		//					}
		//			});
		//		} else {
		self.channel?.sendMessage(message);
		//		}
	}
	
	func registerWithColliderIfReady(){
		if !self.hasJoinedRoomServer {
			return;
		}
		if self.channel == nil {
			//			self.channel = WebSocketChannel(url: self.webSocketURL, restURL: self.webSocketRestURL, delegate: self);
			//self.channel = KMSWebSocketChannel(url: self.webSocketURL, restURL: self.webSocketRestURL, delegate: self);
		}
		//self.channel!.register(self.locationId, id: self.id);
	}
	
	func createLocalMediaStream() -> RTCMediaStream {
		let localStream = self.factory?.mediaStreamWithLabel("ARDAMS");
		let lvt = self.createLocalVideoTrack();
		if lvt != nil {
			localStream?.addVideoTrack(lvt);
			self.delegate?.appClient(self, didReceiveLocalVideoTrack: lvt!);
			self.delegate?.appClient(self, didReceiveRemoteVideoTrack: lvt!);
		}
		let s = self.factory?.audioTrackWithID("ARDAMSa0");
		localStream?.addAudioTrack(s);
		return localStream!;
	}
	
	func createLocalVideoTrack() -> RTCVideoTrack? {
		var localVideoTrack : RTCVideoTrack? = nil;
		let mediaConstraints = self.defaultMediaStreamConstraints();
		let source = RTCAVFoundationVideoSource(factory: self.factory, constraints: mediaConstraints);
		localVideoTrack = RTCVideoTrack(factory: self.factory, source: source!, trackId: "ARDAMSv0");
		return localVideoTrack;
	}
	
	func defaultMediaStreamConstraints() -> RTCMediaConstraints {
		let constraints  = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil);
		
		return constraints;
	}
	
	//MARK:
	func defaultAnswerConstraints() -> RTCMediaConstraints {
		return self.defaultOfferConstraints();
	}
	
	//MARK:
	func defaultOfferConstraints() -> RTCMediaConstraints {
		//	var optionalConstraints : [RTCPair] = [ RTCPair(key:"DtlsSrtpKeyAgreement",value: "true")];
		let mandatoryConstraints : [RTCPair] = [ RTCPair(key:"OfferToReceiveAudio",value: "true"), RTCPair(key:"OfferToReceiveVideo",value:"true")];
		return RTCMediaConstraints(mandatoryConstraints: mandatoryConstraints as [AnyObject], optionalConstraints: nil);
	}
	
	//	func defaultOfferConstraints2() -> RTCMediaConstraints {
	//		var optionalConstraints : [RTCPair] = [ RTCPair(key:"DtlsSrtpKeyAgreement",value: "true")];
	//		var mandatoryConstraints : [RTCPair] = [ RTCPair(key:"OfferToReceiveAudio",value: "false"), RTCPair(key:"OfferToReceiveVideo",value:"false")];
	//		return RTCMediaConstraints(mandatoryConstraints: mandatoryConstraints as [AnyObject], optionalConstraints: optionalConstraints);
	//	}
	
	//MARK:
	public var defaultPeerConnectionConstraints : RTCMediaConstraints? {
		get
		{
			if self._defaultPeerConnectionConstraints == nil {
				
				let optionalConstraints : [RTCPair] = [ RTCPair(key:"DtlsSrtpKeyAgreement",value: "true")];
				self._defaultPeerConnectionConstraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: optionalConstraints);
			}
			return  self._defaultPeerConnectionConstraints;
		}
	}
	
	public var defaultSTUNServer : RTCICEServer? {
		get
		{
			let defaultSTUNServerURL = NSURL(string: kDefaultSTUNServerUrl as String);
			return RTCICEServer(URI: defaultSTUNServerURL, username: "", password: "");
		}
	}
	
	
	func errorForJoinResultType(jrt:JoinResultType) -> NSError? {
		var e : NSError? = nil;
		
		switch jrt {
		case JoinResultType.kJoinResultTypeUnknown:
			e = NSError(domain: kAppClientErrorDomain as String, code: kAppClientErrorUnknown, userInfo: [NSLocalizedDescriptionKey:"Unknown error."]);
		case JoinResultType.kJoinResultTypeFull:
			e = NSError(domain: kAppClientErrorDomain as String, code: kAppClientErrorRoomFull, userInfo: [NSLocalizedDescriptionKey:"Room is full"]);
		default:
			break;
		}
		return e;
	}
	
	func errorForMessageResultType(jrt:MessageResultType) -> NSError? {
		var e : NSError? = nil;
		
		switch jrt {
		case MessageResultType.kMessageResultTypeUnknown:
			e = NSError(domain: kAppClientErrorDomain as String, code: kAppClientErrorUnknown, userInfo: [NSLocalizedDescriptionKey:"Unknown error."]);
		case MessageResultType.kMessageResultTypeInvalidClient:
			e = NSError(domain: kAppClientErrorDomain as String, code: kAppClientErrorInvalidClient, userInfo: [NSLocalizedDescriptionKey:"Invalid client"]);
		case MessageResultType.kMessageResultTypeInvalidRoom:
			e = NSError(domain: kAppClientErrorDomain as String, code: kAppClientErrorInvalidRoom, userInfo: [NSLocalizedDescriptionKey:"invalid room"]);
		default:
			break;
		}
		return e;
	}
}













