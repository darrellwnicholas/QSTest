//
//  WorkShift.m
//  Debbers Schedule
//
//  Created by Darrell on 8/3/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import "WorkShift.h"

@implementation WorkShift
@synthesize shiftName, hours, assignedEmployee, startTime, endTime;

- (void) encodeWithCoder:(NSCoder *)encoder
{
    NSTimeInterval timeInterval;
   // NSTimeInterval timeInterval = [endTime timeIntervalSinceDate:startTime];
   // self.hours = timeInterval;
    if ([self.startTime compare:self.endTime] == NSOrderedDescending) {
        timeInterval = 86400;
        NSTimeInterval temp = [self.startTime timeIntervalSinceDate:self.endTime];
        timeInterval -= temp;
        self.hours = timeInterval;
    } else {
        timeInterval = [self.endTime timeIntervalSinceDate:self.startTime];
        self.hours = timeInterval;
    }
    [encoder encodeObject:self.shiftName forKey:@"shiftnamekey"];
    [encoder encodeObject:[NSNumber numberWithDouble:self.hours] forKey:@"hourskey"];
    [encoder encodeObject:self.assignedEmployee forKey:@"assignedEmployeekey"];
    [encoder encodeObject:self.startTime forKey:@"startTime"];
    [encoder encodeObject:self.endTime forKey:@"endTime"];
    [encoder encodeObject:self.inDay forKey:@"inDay"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self.shiftName = [decoder decodeObjectForKey:@"shiftnamekey"];
    self.hours = [[decoder decodeObjectForKey:@"hourskey"] doubleValue];
    self.assignedEmployee = [decoder decodeObjectForKey:@"assignedEmployeekey"];
    self.startTime = [decoder decodeObjectForKey:@"startTime"];
    self.endTime = [decoder decodeObjectForKey:@"endTime"];
    self.inDay = [decoder decodeObjectForKey:@"inDay"];
    
    
    return self;
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hour = (ti / 3600);
    return [NSString stringWithFormat:@"%li:%02li", (long)hour, (long)minutes];
}

@end
