//
//  AdImageView.h
//  AdvertisementScrollView
//
//  Created by Thomson on 15/12/1.
//  Copyright © 2015年 KEMI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACCommand;

@interface AdImageView : UIImageView

- (instancetype)initWithRACCommand:(RACCommand *)rac_command;

@end
