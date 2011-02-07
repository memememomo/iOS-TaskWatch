//
//  Helper.m
//  TaskWatch2
//
//  Created by Your Name on 11/02/07.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "Helper.h"


void UIAlertViewQuick(NSString* title, NSString* message, NSString* dismissButtonTitle) 
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:nil 
										  cancelButtonTitle:dismissButtonTitle
										  otherButtonTitles:nil
						  ];
	[alert show];
	[alert autorelease];
}


UINavigationController* createNavControllerWrappingViewControllerOfClass(Class controller, NSString* nibName, NSString* iconName, NSString* tabTitle)
{
	UIViewController* viewController = [[controller alloc] initWithNibName:nibName bundle:nil];
	
	UINavigationController *theNavigationController;
	theNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	viewController.tabBarItem.image = [UIImage imageNamed:iconName];
	viewController.title = NSLocalizedString(tabTitle, @""); 
	[viewController release];
	
	return theNavigationController;
}

UINavigationController* createNavControllerWrappingTableViewControllerOfClass(Class controller, NSString* iconName, NSString* tabTitle)
{
	UITableViewController* tableViewController = [[controller alloc] init];
	
	UINavigationController *theNavigationController;
	theNavigationController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
	tableViewController.tabBarItem.image = [UIImage imageNamed:iconName];
	tableViewController.title = NSLocalizedString(tabTitle, @""); 
	[tableViewController release];
	
	return theNavigationController;
}



@implementation Helper
@end
