//
//  PagerViewController.m
//  MyTestCocoaPods
//
//  Created by suger on 16/8/11.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import "PagerViewController.h"

@interface PagerViewController ()

@end

@implementation PagerViewController

- (void)viewDidLoad {
    self.njkCtrlDelegate = self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*!
 *  需要多少个Tab
 *  @return 个数
 */
- (NSInteger)numsOfPagerTabs {
    return 3;
}
/*!
 *  获取多少个Sub-ViewContrller
 *
 *  @return Sub-ViewContrller集合
 */
- (NSArray<UIViewController *> *)numsOfPagerSubVContrls {
    
    PagerSubViewController* sub1 = [[PagerSubViewController alloc]init];
    sub1.title = @"数据";
    
    PagerSubViewController* sub2 = [[PagerSubViewController alloc]init];
    sub2.title = @"测试";
    
    PagerSubViewController* sub3 = [[PagerSubViewController alloc]init];
    sub3.title = @"代码";
    
    return @[sub1,sub2,sub3];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
