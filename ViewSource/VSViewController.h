//
//  VSViewController.h
//  ViewSource
//
//  Created by Sami Samhuri on 2012-11-14.
//  Copyright (c) 2012 Sami Samhuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSSource.h"

@interface VSViewController : UIViewController

@property (strong, nonatomic) VSSource *source;
@property (strong, nonatomic) IBOutlet UITextView *sourceView;

- (void) loadSource: (VSSource *)source;

@end
