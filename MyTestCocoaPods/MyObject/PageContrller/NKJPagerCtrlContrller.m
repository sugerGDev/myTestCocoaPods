//
//  NKJPagerCtrlContrller.m
//  MyTestCocoaPods
//
//  Created by suger on 16/8/11.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import "NKJPagerCtrlContrller.h"

@interface NKJPagerCtrlContrller ()

@end

@implementation NKJPagerCtrlContrller

- (void)viewDidLoad {
    
    //----
    //初始化数据
    if ([self.njkCtrlDelegate respondsToSelector:@selector(numsOfPagerTabs)]) {
        _nNumOfTabs = [self.njkCtrlDelegate numsOfPagerTabs] ;
        _fSingleNabBarW = [UIScreen mainScreen].bounds.size.width / _nNumOfTabs;
    }
    
    if ([self.njkCtrlDelegate respondsToSelector:@selector(numsOfPagerSubVContrls)]) {
        [self.contents addObjectsFromArray:[self.njkCtrlDelegate numsOfPagerSubVContrls]];
    }
    
    self.dataSource = self;
    self.delegate = self;
    
    
    //调用 NKJPagerViewController -viewDidLoad
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -- NKJPagerViewDataSource

- (NSInteger)widthOfTabView {
    return _fSingleNabBarW;
}


- (UIView *)viewPager:(NKJPagerViewController *)viewPager viewForTabAtIndex:(NSUInteger)index{
    
    UILabel *label = [[UILabel  alloc]init];
    label.font = [UIFont systemFontOfSize:17.0];
    label.text = @"测试";//self.contents[index].title;
    label.textColor =  [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;

    return label;
}

#pragma mark - NKJPagerViewDelegate

- (void)viewPager:(NKJPagerViewController *)viewPager
 didSwitchAtIndex:(NSInteger)index withTabs:(NSArray *)tabs
{
    
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         for (UIView *view in self.tabs) {
                             
                             if (index == view.tag) {
                                 
                                 [self animSelectedVContrl:viewPager WithNavTab:view];
                                 
                             } else {
                                 [self animUnselectedVContrl:viewPager WithNavTab:view];
                             }
                         }
                     }completion:nil];
}


#pragma mark - Help
/*!
 * 选择 Nav Tab 动画
 *
 *  @param navTitle
 */
- (void)animSelectedVContrl:(NKJPagerViewController *)viewPager
                 WithNavTab:(UIView *)navTab {
   
    if (![navTab isKindOfClass:[UILabel class]]) {
        return;
    }
    UILabel* lbl = (UILabel *)navTab;
    lbl.alpha = 1.0;
    [lbl setTextColor:[UIColor darkTextColor]];
    lbl.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    CALayer* l = [self findLayer:viewPager.view.layer.sublayers byTag:lbl.tag];
    l.opacity = 1.f;
}

/*!
 *  未选择 Nav Tab 动画
 *
 *  @param navTab <#navTab description#>
 */
- (void)animUnselectedVContrl:(NKJPagerViewController *)viewPager
                   WithNavTab:(UIView *)navTab {
    
    if (![navTab isKindOfClass:[UILabel class]]) {
        return;
    }
    
    UILabel* lbl = (UILabel *)navTab;
    lbl.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [lbl setTextColor:[UIColor lightGrayColor]];
    
    CALayer* l = [self findLayer:viewPager.view.layer.sublayers byTag:lbl.tag];
    l.opacity = 0.f;
}

- (CALayer *)findLayer:(NSArray *)array byTag:(NSInteger)tag {
    NSArray* arrLayer = array;
    CALayer* sl = nil;
    for (IndicatorLayer* l in arrLayer) {
        if ([l isKindOfClass:[IndicatorLayer class]]) {
            if (l.tag == tag) {
                sl = l;
                break;
            }
        }
        
    }
    return sl;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
