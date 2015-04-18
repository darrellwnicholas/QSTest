//
//  EditShiftDetailViewController.h
//  QuickSchedule
//
//  Created by Darrell Nicholas on 9/2/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkDay.h"
#import "WorkShift.h"

@interface EditShiftDetailViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) WorkDay *currentDay;
@property (strong, nonatomic) WorkShift *currentShift;
@property (weak, nonatomic) IBOutlet UITextField *shiftNameField;

//@property (weak, nonatomic) IBOutlet UITextField *startTimeField;
//@property (weak, nonatomic) IBOutlet UITextField *endTimeField;
//@property (weak, nonatomic) IBOutlet UILabel *shiftLengthField;


@end
