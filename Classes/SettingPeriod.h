//
//  SettingPeriod.h
//  TaskWatch
//
//  Created by Your Name on 11/02/07.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigData.h"
#import "SimpleCoreDataFactory.h"
#import "CategoryPickerView.h"
#import "DatePickerView.h"

enum SettingPeriodMode {
	SettingPeriodModeAll,
	SettingPeriodModeOnlyPeriod,
	SettingPeriodModeOnlyCategory,
};


@interface SettingPeriod : UITableViewController <DatePickerViewDelegate> {
	NSArray *sections_;
	NSArray *dataSource_;
	
	ConfigData *configData_;
	
	SimpleCoreData *categoryCoreData_;
	
	NSInteger mode_;
}

@property (nonatomic, retain) ConfigData *configData;
@property (nonatomic) NSInteger mode;

- (NSString *)createPeriodLabel:(NSDate *)date;
- (NSString *)createCategoryLabel:(NSInteger)categoryId;
- (void)setDataForMode;
- (void)setCellWithIndexPath:(NSIndexPath *)indexPath AndCell:(UITableViewCell *)cell;
- (void)executeCategoryPicker;
- (void)executeDatePickerWithDate:(NSDate *)date AndDataType:(NSString *)dataType;

@end
