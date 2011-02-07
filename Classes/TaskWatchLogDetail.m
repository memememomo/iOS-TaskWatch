//
//  TaskWatchLogDetail.m
//  TaskWatch
//
//  Created by Your Name on 11/02/07.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "TaskWatchLogDetail.h"
#import "DefaultCoreData.h"

@implementation TaskWatchLogDetail

@synthesize indexPath = indexPath_;
@synthesize logCoreData = logCoreData_;


/*
 * 初期化と後処理
 */

- (void)dealloc
{
	[logCoreData_ release];
	[configData_ release];
	[indexPath_ release];
	[super dealloc];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	
	// CoreData
	SimpleCoreDataFactory *factory = [SimpleCoreDataFactory sharedCoreData];
	
	categoryCoreData_ = [DefaultCoreData createCategoryCoreData];
	[categoryCoreData_ retain];
	
	
	// データ格納用
	configData_ = [[ConfigData alloc] init];
	
	
	// 削除ボタン
	UIBarButtonItem *trashButton = [[[UIBarButtonItem alloc]
									 initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
									 target:self
									 action:@selector(trashButtonPush:)]
									autorelease];
	self.navigationItem.rightBarButtonItem = trashButton;
	
	
	// ログデータの読み込み
	NSManagedObject *managedObject = [logCoreData_.fetchedResultsController objectAtIndexPath:self.indexPath];
	NSString *title = [managedObject valueForKey:@"title"];
	NSDate *startDate = [managedObject valueForKey:@"startDate"];
	NSDate *endDate = [managedObject valueForKey:@"endDate"];
	NSInteger categoryId = [[managedObject valueForKey:@"categoryId"] intValue];
	NSInteger stopWatchHour = [[managedObject valueForKey:@"stopWatchHour"] intValue];
	NSInteger stopWatchMinite = [[managedObject valueForKey:@"stopWatchMinite"] intValue];
	NSInteger stopWatchSecond = [[managedObject valueForKey:@"stopWatchSecond"] intValue];
	float stopWatchMiriSecond = [[managedObject valueForKey:@"stopWatchMiriSecond"] floatValue];
	stopWatchMiriSecond += stopWatchSecond;
	
	NSString *stopWatch = [NSString stringWithFormat:@"%02d:%02d:%06.3f",
						   stopWatchHour,
						   stopWatchMinite,
						   stopWatchMiriSecond];
	
	
	// タグデータの読み込み
	NSPredicate *predicate = nil;
	predicate = [NSPredicate predicateWithFormat:@"categoryId == %d", categoryId];
	[factory setPredicate:categoryCoreData_.fetchedResultsController.fetchRequest
						  WithPredicate:predicate];
	
	NSArray *categoryArray = [categoryCoreData_ fetchObjectAll];
	if ( [categoryArray count] ) {
		NSManagedObject *categoryObject = [categoryArray objectAtIndex:0];
		categoryLabel_.text = [categoryObject valueForKey:@"category"];
	}
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
	
	
	// GUIパーツに設定
	watchTitle_.text = title;
	watchTitle_.delegate = self;
	startDateLabel_.text = [formatter stringFromDate:startDate];
	endDateLabel_.text = [formatter stringFromDate:endDate];
	stopWatchLabel_.text = stopWatch;
	
	configData_.categoryId = categoryId;
}



#pragma mark --- Delegates ---
#pragma mark -----------------


/*
 * 削除ボタンを押したときに呼び出される
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
 * 削除アラートで選択したら呼び出される
 */

-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch (buttonIndex) {
		case 0:
			// いいえ
			break;
		case 1:
			// はい
			[logCoreData_ deleteObjectWithIndexPath:self.indexPath];
			[self.navigationController popViewControllerAnimated:YES];
			break;
	}
}



/*
 * タグ設定ボタンを押したときに呼び出される
 */ 

- (void)categoryButtonPush:(id)sender
{
	CategoryPickerView *categoryPickerView = [[[CategoryPickerView alloc] 
									 initWithNibName:@"CategoryPickerView"
									 bundle:nil
									 ] autorelease];
	categoryPickerView.delegate = self;
	categoryPickerView.configData = configData_;
	
	[self presentModalViewController:categoryPickerView animated:YES];
}


/*
 * キーボードのDoneを押したときに呼び出される
 */

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSManagedObject *managedObject = [logCoreData_.fetchedResultsController objectAtIndexPath:self.indexPath];
	[managedObject setValue:watchTitle_.text forKey:@"title"];
	[logCoreData_ saveContext];
	[watchTitle_ resignFirstResponder];
	return YES;
}


/*
 * タグの選択ボタンを押したときに呼び出される
 */

- (void)doneCategoryPicker
{
	if ( configData_.categoryId ) {
		NSManagedObject *managedObject = [logCoreData_.fetchedResultsController objectAtIndexPath:self.indexPath];
		[managedObject setValue:[NSNumber numberWithInt:configData_.categoryId] forKey:@"categoryId"];
		[logCoreData_ saveContext];
		
		categoryLabel_.text = configData_.category;
	}
	
}


@end
