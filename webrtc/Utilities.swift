//
//  Utilities.swift
//  webrtc
//
//  Created by ghostmac on 8/4/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//

import Foundation
import UIKit
public class Utility {
	
	/* #RTCICEServer	*/
	public static let kRTCICEServerUsernameKey :NSString = "username";
	public static let  kRTCICEServerPasswordKey : NSString = "password";
	public static let kRTCICEServerUrisKey :NSString = "uris";
	public static let kRTCICEServerUrlKey :NSString = "urls";
	public static let kRTCICEServerCredentialKey :NSString = "credential";
	
	/* #RTCIceCandidate+JSON */
	public static let  kRTCICECandidateTypeKey : NSString = "type";
	public static let  kRTCICECandidateTypeValue : NSString = "candidate";
	public static let  kRTCICECandidateMidKey : NSString = "id";
	public static let  kRTCICECandidateMLineIndexKey : NSString = "label";
	public static let  kRTCICECandidateSdpKey : NSString = "candidate";
	
	/* #RTCMediaConstraints*/
	public static let kRTCMediaConstraintsMandatoryKey : NSString = "mandatory";
	
	public static let kSignalingMessageTypeKey: NSString = "type";
	
	public static let kRTCSessionDescriptionTypeKey : NSString = "type";
	public static let kRTCSessionDescriptionSdpKey : NSString = "sdp";
	
	public static let kJoinResultKey : NSString = "result";
	public static let kJoinResultParamsKey : NSString  = "params";
	public static let kJoinInitiatorKey : NSString = "is_initiator";
	public static let kJoinRoomIdKey : NSString = "room_id";
	public static let kJoinClientIdKey : NSString = "client_id";
	public static let kJoinMessagesKey : NSString = "messages";
	public static let kJoinWebSocketURLKey : NSString = "wss_url";
	public static let kJoinWebSocketRestURLKey : NSString = "wss_post_url";
	public static let kMessageResultKey : NSString =  "result"
	

	
	/*ARDAppClient*/

	
}




public extension NSDictionary {
	
	public static func dictionaryWithJSONString(jsonString:NSString?) -> NSDictionary? {
		let data = jsonString!.dataUsingEncoding(NSUTF8StringEncoding);
		let error = NSErrorPointer();// = nil;
		var dict : AnyObject? = nil;

		do{
			
			try	dict = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions());// as!
			
		}catch{
			
		}
		if error != nil {
			print(error);
		}
		
		return dict as? NSDictionary;
	}
	
	public static func dictionaryWithJSONData(jsonData:NSData?) -> NSDictionary?{
		
		let error = NSErrorPointer();// = nil;
		var dict : AnyObject? = nil;
		
		do{
			
			try dict = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions());
			
		}catch{
			
		}

		if error != nil {
			print(error);
		}
	
		return dict as? NSDictionary;
	}
}

public extension NSURLConnection {
	
	
	public static func sendAsyncRequest(request:NSURLRequest,completionHandler: ((response: NSURLResponse?, data:NSData?,error:NSError?) -> Void)?) -> Void {
		
		///kick off async request which will call back on the main thread.
		NSURLConnection.sendAsynchronousRequest(request,
			queue: NSOperationQueue.mainQueue(),
			completionHandler: {(r:NSURLResponse?, d:NSData?,e: NSError?) in
				if completionHandler != nil {
					completionHandler!(response:r,data:d,error:e);
				}
		});
	}
	
	
	public static func sendAsyncPostToURL(url:NSURL?,withData data: NSData?,completionHandler: ((succeeded:Bool,data:NSData?) -> Void)?) -> Void {
		
		let request = NSMutableURLRequest(URL:url!);
		request.HTTPMethod = "POST";
		request.HTTPBody = data;
		
		self.sendAsyncRequest(request, completionHandler: { (response, d, error) -> Void in
			//			<#code#>
			
			let hasHandler = completionHandler != nil;
			
			if error != nil{
				print("Error posting data: \(error!.localizedDescription)");
				if hasHandler {
					completionHandler!(succeeded:false,data:d!);
				}
				return;
			}
			
			let httpResponse = response as! NSHTTPURLResponse;
			
			if httpResponse.statusCode != 200{
				
				var serverResponse : NSString? = data?.length > 0 ? NSString(data: d!, encoding: NSUTF8StringEncoding) : nil;
				print("Received bad response");
				
				
				if hasHandler {
					completionHandler!(succeeded:false,data:d!);
				}
				return;
			}
			if hasHandler {
				completionHandler!(succeeded:true,data:d!);
			}
		});
	}
}


public extension UIImage {
	
	public static func imageForName(name: NSString,color: UIColor) -> UIImage? {
	//		UIImage *image = [UIImage imageNamed:name];
	//  if (!image) {
	//	return nil;
	//  }
	//  UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
	//  [color setFill];
	//  CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
	//  UIRectFill(bounds);
	//  [image drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
	//  UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
	//  UIGraphicsEndImageContext();
	//		
	//  return coloredImage;
		let image = UIImage(named: name as String);
		if image == nil {
			return nil;
		}
		UIGraphicsBeginImageContextWithOptions(image!.size,false,0.0);
		color.setFill();
		let bounds = CGRectMake(0,0, image!.size.width,image!.size.height);
		UIRectFill(bounds);
		image!.drawInRect(bounds, blendMode: CGBlendMode.DestinationIn, alpha: 1.0);
		let coloredImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return coloredImage;
	}
}










