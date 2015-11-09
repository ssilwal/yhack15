//
//  SKSAppDelegate.m
//  SpeechKitSample
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

#import "SKSAppDelegate.h"
#import "CoffeeRunDoc.h"
#import "SKSMainViewController.h"

@implementation SKSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CoffeeRunDoc *run1 = [[CoffeeRunDoc alloc] initWithTitle:@"Coffee Run 1"
                                                       price:9.99
                                                  thumbImage:[UIImage imageNamed:@"coffee.png"]
                                                    withDate:@"November 8th, 2015"];
    CoffeeRunDoc *run2 = [[CoffeeRunDoc alloc] initWithTitle:@"Coffee Run 2"
                                                       price:4.99
                                                  thumbImage:[UIImage imageNamed:@"coffee.png"] withDate:@"November 9th, 2015"];
    NSMutableArray *runs = [NSMutableArray arrayWithObjects:run1, run2, nil];

    
    UINavigationController *navController = (UINavigationController *) self.window.rootViewController;
    SKSMainViewController *masterController = [navController.viewControllers objectAtIndex:0];
    masterController.runs = runs;
    // Override point for customization after application launch.
    return YES;
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
