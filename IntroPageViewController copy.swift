//
//  ModelController.swift
//  t
//
//  Created by ghostmac on 12/12/15.
//  Copyright © 2015 ghostmac. All rights reserved.
//

import UIKit

/*
A controller object that manages a simple model -- a collection of month names.

The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.

There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
*/


class IntroPageViewController: NSObject, UIPageViewControllerDataSource {
	
	var pageData: [String] = ["MobileConfirmationViewController","CodeConfirmationViewController","CoreDetailsViewController","UserDetailsViewController"]
	
	
	override init() {
		super.init()
		// Create the data model.
//		let dateFormatter = NSDateFormatter()
//		pageData = dateFormatter.monthSymbols
	}
	
	func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> UIViewController? {
		// Return the data view controller for the given index.
		if (self.pageData.count == 0) || (index >= self.pageData.count) {
			return nil
		}
		let controllerName = pageData[index] as String;
		let viewController = storyboard.instantiateViewControllerWithIdentifier(controllerName)
		
		// Create a new view controller and pass suitable data.

//		viewController.dataObject = self.pageData[index]
		return viewController
	}
	
	func indexOfViewController(viewController: UIViewController) -> Int {
		// Return the index of the given data view controller.
		// For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
//		self.
		var stringLookUp = ""
		
		switch viewController {
		case is MobileConfirmationViewController:
			stringLookUp = MobileConfirmationViewController.self.description();
			break
		case is CodeConfirmationViewController:
			stringLookUp = CodeConfirmationViewController.self.description();
			break
		case is CoreDetailsViewController:
			stringLookUp = CoreDetailsViewController.self.description();
			break
		case is UserDetailsViewController:
			stringLookUp = UserDetailsViewController.self.description();
			break
		default:
			break
		}
		
		return pageData.indexOf(stringLookUp) ?? NSNotFound
	}
	
	// MARK: - Page View Controller Data Source
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		var index = self.indexOfViewController(viewController)
		if (index == 0) || (index == NSNotFound) {
			return nil
		}
		viewController.superclass?.description()
		index--
		return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		var index = self.indexOfViewController(viewController)
		if index == NSNotFound {
			return nil
		}
		
		index++
		if index == self.pageData.count {
			return nil
		}
		return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
	}
	
}

