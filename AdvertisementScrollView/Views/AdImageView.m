//
//  AdImageView.m
//  AdvertisementScrollView
//
//  Created by Thomson on 15/12/1.
//  Copyright © 2015年 KEMI. All rights reserved.
//

#import "AdImageView.h"
#import "RACCommand.h"

@interface AdImageView ()

@property (nonatomic, strong) RACCommand *rac_command;

@end

@implementation AdImageView

- (instancetype)initWithRACCommand:(RACCommand *)rac_command
{
    _rac_command = rac_command;

    return [self init];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;

        UITapGestureRecognizer *onTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageTapped:)];
        [self addGestureRecognizer:onTap];
    }

    return self;
}

- (void)onImageTapped:(UIGestureRecognizer *)recognizer
{
    if (self.rac_command)
    {
        [self.rac_command execute:self];
    }
}

@end
