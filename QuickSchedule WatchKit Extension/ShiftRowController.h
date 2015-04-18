//
//  ShiftRowController.h
//  QuickSchedule
//
//  Created by Darrell Nicholas on 4/18/15.
//  Copyright (c) 2015 Darrell Nicholas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyManager.h"
#import <WatchKit/WatchKit.h>

@interface ShiftRowController : NSObject

@property (weak, nonatomic) IBOutlet WKInterfaceImage *dayImage;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *assignedEmployeeLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *shiftNameLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *shiftTimeLabel;



@end
