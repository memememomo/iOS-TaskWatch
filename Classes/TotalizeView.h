//
//  TotalizeView.h
//  TaskWatch
//
//  Created by Your Name on 11/01/18.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleCoreDataFactory.h"
#import "ConfigData.h"

@interface TotalizeView : UITableViewController {
	NSArray *sections_;
	NSArray *dataSource_;
	
	UISegmentedControl *segment_;
	
	NSInteger totalizeType_;
	
	SimpleCoreData *logCoreData_;
	SimpleCoreData *categoryCoreData_;
	
	ConfigData *configData_;
	
	NSArray *totalizes_;
}

@property (nonatomic, retain) NSArray *totalizes;

- (void)initTotalize;
- (NSInteger)sumStopWatch:(NSString *)unit AndCoreData:(SimpleCoreData *)coreData;
- (NSArray *)sumStopWatchWithType:(NSInteger)type AndUnit:(NSString *)unit AndCoreData:(SimpleCoreData *)coreData;
- (NSArray *)calcSumWithCategoryId:(NSInteger)categoryId;
- (NSArray *)calcCarryWithHour:(NSInteger)hour AndMinite:(NSInteger)minite AndMiriSecond:(float)miriSecond;

@end
