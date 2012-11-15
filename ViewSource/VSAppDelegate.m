//
//  VSAppDelegate.m
//  ViewSource
//
//  Created by Sami Samhuri on 2012-11-14.
//  Copyright (c) 2012 Sami Samhuri. All rights reserved.
//

#import "VSAppDelegate.h"
#import "VSViewController.h"
#import "VSSource.h"

@implementation VSAppDelegate

- (BOOL) application: (UIApplication *)application didFinishLaunchingWithOptions: (NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions: %@", launchOptions);

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[VSViewController alloc] initWithNibName:@"VSViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[VSViewController alloc] initWithNibName:@"VSViewController_iPad" bundle:nil];
    }

    // TODO restore from disk
    NSString *url = @"http://samhuri.net/vs";
    NSRange scrollRange = NSMakeRange(0, 0);
    VSSource *source = [VSSource sourceWithURL: url scrollRange: scrollRange];
    [self.viewController loadSource: source];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL) application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation
{
    NSString *urlString = [[[url absoluteString]
                            stringByReplacingOccurrencesOfString: @"vs://" withString: @"http://"]
                           stringByReplacingOccurrencesOfString: @"vss://" withString: @"https://"];
    NSLog(@"url: %@", urlString);
    VSSource *source = [VSSource sourceWithURL: urlString scrollRange: NSMakeRange(0, 0)];
    [self.viewController loadSource: source];
    return YES;
}

- (void) applicationWillResignActive: (UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void) applicationDidEnterBackground: (UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void) applicationWillEnterForeground: (UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void) applicationDidBecomeActive: (UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void) applicationWillTerminate: (UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
