//
//  TaskWatchSetting.m
//  TaskWatch
//
//  Created by Your Name on 11/02/07.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "TaskWatchSetting.h"
#import "DefaultCoreData.h"
#import "CategoryPickerView.h"


@implementation TaskWatchSetting


- (void)dealloc
{
	[logCoreData_ release];
	[categoryCoreData_ release];
	[categoryIdCoreData_ release];
	
	[configData_ release];
	
	[super dealloc];
}


- (void)viewDidLoad
{
	[super viewDidLoad];
	
	titleTextField_.delegate = self;
	categoryTextField_.delegate = self;
	configData_ = [[ConfigData alloc] init];
	
	logCoreData_ = [DefaultCoreData createLogCoreData:nil];
	[logCoreData_ retain];
	
	categoryCoreData_ = [DefaultCoreData createCategoryCoreData];
	[categoryCoreData_ retain];
	
	categoryIdCoreData_ = [DefaultCoreData createCategoryCoreData];
	[categoryIdCoreData_ retain];
}


#pragma mark -
#pragma mark UIButton Actions


/*
 * 「計測スタート」ボタンが押されたときに呼び出される
 */

- (IBAction)startStopWatch:(id)sender
{
	// 入力チェック
	if ( [titleTextField_.text isEqualToString:@""] ) {
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:nil
							  message:LOCALIZE(@"PLEASE_INPUT_TITLE")
							  delegate:self 
							  cancelButtonTitle:@"OK" 
							  otherButtonTitles:nil]; 
		[alert show];
		[alert release];
		return;
	}
	
	
	NSString *categoryStr = categoryTextField_.text;
	if ( [categoryStr isEqualToString:@""] ) {
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:nil
							  message:LOCALIZE(@"PLEASE_INPUT_CATEGORY")
							  delegate:self 
							  cancelButtonTitle:@"OK" 
							  otherButtonTitles:nil]; 
		[alert show];
		[alert release];
		return;
	}
	
	
	// タグIDの取得
	NSInteger categoryId = [DefaultCoreData addCategory:categoryStr];
	
	
	// ストップウォッチ画面の表示
	TaskWatch *taskWatch = [[[TaskWatch alloc] initWithNibName:@"TaskWatch" bundle:nil] autorelease];
	taskWatch.taskTitle = titleTextField_.text;
	taskWatch.categoryId = categoryId;
	taskWatch.delegate = self;
	taskWatch.logCoreData = logCoreData_;
	
	[self presentModalViewController:taskWatch animated:YES];
}


/*
 * タグ設定ボタンが押されたときに呼び出される。ピッカーを起動する
 */

- (void)categorySelectButtonPush:(id)sender
{
	CategoryPickerView *categoryPickerView = [[[CategoryPickerView alloc]
									 initWithNibName:@"CategoryPickerView"
									 bundle:nil]
									autorelease];
	categoryPickerView.delegate = self;
	categoryPickerView.configData = configData_;
	
	[self presentModalViewController:categoryPickerView animated:YES];
}


/*
 * キーボードのDoneボタンが押されたときに呼び出される
 */

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[titleTextField_ resignFirstResponder];
	[categoryTextField_ resignFirstResponder];
	return YES;
}



#pragma mark -
#pragma mark For Delegate


/*
 * ピッカー画面で「設定」ボタンが押されたときに呼び出される（）
 */

- (void)doneCategoryPicker
{
	categoryTextField_.text = configData_.category;
}


/*
 * 計測終了ボタンが押されたときに呼び出される（TaskWatchDelegate）
 */

- (void)doneTaskWatch
{
	titleTextField_.text = @"";
	categoryTextField_.text = @"";
}


@end
