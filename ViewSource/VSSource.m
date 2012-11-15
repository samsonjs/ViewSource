//
//  VSSource.m
//  ViewSource
//
//  Created by Sami Samhuri on 2012-11-14.
//  Copyright (c) 2012 Sami Samhuri. All rights reserved.
//

#import "VSSource.h"
#import "MMHTTPClient.h"

@interface VSSource ()
@property (strong, nonatomic) MMHTTPRequest *request;
@property (copy, nonatomic) VSSourceCallback callback;
@end


@implementation VSSource

@synthesize scrollRange = _scrollRange;
@synthesize text = _text;
@synthesize url = _url;

+ (id) sourceWithURL: (NSString *)url scrollRange: (NSRange)scrollRange
{
    return [[self alloc]  initWithURL: url scrollRange: scrollRange];
}

+ (id) sourceWithURL: (NSString *)url
{
    return [self sourceWithURL: url scrollRange: NSMakeRange(0, 0)];
}

- (id) initWithURL: (NSString *)url scrollRange: (NSRange)scrollRange
{
    self = [super init];
    if (self) {
        self.url = url;
        self.scrollRange = scrollRange;
    }
    return self;
}

- (id) initWithURL: (NSString *)url
{
    return [self initWithURL: url scrollRange: NSMakeRange(0, 0)];
}

- (void) fetch: (VSSourceCallback)callback;
{
    if (self.text) {
        callback(YES, self.text);
    }
    else {
        self.callback = callback;
        self.request = [MMHTTPClient getText: self.url then: ^(NSInteger status, NSString *text) {
            self.text = text;
            if (self.callback) {
                self.callback(status == 200, self.text);
            }
        }];
    }
}

- (void) cancel
{
    [self.request cancel];
    self.request = nil;
    self.callback = nil;
    self.text = nil;
}

@end
