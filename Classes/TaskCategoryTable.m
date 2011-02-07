//
//  TaskCategoryTable.m
//  TaskWatch
//
//  Created by Your Name on 11/01/21.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "TaskCategoryTable.h"
#import "TaskCategoryTableAdd.h"


@implementation TaskCategoryTable


/*
 * 初期化と後処理
 */

- (void)dealloc
{
	[logCoreData_ release];
	[categoryCoreData_ release];
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}

- (void)viewDidLoad 
{
	[super viewDidLoad];
	
	// 集計
	logCoreData_ = [DefaultCoreData createLogCoreData:nil];
	[logCoreData_ retain];
	categoryCoreData_ = [DefaultCoreData createCategoryCoreData];
	[categoryCoreData_ retain];
	

	// 追加ボタン
	UIBarButtonItem *configButton = [[[UIBarButtonItem alloc]
									 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
									 target:self
									 action:@selector(addButtonPush:)]
									autorelease];
	self.navigationItem.rightBarButtonItem = configButton;
	
}

/*
 * セクション数を返す
 */

- (NSInteger)tableView:(UITableView*)tableView 
{
	return [[categoryCoreData_.fetchedResultsController sections] count];
}


/*
 * セクション数
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [[categoryCoreData_.fetchedResultsController sections] count];
}


/*
 * セクションの中のデータ数を返す
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	id <NSFetchedResultsSectionInfo> sectionInfo = [[categoryCoreData_.fetchedResultsController sections] objectAtIndex:0];
	return [sectionInfo numberOfObjects];
}


/*
 * セルの内容を返す
 */

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString *identifier = @"basis-cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if ( nil == cell ) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									  reuseIdentifier:identifier];
		[cell autorelease];
	}
	
	NSManagedObject *managedObject = [categoryCoreData_.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = [managedObject valueForKey:@"category"];
	
	return cell;
}


/*
 * セルを選択
 */

- (void)tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	TaskCategoryTableDetail *categoryTableDetail = [[[TaskCategoryTableDetail alloc] 
													 initWithNibName:@"TaskCategoryTableDetail" bundle:nil]
													autorelease];
	categoryTableDetail.title = LOCALIZE(@"CATEGORY_LABEL");
	categoryTableDetail.indexPath = indexPath;
	categoryTableDetail.logCoreData = logCoreData_;
	categoryTableDetail.categoryCoreData = categoryCoreData_;
	[self.navigationController pushViewController:categoryTableDetail animated:YES];
}


- (void)addButtonPush:(id)sender
{
	TaskCategoryTableAdd *categoryTableAdd = [[[TaskCategoryTableAdd alloc] 
											   initWithNibName:@"TaskCategoryTableAdd" bundle:nil]
											  autorelease];
	categoryTableAdd.title = LOCALIZE(@"ADD_CATEGORY");

	[self.navigationController pushViewController:categoryTableAdd animated:YES];
}


@end
