//
//  MyManager.m
//  QuickSchedule
//
//  Created by Darrell Nicholas on 9/17/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import "MyManager.h"

@interface MyManager ()

- (void)initializeEmployeeList;

@end

@implementation MyManager
@synthesize masterEmployeeList;

+ (MyManager *)sharedManager
{
    static MyManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (NSMutableArray *)getAllShifts {
    NSMutableArray *theArray = [[NSMutableArray alloc] init];
    for (WorkDay *day in [self daysArray]) {
        for (WorkShift *shift in day.shifts) {
            [theArray addObject:shift];
        }
    }
    return theArray;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *path = [self itemArchivePath];
        _daysArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];

        [self initializeEmployeeList];
        
    }
    return self;
}

- (NSMutableArray *)daysArray
{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dayNumber" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    _daysArray = [[_daysArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    return _daysArray;
}

- (void)initializeEmployeeList
{
    NSString *path = [self employeeArchivePath];
    NSMutableArray *storedMasterEmployeeList = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (storedMasterEmployeeList) {
        self.masterEmployeeList = storedMasterEmployeeList;
    } else {
        NSMutableArray *employeeList = [[NSMutableArray alloc] init];
        self.masterEmployeeList = employeeList;
    }
}

- (NSString *)itemArchivePath
{
    // shared app group ID
    NSString *groupID = @"group.YAZVT7PQ49.com.darrellnicholas.QuickSchedule";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // grabbing a URL and simulataneously changing it to a string.
    NSString *groupPath = [[fileManager containerURLForSecurityApplicationGroupIdentifier:groupID] absoluteString];
    // stripping off the slashes from the URL
    NSString *newGroupPath = [groupPath substringWithRange:NSMakeRange(6, [groupPath length]-6)];
    
    return [newGroupPath stringByAppendingPathComponent:@"days.plist"];
}

- (NSString *)employeeArchivePath
{
    // shared app group ID
    NSString *groupID = @"group.YAZVT7PQ49.com.darrellnicholas.QuickSchedule";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // grabbing a URL and simulataneously changing it to a string.
    NSString *groupPath = [[fileManager containerURLForSecurityApplicationGroupIdentifier:groupID] absoluteString];
    // stripping off the slashes from the URL
    NSString *newGroupPath = [groupPath substringWithRange:NSMakeRange(6, [groupPath length]-6)];
    return [newGroupPath stringByAppendingPathComponent:@"employees.plist"];
}

- (void)setMasterEmployeeList:(NSMutableArray *)newMasterEmployeeList
{
    if (masterEmployeeList != newMasterEmployeeList) {
        masterEmployeeList = [newMasterEmployeeList mutableCopy];
    }
}

- (NSMutableArray *)masterEmployeeList
{
    return masterEmployeeList;
}

- (WorkDay *)createDay
{
    WorkDay *d = [[WorkDay alloc] init];
    [self.daysArray addObject:d];
    return d;
}

- (BOOL)saveChanges
{
    // Shared App Group Identifier
    NSString *groupID = @"group.YAZVT7PQ49.com.darrellnicholas.QuickSchedule";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // creating a URL to the App Group
    NSURL *path = [fileManager containerURLForSecurityApplicationGroupIdentifier:groupID];
    // changing the URL to a String because this app used string paths instead of URLs so it's just easier to keep it this way
    NSString *itemPath = [[path URLByAppendingPathComponent:@"days.plist"] absoluteString];
    NSString *empPath = [[path URLByAppendingPathComponent:@"employees.plist"] absoluteString];
    
    // I have to strip off the "file://" from the URL to make it work as a string. It ends up creating a string with 2 "//"s at the
    // beginning, but for some reason, it still converts it to just a single slash so I'm not messing with it at this time, maybe
    // later I will come back and see if I can adjust the following from "6 and -6" to "7 and -7" or whatever, but for now, ios
    // is handling it, and I will let it. I am making this comment in case Apple changes something in the future and this causes
    // issues. -Darrell 4/8/2015
    return ([NSKeyedArchiver archiveRootObject:self.daysArray toFile:[itemPath substringWithRange:NSMakeRange(6, [itemPath length]-6)]] && [NSKeyedArchiver archiveRootObject:self.masterEmployeeList toFile:[empPath substringWithRange:NSMakeRange(6, [empPath length]-6)]]);
}

- (Employee *)createEmployeeWithFirstName:(NSString*)first andLastName:(NSString*)last andEmail:(NSString *)email
{
    Employee *employee = [[Employee alloc] initWithFirstName:first lastName:last email:email];
    return employee;
}
- (WorkShift *)createShift
{
    WorkShift *shift = [[WorkShift alloc] init];
    shift.inDay = @"";
    return shift;
}
- (void)assignEmployee:(Employee*)employee toShift:(WorkShift*)shift
{
    shift.assignedEmployee = employee;
}

- (void)calculateHoursForEmployee:(Employee *)emp
{
    emp.hours = 0;
    for (WorkDay *day in self.daysArray) {
        for (WorkShift *shift in day.shifts) {
            if ([shift.assignedEmployee.description isEqualToString:emp.description]) {
                emp.hours += shift.hours;
            }
        }
    }
    
}

- (void)addEmployeeToList:(Employee *)newEmployee {
    [self.masterEmployeeList addObject:newEmployee];
}

- (NSUInteger)countOfList {
    return [self.masterEmployeeList count];
}

- (Employee *)objectInListAtIndex:(NSUInteger)theIndex {
    return [self.masterEmployeeList objectAtIndex:theIndex];
}

- (void)removeEmployee:(Employee *)emp
{
    [self.masterEmployeeList removeObjectIdenticalTo:emp];
}

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.masterEmployeeList forKey:@"employeeListKey"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self.masterEmployeeList = [decoder decodeObjectForKey:@"employeeListKey"];
    
    return self;
}

- (void)initialSetUp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSString *startTime1 = @"6:00 AM";
    NSString *startTime2 = @"2:00 PM";
    NSString *endTime1 = startTime2;
    NSString *endTime2 = @"10:00 PM";
    
    MyManager *sharedManager = [MyManager sharedManager];
    WorkDay *mon = [sharedManager createDay];
    mon.name = @"Monday";
    mon.dayNumber = 0;
    WorkShift *shift = [sharedManager createShift];
    shift.shiftName = @"Shift 1";
    
    WorkShift *shift2 = [sharedManager createShift];
    shift2.shiftName = @"Shift 2";
    
    shift.startTime = [dateFormatter dateFromString:startTime1];
    shift.endTime = [dateFormatter dateFromString:endTime1];
    shift2.startTime = [dateFormatter dateFromString:startTime2];
    shift2.endTime = [dateFormatter dateFromString:endTime2];
    [mon.shifts addObject:shift];
    [mon.shifts addObject:shift2];
    
    WorkDay *tues = [sharedManager createDay];
    tues.name = @"Tuesday";
    tues.dayNumber = 1;
    WorkShift *shift3 = [sharedManager createShift];
    shift3.shiftName = @"Shift 1";
    WorkShift *shift4 = [sharedManager createShift];
    shift4.shiftName = @"Shift 2";
    shift3.startTime = [dateFormatter dateFromString:startTime1];
    shift3.endTime = [dateFormatter dateFromString:endTime1];
    shift4.startTime = [dateFormatter dateFromString:startTime2];
    shift4.endTime = [dateFormatter dateFromString:endTime2];
    [tues.shifts addObject:shift3];
    [tues.shifts addObject:shift4];
    
    WorkDay *wed = [sharedManager createDay];
    wed.name = @"Wednesday";
    wed.dayNumber = 2;
    WorkShift *shift5 = [sharedManager createShift];
    shift5.shiftName = @"Shift 1";
    WorkShift *shift6 = [sharedManager createShift];
    shift6.shiftName = @"Shift 2";
    shift5.startTime = [dateFormatter dateFromString:startTime1];
    shift5.endTime = [dateFormatter dateFromString:endTime1];
    shift6.startTime = [dateFormatter dateFromString:startTime2];
    shift6.endTime = [dateFormatter dateFromString:endTime2];
    [wed.shifts addObject:shift5];
    [wed.shifts addObject:shift6];
    
    WorkDay *thurs = [sharedManager createDay];
    thurs.name = @"Thursday";
    thurs.dayNumber = 3;
    WorkShift *shift7 = [sharedManager createShift];
    shift7.shiftName = @"Shift 1";
    WorkShift *shift8 = [sharedManager createShift];
    shift8.shiftName = @"Shift 2";
    shift7.startTime = [dateFormatter dateFromString:startTime1];
    shift7.endTime = [dateFormatter dateFromString:endTime1];
    shift8.startTime = [dateFormatter dateFromString:startTime2];
    shift8.endTime = [dateFormatter dateFromString:endTime2];
    [thurs.shifts addObject:shift7];
    [thurs.shifts addObject:shift8];
    
    WorkDay *friday = [sharedManager createDay];
    friday.name = @"Friday";
    friday.dayNumber = 4;
    WorkShift *shift9 = [sharedManager createShift];
    shift9.shiftName = @"Shift 1";
    WorkShift *shift10 = [sharedManager createShift];
    shift10.shiftName = @"Shift 2";
    shift9.startTime = [dateFormatter dateFromString:startTime1];
    shift9.endTime = [dateFormatter dateFromString:endTime1];
    shift10.startTime = [dateFormatter dateFromString:startTime2];
    shift10.endTime = [dateFormatter dateFromString:endTime2];
    [friday.shifts addObject:shift9];
    [friday.shifts addObject:shift10];
    
    WorkDay *sat = [sharedManager createDay];
    sat.name = @"Saturday";
    sat.dayNumber = 5;
    WorkShift *shift11 = [sharedManager createShift];
    shift11.shiftName = @"Shift 1";
    WorkShift *shift12 = [sharedManager createShift];
    shift12.shiftName = @"Shift 2";
    shift11.startTime = [dateFormatter dateFromString:startTime1];
    shift11.endTime = [dateFormatter dateFromString:endTime1];
    shift12.startTime = [dateFormatter dateFromString:startTime2];
    shift12.endTime = [dateFormatter dateFromString:endTime2];
    [sat.shifts addObject:shift11];
    [sat.shifts addObject:shift12];
    
    WorkDay *sun = [sharedManager createDay];
    sun.name = @"Sunday";
    sun.dayNumber = 6;
    WorkShift *shift13 = [sharedManager createShift];
    shift13.shiftName = @"Shift 1";
    WorkShift *shift14 = [sharedManager createShift];
    shift14.shiftName = @"Shift 2";
    shift13.startTime = [dateFormatter dateFromString:startTime1];
    shift13.endTime = [dateFormatter dateFromString:endTime1];
    shift14.startTime = [dateFormatter dateFromString:startTime2];
    shift14.endTime = [dateFormatter dateFromString:endTime2];
    [sun.shifts addObject:shift13];
    [sun.shifts addObject:shift14];
    
    NSMutableArray *archivedDaysArray = [[NSMutableArray alloc] initWithObjects:mon, tues, wed, thurs, friday, sat, sun, nil];
    for (WorkDay *d in archivedDaysArray) {
        for (WorkShift *s in d.shifts) {
            s.inDay = d.name;
        }
    }
    sharedManager.daysArray = archivedDaysArray;
    if (![sharedManager saveChanges]) {
        NSLog(@"Did not save.");
    } else {
        NSLog(@"Saved");
    }
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.YAZVT7PQ49.com.darrellnicholas.QuickSchedule"];
    [defaults setBool:YES forKey:@"hasBeenLaunched"];
    [defaults synchronize];
    
    
}

@end
