//
//  WorkShift.h
//  Debbers Schedule
//
//  Created by Darrell on 8/3/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Employee.h"
#import "WorkDay.h"

@interface WorkShift : NSObject <NSCoding>

@property (strong, nonatomic) NSString *shiftName;
@property (nonatomic) NSTimeInterval hours;
@property (strong, nonatomic) Employee *assignedEmployee;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) NSString *inDay;

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval;

@end
