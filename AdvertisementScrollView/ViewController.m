//
//  ViewController.m
//  AdvertisementScrollView
//
//  Created by Thomson on 15/12/1.
//  Copyright © 2015年 KEMI. All rights reserved.
//

#import "ViewController.h"

#import <Masonry/Masonry.h>
#import "RACCommand.h"
#import "RACSignal.h"
#import "UIImageView+WebCache.h"

#import "AdScrollView.h"
#import "AdImageView.h"

static CGFloat const kAnimationDuration = 2.0;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *itemsArray = @[
                            @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr0nly5j20pf0gygo6.jpg",
                            @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
                            @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                            @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                            @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                            @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg",
                            @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                            @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg"
                            ];

    NSMutableArray *imagesM = [[NSMutableArray alloc] initWithCapacity:0];

    for (NSInteger index = 0; index < [itemsArray count]; index ++)
    {
        AdImageView *imageView = [[AdImageView alloc] initWithRACCommand:[[RACCommand alloc]
                                                                           initWithSignalBlock:^RACSignal *(id input) {

                                                                               NSLog(@"%zi", index);

                                                                               return [RACSignal empty];
                                                                           }]];

        [imagesM addObject:imageView];

        NSString *URLString = itemsArray[index];
        [imageView sd_setImageWithURL:[NSURL URLWithString:URLString]];
    }

    AdScrollView *scrollView = [[AdScrollView alloc] initWithAnimationDuration:kAnimationDuration];
    scrollView.adsArray = [[NSArray alloc] initWithArray:imagesM];
    [self.view addSubview:scrollView];

    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.and.right.and.top.equalTo(self.view);
        make.height.equalTo(@(kAdScrollViewHeight));
    }];

    self.navigationController.navigationBar.translucent = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

@end
