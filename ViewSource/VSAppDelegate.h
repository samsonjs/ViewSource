//
//  VSAppDelegate.h
//  ViewSource
//
//  Created by Sami Samhuri on 2012-11-14.
//  Copyright (c) 2012 Sami Samhuri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VSViewController;

@interface VSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) VSViewController *viewController;

@end
