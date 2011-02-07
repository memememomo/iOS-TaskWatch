//
//  DefaultCoreData.h
//  TaskWatch
//
//  Created by Your Name on 11/01/20.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleCoreDataFactory.h"

@interface DefaultCoreData : NSObject {

}

+ (NSDictionary *)sortDescription;
+ (SimpleCoreData *)createLogCoreData:(NSString *)sectionNameKeyPath;
+ (SimpleCoreData *)createCategoryCoreData;
+ (SimpleCoreData *)createCategoryIdCoreData;
+ (NSInteger)addCategory:(NSString *)categoryStr;
@end
