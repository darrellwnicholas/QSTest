//
//  EmployeesViewController.h
//  QuickSchedule
//
//  Created by Darrell Nicholas on 8/11/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"
#import "ScheduleViewController.h"
#import "MyManager.h"



@interface EmployeesViewController : UITableViewController


@property (strong, nonatomic) WorkShift *activeShift;


- (IBAction)done:(UIStoryboardSegue *)segue;
- (IBAction)cancel:(UIStoryboardSegue *)segue;

@end
