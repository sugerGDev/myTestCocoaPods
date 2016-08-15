//
//  UIButton+Animation.m
//  MyTestCocoaPods
//
//  Created by suger on 16/8/15.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import "UIButton+Animation.h"

@implementation UIButton (Animation)

- (void)playSelectedAnimation {
    
    CAKeyframeAnimation* b = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    b.values = @[@(1.0) ,@(1.4), @(0.9), @(1.15), @(0.95), @(1.02), @(1.0)];
    b.duration = 0.7;
    b.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:b forKey:nil];
}


@end
