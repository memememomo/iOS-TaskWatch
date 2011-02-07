//
//  TaskCategoryTable.h
//  TaskWatch
//
//  Created by Your Name on 11/01/21.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultCoreData.h"
#import "TaskCategoryTableDetail.h"

@interface TaskCategoryTable : UITableViewController {
	SimpleCoreData *logCoreData_;
	SimpleCoreData *categoryCoreData_;
}

@end
