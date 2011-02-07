//
//  TaskWatch.m
//  TaskWatch
//
//  Created by Your Name on 11/02/07.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "TaskWatch.h"


@implementation TaskWatch


@synthesize taskTitle = taskTitle_;
@synthesize startDate = startDate_;
@synthesize endDate = endDate_;
@synthesize stdDate = stdDate_;
@synthesize categoryId = categoryId_;
@synthesize delegate;

@synthesize logCoreData = logCoreData_;




/*
 * 初期化と後処理
 */

- (void)dealloc
{
	[logCoreData_ release];

	[watchTitle_ release];
	[startDate_ release];
	[endDate_ release];
	[stdDate_ release];
	[super dealloc];
}


- (void)viewDidLoad
{
	[super viewDidLoad];

	// タスク開始時刻を記録
	self.startDate = [NSDate date];
	self.stdDate = [NSDate date];
	timeFlag_ = YES;
	
	// ストップウォッチ設定
	SEL sel = @selector(timerUpdate);
	NSMethodSignature *signature = [self methodSignatureForSelector:sel];
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
	[invocation setTarget:self];
	[invocation setSelector:sel];
	timer_ = [NSTimer scheduledTimerWithTimeInterval:0.001f
										  invocation:invocation
											 repeats:YES];
	
	// 時計の値
	milliSecond_ = 0.0f;
	hh_ = mm_ = ss_ = 0;
	
	
	// ストップウォッチが動いている時は、完了ボタンを非表示
	[doneButton_ removeFromSuperview];
}




#pragma mark -
#pragma mark Timer 


/*
 * 0.001f間隔で呼び出される
 */

- (void)timerUpdate
{
	if (timeFlag_) {
		NSDate *now = [NSDate date];
		NSTimeInterval duration = [now timeIntervalSinceDate:self.stdDate];
		milliSecond_ += duration;
		self.stdDate = now;
		
		
		int ssCarry = (int)milliSecond_;
		milliSecond_ -= ssCarry;
		
		ss_ += ssCarry;
		
		int mmCarry = ss_ / 60;
		ss_ -= 60 * mmCarry;
		mm_ += mmCarry;
		
		int hhCarry = mm_ / 60;
		mm_ -= 60 * hhCarry;
		hh_ += hhCarry;
		
		float milli = ss_ + milliSecond_;
		
		timeLabel_.text = [NSString stringWithFormat:@"%02d:%02d:%06.3f", 
						   hh_,
						   mm_,
						   milli];
	}	
}




#pragma mark -
#pragma mark Button Actions


/*
 * スタートとストップボタンの切り替え
 */

- (IBAction)switchButton:(id)sender
{
	if ( startFlag_ == YES ) {
		startFlag_ = NO;
		doneButton_.enabled = YES;
		[switchButton_ setTitle:LOCALIZE(@"START") forState:UIControlStateNormal];
		
		timeFlag_ = NO;
		
		[self.view addSubview:doneButton_];
	} else if ( startFlag_ == NO ) {
		startFlag_ = YES;
		doneButton_.enabled = NO;
		[switchButton_ setTitle:LOCALIZE(@"STOP") forState:UIControlStateNormal];
		
		timeFlag_ = YES;
		self.stdDate = [NSDate date];
		
		[doneButton_ removeFromSuperview];
	}
}


/*
 * 終了ボタンが押されたら呼び出される
 */

- (IBAction)doneButton:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
	self.endDate = [NSDate date];
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"YYYY/MM/dd"];
	NSString *dateForGrouping = [formatter stringFromDate:self.startDate];
	
	NSManagedObject *newObject = [logCoreData_ newManagedObject];
	[newObject setValue:dateForGrouping forKey:@"startDateForGrouping"];
	[newObject setValue:self.startDate forKey:@"startDate"];
	[newObject setValue:self.endDate forKey:@"endDate"];
	[newObject setValue:self.taskTitle forKey:@"title"];
	[newObject setValue:[NSNumber numberWithInteger:self.categoryId] forKey:@"categoryId"];
	[newObject setValue:[NSNumber numberWithInteger:hh_] forKey:@"StopWatchHour"];
	[newObject setValue:[NSNumber numberWithInteger:mm_] forKey:@"StopWatchMinite"];
	[newObject setValue:[NSNumber numberWithInteger:ss_] forKey:@"StopWatchSecond"];
	[newObject setValue:[NSNumber numberWithFloat:milliSecond_] forKey:@"StopWatchMiriSecond"];
	[newObject setValue:[NSDate date] forKey:@"timeStamp"];
	[logCoreData_ saveContext];
	
	[delegate doneTaskWatch];
}



@end
