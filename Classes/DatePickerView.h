//
//  DatePickerView.h
//  TaskWatch
//
//  Created by Your Name on 11/02/07.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DatePickerViewDelegate
- (void)updateDate:(NSArray *)array;
@end


@interface DatePickerView : UIViewController {
	id<DatePickerViewDelegate> delegate;
	
	NSDate *date_;
	NSString *dateType_;
	
	IBOutlet UIDatePicker *picker_;
	
	IBOutlet UIButton *configButton_;
	IBOutlet UIButton *cancelButton_;
	
}

@property (nonatomic, assign) id<DatePickerViewDelegate> delegate;

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *dateType;

- (void)settingButtonPush:(id)sender;
- (void)cancelButtonPush:(id)sender;

@end
