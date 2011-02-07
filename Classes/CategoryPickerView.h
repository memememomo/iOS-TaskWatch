//
//  CategoryPickerView.h
//  TaskWatch
//
//  Created by Your Name on 11/01/17.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigData.h"
#import "SimpleCoreDataFactory.h"

@protocol CategoryPickerViewDelegate
- (void)doneCategoryPicker;
@end


@interface CategoryPickerView : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource> {
	id<CategoryPickerViewDelegate> delegate;
	
	IBOutlet UIButton *setButton_;
	IBOutlet UIButton *cancelButton_;
	IBOutlet UIPickerView *categoryPickerView_;
	
	ConfigData *configData_;
	
	SimpleCoreData *categoryCoreData_;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) ConfigData *configData;

- (IBAction)setButtonPush:(id)sender;
- (IBAction)cancelButtonPush:(id)sender;

@end
