//
//  MyManager.h
//  QuickSchedule
//
//  Created by Darrell Nicholas on 9/17/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Employee.h"
#import "WorkDay.h"
#import "WorkShift.h"

@interface MyManager : NSObject <NSCoding>

@property (strong, nonatomic) NSMutableArray *daysArray;
@property (nonatomic, retain) NSMutableArray *masterEmployeeList;

+ (MyManager *)sharedManager;
- (NSString *)itemArchivePath;
- (NSString *)employeeArchivePath;
- (BOOL)saveChanges;
- (WorkDay *)createDay;
- (Employee *)createEmployeeWithFirstName:(NSString*)first andLastName:(NSString*)last andEmail:(NSString *)email;
- (WorkShift *)createShift;
- (void)assignEmployee:(Employee*)employee toShift:(WorkShift*)shift;
- (void)removeEmployee:(Employee*)emp;
- (void)addEmployeeToList:(Employee *)newEmployee;
- (NSUInteger)countOfList;
- (Employee *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)calculateHoursForEmployee:(Employee *)emp;
- (void)initialSetUp;
- (NSMutableArray *)getAllShifts;

@end
