//
//  WorkDay.h
//  Debbers Schedule
//
//  Created by Darrell on 8/3/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkShift.h"
#import "Employee.h"

@interface WorkDay : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *shifts;
@property (assign, nonatomic) int dayNumber;

@end
