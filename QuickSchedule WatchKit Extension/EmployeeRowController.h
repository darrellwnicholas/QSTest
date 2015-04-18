//
//  EmployeeRowController.h
//  QuickSchedule
//
//  Created by Darrell Nicholas on 4/18/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyManager.h"
#import <WatchKit/WatchKit.h>

@interface EmployeeRowController : NSObject
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *employeeNameLabel;

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *totalHoursLabel;

@end
