//
//  TaskCategoryTableAdd.h
//  TaskWatch
//
//  Created by Your Name on 11/01/22.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultCoreData.h"


@interface TaskCategoryTableAdd : UIViewController {
	IBOutlet UITextField *newCategoryName_;
	
	IBOutlet UILabel *newCategoryNameLabel_;
}

- (IBAction)addButtonPush:(id)sender;

@end
