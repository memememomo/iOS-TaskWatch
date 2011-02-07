//
//  TaskCategoryTableDetail.h
//  TaskWatch
//
//  Created by Your Name on 11/01/21.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultCoreData.h"

@interface TaskCategoryTableDetail : UIViewController {
	IBOutlet UITextField *category_;
	IBOutlet UILabel *categoryTitleLabel_;
	
	NSIndexPath *indexPath_;
	
	SimpleCoreData *categoryCoreData_;
	SimpleCoreData *logCoreData_;
}

@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) SimpleCoreData *categoryCoreData;
@property (nonatomic, retain) SimpleCoreData *logCoreData;

@end
