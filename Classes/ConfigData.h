//
//  ConfigData.h
//  TaskWatch
//
//  Created by Your Name on 11/01/18.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigData : NSObject
{
	NSDate *startPeriod_, *endPeriod_;
	NSInteger categoryId_;
	NSString *category_;
}

@property (nonatomic, retain) NSDate *startPeriod;
@property (nonatomic, retain) NSDate *endPeriod;
@property (nonatomic) NSInteger categoryId;
@property (nonatomic, retain) NSString *category;

@end

