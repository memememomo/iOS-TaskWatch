//
//  TaskWatch.h
//  TaskWatch
//
//  Created by Your Name on 11/02/07.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleCoreDataFactory.h"


@protocol TaskWatchDelegate
- (void)doneTaskWatch;
@end


@interface TaskWatch : UIViewController {
	NSString *watchTitle_;
	
	int categoryId_;
	BOOL startFlag_;
	
	float milliSecond_;
	int hh_, mm_, ss_;
	
	NSDate *stdDate_;
	BOOL timeFlag_;
	
	NSDate *startDate_, *endDate_;
	NSTimer *timer_;
	
	IBOutlet UILabel *timeLabel_;
	IBOutlet UIButton *switchButton_;
	IBOutlet UIButton *doneButton_;
	
	SimpleCoreData *logCoreData_;
	
	id<TaskWatchDelegate> delegate;
}

@property (nonatomic, retain) SimpleCoreData *logCoreData;

@property (nonatomic, retain) NSString *taskTitle;
@property (nonatomic) int categoryId;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSDate *stdDate;
@property (nonatomic, assign) id<TaskWatchDelegate> delegate;

- (IBAction)switchButton:(id)sender;
- (IBAction)doneButton:(id)sender;

@end
