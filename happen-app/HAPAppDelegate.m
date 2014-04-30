//
//  HAPAppDelegate.m
//  happen-app
//
//  Created by Sam Couch on 1/27/14.
//  Copyright (c) 2014 Happen. All rights reserved.
//

#import "HAPAppDelegate.h"
#import <Parse/Parse.h>

@implementation HAPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"T67m6NTwHFuyyNavdRdFGlwNM5UiPE48l3sIP6fP"
                  clientKey:@"GVaSbLvVYagIzZCd7XYLfG0H9lHJBwpUvsUKen7Z"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    UIColor *greenColor = [UIColor colorWithRed:100.0 / 255.0 green:197.0 / 255.0 blue:157.0 / 255.0 alpha:1.0];
    //UIColor *selectedColor = [UIColor colorWithRed:55.0 / 255.0 green:122.0 / 255.0 blue:118.0 / 255.0 alpha:1.0];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Medium" size:10],
                                                           NSForegroundColorAttributeName : greenColor,
                                                           NSKernAttributeName : @(1.8f)
                                                           } forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{
                                                              NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Medium" size:10],
                                                              NSForegroundColorAttributeName : [UIColor whiteColor],
                                                              NSKernAttributeName : @(1.8f)
                                                              } forState:UIControlStateSelected];
    
    [[UITabBar appearance] setSelectedImageTintColor: greenColor];
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
        // determine the initial view controller here and instantiate it with [storyboard instantiateViewControllerWithIdentifier:<storyboard id>];
    UIViewController *viewController;
    if ([PFUser currentUser]) {
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    }
    else {
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"AuthViewController"];
    }
    
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
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
