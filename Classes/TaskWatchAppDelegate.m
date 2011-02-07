//
//  TaskWatchAppDelegate.m
//  TaskWatch
//
//  Created by Your Name on 11/02/07.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "TaskWatchAppDelegate.h"
#import "TaskWatchSetting.h"
#import "TaskWatchLog.h"
#import "DefaultCoreData.h"
#import "TotalizeView.h"
#import "TaskCategoryTable.h"

@implementation TaskWatchAppDelegate



#pragma mark -
#pragma mark For TableView in TabBar

- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController animated:(BOOL)animated 
{
	[viewController viewWillAppear:animated];
}


- (void)navigationController:(UINavigationController *)navigationController 
	   didShowViewController:(UIViewController *)viewController animated:(BOOL)animated 
{
	[viewController viewDidAppear:animated];
}



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application 
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
	CGRect frame = [[UIScreen mainScreen] bounds];
	window_ = [[UIWindow alloc] initWithFrame:frame];
	

	// CoreDataの初期化
    SimpleCoreDataFactory *factory = [SimpleCoreDataFactory sharedCoreData];
	factory.xcdatamodelName = @"StopWatch";
	factory.sqliteName = @"StopWatch";
	
	
	// タブバーの設定
	NSMutableArray *controllers = [[NSMutableArray alloc] init];
	UINavigationController *localNavigationController;
	
	tabBarController_ = [[UITabBarController alloc] init];
	tabBarController_.delegate = self;

	
	// 計測設定画面
	localNavigationController = 
		createNavControllerWrappingViewControllerOfClass([TaskWatchSetting class],
														 @"TaskWatchSetting",
														 @"clock.png",
														 LOCALIZE(@"TITLE_WATCH_SETTING"));
	[controllers addObject:localNavigationController];
	[localNavigationController release];
	
	
	// 集計
	localNavigationController =
		createNavControllerWrappingTableViewControllerOfClass([TotalizeView class],
															  @"totalize.png",
															  LOCALIZE(@"TOTALIZE"));
	[controllers addObject:localNavigationController];
	[localNavigationController release];
	
	
	// ログ
	localNavigationController =
		createNavControllerWrappingViewControllerOfClass([TaskWatchLog class], 
														 nil,
														 @"bag.png",
														 LOCALIZE(@"LOG"));
	[controllers addObject:localNavigationController];
	[localNavigationController release];
	
	
	// カテゴリ
	localNavigationController =
		createNavControllerWrappingTableViewControllerOfClass([TaskCategoryTable class],
															  @"category.png",
															  LOCALIZE(@"CATEGORY_LABEL"));
	[controllers addObject:localNavigationController];
	[localNavigationController release];
	
	
	
	[tabBarController_ setViewControllers:controllers];
	[controllers release];													  
	
	
	[window_ addSubview:tabBarController_.view];
    [window_ makeKeyAndVisible];
	
	
	// テストデータ
	//[DefaultCoreData deleteTestData];
	//[DefaultCoreData insertTestData];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[tabBarController_ release];
    [window_ release];
    [super dealloc];
}


@end
