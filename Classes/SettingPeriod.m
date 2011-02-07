//
//  SettingPeriod.m
//  TaskWatch
//
//  Created by Your Name on 11/02/07.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "SettingPeriod.h"
#import "DefaultCoreData.h"


@implementation SettingPeriod

@synthesize configData = configData_;
@synthesize mode = mode_;

- (void)dealloc
{
	[sections_ release];
	[dataSource_ release];
	
	[configData_ release];
	[categoryCoreData_ release];

	[super dealloc];
}

- (id)init
{
	if ( self = [super initWithStyle:UITableViewStyleGrouped] ) {
		mode_ = SettingPeriodModeAll;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setDataForMode];

	categoryCoreData_ = [DefaultCoreData createCategoryCoreData];
	[categoryCoreData_ retain];
}


- (void)setDataForMode
{
	NSString *periodString = LOCALIZE(@"PERIOD");
	NSString *categoryString = LOCALIZE(@"CATEGORY_LABEL");
	NSString *startDate = LOCALIZE(@"START_DATE");
	NSString *endDate = LOCALIZE(@"END_DATE");
	NSString *kind = LOCALIZE(@"KIND");
	
	switch (mode_) {
		case SettingPeriodModeAll:
			sections_ = [[NSArray alloc] initWithObjects:periodString, categoryString, nil];
			NSArray *rows1 = [NSArray arrayWithObjects:startDate, endDate, nil];
			NSArray *rows2 = [NSArray arrayWithObjects:kind, nil];
			dataSource_ = [[NSArray alloc] initWithObjects:rows1, rows2, nil];
			break;
		case SettingPeriodModeOnlyPeriod:
			sections_ = [[NSArray alloc] initWithObjects:periodString, nil];
			NSArray *rowsPeriod = [NSArray arrayWithObjects:startDate, endDate, nil];
			dataSource_ = [[NSArray alloc] initWithObjects:rowsPeriod, nil];
			break;
		case SettingPeriodModeOnlyCategory:
			sections_ = [[NSArray alloc] initWithObjects:categoryString, nil];
			NSArray *rowsCategory = [NSArray arrayWithObjects:kind, nil];
			dataSource_ = [[NSArray alloc] initWithObjects:rowsCategory, nil];
			break;
	}
}


#pragma mark -
#pragma mark TableView


/*
 * セクションの数
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [sections_ count];
}


/*
 * セクション内の行数
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[dataSource_ objectAtIndex:section] count];
}


/*
 * セクション名
 */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [sections_ objectAtIndex:section];
}


/*
 * セルのデータ表示
 */

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString *identifier = @"basis-cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if ( nil == cell ) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									  reuseIdentifier:identifier];
		[cell autorelease];
	}
	
	[self setCellWithIndexPath:indexPath AndCell:cell];
	cell.textLabel.numberOfLines = 0;
	
	return cell;
}

- (void)setCellWithIndexPath:(NSIndexPath *)indexPath AndCell:(UITableViewCell *)cell
{
	switch (mode_) {
		case SettingPeriodModeAll:
			if ( indexPath.section == 0 ) { 
				// 期間分類
				
				if ( indexPath.row == 0 ) { 
					// スタート時刻
					cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@",
										   [[dataSource_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row],
										   [self createPeriodLabel:self.configData.startPeriod]];
				} else if ( indexPath.row == 1 ) { 
					// 終了時刻
					cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@",
										   [[dataSource_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row],
										   [self createPeriodLabel:self.configData.endPeriod]];
				}
			} else if ( indexPath.section == 1 ) { 
				// タグ分類
				
				cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@",
									   [[dataSource_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row],
									   [self createCategoryLabel:self.configData.categoryId]];
			}
			break;
		case SettingPeriodModeOnlyPeriod:
			if ( indexPath.row == 0 ) { 
				// スタート時刻
				cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@",
									   [[dataSource_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row],
									   [self createPeriodLabel:self.configData.startPeriod]];
			} else if ( indexPath.row == 1 ) { 
				// 終了時刻
				cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@",
									   [[dataSource_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row],
									   [self createPeriodLabel:self.configData.endPeriod]];
			}
			break;
		case SettingPeriodModeOnlyCategory:
			// タグ分類
			
			cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@",
								   [[dataSource_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row],
								   [self createCategoryLabel:self.configData.categoryId]];
			break;
	}
}

- (NSString *)createPeriodLabel:(NSDate*)date
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"YYYY/MM/dd"];
	return [formatter stringFromDate:date];
}

- (NSString *)createCategoryLabel:(NSInteger)categoryId
{
	NSString *text = @"";
	
	if ( categoryId ) {
		SimpleCoreDataFactory *simpleCoreDataFactory = [SimpleCoreDataFactory sharedCoreData];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryId == %d", categoryId];
		[simpleCoreDataFactory setPredicate:categoryCoreData_.fetchedResultsController.fetchRequest
							  WithPredicate:predicate];
		
		NSArray *array = [categoryCoreData_ fetchObjectAll];
		if ( [array count] ) {
			NSManagedObject *managedObject = [array objectAtIndex:0];
			text = [managedObject valueForKey:@"category"];
		}
	}
	
	return text;
}


/*
 * セルを選択
 */

- (void)tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	switch (mode_) {
		case SettingPeriodModeAll:
			if ( indexPath.section == 0 ) {
				switch (indexPath.row) {
					case 0:
						[self executeDatePickerWithDate:self.configData.startPeriod AndDataType:@"startPeriod"];
						break;
					case 1:
						[self executeDatePickerWithDate:self.configData.endPeriod AndDataType:@"endPeriod"];
						break;
				}
			} else if ( indexPath.section == 1 ) {
				[self executeCategoryPicker];
			}
			break;
		case SettingPeriodModeOnlyPeriod:
			switch (indexPath.row) {
				case 0:
					[self executeDatePickerWithDate:self.configData.startPeriod AndDataType:@"startPeriod"];
					break;
				case 1:
					[self executeDatePickerWithDate:self.configData.endPeriod AndDataType:@"endPeriod"];
					break;
			}
			break;
		case SettingPeriodModeOnlyCategory:
			[self executeCategoryPicker];
			break;
	}
}

- (void)executeDatePickerWithDate:(NSDate *)date AndDataType:(NSString *)dataType
{
	DatePickerView *datePickerView = [[[DatePickerView alloc] init] autorelease];
	datePickerView.delegate = self;
	datePickerView.date = date;
	datePickerView.dateType = dataType;
	[self presentModalViewController:datePickerView animated:YES];
}

- (void)executeCategoryPicker
{
	CategoryPickerView *categoryPickerView = [[[CategoryPickerView alloc] init] autorelease];
	categoryPickerView.delegate = self;
	categoryPickerView.configData = self.configData;
	[self presentModalViewController:categoryPickerView animated:YES];
}



#pragma mark -
#pragma mark For Delegate 


/*
 * DatePickerViewDelegate
 */

- (void)updateDate:(NSArray *)array
{
	NSDate *date = [array objectAtIndex:0];
	NSString *type = [array objectAtIndex:1];
	
	if ( [type isEqualToString:@"startPeriod"] ) {
	 	self.configData.startPeriod = date;
	} else if ( [type isEqualToString:@"endPeriod"] ) {
		self.configData.endPeriod = date;
	}
	
	[self.tableView reloadData];
}


/*
 * CategoryPickerViewDelegate
 */

- (void)doneCategoryPicker
{
	[self.tableView reloadData];
}


@end
