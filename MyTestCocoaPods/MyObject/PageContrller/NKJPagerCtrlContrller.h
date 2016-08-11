//
//  NKJPagerCtrlContrller.h
//  MyTestCocoaPods
//
//  Created by suger on 16/8/11.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import "NKJPagerViewController.h"

@protocol NKJPagerCtrlDelegate <NSObject>

/*!
 *  需要多少个Tab
 *  @return 个数
 */
- (NSInteger)numsOfPagerTabs;
/*!
 *  获取多少个Sub-ViewContrller
 *
 *  @return Sub-ViewContrller集合
 */
- (NSArray<UIViewController *> *)numsOfPagerSubVContrls;
@end
/*!
 *  [NKJPagerCtrlContrller] 继承 [NKJPagerViewController] ，实现相关统一接口
 *
 */
@interface NKJPagerCtrlContrller : NKJPagerViewController
<NKJPagerViewDataSource,NKJPagerViewDelegate>{
    //统计tab个数
    NSInteger _nNumOfTabs;
    //单个NavBar宽度
    CGFloat _fSingleNabBarW;
    
}



@property (nonatomic , weak) id<NKJPagerCtrlDelegate> njkCtrlDelegate;

@end



