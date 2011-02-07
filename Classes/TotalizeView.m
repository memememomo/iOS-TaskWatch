//
//  TotalizeView.m
//  TaskWatch
//
//  Created by Your Name on 11/01/18.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "TotalizeView.h"
#import "DefaultCoreData.h"
#import "SettingPeriod.h"

@implementation TotalizeView

@synthesize totalizes = totalizes_;

enum TOTALIZE_VALUE {
	TOTALIZE_TODAY,
	TOTALIZE_ALL,
	TOTALIZE_PERIOD,
};


/*
 * 初期化と後処理
 */

- (void)dealloc
{
	[segment_ release];
	[logCoreData_ release];
	[categoryCoreData_ release];
	[totalizes_ release];
	[configData_ release];
	[super dealloc];
}

- (id)init
{
	if ( self = [super initWithStyle:UITableViewStyleGrouped] ) {
	}

	return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self initTotalize];
	[self.tableView reloadData];
}

- (void)viewDidLoad 
{
	[super viewDidLoad];
	
	// 期間指定
	segment_ = [[UISegmentedControl alloc] 
				initWithItems:[NSArray arrayWithObjects:
							   LOCALIZE(@"SEG_TODAY"), 
							   LOCALIZE(@"SEG_ALL"),
							   LOCALIZE(@"SEG_PERIOD")
							   , nil]];
	segment_.selectedSegmentIndex = 0;
	[segment_ addTarget:self
				 action:@selector(segmentDidChange:)
	   forControlEvents:UIControlEventValueChanged];
	//self.tableView.tableHeaderView = segment_;
	
	
	configData_ = [[ConfigData alloc] init];
	configData_.endPeriod   = [NSDate date];
	configData_.startPeriod = [NSDate dateWithTimeIntervalSinceNow:-14*24*60*60];

	
	// セクション
	sections_ = [[NSArray alloc] initWithObjects:@"", LOCALIZE(@"CATEGORY_LABEL"), nil];
	

	// 集計
	logCoreData_ = [DefaultCoreData createLogCoreData:nil];
	[logCoreData_ retain];
	categoryCoreData_ = [DefaultCoreData createCategoryCoreData];
	[categoryCoreData_ retain];
	
	totalizeType_ = TOTALIZE_TODAY;
	
	[self initTotalize];
}


/*
 * 集計
 */

- (void)initTotalize
{
	// タグをすべて取得する
	NSArray *categorys = [categoryCoreData_ fetchObjectAll];
	
	
	// 合計用の変数
	NSInteger sumHour, sumMinite;
	float sumMiriSecond;
	
	sumHour = sumMinite = 0;
	sumMiriSecond = 0.0f;
	
	
	// 計算結果格納用
	NSMutableArray *totalizes = [[[NSMutableArray alloc] init] autorelease];
	
	NSInteger countCategorys = [categorys count];
	for (int i = 0; i < countCategorys; i++) {
		// タグ情報を取得
		NSManagedObject *managedObject = [categorys objectAtIndex:i];
		NSString *category = [managedObject valueForKey:@"category"];
		NSInteger categoryId = [[managedObject valueForKey:@"categoryId"] intValue];
		
		// タグの時間集計をする
		NSArray *timeArray = [self calcSumWithCategoryId:categoryId];
		NSInteger hour = [[timeArray objectAtIndex:0] intValue];
		NSInteger minite = [[timeArray objectAtIndex:1] intValue];
		float miriSecond = [[timeArray objectAtIndex:2] floatValue];
		
		sumHour += hour;
		sumMinite += minite;
		sumMiriSecond += miriSecond;
		
		// 表示用文字列
		NSString *time = [NSString stringWithFormat:LOCALIZE(@"STOP_WATCH_FORMAT"), hour, minite, miriSecond];
		NSArray *data = [NSArray arrayWithObjects:category, time, nil];
		[totalizes addObject:data];
	}
	
	// 合計
	NSArray *timeAllArray = [self calcCarryWithHour:sumHour
										  AndMinite:sumMinite
									  AndMiriSecond:sumMiriSecond];
	
	NSString *timeAll = [NSString stringWithFormat:LOCALIZE(@"STOP_WATCH_FORMAT"),
						 [[timeAllArray objectAtIndex:0] intValue],
						 [[timeAllArray objectAtIndex:1] intValue],
						 [[timeAllArray objectAtIndex:2] floatValue]
						 ];
	
	NSString *allTitle = LOCALIZE(@"SUM");
	
	if ( totalizeType_ == TOTALIZE_PERIOD ) {
		NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
		[formatter setDateFormat:@"YYYY/MM/dd"];
		
		allTitle = [NSString stringWithFormat:@"%@ (%@〜%@)", 
					allTitle, 
					[formatter stringFromDate:configData_.startPeriod],
					[formatter stringFromDate:configData_.endPeriod]];
	}	

	NSArray *allData = [NSArray arrayWithObjects:allTitle, timeAll, nil];
	

	[totalizes insertObject:allData atIndex:0];
	self.totalizes = [[[NSMutableArray alloc] initWithArray:totalizes] autorelease];
}


/*
 * 期間切り替えのスイッチがタップされたとき
 */

- (void)segmentDidChange:(id)sender
{
	if ( [sender isKindOfClass:[UISegmentedControl class]] ) {
		UISegmentedControl *segment = sender;
		self.navigationItem.rightBarButtonItem = nil;
		switch (segment.selectedSegmentIndex) {
			case 0:
				totalizeType_ = TOTALIZE_TODAY;
				break;
			case 1:
				totalizeType_ = TOTALIZE_ALL;
				break;
			case 2:
				totalizeType_ = TOTALIZE_PERIOD;
				self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
														   initWithTitle:LOCALIZE(@"CONFIG")
														   style:UIBarButtonItemStylePlain
														   target:self
														   action:@selector(settingPeriod)] 
														  autorelease];
				break;
		}
		[self initTotalize];
		[self.tableView reloadData];
	}			
}


- (void)settingPeriod
{
	SettingPeriod *settingPeriod = [[[SettingPeriod alloc] init] autorelease];
	settingPeriod.title = LOCALIZE(@"SEG_PERIOD");
	settingPeriod.configData = configData_;
	settingPeriod.mode = SettingPeriodModeOnlyPeriod;
	[self.navigationController pushViewController:settingPeriod animated:YES]; 
}


/*
 * セクション数
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [sections_ count];
}


/*
 * セクションの中のデータ数を返す
 * 0:セグメントスイッチ
 * 1:カテゴリ数
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ( section == 0 ) {
		return 1;
	} else {
		// 行数を求める
		return [self.totalizes count];
	}
}


/*
 * セルの内容を返す
 */

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString *identifier = @"basis-cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if ( nil == cell ) {
		NSInteger style;
		if ( indexPath.section == 0 ) {
			style = UITableViewCellStyleDefault;
		} else {
			style = UITableViewCellStyleSubtitle;
		}
		
		cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:identifier];
		[cell autorelease];
	}
	
	
	if ( indexPath.section == 0 ) {
		// セグメントスイッチによる集計期間指定
		if ( indexPath.row == 0 ) {
			segment_.frame = CGRectMake(0, 0, 300, 45);
			segment_.autoresizingMask =
				UIViewAutoresizingFlexibleLeftMargin |
				UIViewAutoresizingFlexibleRightMargin |
				UIViewAutoresizingFlexibleTopMargin |
				UIViewAutoresizingFlexibleBottomMargin;
			[cell.contentView addSubview:segment_];
			cell.backgroundColor = [UIColor clearColor];
		}
	} else if ( indexPath.section == 1 ) {
		NSArray *data = [self.totalizes objectAtIndex:indexPath.row];

		cell.detailTextLabel.text = [data objectAtIndex:1];
		cell.textLabel.text = [data objectAtIndex:0];
	}
	cell.textLabel.numberOfLines = 0;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	
	return cell;
}


/*
 * セクション名を返す
 */

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
	return [sections_ objectAtIndex:section];
}


/*
 * セルを選択
 */

- (void)tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
}


/*
 * 時分の合計を出すマクロ関数
 */

- (NSInteger)sumStopWatch:(NSString *)unit AndCoreData:(SimpleCoreData *)coreData
{
	NSArray *data = [self sumStopWatchWithType:NSInteger16AttributeType
									   AndUnit:unit
								   AndCoreData:coreData];
	NSInteger sum = [[[data objectAtIndex:0] valueForKey:@"sumValue"] intValue];
	return sum;
}


/*
 * CoreDataのSum関数を使って計算する
 */

- (NSArray *)sumStopWatchWithType:(NSInteger)type AndUnit:(NSString *)unit AndCoreData:(SimpleCoreData *)coreData 
{
	SimpleCoreDataFactory *simpleCoreDataFactory = [SimpleCoreDataFactory sharedCoreData];
	[simpleCoreDataFactory setFunction:logCoreData_.fetchedResultsController.fetchRequest
							WithColumn:[NSString stringWithFormat:@"stopWatch%@", unit]
						   AndFunction:@"sum" 
							AndSetName:@"sumValue"
						 AndResultType:type];
	NSArray *data = [coreData fetchObjectAll];
	
	return data;
}


/*
 * タグ毎の時間集計をする
 * 期間なども指定する
 */

- (NSArray *)calcSumWithCategoryId:(NSInteger)categoryId
{
	SimpleCoreDataFactory *simpleCoreDataFactory = [SimpleCoreDataFactory sharedCoreData];
	
	NSPredicate *predicate = nil;
	
	switch (totalizeType_) {
		case TOTALIZE_TODAY: {
			NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
			[formatter setDateFormat:@"YYYY/MM/dd"];
			NSString *todayStr = [formatter stringFromDate:[NSDate date]];
			
			NSDate *today = [formatter dateFromString:todayStr];
			NSDate *todayPlus = [today initWithTimeInterval:1*24*60*60 sinceDate:today];
			predicate = [NSPredicate predicateWithFormat:@"categoryId == %d AND startDate >= %@ AND startDate <= %@", 
						 categoryId,
						 today,
						 todayPlus
						 ];
			[todayPlus release];
		}
			break;
		case TOTALIZE_ALL:
			predicate = [NSPredicate predicateWithFormat:@"categoryId == %d", categoryId];
			break;
		case TOTALIZE_PERIOD: {
			NSDate *endPeriod = configData_.endPeriod;
			NSDate *endDate = [endPeriod initWithTimeInterval:1*24*60*60 sinceDate:endPeriod];

			predicate = [NSPredicate predicateWithFormat:@"categoryId == %d AND startDate >= %@ AND startDate <= %@",
						 categoryId, configData_.startPeriod, endDate];
			[endDate release];
		}
			break;
	}
	
	[simpleCoreDataFactory setPredicate:logCoreData_.fetchedResultsController.fetchRequest
						  WithPredicate:predicate];
	[logCoreData_ performFetch];
	
	
	NSInteger sumHour = [self sumStopWatch:@"Hour" AndCoreData:logCoreData_];
	NSInteger sumMinite = [self sumStopWatch:@"Minite" AndCoreData:logCoreData_];
	NSInteger sumSecond = [self sumStopWatch:@"Second" AndCoreData:logCoreData_];
	
	NSArray *arrayMiriSecond = [self sumStopWatchWithType:NSFloatAttributeType
												  AndUnit:@"MiriSecond"
											  AndCoreData:logCoreData_];
	float sumMiriSecond = [[[arrayMiriSecond objectAtIndex:0] valueForKey:@"sumValue"] floatValue];
	sumMiriSecond += sumSecond;
	
	NSArray *timeArray = [self calcCarryWithHour:sumHour
									   AndMinite:sumMinite
								   AndMiriSecond:sumMiriSecond];
	
	
	return timeArray;
}


/*
 * 時分秒のくり上がりを計算する
 */

- (NSArray *)calcCarryWithHour:(NSInteger)hour 
					 AndMinite:(NSInteger)minite 
				 AndMiriSecond:(float)miriSecond
{
	NSInteger mm = (NSInteger)miriSecond / 60;
	miriSecond -= mm * 60;
	
	minite += mm;
	NSInteger hh = (NSInteger)minite / 60;
	minite -= hh * 60;
	
	hour += hh;
	
	return [NSArray arrayWithObjects:
			[NSNumber numberWithInt:hour],
			[NSNumber numberWithInt:minite],
			[NSNumber numberWithFloat:miriSecond],nil];
}

@end
