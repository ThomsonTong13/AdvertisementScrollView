//
//  NSTimer+Addition.m
//  AdvertisementScrollView
//
//  Created by Thomson on 15/12/1.
//  Copyright © 2015年 KEMI. All rights reserved.
//

#import "NSTimer+Addition.h"

@implementation NSTimer (Addition)

- (void)pauseTimer
{
    if (![self isValid]) return;

    [self setFireDate:[NSDate distantFuture]];
}


- (void)resumeTimer
{
    if (![self isValid]) return;

    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) return;

    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}


@end
