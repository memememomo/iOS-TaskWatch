//
//  TaskCategoryTableAdd.m
//  TaskWatch
//
//  Created by Your Name on 11/01/22.
//  Copyright 2011 Your Org Name. All rights reserved.
//

#import "TaskCategoryTableAdd.h"


@implementation TaskCategoryTableAdd

- (void)dealloc
{
	
	[super dealloc];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[newCategoryName_ resignFirstResponder];
	return YES;
}	

- (IBAction)addButtonPush:(id)sender
{
	if ( ![newCategoryName_.text isEqualToString:@""] ) { 
		[DefaultCoreData addCategory:newCategoryName_.text];
	}

	[self.navigationController popViewControllerAnimated:YES];
}

@end
