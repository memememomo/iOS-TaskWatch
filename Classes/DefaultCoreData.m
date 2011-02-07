//
//  DefaultCoreData.m
//  TaskWatch
//
//  Created by Your Name on 11/01/20.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "DefaultCoreData.h"


@implementation DefaultCoreData


/*
 * sortの基本設定
 */

+ (NSDictionary *)sortDescription
{
	NSDictionary *sort = [[[NSDictionary alloc] 
						   initWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithBool:NO],nil] 
						   forKeys:[NSArray arrayWithObjects:@"timeStamp", nil]]
						  autorelease];
	
	return sort;
}


/*
 * StopWatchLogエンティティのCoreData設定
 */

+ (SimpleCoreData *)createLogCoreData:(NSString *)sectionNameKeyPath
{
	SimpleCoreDataFactory *simpleCoreDataFactory = [SimpleCoreDataFactory sharedCoreData];
	
	NSFetchRequest *requestLog = [simpleCoreDataFactory createRequest:@"TaskWatchLog"];
	[simpleCoreDataFactory setSortDescriptors:requestLog AndSort:[self sortDescription]];
	NSFetchedResultsController *fetchedResultController = [simpleCoreDataFactory fetchedResultsController:requestLog
																				AndSectionNameKeyPath:sectionNameKeyPath];
	
	SimpleCoreData *logCoreData = [simpleCoreDataFactory createSimpleCoreData:fetchedResultController];
	
	return logCoreData;
}


/*
 * CategoryエンティティのCoreData設定
 */

+ (SimpleCoreData *)createCategoryCoreData
{
	SimpleCoreDataFactory *simpleCoreDataFactory = [SimpleCoreDataFactory sharedCoreData];
	
	NSFetchRequest *requestCategory = [simpleCoreDataFactory createRequest:@"Category"];
	[simpleCoreDataFactory setSortDescriptors:requestCategory AndSort:[self sortDescription]];
	NSFetchedResultsController *fetchedResultController = [simpleCoreDataFactory fetchedResultsController:requestCategory 
													AndSectionNameKeyPath:nil];
	SimpleCoreData *categoryCoreData = [simpleCoreDataFactory createSimpleCoreData:fetchedResultController];
	
	return categoryCoreData;
}


/*
 * CategoryIdエンティティのCoreData設定
 */

+ (SimpleCoreData *)createCategoryIdCoreData
{
	SimpleCoreDataFactory *simpleCoreDataFactory = [SimpleCoreDataFactory sharedCoreData];
	
	NSFetchRequest *requestCategoryId = [simpleCoreDataFactory createRequest:@"CategoryId"];
	[simpleCoreDataFactory setSortDescriptors:requestCategoryId AndSort:[self sortDescription]];
	NSFetchedResultsController *fetchedResultController = [simpleCoreDataFactory fetchedResultsController:requestCategoryId
														AndSectionNameKeyPath:nil];
	SimpleCoreData *categoryIdCoreData = [simpleCoreDataFactory createSimpleCoreData:fetchedResultController];

	return categoryIdCoreData;
}


/*
 * タグIDを取得する
 */

+ (NSInteger)addCategory:(NSString *)categoryStr
{
	SimpleCoreDataFactory *simpleCoreDataFactory = [SimpleCoreDataFactory sharedCoreData];
	
	SimpleCoreData *categoryCoreData = [DefaultCoreData createCategoryCoreData];
	SimpleCoreData *categoryIdCoreData = [DefaultCoreData createCategoryIdCoreData];
	
	
	if ( [categoryCoreData countObjects] == 0 ) {
		// latestCategoryIdにデータが入っていない時
		NSManagedObject *managedObject = [categoryIdCoreData newManagedObject];
		[managedObject setValue:[NSNumber numberWithInt:1] forKey:@"latestCategoryId"];
		[categoryIdCoreData saveContext];
	}
	
	
	// タグがすでに登録されているものかどうかを確認する
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", categoryStr];
	[simpleCoreDataFactory setPredicate:categoryCoreData.fetchedResultsController.fetchRequest
						  WithPredicate:predicate];
	
	NSArray *array = [categoryCoreData fetchObjectAll];
	
	NSInteger categoryId;
	
	if ( [array count] ) {
		// 既存のタグIDを取得する
		NSManagedObject *managedObject = [array objectAtIndex:0];
		categoryId = [[managedObject valueForKey:@"categoryId"] intValue];
	} else {
		// 新たなタグIDを取得する
		NSManagedObject *categoryIdManager = [categoryIdCoreData fetchObjectWithRow:0 AndSection:0];
		int latestCategoryId = [[categoryIdManager valueForKey:@"latestCategoryId"] intValue];
		
		// 次のタグIDを登録しておく
		int newLatestCategoryId = latestCategoryId + 1;
		[categoryIdManager setValue:[NSNumber numberWithInt:newLatestCategoryId] forKey:@"latestCategoryId"];
		
		// タグ文字列とタグIDのペアをエンティティに登録しておく
		NSManagedObject *newManagedObject = [categoryCoreData newManagedObject];
		[newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
		[newManagedObject setValue:[NSNumber numberWithInt:latestCategoryId] forKey:@"categoryId"];
		[newManagedObject setValue:categoryStr forKey:@"category"];
		[categoryIdCoreData saveContext];
		
		// タグIDを返す
		categoryId = latestCategoryId;
	}
	
	return categoryId;
}



/*
#pragma mark -
#pragma mark TestData

+ (void)deleteTestData
{
	SimpleCoreData *logCoreData = [DefaultCoreData createLogCoreData:nil];
	NSInteger count = [logCoreData countObjects];
	
	for (int i = 0; i < count; i++) {
		[logCoreData deleteObjectWithRow:0 AndSection:0];
	}
	
	
	
	SimpleCoreData *categoryCoreData = [DefaultCoreData createCategoryCoreData];
	
	count = [categoryCoreData countObjects];
	
	for (int i = 0; i < count; i++) {
		[categoryCoreData deleteObjectWithRow:0 AndSection:0];
	}
}

+ (void)insertTestData
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"YYYY/MM/dd"];
	
	
	for (int i = 0; i < 100; i++) {
		NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-(100-i+1)*24*60*60];
		NSDate *endDate = [startDate dateByAddingTimeInterval:1000];
		NSString *dateForGrouping = [formatter stringFromDate:startDate];
		
		[self insertDataToCoreDataForTest:
		 [NSArray arrayWithObjects:
		  dateForGrouping,
		  startDate,
		  endDate,
		  @"test",
		  [NSNumber numberWithInt:1],
		  [NSNumber numberWithInt:2],
		  [NSNumber numberWithInt:1],
		  [NSNumber numberWithFloat:0.51f],
		  endDate,
		  [NSNumber numberWithInt:i%3+1],
		  nil
		  ]];
	}
	
	[self insertDataToCategoryForTest:
	 [NSArray arrayWithObjects:
	  [NSNumber numberWithInt:1],
	  @"One",nil
	  ]];
	
	[self insertDataToCategoryForTest:
	 [NSArray arrayWithObjects:
	  [NSNumber numberWithInt:2],
	  @"Two",nil
	  ]];
	
	[self insertDataToCategoryForTest:
	 [NSArray arrayWithObjects:
	  [NSNumber numberWithInt:3],
	  @"Three",nil
	  ]];
}
 
+ (void)insertDataToCoreDataForTest:(NSArray*)datas
 {
	 SimpleCoreData *logCoreData = [DefaultCoreData createLogCoreData:nil];
	 NSManagedObject *newObject = [logCoreData newManagedObject];
	 [newObject setValue:[datas objectAtIndex:0] forKey:@"startDateForGrouping"];
	 [newObject setValue:[datas objectAtIndex:1] forKey:@"startDate"];
	 [newObject setValue:[datas objectAtIndex:2] forKey:@"endDate"];
	 [newObject setValue:[datas objectAtIndex:3] forKey:@"title"];
	 [newObject setValue:[datas objectAtIndex:4] forKey:@"StopWatchHour"];
	 [newObject setValue:[datas objectAtIndex:5] forKey:@"StopWatchMinite"];
	 [newObject setValue:[datas objectAtIndex:6] forKey:@"StopWatchSecond"];
	 [newObject setValue:[datas objectAtIndex:7] forKey:@"StopWatchMiriSecond"];
	 [newObject setValue:[datas objectAtIndex:8] forKey:@"timeStamp"];
	 [newObject setValue:[datas objectAtIndex:9] forKey:@"categoryId"];
	 [logCoreData saveContext];
 }


+ (void)insertDataToCategoryForTest:(NSArray *)datas
{
	SimpleCoreData *categoryCoreData = [DefaultCoreData createCategoryCoreData];
	
	NSManagedObject *newObject = [categoryCoreData newManagedObject];
	[newObject setValue:[datas objectAtIndex:0] forKey:@"categoryId"];
	[newObject setValue:[datas objectAtIndex:1] forKey:@"category"];
	[newObject setValue:[NSDate date] forKey:@"timeStamp"];
	[categoryCoreData saveContext];
}
*/


@end
