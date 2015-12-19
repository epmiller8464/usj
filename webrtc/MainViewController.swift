
import Foundation
import UIKit


public protocol MainViewControllerProtocol {
	func applicationWillResignActive(application: UIApplication) -> Void;
}


public class MainViewController : UIViewController, MainViewDelegate, MainViewControllerProtocol {
	
	
	
	public override func loadView() {
		let mainView = MainView(frame: CGRectZero);
		mainView.delegate = self;
		self.view = mainView;
	}
	
	public func mainView(mainView: MainView, didInputRoom room: String) {
		
		if room.isNilOrEmpty() {
			return;
		}
		
		let trimmedRoom = room.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
		
		let error = NSErrorPointer();// = nil;
		var regex: NSRegularExpression?
		do {
			regex = try NSRegularExpression(pattern: "\\w+", options: NSRegularExpressionOptions.CaseInsensitive)
		} catch let error1 as NSError {
			error.memory = error1
			regex = nil
		};
		
		if error != nil {
			self.showAlertWithMessage("Invalid room name.");
			return;
		}
		
		let matchRange : NSRange = regex!.rangeOfFirstMatchInString(trimmedRoom, options: NSMatchingOptions(), range: NSMakeRange(0,room.length));
		
		if matchRange.location == NSNotFound || matchRange.length != room.length {
			self.showAlertWithMessage("Invalid room name.");
			return;
		}
		
		let videoCallViewController = VideoCallViewController(room: trimmedRoom);
		videoCallViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve;
		self.presentViewController(videoCallViewController, animated: true, completion: nil);
	}
	
	public func applicationWillResignActive(application: UIApplication) {
		self.dismissViewControllerAnimated(false, completion: nil);
	}
	
	func showAlertWithMessage(message:NSString){
		let alertView = UIAlertView(title: nil, message: message as String, delegate: nil, cancelButtonTitle: "Ok");
		alertView.show();
	}
}
