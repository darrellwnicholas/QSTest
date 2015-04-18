//
//  InterfaceController.m
//  QuickSchedule WatchKit Extension
//
//  Created by Darrell Nicholas on 4/18/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import "InterfaceController.h"
#import "ShiftRowController.h"
#import "MyManager.h"
#import "EmployeesInterfaceController.h"


@interface InterfaceController()
@property (nonatomic, strong) NSMutableArray *shifts;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    [self configureCells];
}

- (instancetype)contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex {
    return self.shifts[rowIndex];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self configureCells];
}

- (void)configureCells {
    MyManager *manager = [MyManager sharedManager];
    self.shifts = manager.getAllShifts;
    [_table setNumberOfRows:self.shifts.count withRowType:@"ShiftRowType"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    
    NSUInteger index = 0;
    for (WorkShift *shift in self.shifts) {
        ShiftRowController *r = [[ShiftRowController alloc] init];
        r = (ShiftRowController*)[self.table rowControllerAtIndex:index];
        if (shift.assignedEmployee == nil) {
            [r.assignedEmployeeLabel setText:@""];
        } else {
            [r.assignedEmployeeLabel setText:shift.assignedEmployee.description];
        }
        [r.shiftNameLabel setText:shift.shiftName];
        [r.shiftTimeLabel setText:[NSString stringWithFormat:@"%@-%@",[df stringFromDate:shift.startTime], [df stringFromDate:shift.endTime]]];
        [r.dayImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", shift.inDay]]];
        index++;
    }
    
}


- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    [[MyManager sharedManager] saveChanges];
}

@end



