//
//  WorkDay.m
//  Debbers Schedule
//
//  Created by Darrell on 8/3/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import "WorkDay.h"

@implementation WorkDay
@synthesize name, shifts, dayNumber;

- (id)init
{
    self = [super init];
    if (self) {
        self.shifts = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"namekey"];
    [encoder encodeObject:self.shifts forKey:@"shiftskey"];
    [encoder encodeObject:[NSNumber numberWithInt:self.dayNumber] forKey:@"daynumberkey"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self.name = [decoder decodeObjectForKey:@"namekey"];
    self.shifts = [decoder decodeObjectForKey:@"shiftskey"];
    self.dayNumber = [[decoder decodeObjectForKey:@"daynumberkey"] intValue];
    
    return self;
}


@end
