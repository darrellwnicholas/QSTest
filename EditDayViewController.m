//
//  EditDayViewController.m
//  QuickSchedule
//
//  Created by Darrell Nicholas on 9/2/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import "EditDayViewController.h"
#import "EditShiftDetailViewController.h"
#import "WorkShift.h"
#import "MyManager.h"

@interface EditDayViewController ()
@property (strong, nonatomic) NSMutableArray *daysArray;
@end

@implementation EditDayViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.25 green:0.4 blue:0.4 alpha:1.0]];
    
    self.title = [self.currentDay name];
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hour = (ti / 3600);
    return [NSString stringWithFormat:@"%li:%02li", (long)hour, (long)minutes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SelectShiftToEditSegue"]) {
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        WorkDay *day = self.currentDay;
        
        EditShiftDetailViewController *shiftDetailController = [segue destinationViewController];
        [shiftDetailController setCurrentDay:day];
        [shiftDetailController setCurrentShift:[self.currentDay.shifts objectAtIndex:path.row]];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Tap Shift to edit it";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [self.currentDay.shifts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    WorkShift *shift = [self.currentDay.shifts objectAtIndex:indexPath.row];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterShortStyle];
    NSString *cellText;
    NSTimeInterval timeInterval;
    if ([shift.startTime compare:shift.endTime] == NSOrderedDescending) {
        timeInterval = 86400;
        NSTimeInterval temp = [shift.startTime timeIntervalSinceDate:shift.endTime];
        timeInterval -= temp;
        cellText = [self stringFromTimeInterval:timeInterval];
    }else{
    timeInterval = [shift.endTime timeIntervalSinceDate:shift.startTime];
        cellText = [self stringFromTimeInterval:timeInterval];
    }
    
    
    cell.textLabel.text = shift.shiftName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@     (%@ hours)", [df stringFromDate:shift.startTime], [df stringFromDate:shift.endTime], cellText];
    
    
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.currentDay.shifts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
       // WorkShift *newShift = [[WorkShift alloc] init];
       // [self.currentDay.shifts addObject:newShift];
       // newShift.shiftName = @"New Shift";
       // [tableView reloadData];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)addShift:(id)sender {
    WorkShift *newShift = [[WorkShift alloc] init];
    [self.currentDay.shifts addObject:newShift];
    newShift.shiftName = @"New Shift";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterShortStyle];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    newShift.startTime = [df dateFromString:@"12:00 AM"];
    newShift.endTime = [df dateFromString:@"12:00 AM"];
    [self saveData];
    [self.tableView reloadData];
}

- (void)saveData
{
    [[MyManager sharedManager] saveChanges];
}

@end
