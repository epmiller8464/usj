import Foundation


public class WebSocketChannel : NSObject , SignalingChannel, SRWebSocketDelegate{
	
	static let kMessageErrorKey : NSString = "error";
	static let kMessagePayloadKey :NSString = "msg";

	private var _webSocket : SRWebSocket?;
	private var _url : NSURL? = nil;
	private var _restUrl : NSURL? = nil;
	
	private var _locationId : NSString = "";
	private var _id : NSString = "";
	private var _state : SignalingChannelState? = nil;
	private var _delegate : protocol<SignalingChannelDelegate>? = nil;
	
	
	
	public var locationId : NSString {get{ return self._locationId;}}
	
	public var id : NSString {get{ return self._id;}}
	
	public var state : SignalingChannelState? {get{ return self._state;}}
	
	public var delegate : protocol<SignalingChannelDelegate>? {
		get{
			return self._delegate;
		}
		set{
			self._delegate = newValue
		}
	}
	
	override	init(){
		super.init();
		
	}
	
	convenience init(url: NSURL?,restURL:NSURL?,delegate:protocol<SignalingChannelDelegate>?){
		self.init();
		
		self._url = url!;
		self._restUrl = restURL!;
		self._delegate = delegate;
		
		if self._webSocket != nil {
			
			self._webSocket!.delegate = nil;
			self._webSocket = nil;
		}
		
		self._webSocket = SRWebSocket(URLRequest: NSURLRequest(URL:self._url!));// NSURL(string: "ws://localhost:8181/call")!));
		self._webSocket!.delegate = self;
		//RTCLog(@"Opening WebSocket.");
		print("opening web socket");
		self._webSocket!.open();
		//	self.connectWebSocket();
	}
	
	deinit{
		self.disconnect();
	}
	
	func setState(state:SignalingChannelState){
		
		if self._state == state {
			return;
		}
		self._state = state;
//		self._delegate?.channel(self, didStateChange:self._state!);
	}
	public func register(lid: NSString, id: NSString) {

		self._locationId = lid;
		self._id = id;
		if self._state != nil && self._state == SignalingChannelState.kSignalingChannelStateOpen {
			self.registerWithCollider();
		}
	}
	
	
	//	// Sends message over the WebSocket connection if registered, otherwise POSTs to
	//	// the web socket server instead.
	//	- (void)sendMessage:(ARDSignalingMessage *)message;
	public func sendMessage(message: SignalingMessage) -> Void{
		//		NSParameterAssert(_clientId.length);
		//  NSParameterAssert(_roomId.length);
		//  NSData *data = [message JSONData];
		let data = message.JSONData();
		let payload = NSString(data: data!, encoding: NSUTF8StringEncoding);
		if self.state == SignalingChannelState.kSignalingChannelStateRegistered {
			
			//var msgData = msgStr!.dataUsingEncoding(NSUTF8StringEncoding);
			let msgObj = try? NSJSONSerialization.dataWithJSONObject(["cmd":"send","msg":payload!], options: NSJSONWritingOptions.PrettyPrinted);
			let msgStr = NSString(data: msgObj!, encoding: NSUTF8StringEncoding);
			print(NSString(format:"C->WSS: %@", msgStr!));
						self._webSocket?.send(msgStr);
			
		}else{
			print(NSString(format:"C->post: %@", payload!));
			let urlString = NSString(format:"%@/%@/%@",self._restUrl!.absoluteString,self._locationId,self._id);
			let urls = NSURL(string: urlString as String )!;
			NSURLConnection.sendAsyncPostToURL(urls, withData: data!, completionHandler: nil);
			
		}
		
	}
	
	func disconnect(){
		if self.state == SignalingChannelState.kSignalingChannelStateError ||
			self.state == SignalingChannelState.kSignalingChannelStateClosed {
				return;
		}
		self._webSocket?.close();
		
		let urlString = NSString(format:"%@/%@/%@",self._restUrl!.absoluteString,self.locationId,self.id);
		let url = NSURL(string: urlString as String )!;
		let request  = NSMutableURLRequest(URL: url);
		request.HTTPMethod = "DELETE";
		request.HTTPBody = nil;
		NSURLConnection.sendAsyncRequest(request,completionHandler: nil);
		
	}
	
	public func webSocketDidOpen(webSocket: SRWebSocket!) {
		print("webSocket connection opened");
		self._state = SignalingChannelState.kSignalingChannelStateOpen;
		if self.locationId.length > 0 && self.id.length > 0 {
			registerWithCollider();
		}
	}
	
	public func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
		//<#code#>
		print(message);
		let msgStr = message as! NSString?;
		let msgData = msgStr!.dataUsingEncoding(NSUTF8StringEncoding);
		let jsonObj : AnyObject? = try? NSJSONSerialization.JSONObjectWithData(msgData!, options: NSJSONReadingOptions());
		
		if !(jsonObj! is NSDictionary) {
			print("WebSocket error: unexpected message");
			return;
		}
		let wssMessage = jsonObj! as! NSDictionary;
		let errorString = wssMessage[WebSocketChannel.kMessageErrorKey] as! NSString?;
		
		if errorString != nil {
			print("wss error: \(errorString!)");
			return;
		}
		
		let payload = wssMessage[WebSocketChannel.kMessagePayloadKey] as! NSString?;
		let sm = SignalingMessage.messageFromJSONString(payload!);
		print("payload: \(payload)");
		
//		self._delegate!.channel(self, didReceiveMessage: sm!);
	}
	
	public func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
		print("WebSocket error: \(error)");
		self._state = SignalingChannelState.kSignalingChannelStateError;
		//self.connectWebSocket();
	}
	public func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
		//self._webSocket = webSocket!;
		print("WebSocket closed with code: \(code) reason:\(reason!) wasClean:\(wasClean)")
		
		self._state = SignalingChannelState.kSignalingChannelStateClosed;
		//self.webSocket?.close()
		//self.connectWebSocket();
	}
	
	func registerWithCollider(){
		if self._state == SignalingChannelState.kSignalingChannelStateRegistered {
			return;
		}
		let regMessage = ["cmd":"register","roomId": self.locationId , "clientId" : self.id];
		let msg = try? NSJSONSerialization.dataWithJSONObject(regMessage, options: NSJSONWritingOptions.PrettyPrinted);
		let msgStr =	 NSString(data: msg!, encoding: NSUTF8StringEncoding);
		self._webSocket!.send(msgStr);
		self._state = SignalingChannelState.kSignalingChannelStateRegistered;
	}
}













