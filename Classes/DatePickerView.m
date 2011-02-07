//
//  DatePickerView.m
//  TaskWatch
//
//  Created by Your Name on 11/02/07.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "DatePickerView.h"


@implementation DatePickerView

@synthesize delegate;
@synthesize date = date_;
@synthesize dateType = dateType_;

- (void)dealloc
{
	[date_ release];
	[dateType_ release];
	[super dealloc];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	picker_.date = self.date;
	[picker_ setTimeZone:[NSTimeZone systemTimeZone]];
}


/*
 * 設定ボタンが押されたとき
 */

- (void)settingButtonPush:(id)sender
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"YYYY/MM/dd"];
	NSString *dateStr = [formatter stringFromDate:picker_.date];
		
	NSDate *pickerDate = [formatter dateFromString:dateStr];
	[delegate updateDate:[NSArray arrayWithObjects:pickerDate, dateType_, nil]];

	[self dismissModalViewControllerAnimated:YES];
}


/*
 * キャンセルボタンが押されたとき
 */

- (void)cancelButtonPush:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}


@end
