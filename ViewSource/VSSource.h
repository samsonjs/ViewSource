//
//  VSSource.h
//  ViewSource
//
//  Created by Sami Samhuri on 2012-11-14.
//  Copyright (c) 2012 Sami Samhuri. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^VSSourceCallback)(BOOL ok, NSString *text);

@interface VSSource : NSObject

@property (strong, nonatomic) NSString *url;
@property (assign, nonatomic) NSRange scrollRange;
@property (strong, nonatomic) NSString *text;

+ (id) sourceWithURL: (NSString *)url scrollRange: (NSRange)scrollRange;
+ (id) sourceWithURL: (NSString *)url;

- (id) initWithURL: (NSString *)url scrollRange: (NSRange)scrollRange;
- (id) initWithURL: (NSString *)url;
- (void) fetch: (VSSourceCallback)callback;
- (void) cancel;

@end
