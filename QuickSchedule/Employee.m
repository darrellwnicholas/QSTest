//
//  Employee.m
//  Debbers Schedule
//
//  Created by Darrell on 8/3/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import "Employee.h"

@implementation Employee
@synthesize firstName, lastName, email;

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
}

- (id)initWithFirstName:(NSString *)first lastName:(NSString *)last email:(NSString *)mail
{
    self = [super init];
    if (self) {
        firstName = first;
        lastName = last;
        email = mail;
        return self;
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.firstName forKey:@"firstnamekey"];
    [aCoder encodeObject:self.lastName forKey:@"lastnamekey"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.hours] forKey:@"hourskey"];
    [aCoder encodeObject:self.email forKey:@"emailkey"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.firstName = [aDecoder decodeObjectForKey:@"firstnamekey"];
    self.lastName = [aDecoder decodeObjectForKey:@"lastnamekey"];
    self.hours = [[aDecoder decodeObjectForKey:@"hourskey"] doubleValue];
    self.email = [aDecoder decodeObjectForKey:@"emailkey"];
    
    return self;
}

@end
