//
//  AppDelegate.m
//  NSURLConnection
//
//  Created by shenyixin on 14-4-29.
//  Copyright (c) 2014年 shenyixin. All rights reserved.
//

// refer to https://developer.apple.com/library/mac/documentation/cocoa/Conceptual/URLLoadingSystem/Tasks/UsingNSURLConnection.html#//apple_ref/doc/uid/20001836-BAJEAIEE

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize connection = _connection;
@synthesize receivedData = _receivedData;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self sendSynchronousRequestExample];
    //[self sendASynchronousRequestExample];
    //[self initWithRequestExample];
    //[self initWithRequestPostExample];
}


#pragma mark - sync using sendSynchronousRequest
- (void)sendSynchronousRequestExample
{
    NSString *url = @"http://www.apple.com/";
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:15.0];
    
    NSURLResponse* response = nil;
    NSError *error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if (error)
    {
        NSLog(@"sendSynchronousRequest error = %@", [error localizedDescription]);;
    }
    else
    {
        if ([(NSHTTPURLResponse *)response statusCode] == 200)
        {
            NSString *receivedDataString = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
            NSLog(@"receivedDataString = %@", receivedDataString);
        }
        else
        {
            NSLog(@"statusCode = %lu", [(NSHTTPURLResponse *)response statusCode]);
        }
    }
}

#pragma mark - async using sendAsynchronousRequest with block
//NS_AVAILABLE(10_7, 5_0);
- (void)sendASynchronousRequestExample
{
    NSString *url = @"http://www.apple.com/";
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:15.0];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if (connectionError)
         {
             NSLog(@"sendAsynchronousRequest error = %@", [connectionError localizedDescription]);;
         }
         else
         {
             NSString *receivedDataString = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
             NSLog(@"receivedDataString = %@", receivedDataString);
         }
     }];
}

#pragma mark - async get using initWithRequest with delegate
- (void)initWithRequestExample
{
    NSString *url = @"http://www.apple.com/";
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:15.0];
    
    self.receivedData = [NSMutableData dataWithCapacity: 0];

    // create the connection with the request
    // and start loading the data
    self.connection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
    
    //----cancel
    ///[self.connection cancel];
}

#pragma mark - async post using initWithRequest with delegate
- (void)initWithRequestPostExample
{
    // In body data for the 'application/x-www-form-urlencoded' content type,
    // form fields are separated by an ampersand. Note the absence of a
    // leading ampersand.
    NSString *bodyData = @"name=Jane+Doe&address=123+Main+St";
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.apple.com"]];
    
    // Set the request's content type to application/x-www-form-urlencoded
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //NSDictionary* headers = [NSDictionary dictionaryWithObjectsAndKeys: @"application/octet-stream", @"Content-Type", @"Close", @"Connection", @"Mozilla/4.0", @"User-Agent", @"*/*", @"Accept", nil];
    //[postRequest setAllHTTPHeaderFields: headers];
    
    
    // Designate the request a POST request and specify its body data
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    
    // Initialize the NSURLConnection and proceed as described in
    // Retrieving the Contents of a URL
    self.receivedData = [NSMutableData dataWithCapacity: 0];
    
    // create the connection with the request
    // and start loading the data
    self.connection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
    
}

#pragma mark - connection delegate

//响应的时候触发
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.receivedData setLength:0];
}

//有新的数据收到，会触发，我们把新的数据append
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

//完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *receivedDataString = [[[NSString alloc] initWithData:self.receivedData encoding:NSASCIIStringEncoding] autorelease];
    NSLog(@"receivedDataString = %@", receivedDataString);
    
    
    //因为initWithRequest会retain delegate，所以在finish跟error的时候，需要释放掉connection
    [self.connection release];
    [self.receivedData release];
}

//错误
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //因为initWithRequest会retain delegate，所以在finish跟error的时候，需要释放掉connection
    [self.connection release];
    [self.receivedData release];
}


@end
