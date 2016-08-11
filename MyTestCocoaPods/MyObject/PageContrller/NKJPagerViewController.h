//
//  NKJPagerViewController.h
//  NKJPagerViewController
//
//  Created by nakajijapan on 11/28/14.
//  Copyright (c) 2015 net.nakajijapan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndicatorLayer : CALayer
@property (nonatomic , assign) NSInteger tag;
@end




@protocol NKJPagerViewDataSource;
@protocol NKJPagerViewDelegate;

@interface NKJPagerViewController : UIViewController {
        NSInteger _indexPath;
}

@property (nonatomic , strong)  NSMutableArray *tabs;     // Views
@property (nonatomic , strong)  NSMutableArray<UIViewController*> *contents; // ViewControllers

@property (nonatomic , strong) UIView *contentView;

@property (nonatomic , weak) id<NKJPagerViewDataSource> dataSource;
@property (nonatomic , weak) id<NKJPagerViewDelegate> delegate;

@property (nonatomic , assign)  CGFloat heightOfTabView;
@property (nonatomic , assign)  CGFloat yPositionOfTabView;
@property (nonatomic , strong)  UIColor *tabsViewBackgroundColor;


- (void)setActiveContentIndex:(NSInteger)index;
@end

#pragma mark NKJPagerViewDataSource

@protocol NKJPagerViewDataSource <NSObject>
//- (NSUInteger)numberOfTabView;
- (NSInteger)widthOfTabView;
- (UIView *)viewPager:(NKJPagerViewController *)viewPager viewForTabAtIndex:(NSUInteger)index;
//- (UIViewController *)viewPager:(NKJPagerViewController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index;
@end

#pragma mark NKJPagerViewDelegate

@protocol NKJPagerViewDelegate <NSObject>

@optional
- (void)viewPagerWillTransition:(NKJPagerViewController *)viewPager;
- (void)viewPagerWillTransition:(NKJPagerViewController *)viewPager willTransitionToViewControllers:(NSArray *)pendingViewControllers;
- (void)viewPager:(NKJPagerViewController *)viewPager didSwitchAtIndex:(NSInteger)index withTabs:(NSArray *)tabs;
- (void)viewPagerDidAddContentView;
@end
