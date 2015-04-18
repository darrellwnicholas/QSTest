//
//  AddEmployeeViewController.h
//  QuickSchedule
//
//  Created by Darrell Nicholas on 8/17/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Employee;

@interface AddEmployeeViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) Employee *employee;

@end
