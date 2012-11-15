//
//  VSViewController.m
//  ViewSource
//
//  Created by Sami Samhuri on 2012-11-14.
//  Copyright (c) 2012 Sami Samhuri. All rights reserved.
//

#import "VSViewController.h"

@interface VSViewController ()
- (void) update;
@end

@implementation VSViewController

@synthesize source = _source;

- (void) viewDidLoad
{
    [super viewDidLoad];
    if (self.source) {
        [self update];
    }
}

- (void) loadSource: (VSSource *)source
{
    self.source = source;
    [self update];
}

- (void) update
{
    if (self.sourceView && self.source) {
        if (self.source.text) {
            self.sourceView.text = self.source.text;
            [self.sourceView scrollRangeToVisible: self.source.scrollRange];
        }
        else {
            [self.source fetch: ^(BOOL ok, NSString *text) {
                if (ok) {
                    [self update];
                }
                else {
                    NSLog(@"error fetching %@", self.source.url);
                }
            }];
        }
    }
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
