//
//  EmployeesInterfaceController.h
//  QuickSchedule
//
//  Created by Darrell Nicholas on 4/18/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "WorkShift.h"

@interface EmployeesInterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceTable *table;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *addEmployeeMessageLabel;
@property (weak, nonatomic) WorkShift *selectedShift;
@end
