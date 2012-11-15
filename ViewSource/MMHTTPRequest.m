//
//  MMHTTPRequest.m
//  Marshmallows
//
//  Created by Sami Samhuri on 11-09-03.
//  Copyright 2011 Guru Logic. All rights reserved.
//

#import "MMHTTPRequest.h"

@interface MMHTTPRequest ()
- (void) _start;
@end


@implementation MMHTTPRequest

@synthesize connection = _connection;
@synthesize request = _request;
@synthesize method = _method;
@synthesize url = _url;
@synthesize headers = _headers;
@synthesize data = _data;
@synthesize type = _type;
@synthesize callback = _callback;
@synthesize timeout = _timeout;
@synthesize statusCode = _statusCode;
@synthesize responseHeaders = _responseHeaders;

+ (id) requestWithOptions: (NSDictionary *)options callback: (MMHTTPCallback)callback
{
    return [[self alloc] initWithOptions: options callback: callback];
}

- (id) initWithOptions: (NSDictionary *)options callback: (MMHTTPCallback)callback
{
    self = [super init];
    if (self) {
        self.callback = callback;
        self.timeout = MMHTTPRequestDefaultTimeout;
        self.method = [options objectForKey: @"method"];
        self.url = [options objectForKey: @"url"];
        self.headers = [options objectForKey: @"headers"];
        self.data = [options objectForKey: @"data"];
        self.type = [options objectForKey: @"type"];
        if (!self.method) self.method = @"GET";
        [self _start];
    }
    return self;
}

- (void) cancel
{
    self.callback = nil;
    [_connection cancel];
}

- (NSData *) responseData
{
    return [NSData dataWithData: _responseData];
}

- (NSString *) responseText
{
    return [[NSString alloc] initWithBytes: _responseData.bytes
                                    length: _responseData.length
                                  encoding: NSUTF8StringEncoding];
}

- (UIImage *) responseImage
{
    return [UIImage imageWithData: _responseData];
}

- (void) _start
{
    self.request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: self.url]
                                           cachePolicy: NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval: self.timeout];
    [self.request setHTTPMethod: self.method];
    
    if (self.data && ([self.method isEqualToString: @"POST"] || [self.method isEqualToString: @"PUT"])) {
        [self.request setHTTPBody: self.data];
    }

    if (self.headers) {
        for (NSString *key in self.headers) {
            [self.request setValue: [self.headers objectForKey: key] forHTTPHeaderField: key];
        }
    }
    
    self.connection = [NSURLConnection connectionWithRequest: self.request delegate: self];
    [self.connection start];
}

#pragma mark - NSURLConnection delegate methods

- (void) connection: (NSURLConnection *)connection didReceiveResponse: (NSURLResponse *)response
{
    NSLog(@"response: %@ (%d, %@)", response, [(NSHTTPURLResponse *)response statusCode], [(NSHTTPURLResponse *)response allHeaderFields]);
    if ([response respondsToSelector: @selector(statusCode)])
    {
        _statusCode = [(NSHTTPURLResponse *)response statusCode];
        _responseHeaders = [(NSHTTPURLResponse *)response allHeaderFields];
    }
    else {
        _statusCode = 500;
        _responseHeaders = [[NSDictionary alloc] init];
    }
    
    _responseData  = [[NSMutableData alloc] init];
}

- (void) connection: (NSURLConnection *)connection didReceiveData: (NSData *)data
{
    [_responseData appendData: data];
}

- (void) connection: (NSURLConnection *)connection didFailWithError: (NSError *)error
{
    _responseData = nil;
    _statusCode = MMHTTPRequestStatusError;
    if (self.callback) {
        self.callback(self.statusCode, error);
    }
}

- (void) connectionDidFinishLoading: (NSURLConnection *)connection
{
    id data = nil;
    if (self.callback && self.statusCode == 200) {
        if ([self.type isEqualToString: @"text"]) {
            data = self.responseText;
        }
        else if ([self.type isEqualToString: @"image"]) {
            data = self.responseImage;
        }
        else {
            data = self.responseData;
        }
    }

    if (self.callback) {
        self.callback(self.statusCode, data);
    }
}

@end
