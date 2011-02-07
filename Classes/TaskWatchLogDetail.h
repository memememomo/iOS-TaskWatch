//
//  TaskWatchLogDetail.h
//  TaskWatch
//
//  Created by Your Name on 11/02/07.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigData.h"
#import "SimpleCoreDataFactory.h"
#import "CategoryPickerView.h"

@interface TaskWatchLogDetail : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField *watchTitle_;
	IBOutlet UILabel *categoryLabel_;
	IBOutlet UILabel *stopWatchLabel_;
	IBOutlet UILabel *startDateLabel_;
	IBOutlet UILabel *endDateLabel_;
	IBOutlet UIButton *categoryButton_;

	NSIndexPath *indexPath_;
	
	ConfigData *configData_;
	
	SimpleCoreData *logCoreData_;
	SimpleCoreData *categoryCoreData_;
}

@property (nonatomic, retain) SimpleCoreData *logCoreData;
@property (nonatomic, retain) NSIndexPath *indexPath;

- (void)categoryButtonPush:(id)sender;

@end
