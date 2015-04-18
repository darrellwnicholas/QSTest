//
//  AddEmployeeViewController.m
//  QuickSchedule
//
//  Created by Darrell Nicholas on 8/17/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import "AddEmployeeViewController.h"
#import "Employee.h"
#import "MyManager.h"

@interface AddEmployeeViewController ()

@end

@implementation AddEmployeeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.toolbar setTranslucent:NO];
    [self.navigationController.toolbar setTintColor:[UIColor colorWithRed:0.25 green:0.4 blue:0.4 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.25 green:0.4 blue:0.4 alpha:1.0]];
    [self.navigationController.toolbar setBarTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:0.95 alpha:0.4]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:0.95 alpha:0.4]];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == self.firstNameField) || (textField == self.lastNameField) || (textField == self.emailField)) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
        if ([self.firstNameField.text length] || [self.lastNameField.text length] || [self.emailField.text length]) {
            
            Employee *newEmployee = [[MyManager sharedManager] createEmployeeWithFirstName:self.firstNameField.text andLastName:self.lastNameField.text andEmail:self.emailField.text];
            [[MyManager sharedManager] addEmployeeToList:newEmployee];
            self.employee = newEmployee;
            
            //NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:newEmployee, nil];
            //[manager.masterEmployeeList addObject:newEmployee];
            
        }
    }
}

@end
