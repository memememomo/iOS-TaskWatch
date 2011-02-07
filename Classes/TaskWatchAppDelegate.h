//
//  TaskWatchAppDelegate.h
//  TaskWatch
//
//  Created by Your Name on 11/02/07.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskWatchAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate> {
    UIWindow *window_;
	UITabBarController *tabBarController_;
}

@end

