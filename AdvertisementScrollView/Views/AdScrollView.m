//
//  AdScrollView.m
//  AdvertisementScrollView
//
//  Created by Thomson on 15/12/1.
//  Copyright © 2015年 KEMI. All rights reserved.
//

#import "AdScrollView.h"
#import "TAPageControl.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"

#import "NSTimer+Addition.h"

#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width)

@interface AdScrollView () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) NSInteger totalPageCount;
@property (nonatomic, strong) NSMutableArray *contentViews;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) TAPageControl *pageControl;

@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, assign) NSTimeInterval animationDuration;

@end

@implementation AdScrollView

- (instancetype)initWithAnimationDuration:(NSTimeInterval)animationDuration
{
    self = [self init];

    if (animationDuration > 0.f)
    {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                                               target:self selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
    }

    return self;
}

- (instancetype)init
{
    self = [super init];

    if (self)
    {
        self.currentPageIndex = 0;

        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];

        @weakify(self);
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {

            @strongify(self);
            make.edges.equalTo(self);
        }];

        RAC(self.pageControl, currentPage) = [RACObserve(self, currentPageIndex)
                                              map:^NSNumber *(NSNumber *index) {

                                                  return index;
                                              }];

        [[RACObserve(self, adsArray)
          filter:^BOOL(id value) {

              return value != nil;
          }]
          subscribeNext:^(NSArray *ads) {

              @strongify(self);

              self.totalPageCount = ads.count;
              self.pageControl.numberOfPages = self.totalPageCount;
              [self configContentViews:NO];
          }];

        [[self
          rac_signalForSelector:@selector(scrollViewWillBeginDragging:)
          fromProtocol:@protocol(UIScrollViewDelegate)]
          subscribeNext:^(RACTuple *tuple) {

              @strongify(self);
              [self.animationTimer pauseTimer];
          }];
        
        [[self
          rac_signalForSelector:@selector(scrollViewDidEndDragging:willDecelerate:)
          fromProtocol:@protocol(UIScrollViewDelegate)]
          subscribeNext:^(RACTuple *tuple) {

              @strongify(self);
              [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
          }];
        
        [[self
          rac_signalForSelector:@selector(scrollViewDidEndDecelerating:)
          fromProtocol:@protocol(UIScrollViewDelegate)]
          subscribeNext:^(RACTuple *tuple) {

              UIScrollView *scrollView = tuple.first;
              [scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
          }];
        
        [[self
          rac_signalForSelector:@selector(scrollViewDidScroll:)
          fromProtocol:@protocol(UIScrollViewDelegate)]
          subscribeNext:^(RACTuple *tuple) {

              @strongify(self);

              UIScrollView *scrollView = tuple.first;
              int contentOffsetX = scrollView.contentOffset.x;

              if(contentOffsetX >= (2 * kScreenWidth))
              {
                  self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
                  [self configContentViews:NO];
              }

              if(contentOffsetX <= 0)
              {
                  self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
                  [self configContentViews:YES];
              }
          }];

        self.scrollView.delegate = nil;
        self.scrollView.delegate = self;
    }

    return self;
}

#pragma mark - event response

- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + kScreenWidth, self.scrollView.contentOffset.y);

    [self.scrollView setContentOffset:newOffset animated:YES];
}

#pragma mark - public methods

- (void)configContentViews:(BOOL)isLeft
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource:isLeft];

    NSInteger counter = 0;

    for (UIView *contentView in self.contentViews)
    {
        contentView.frame = CGRectMake(counter++ * kScreenWidth, 0, kScreenWidth, kAdScrollViewHeight);
        [self.scrollView addSubview:contentView];
    }

    CGFloat offset = kScreenWidth;
    [_scrollView setContentOffset:CGPointMake(offset, 0)];
}

#pragma mark - private methods

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1)
    {
        return self.totalPageCount - 1;
    }
    else if (currentPageIndex == self.totalPageCount)
    {
        return 0;
    }
    else
    {
        return currentPageIndex;
    }
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource:(BOOL)isLeft
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];

    if (self.contentViews.count == 0)
    {
        [self.contentViews addObject:self.adsArray[previousPageIndex]];
        [self.contentViews addObject:self.adsArray[self.currentPageIndex]];
        [self.contentViews addObject:self.adsArray[rearPageIndex]];
    }
    else
    {
        if (isLeft)
        {
            [self.contentViews removeLastObject];
            [self.contentViews insertObject:self.adsArray[previousPageIndex] atIndex:0];
        }
        else
        {
            [self.contentViews removeObjectAtIndex:0];
            [self.contentViews addObject:self.adsArray[rearPageIndex]];
        }
    }
}

- (void)resumeTimer
{
    [self configContentViews:NO];
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

#pragma mark - getters and setters

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [UIScrollView new];

        _scrollView.contentMode = UIViewContentModeCenter;
        _scrollView.contentSize = CGSizeMake(3*kScreenWidth, kAdScrollViewHeight);
        _scrollView.contentOffset = CGPointMake(0, 0);
        _scrollView.pagingEnabled = YES;
    }

    return _scrollView;
}

- (TAPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl = [[TAPageControl alloc] initWithFrame:CGRectMake(0, kAdScrollViewHeight - 40, kScreenWidth, 40)];
        _pageControl.currentPage = 0;
    }

    return _pageControl;
}

- (NSMutableArray *)contentViews
{
    if (!_contentViews) _contentViews = [NSMutableArray new];

    return _contentViews;
}

@end
