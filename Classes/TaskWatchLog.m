//
//  TaskWatchLog.m
//  TaskWatch
//
//  Created by Your Name on 11/02/07.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "TaskWatchLog.h"
#import "TaskWatchLogDetail.h"
#import "DefaultCoreData.h"
#import "SettingPeriod.h"


@implementation TaskWatchLog

static int maxRows = 1000;

@synthesize configData = configData_;


/*
 * 初期化と後処理
 */

- (void)dealloc
{
	[logCoreData_ release];
	[categoryCoreData_ release];
	[configData_ release];
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self initCoreData];
	[self.tableView reloadData];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	
	configData_ = [[ConfigData alloc] init];
	
	self.configData.endPeriod = [NSDate date];
	self.configData.startPeriod = [NSDate dateWithTimeIntervalSinceNow:-14*24*60*60];
	
	logCoreData_ = [DefaultCoreData createLogCoreData:@"startDateForGrouping"];
	[logCoreData_ retain];
	categoryCoreData_ = [DefaultCoreData createCategoryCoreData];
	[categoryCoreData_ retain];
	
	[self initCoreData];
	
	UIBarButtonItem *configButton = [[[UIBarButtonItem alloc]
									  initWithTitle:LOCALIZE(@"CONFIG")									  
									  style:UIBarButtonItemStylePlain
									  target:self
									  action:@selector(configButtonPush:)]
									 autorelease];
	self.navigationItem.rightBarButtonItem = configButton;
}

- (void)configButtonPush:(id)sender
{
	SettingPeriod *settingPeriod = [[[SettingPeriod alloc] init] autorelease];
	settingPeriod.configData = self.configData;
	[self.navigationController pushViewController:settingPeriod animated:YES]; 
}

- (void)initCoreData
{
	SimpleCoreDataFactory *simpleCoreDataFactory = [SimpleCoreDataFactory sharedCoreData];
	
	NSDate *endPeriod = self.configData.endPeriod;
	NSDate *endDate = [endPeriod initWithTimeInterval:1*24*60*60 sinceDate:endPeriod];
	
	NSPredicate *predicate = nil;
	if ( self.configData.categoryId > 0 ) {
		predicate = [NSPredicate predicateWithFormat:@"startDate >= %@ AND startDate <= %@ AND categoryId == %d",
					 self.configData.startPeriod,
					 endDate,
					 self.configData.categoryId];
	} else {
		predicate = [NSPredicate predicateWithFormat:@"startDate >= %@ AND startDate <= %@", 
					 self.configData.startPeriod,
					 endDate];
	}
	[endDate release];
	
	[simpleCoreDataFactory setPredicate:logCoreData_.fetchedResultsController.fetchRequest
						  WithPredicate:predicate];
	[logCoreData_ performFetch];
}



#pragma mark -
#pragma mark TableView


/*
 * セルの幅を調整する
 */

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	NSManagedObject *managedObject = [logCoreData_.fetchedResultsController objectAtIndexPath:indexPath];
	
	// タイトル
	NSString *title = [managedObject valueForKey:@"title"];
	
	// 分類
	NSInteger categoryId = [[managedObject valueForKey:@"categoryId"] intValue];
	NSManagedObject *categoryInfo = [self fetchCategoryInfo:categoryId];
	
	
	
	NSString *text = [NSString stringWithFormat:@"(%@)%@\ndate\ndate", 
					  [categoryInfo valueForKey:@"category"],
					  title];
	
	
	CGFloat height = 50.0f;
	
	// 最大の表示領域CGSize。このCGSize以上は文字列長がこのサイズを超える場合はすべて表示されない
	CGSize bounds = CGSizeMake(300, 10000);
	
	// 文字列描画に使用するフォント
	UIFont *font = [UIFont systemFontOfSize:18];
	
	// 表示に必要なCGSize
	CGSize size = [text sizeWithFont:font constrainedToSize:bounds lineBreakMode:UILineBreakModeTailTruncation];
	
	CGFloat h = size.height - height;
	if ( h > 0 ) {
		height += h;
	}
	
	return height;
} 
 

/*
 * セクション数を返す
 */

- (NSInteger)tableView:(UITableView*)tableView 
{
	return [[logCoreData_.fetchedResultsController sections] count];
}


/*
 * セクション名を返す
 */ 

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[logCoreData_.fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo name];
}


/*
 * セクション毎の行数
 */

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	
	// 行数を求める
	id <NSFetchedResultsSectionInfo> sectionInfo = [[logCoreData_.fetchedResultsController sections] objectAtIndex:section];
	NSInteger rows = [sectionInfo numberOfObjects];
	
	if ( rows > maxRows ) {
		return maxRows;
	} else {
		return rows;
	}
	
}


/*
 * テーブルにあるセクション数を返す
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return [[logCoreData_.fetchedResultsController sections] count];
}


/*
 * セルの内容を返す
 */

- (UITableViewCell*)tableView:(UITableView*)tableView
		cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString *identifier = @"basis-cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if ( nil == cell ) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									  reuseIdentifier:identifier];
		[cell autorelease];
	}
	
	NSManagedObject *managedObject = [logCoreData_.fetchedResultsController objectAtIndexPath:indexPath];
	
	// 日付
	NSDate *startDate = [managedObject valueForKey:@"startDate"];
	NSDate *endDate = [managedObject valueForKey:@"endDate"];
	
	
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
	
	NSString *startDateStr = [formatter stringFromDate:startDate];
	NSString *endDateStr = [formatter stringFromDate:endDate];
	
	
	// タイトル
	NSString *title = [managedObject valueForKey:@"title"];
	
	// 分類
	NSInteger categoryId = [[managedObject valueForKey:@"categoryId"] intValue];
	NSManagedObject *categoryInfo = [self fetchCategoryInfo:categoryId];
	
	
	// ストップウォッチ
	int hh = [[managedObject valueForKey:@"StopWatchHour"] intValue];
	int mm = [[managedObject valueForKey:@"StopWatchMinite"] intValue];
	int ss = [[managedObject valueForKey:@"StopWatchSecond"] intValue];
	float miriSecond = [[managedObject valueForKey:@"StopWatchMiriSecond"] floatValue];
	miriSecond += ss;
	
	NSString *stopWatch = [NSString stringWithFormat:@"%02d:%02d:%06.3f",
						   hh, mm, miriSecond];
	
	
	// セルにテキストをセット
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", startDateStr, endDateStr];
	cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@", title, stopWatch];
	
	if ( categoryInfo ) {
		cell.textLabel.text = [NSString stringWithFormat:@"(%@)%@",
							   [categoryInfo valueForKey:@"category"],
							   cell.textLabel.text];
		
	}
	
	cell.textLabel.numberOfLines = 0;
	
	
	return cell;
}


/*
 * セルを削除
 */

- (void)tableView:(UITableView*)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath*)indexPath
{
	if ( UITableViewCellEditingStyleDelete == editingStyle ) {
		[logCoreData_ deleteObjectWithIndexPath:indexPath];
		[tableView reloadData];
	}
}


/*
 * セルを選択
 */

- (void)tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	TaskWatchLogDetail *watchLogDetail = [[[TaskWatchLogDetail alloc]
										   initWithNibName:@"TaskWatchLogDetail"
										   bundle:nil]
										  autorelease];
	watchLogDetail.indexPath = indexPath;
	watchLogDetail.logCoreData = logCoreData_;
	[self.navigationController pushViewController:watchLogDetail animated:YES];
}


- (NSManagedObject *)fetchCategoryInfo:(NSInteger)categoryId
{
	SimpleCoreDataFactory *simpleCoreDataFactory = [SimpleCoreDataFactory sharedCoreData];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryId == %d", categoryId];
	[simpleCoreDataFactory setPredicate:categoryCoreData_.fetchedResultsController.fetchRequest
						  WithPredicate:predicate];
	
	NSArray *array = [categoryCoreData_ fetchObjectAll];
	
	NSManagedObject *managedObject = nil;
	if ( [array count] ) {
		managedObject = [array objectAtIndex:0];
	}
	
	return managedObject;
}




@end
