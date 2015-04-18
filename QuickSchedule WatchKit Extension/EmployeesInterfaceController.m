//
//  EmployeesInterfaceController.m
//  QuickSchedule
//
//  Created by Darrell Nicholas on 4/18/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import "EmployeesInterfaceController.h"
#import "MyManager.h"
#import "EmployeeRowController.h"


@interface EmployeesInterfaceController()
@property (nonatomic, strong) NSMutableArray *employees;
@end


@implementation EmployeesInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.selectedShift = (WorkShift *)context;
    // Configure interface objects here.
    MyManager *manager = [MyManager sharedManager];
    self.employees = manager.masterEmployeeList;
    [_table setNumberOfRows:[manager countOfList] withRowType:@"EmployeeRowType"];
    if ([manager countOfList] == 0) {
        [self.addEmployeeMessageLabel setHidden:NO];
    } else {
        [self.addEmployeeMessageLabel setHidden:YES];
        for (Employee *emp in [manager masterEmployeeList]) {
            [manager calculateHoursForEmployee:emp];
        }
        
        NSUInteger index = 0;
        for (Employee *e in self.employees) {
            EmployeeRowController *rc = [[EmployeeRowController alloc] init];
            rc = (EmployeeRowController *)[self.table rowControllerAtIndex:index];
            [rc.employeeNameLabel setText:[NSString stringWithFormat:@"%@", e.description]];
            [rc.totalHoursLabel setText:[self stringFromHours:e.hours]];
            index++;
        }

    }
}

- (NSString *)stringFromHours:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hour = (ti / 3600);
    return [NSString stringWithFormat:@"%li:%02li Hours", (long)hour, (long)minutes];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    Employee *employee = [self.employees objectAtIndex:rowIndex];
    WorkShift *shift = self.selectedShift;
    shift.assignedEmployee = employee;
    [[MyManager sharedManager] saveChanges];
    [self popController];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



