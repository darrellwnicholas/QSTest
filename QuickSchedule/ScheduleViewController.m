//
//  ScheduleViewController.m
//  QuickSchedule
//
//  Created by Darrell Nicholas on 8/11/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import "ScheduleViewController.h"
#import "EmployeesViewController.h"
#import "EditShiftsViewController.h"
#import "MyManager.h"
#import <QuartzCore/QuartzCore.h>

@interface ScheduleViewController ()<MFMailComposeViewControllerDelegate>
@property (nonatomic) NSData *pdfData;
@property (nonatomic) NSString *feedbackMsg;
//@property (nonatomic) MFMailComposeViewController *mailComposer;
@end

@implementation ScheduleViewController
@synthesize daysArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[MyManager sharedManager] saveChanges];
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Schedule";
    [self.navigationController.toolbar setTranslucent:NO];
    [self.navigationController.toolbar setTintColor:[UIColor colorWithRed:0.25 green:0.4 blue:0.4 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.25 green:0.4 blue:0.4 alpha:1.0]];
    [self.navigationController.toolbar setBarTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:0.95 alpha:0.4]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:0.95 alpha:0.4]];
    
//    _mailComposer = [[MFMailComposeViewController alloc]init];
//    _mailComposer.mailComposeDelegate = self;
    
    //UIToolbar *toolbar;
    //[toolbar setBarTintColor:[UIColor greenColor]];
    //[toolbar setTranslucent:NO];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.pdfData = nil;
    
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"DoneEditing"]) {
        [[MyManager sharedManager] saveChanges];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[[MyManager sharedManager] daysArray] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [[[self.daysArray objectAtIndex:section] shifts] count];
    return [[[[[MyManager sharedManager] daysArray] objectAtIndex:section] shifts] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //return [[self.daysArray objectAtIndex:section] name];
    return [[[[MyManager sharedManager] daysArray] objectAtIndex:section] name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //WorkDay *day = [self.daysArray objectAtIndex:indexPath.section];
    WorkDay *day = [[[MyManager sharedManager] daysArray] objectAtIndex:indexPath.section];
    WorkShift *shift = [day.shifts objectAtIndex:indexPath.row];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterShortStyle];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@   %@ - %@", shift.shiftName,
                                 [df stringFromDate:shift.startTime], [df stringFromDate:shift.endTime]];
    
    
    cell.textLabel.text = [[[day.shifts objectAtIndex:indexPath.row] assignedEmployee] description];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ChooseEmployee"]) {
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        WorkDay *day = [[[MyManager sharedManager] daysArray] objectAtIndex:path.section];
        WorkShift *thisShift = [day.shifts objectAtIndex:path.row];
        
        EmployeesViewController *employeeController = [segue destinationViewController];
        [employeeController setActiveShift:thisShift];
    } else if ([[segue identifier] isEqualToString:@"EditShiftsSegue"]) {
        
        
    }
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Unassign";
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)path
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray *updateIndexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:path.row inSection:path.section], nil];
        WorkDay *thisDay = [[[MyManager sharedManager]daysArray] objectAtIndex:path.section];
        WorkShift *thisShift = [thisDay.shifts objectAtIndex:path.row];
        thisShift.assignedEmployee.hours -= thisShift.hours;
        thisShift.assignedEmployee = nil;
        [[MyManager sharedManager] saveChanges];
        [self.tableView reloadRowsAtIndexPaths:updateIndexPaths
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } 
}




/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate


     
#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            self.feedbackMsg = @"Result: Mail sending canceled";
            break;
        case MFMailComposeResultSaved:
            self.feedbackMsg = @"Result: Mail saved";
            break;
        case MFMailComposeResultSent:
            self.feedbackMsg = @"Result: Mail sent";
            break;
        case MFMailComposeResultFailed:
            self.feedbackMsg = @"Result: Mail sending failed";
            break;
        default:
            self.feedbackMsg = @"Result: Mail not sent";
            break;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"QuickSchedule" message:self.feedbackMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:okAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController presentViewController:alert animated:YES completion:^{
        
        
    }];
    
    //    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)stringFromHours:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hour = (ti / 3600);
    return [NSString stringWithFormat:@"%li:%02li Hours", (long)hour, (long)minutes];
}

- (void)displayMailComposerSheet {
    

        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateStyle:NSDateFormatterNoStyle];
        [df setTimeStyle:NSDateFormatterShortStyle];
        
        NSString *scheduleString = @"";
        
        // Go through each Workday and get the day's name and add it to the scheduleString
        for (WorkDay *day in [[MyManager sharedManager] daysArray]) {
            NSString *dayString = [NSString stringWithFormat:@"----\n%@\n", day.name];
            scheduleString = [scheduleString stringByAppendingString:dayString];
            
            for (WorkShift *shift in day.shifts) {
                if (shift.assignedEmployee != nil) {
                    NSString *shiftString = [NSString stringWithFormat:@"%@: %@\n %@ - %@\n", shift.shiftName, shift.assignedEmployee.description, [df stringFromDate:shift.startTime], [df stringFromDate:shift.endTime]];
                    scheduleString = [scheduleString stringByAppendingString:shiftString];
                } else {
                    NSString *shiftString = [NSString stringWithFormat:@"%@: **UNASSIGNED**\n %@ - %@\n", shift.shiftName, [df stringFromDate:shift.startTime], [df stringFromDate:shift.endTime]];
                    scheduleString = [scheduleString stringByAppendingString:shiftString];
                }
            }
        }
        NSString *totalHrsHeader = @"--------\n--------\nTotal Assigned Hours:\n----\n";
        scheduleString = [scheduleString stringByAppendingString:totalHrsHeader];
        for (Employee *emp in [[MyManager sharedManager] masterEmployeeList]) {
            NSString *hourString = [self stringFromHours:emp.hours];
            NSString *empString = [NSString stringWithFormat:@"%@, scheduled for %@\n", emp.description, hourString];
            scheduleString = [scheduleString stringByAppendingString:empString];
        }
        
        scheduleString = [scheduleString stringByAppendingString:@"\n\nMade with QuickSchedule™\n"];
    // set up recipients
    NSMutableArray *addresses = [[NSMutableArray alloc]init];
    if ([[MyManager sharedManager] countOfList] == 0) {
        // display alert that there is nobody to send email to
        self.feedbackMsg = @"You have nobody to send a schedule to...";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Whoops!" message:self.feedbackMsg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            //            [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
            // Nothing to see here
        }];
    } else {
        
        for (Employee *emp in [[MyManager sharedManager] masterEmployeeList]) {
//            NSError *error = NULL;
//            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" options:NSRegularExpressionCaseInsensitive error:&error];
            NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"%@ MATCHES %@",emp.email, regex];
            if ([emailTest evaluateWithObject:emailTest] == YES)
            {
                [addresses addObject:emp.email];
            }
            
        }
        NSLog(@"email addresses = %@", addresses);
        
        mailComposer = [[MFMailComposeViewController alloc]init];
        mailComposer.mailComposeDelegate = self;
        [mailComposer setToRecipients:addresses];
        [mailComposer setSubject:@"Schedule"];
        [mailComposer addAttachmentData:self.pdfData mimeType:@"application/pdf" fileName:@"Schedule.pdf"];
        [mailComposer setMessageBody:scheduleString isHTML:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:mailComposer animated:YES completion:NULL];
        });
        
        
    }
}


- (IBAction)shareSchedule:(id)sender {

    if ([MFMailComposeViewController canSendMail])
        // The device can send email.
    {
        [self displayMailComposerSheet];
    }
    else
        // The device can not send email.
    {
        // put an alert here
        
        self.feedbackMsg = @"Device not configured to send mail.";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Whoops!" message:self.feedbackMsg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:okAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController presentViewController:alert animated:YES completion:^{
            // Nothing to see here
        }];
        
    }
    
}

-(void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    CGRect priorBounds = aView.bounds;
    CGSize fittedSize = [aView sizeThatFits:CGSizeMake(priorBounds.size.width, HUGE_VALF)];
    aView.bounds = CGRectMake(0, 0, fittedSize.width, fittedSize.height);
    
    CGRect pdfPageBounds = CGRectMake(0, 0, 612, 792);
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [[NSMutableData alloc]init];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil); {
        for (CGFloat pageOriginY = 0; pageOriginY < fittedSize.height; pageOriginY += pdfPageBounds.size.height) {
            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil);
            CGContextSaveGState(UIGraphicsGetCurrentContext()); {
                CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, -pageOriginY);
                [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
            }
        } UIGraphicsEndPDFContext();
        aView.bounds = priorBounds;
    }
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    //instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    self.pdfData = pdfData;
    
//    UIGraphicsBeginPDFPage();
//    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
//    
//    
//    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
//    
//    [aView.layer renderInContext:pdfContext];
//    
//    // remove PDF rendering context
//    UIGraphicsEndPDFContext();
    
    // Retrieves the document directories from the iOS device
    // Get a path to the app group with fileName
    
    // shared app group ID
//    NSString *groupID = @"group.YAZVT7PQ49.com.darrellnicholas.QuickSchedule";
//    NSFileManager *fileManager = [NSFileManager defaultManager];
    // grabbing a URL and simulataneously changing it to a string.
//    NSString *groupPath = [[fileManager containerURLForSecurityApplicationGroupIdentifier:groupID] absoluteString];
    // stripping off the slashes from the URL
//    NSString *newGroupPath = [groupPath substringWithRange:NSMakeRange(6, [groupPath length]-6)];
//    [newGroupPath stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
//    [pdfData writeToFile:newGroupPath atomically:YES];
//    self.pdfData = pdfData;
//    NSLog(@"PDF Filename = %@", newGroupPath);
}

@end
