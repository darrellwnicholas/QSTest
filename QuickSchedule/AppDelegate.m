//
//  AppDelegate.m
//  QuickSchedule
//
//  Created by Darrell Nicholas on 8/11/13.
//  Copyright (c) 2013 Darrell Nicholas. All rights reserved.
//

#import "AppDelegate.h"
#import "WorkDay.h"
#import "WorkShift.h"
#import "ScheduleViewController.h"
#import "MyManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    MyManager *mngr = [MyManager sharedManager];
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.YAZVT7PQ49.com.darrellnicholas.QuickSchedule"];
    if (![defaults boolForKey:@"hasBeenLaunched"]) {
        NSString *documentDirectory = [self applicationDocumentsDirectory];
        NSString *src = [documentDirectory stringByAppendingPathComponent:@"days.plist"];
        NSString *src2 = [documentDirectory stringByAppendingPathComponent:@"employees.plist"];
        NSFileManager *mgr = [[NSFileManager alloc] init];
        
        if ([mgr fileExistsAtPath:src] || [mgr fileExistsAtPath:src2]) {
            mngr.daysArray = [NSKeyedUnarchiver unarchiveObjectWithFile:src];
            mngr.masterEmployeeList = [NSKeyedUnarchiver unarchiveObjectWithFile:src2];
            for (WorkDay *d in mngr.daysArray) {
                for (WorkShift *s in d.shifts) {
                    if ([s.inDay isEqualToString:@""]) {
                        s.inDay = d.name;
                    }
                    
                }
            }
            [mngr saveChanges];
            [mgr removeItemAtPath:src error:nil];
            [mgr removeItemAtPath:src2 error:nil];
            
        } else {
            [mngr initialSetUp];
        }
    }
    
    return YES;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
