//
//  EditDayViewController.h
//  QuickSchedule
//
//  Created by Darrell Nicholas on 9/2/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkDay.h"

@interface EditDayViewController : UITableViewController

@property (strong, nonatomic) WorkDay *currentDay;
- (IBAction)addShift:(id)sender;

@end
