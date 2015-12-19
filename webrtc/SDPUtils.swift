//
//  SDPUtils.swift
//  webrtc
//
//  Created by ghostmac on 8/4/15.
//  Copyright (c) 2015 ghostmac. All rights reserved.
//

import Foundation

public protocol SDPUtilsProtocol : AnyObject {
	
	static func descriptionForDescription(description:RTCSessionDescription!,preferredVideoCodec codec:NSString) -> RTCSessionDescription;
}


public class SDPUtils : SDPUtilsProtocol {
	
	public static func descriptionForDescription(description: RTCSessionDescription!, preferredVideoCodec codec: NSString) ->  RTCSessionDescription {
		
		//		dispatch_async(queue: dispatch_queue_t.self) { () -> Void in
		//			//	<#code#>
		//		}
		
		
		//		NSString *sdpString = description.description;
		//  NSString *lineSeparator = @"\n";
		//  NSString *mLineSeparator = @" ";
		
		let sdpString = description.description, lineSeparator = "\n" ,mLineSeparator : NSString  = " ";
		//  // Copied from PeerConnectionClient.java.
		//  // TODO(tkchin): Move this to a shared C++ file.
		//  NSMutableArray *lines =
		//		[NSMutableArray arrayWithArray:
		//		[sdpString componentsSeparatedByString:lineSeparator]];
		let lines  = NSMutableArray(array: sdpString!.componentsSeparatedByString(lineSeparator));
		//  NSInteger mLineIndex = -1;
		var mLineIndex = -1
		//  NSString *codecRtpMap = nil;
		var codecRtpMap : NSString? = nil;
		
		//  // a=rtpmap:<payload type> <encoding name>/<clock rate>
		//  // [/<encoding parameters>]
		//  NSString *pattern =
		//		[NSString stringWithFormat:@"^a=rtpmap:(\\d+) %@(/\\d+)+[\r]?$", codec];
		let pattern  = String(format:"^a=rtpmap:(\\d+) %@(/\\d+)+[\r]?" ,codec);
		
		//  NSRegularExpression *regex =
		//		[NSRegularExpression regularExpressionWithPattern:pattern
		//		options:0
		//		error:nil];
		
		let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions());
		
		//  for (NSInteger i = 0; (i < lines.count) && (mLineIndex == -1 || !codecRtpMap);
		//		++i) {
		//			NSString *line = lines[i];
		//			if ([line hasPrefix:@"m=video"]) {
		//				mLineIndex = i;
		//				continue;
		//			}
		//			NSTextCheckingResult *codecMatches =
		//				[regex firstMatchInString:line
		//					options:0
		//					range:NSMakeRange(0, line.length)];
		//			if (codecMatches) {
		//				codecRtpMap =
		//					[line substringWithRange:[codecMatches rangeAtIndex:1]];
		//				continue;
		//			}
		//  }
		for var i : NSInteger = 0; (i < lines.count) && (mLineIndex == -1); ++i {
			
			let line = lines[i] as! NSString;
			if line.hasPrefix("m=video") {
				mLineIndex = i;
				continue;
			}
			let codecMatches  = regex?.firstMatchInString(line as String, options: NSMatchingOptions(), range: NSMakeRange(0,line.length));
			if codecMatches != nil {
				codecRtpMap = line.substringWithRange(codecMatches!.rangeAtIndex(1));
				continue;
			}
		}
		/*
		//a=rtpmap:107 H264/90000
		//a=rtcp-fb:107 ccm fir
		//a=rtcp-fb:107 nack
		//a=rtcp-fb:107 nack pli
		//a=rtcp-fb:107 goog-remb
		*/
		
//		a=ice-options:trickle
		
		//  if (mLineIndex == -1) {
		//	RTCLog(@"No m=video line, so can't prefer %@", codec);
		//	return description;
		//  }
		
		if mLineIndex == -1 {
			print(String(format: "No m=video line, so can't prefer %@", codec));
			return description;
		}
		
		//  if (!codecRtpMap) {
		//	RTCLog(@"No rtpmap for %@", codec);
		//	return description;
		//  }
		if codecRtpMap == nil {
			print(String(format: "No rtpmap for %@", codec));
			return description;
		}
		//  NSArray *origMLineParts =
		//	[lines[mLineIndex] componentsSeparatedByString:mLineSeparator];
		var origMLineParts = lines[mLineIndex].componentsSeparatedByString(mLineSeparator as String);
		
		//  if (origMLineParts.count > 3) {
		if origMLineParts.count > 3 {
			//	NSMutableArray *newMLineParts =
			//		[NSMutableArray arrayWithCapacity:origMLineParts.count];
			let	newMLineParts = NSMutableArray(capacity: origMLineParts.count);
			//	NSInteger origPartIndex = 0;
			var origPartIndex = 0;
			//	// Format is: m=<media> <port> <proto> <fmt> ...
			//	[newMLineParts addObject:origMLineParts[origPartIndex++]];
			newMLineParts.addObject(origMLineParts[origPartIndex++]);
			//	[newMLineParts addObject:origMLineParts[origPartIndex++]];
			newMLineParts.addObject(origMLineParts[origPartIndex++]);
			//	[newMLineParts addObject:origMLineParts[origPartIndex++]];
			newMLineParts.addObject(origMLineParts[origPartIndex++]);
			//	[newMLineParts addObject:codecRtpMap];
			newMLineParts.addObject(codecRtpMap!);
			//	for (; origPartIndex < origMLineParts.count; ++origPartIndex) {
			for (; origPartIndex < origMLineParts.count; ++origPartIndex) {
				//		if (![codecRtpMap isEqualToString:origMLineParts[origPartIndex]]) {
				if !(codecRtpMap! == origMLineParts[origPartIndex]) {
					
					newMLineParts.addObject(origMLineParts[origPartIndex]);
				}
			}
			//	NSString *newMLine =
			//		[newMLineParts componentsJoinedByString:mLineSeparator];
			let newMLine = newMLineParts.componentsJoinedByString(mLineSeparator as String);
			//	[lines replaceObjectAtIndex:mLineIndex
			//		withObject:newMLine];
			lines.replaceObjectAtIndex(mLineIndex, withObject: newMLine);
			//} else {
			//	RTCLogWarning(@"Wrong SDP media description format: %@", lines[mLineIndex]);
			//  }
		}else {
			
			print(String(format:"Wrong SDP media description format: %@",lines[mLineIndex] as! String));
			
		}
		//  NSString *mangledSdpString = [lines componentsJoinedByString:lineSeparator];
		let mangledSdpString = lines.componentsJoinedByString(lineSeparator);
		//  return [[RTCSessionDescription alloc] initWithType:description.type
		//	sdp:mangledSdpString];
		return RTCSessionDescription(type: description.type,sdp: mangledSdpString);
	}
}