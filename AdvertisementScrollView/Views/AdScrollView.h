//
//  AdScrollView.h
//  AdvertisementScrollView
//
//  Created by Thomson on 15/12/1.
//  Copyright © 2015年 KEMI. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger kAdScrollViewHeight = 150;

@interface AdScrollView : UIView

@property (nonatomic, readonly) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *adsArray;
/**
 *  初始化
 *
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 *
 *  @return instance
 */
- (instancetype)initWithAnimationDuration:(NSTimeInterval)animationDuration;

@end
