//
//  MyCocoaPodsObject.m
//  MyTestCocoaPods
//
//  Created by suger on 16/8/10.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import "MyCocoaPodsObject.h"

@implementation MyCocoaPodsObject
- (instancetype)init {
    if (self = [super init]) {
        _oLog = @"这是在测试CocoaPods工程，仅在学习中..";
    }
    return self;
}

- (void)log {
    NSLog(@"%@,调用时间是-> %@",_oLog , [NSDate date]);
}

@end
