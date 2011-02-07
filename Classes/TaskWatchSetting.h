//
//  TaskWatchSetting.h
//  TaskWatch
//
//  Created by Your Name on 11/02/07.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigData.h"
#import "SimpleCoreDataFactory.h"
#import "TaskWatch.h"
#import "CategoryPickerView.h"


@interface TaskWatchSetting : UIViewController <UITextFieldDelegate, TaskWatchDelegate, CategoryPickerViewDelegate> {
	IBOutlet UITextField *titleTextField_;
	
	IBOutlet UITextField *categoryTextField_;
	IBOutlet UIButton *categorySelectButton_;
	
	IBOutlet UIButton *startWatchButton_;
	
	ConfigData *configData_;
	
	SimpleCoreData *logCoreData_;
	SimpleCoreData *categoryCoreData_;
	SimpleCoreData *categoryIdCoreData_;
}

- (IBAction)startStopWatch:(id)sender;
- (IBAction)categorySelectButtonPush:(id)sender;

@end
