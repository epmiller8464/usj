//
//  RTCICEServer+JSON.swift
//  webrtc
//
//  Created by ghostmac on 8/4/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//

import Foundation


import Foundation

public extension RTCICEServer  {
	
	
	public static func serverFromJSONDictionary(dict:NSDictionary) -> RTCICEServer {
		
		let url = dict[Utility.kRTCICEServerUrlKey] as! NSString;
		var username = dict[Utility.kRTCICEServerUsernameKey] as! NSString ;
		var credential = dict[Utility.kRTCICEServerCredentialKey] as! NSString;
		
		username = isNilOrEmpty(username) ? username:"";
		credential = isNilOrEmpty(credential) ? credential:"";
		
		return RTCICEServer(URI: NSURL(string: url as String)! , username: username as String, password: credential as String);
	}
	
	public static func serversFromCEODJSONDictionary(dict:NSDictionary) -> NSArray {
		
		let username = dict[Utility.kRTCICEServerUsernameKey] as! NSString ;
		let password = dict[Utility.kRTCICEServerPasswordKey] as! NSString;
		
		let uris = dict[Utility.kRTCICEServerUrisKey] as! NSArray;
		let servers = NSMutableArray(capacity: uris.count);
		
		for uri in uris {
			
			let server = RTCICEServer(URI: NSURL(string: uri as! String)! , username: username as String, password: password as String);
			//			servers.
			servers.addObject(server);
		}
		
		return servers;
	}
	
}