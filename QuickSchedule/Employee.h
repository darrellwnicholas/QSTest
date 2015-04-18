//
//  Employee.h
//  Debbers Schedule
//
//  Created by Darrell on 8/3/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Employee : NSObject <NSCoding>

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (nonatomic) float hours;
@property (strong, nonatomic) NSString *email;

- (id)initWithFirstName:(NSString *)first lastName:(NSString *)last email:(NSString *)email;

@end
