//
//  NSTimer+Addition.h
//  AdvertisementScrollView
//
//  Created by Thomson on 15/12/1.
//  Copyright © 2015年 KEMI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
