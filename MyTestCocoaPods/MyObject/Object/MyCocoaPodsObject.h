//
//  MyCocoaPodsObject.h
//  MyTestCocoaPods
//
//  Created by suger on 16/8/10.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 *  测试CocoaPods 函数
 */
@interface MyCocoaPodsObject : NSObject{
    NSString* _oLog;
}

- (instancetype)init;
- (void)log;
@end
