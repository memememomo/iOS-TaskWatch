//
//  TaskCategoryTableDetail.m
//  TaskWatch
//
//  Created by Your Name on 11/01/21.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "TaskCategoryTableDetail.h"


@implementation TaskCategoryTableDetail

@synthesize logCoreData = logCoreData_;
@synthesize categoryCoreData = categoryCoreData_;
@synthesize indexPath = indexPath_;

- (void)dealloc
{
	[logCoreData_ release];
	[categoryCoreData_ release];
	[indexPath_ release];
	[super dealloc];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UIBarButtonItem *trashButton = [[[UIBarButtonItem alloc]
									 initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
									 target:self
									 action:@selector(trashButtonPush:)]
									autorelease];
	self.navigationItem.rightBarButtonItem = trashButton;
	
	NSManagedObject *managedObject = [categoryCoreData_.fetchedResultsController objectAtIndexPath:self.indexPath];
	category_.text = [managedObject valueForKey:@"category"];
}



#pragma mark --- Delegate ---
#pragma mark ----------------


/*
 * キーボードのDoneを押したときに呼び出される
 */

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSManagedObject *managedObject = [categoryCoreData_.fetchedResultsController objectAtIndexPath:self.indexPath];
	[managedObject setValue:category_.text forKey:@"category"];
	[categoryCoreData_ saveContext];
	[category_ resignFirstResponder];
	return YES;
}


/*
 * 削除ボタンが押されたら呼び出される
 */

- (void)trashButtonPush:(id)sender
{
	// １行で書くタイプ（複数ボタンタイプ）
	UIAlertView *alert =
	[[UIAlertView alloc] initWithTitle:LOCALIZE(@"CONFIRM")
							   message:LOCALIZE(@"DELETE_CONFIRM_MESSAGE")
							  delegate:self 
					 cancelButtonTitle:LOCALIZE(@"CONFIRM_NO")
					 otherButtonTitles:LOCALIZE(@"CONFIRM_YES"), 
	 nil];
	[alert show];
	[alert release];
}


/*
 * 削除機能
 */

-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch (buttonIndex) {
		case 0:
			// いいえ
			break;
		case 1:
			// はい
			[categoryCoreData_ deleteObjectWithIndexPath:self.indexPath];
			[self.navigationController popViewControllerAnimated:YES];
			break;
	}
}

@end
