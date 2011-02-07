//
//  TaskWatchLog.h
//  TaskWatch
//
//  Created by Your Name on 11/02/07.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleCoreDataFactory.h"
#import "ConfigData.h"

@interface TaskWatchLog : UITableViewController {
	ConfigData *configData_;
	
	SimpleCoreData *logCoreData_;
	SimpleCoreData *categoryCoreData_;
}

@property (nonatomic, retain) ConfigData *configData;

- (void)initCoreData;
- (NSManagedObject *)fetchCategoryInfo:(NSInteger)categoryId;

@end
