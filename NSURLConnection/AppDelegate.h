//
//  AppDelegate.h
//  NSURLConnection
//
//  Created by shenyixin on 14-4-29.
//  Copyright (c) 2014年 shenyixin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    NSURLConnection * _connection;
    NSMutableData *_receivedData;
}


@property (nonatomic,readwrite,retain) NSURLConnection *connection;
@property (nonatomic,readwrite,retain) NSMutableData *receivedData;


@property (assign) IBOutlet NSWindow *window;

@end
