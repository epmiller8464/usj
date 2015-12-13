//
//  LaunchViewController.swift
//  usj
//
//  Created by ghostmac on 12/12/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import UIKit

class LaunchViewPageController: UIViewController,UIPageViewControllerDelegate,UINavigationControllerDelegate {
	
	var pageViewController: UIPageViewController?
	@IBOutlet weak var pagerControl : UIPageControl?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		// Configure the page view controller and add it as a child view controller.
		self.pageViewController = UIPageViewController(transitionStyle: ., navigationOrientation: .Horizontal, options: nil)
		self.pageViewController!.delegate = self
		
		let startingViewController = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!)!
		let viewControllers = [startingViewController]
		self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })
		
		self.pageViewController!.dataSource = self.modelController
		
		self.addChildViewController(self.pageViewController!)
		self.view.addSubview(self.pageViewController!.view)
		
		// Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
		var pageViewRect = self.view.bounds
		if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
			pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0)
		}
		self.pageViewController!.view.frame = pageViewRect
		
		self.pageViewController!.didMoveToParentViewController(self)
		
		// Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
		self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	var modelController: LaunchViewPageModel {
		// Return the model controller object, creating it if necessary.
		// In more complex implementations, the model controller may be passed to the view controller.
		if _modelController == nil {
			_modelController = LaunchViewPageModel()
		}
		return _modelController!
	}
	
	var _modelController: LaunchViewPageModel? = nil
	
	// MARK: - UIPageViewController delegate methods
	
	func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
		if (orientation == .Portrait) || (orientation == .PortraitUpsideDown) || (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
			// In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so set it to false here.
			let currentViewController = self.pageViewController!.viewControllers![0]
			let viewControllers = [currentViewController]
			self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })
			
			self.pageViewController!.doubleSided = false
			return .Min
		}
		
		// In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
		let currentViewController = self.pageViewController!.viewControllers![0] 
		var viewControllers: [UIViewController]
		
		let indexOfCurrentViewController = self.modelController.indexOfViewController(currentViewController)
		if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
			let nextViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerAfterViewController: currentViewController)
			viewControllers = [currentViewController, nextViewController!]
		} else {
			let previousViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerBeforeViewController: currentViewController)
			viewControllers = [previousViewController!, currentViewController]
		}
		self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })
		
		return .Mid
	}



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
