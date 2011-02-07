//
//  CategoryPickerView.m
//  TaskWatch
//
//  Created by Your Name on 11/01/17.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "CategoryPickerView.h"
#import "DefaultCoreData.h"

@implementation CategoryPickerView

@synthesize configData = configData_;
@synthesize delegate;


- (void)dealloc
{
	[categoryCoreData_ release];
	[configData_ release];
	[super dealloc];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	categoryCoreData_ = [DefaultCoreData createCategoryCoreData];
	[categoryCoreData_ retain];
}


#pragma mark -
#pragma mark Button Actions


/*
 * カテゴリ設定ボタンが押されたとき
 */

- (IBAction)setButtonPush:(id)sender
{
	NSInteger component = [categoryPickerView_ selectedRowInComponent:0];
	
	if ( component > 0 ) {
		NSManagedObject *managedObject = [categoryCoreData_ fetchObjectWithRow:component-1 AndSection:0];
		configData_.categoryId = [[managedObject valueForKey:@"categoryId"] intValue];
		configData_.category = [managedObject valueForKey:@"category"];
	} else {
		configData_.categoryId = 0;
		configData_.category = nil;
	}
	[self dismissModalViewControllerAnimated:YES];
	
	[delegate doneCategoryPicker];
}


/*
 * キャンセルボタンが押されたとき
 */

- (IBAction)cancelButtonPush:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Picker Delegate


/*
 * 列の数
 */

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
	return 1;
}


/*
 * データの数
 */

- (NSInteger)pickerView:(UIPickerView*)pickerView
numberOfRowsInComponent:(NSInteger)component
{
	if ( component == 0 ) {
		// 空白分だけプラス1
		return [categoryCoreData_ countObjects] + 1;
	}
	
	return 0;
}


/*
 * タイトルの表示
 */

- (NSString *)pickerView:(UIPickerView *)pickerView 
			 titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if ( component == 0 && row > 0 ) {
		NSManagedObject *managedObject = [categoryCoreData_ fetchObjectWithRow:row-1 AndSection:0];
		return [managedObject valueForKey:@"category"];
	}
	
	return @"";
}


@end
