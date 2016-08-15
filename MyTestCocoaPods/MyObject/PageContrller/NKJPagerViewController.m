//
//  MIPagerViewController.m
//  NKJPagerViewController
//
//  Created by nakajijapan on 11/28/14.
//  Copyright (c) 2015 net.nakajijapan. All rights reserved.
//

#import "NKJPagerViewController.h"



@implementation IndicatorLayer
@end

#define kTabViewTag 18
#define kContentViewTag 24

#define kTabsViewBackgroundColor [UIColor colorWithRed:234.0 / 255.0 green:234.0 / 255.0 blue:234.0 / 255.0 alpha:0.75]
#define kContentViewBackgroundColor [UIColor colorWithRed:248.0 / 255.0 green:248.0 / 255.0 blue:248.0 / 255.0 alpha:0.75]

@interface NKJPagerViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property CGFloat leftTabIndex;
@property NSInteger tabCount;
@property UIPageViewController *pageViewController;

@property (nonatomic) NSInteger activeContentIndex;
@property (nonatomic) NSInteger activeTabIndex;

@end

@implementation NKJPagerViewController

#pragma mark - Initialize


- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultSettings];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self defaultSettings];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultSettings];
    }
    return self;
    
}

- (void)defaultSettings
{
    _indexPath = 0;
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    [self addChildViewController:self.pageViewController];

    ((UIScrollView *)[self.pageViewController.view.subviews objectAtIndex:0]).delegate = self;

    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;

    self.heightOfTabView = 44.f;
    self.yPositionOfTabView = 64.0f;

}

- (void)defaultSetUp
{
 

    // Initializes
    self.tabCount = self.contents.count;
    self.leftTabIndex = 2;

    // Add tabsView in Superview


    NSInteger contentSizeWidth = 0;
    for (NSUInteger i = 0; i < self.tabCount; i++) {
        

        UIView *tabView = [self.dataSource viewPager:self viewForTabAtIndex:i];
        tabView.tag = i;
        //setFrame
        CGRect frame ;
        frame.origin.x = contentSizeWidth;
        frame.origin.y = self.yPositionOfTabView ;
        frame.size.width = [self.dataSource widthOfTabView];
        frame.size.height = self.heightOfTabView;
        
        tabView.frame = frame;
        tabView.userInteractionEnabled = YES;
        
        //select Indicator view
        IndicatorLayer* l = [IndicatorLayer layer];
        l.frame = CGRectMake(frame.origin.x,
                             self.yPositionOfTabView  + frame.size.height - 1 ,
                             frame.size.width, 1.f);
        
        l.backgroundColor = [UIColor redColor].CGColor;
        l.opacity = 0.f;
        l.tag = i;
        [self.view.layer addSublayer:l];
        
        
        [self.view addSubview:tabView];
        [self.tabs addObject:tabView];
        
        contentSizeWidth += CGRectGetWidth(tabView.frame);

        // To capture tap events
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [tabView addGestureRecognizer:tapGestureRecognizer];

    }
    
    NSAssert(self.contents.count, @"self.contents  is sub-viewcontrlller nil");

}

- (void)defaultContainerSetUp {
    // Add contentView in Superview
    self.contentView = [self.view viewWithTag:kContentViewTag];
    if (!self.contentView) {
        
        // Populate pageViewController.view in contentView
        self.contentView = self.pageViewController.view;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.contentView.backgroundColor = kTabsViewBackgroundColor;
        self.contentView.bounds = self.view.bounds;
        self.contentView.tag = kContentViewTag;
        [self.view insertSubview:self.contentView atIndex:0];
        
        // constraints
        if ([self.delegate respondsToSelector:@selector(viewPagerDidAddContentView)]) {
            [self.delegate viewPagerDidAddContentView];
        
        } else {
            self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
            NSDictionary *views = @{
                                    @"contentView"       : self.contentView,
                                    @"topLayoutGuide"    : self.topLayoutGuide,
                                    @"bottomLayoutGuide" : self.bottomLayoutGuide
                                    };
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[contentView]-0-|" options:0 metrics:nil views:views]];
            
            NSDictionary* metrics = @{@"top":@44,@"bottom":@0};
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-top-[contentView]-bottom-[bottomLayoutGuide]" options:0 metrics:metrics views:views]];
        }
    }
    
    // Setting Active Index
    [self selectTabAtIndex:0];
    
    // Default Design
    if ([self.delegate respondsToSelector:@selector(viewPager:didSwitchAtIndex:withTabs:)]) {
        [self.delegate viewPager:self didSwitchAtIndex:self.activeContentIndex withTabs:self.tabs];
    }

}

#pragma mark - Life Cycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self defaultContainerSetUp];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self defaultSetUp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -- Lazy load 
- (NSMutableArray<UIViewController*> *)contents {
    if (!_contents) {
        _contents = [NSMutableArray arrayWithCapacity:10];
    }
    return _contents;
}

- (NSMutableArray *)tabs {
    if (!_tabs) {
        _tabs = [NSMutableArray arrayWithCapacity:10];
    }
    return _tabs;
}

#pragma mark - Gesture

- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    
    if (_indexPath == sender.view.tag) {
        return;
    }
    _indexPath = sender.view.tag;
    
    [self selectTabAtIndex:sender.view.tag];
    if ([self.delegate respondsToSelector:@selector(viewPager:didSwitchAtIndex:withTabs:)]) {
        [self.delegate viewPager:self didSwitchAtIndex:sender.view.tag withTabs:self.tabs];
    }
}




#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{

    NSUInteger index = [self indexForViewController:viewController];
    index++;

    if (index == [self.contents count]) {
        //stop cycle action
//        index = 0;
        index = -1;
    }

    return [self viewControllerAtIndex:index];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexForViewController:viewController];

    if (index == 0) {
        //stop cycle action
//        index = [self.contents count] - 1;
        index = - 1;
    } else {
        index--;
    }

    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    if ([self.delegate respondsToSelector:@selector(viewPagerWillTransition:)]) {
        [self.delegate viewPagerWillTransition:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(viewPagerWillTransition:willTransitionToViewControllers:)]) {
        [self.delegate viewPagerWillTransition:self willTransitionToViewControllers:pendingViewControllers];
    }
    
    
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController
         didFinishAnimating:(BOOL)finished
    previousViewControllers:(NSArray *)previousViewControllers
        transitionCompleted:(BOOL)completed
{
    UIViewController *viewController = self.pageViewController.viewControllers[0];

    //当pageviewController 滚动的时候，滚动Tab
    NSUInteger index = [self indexForViewController:viewController];
    if ([self.delegate respondsToSelector:@selector(viewPager:didSwitchAtIndex:withTabs:)]) {
        [self.delegate viewPager:self didSwitchAtIndex:index withTabs:self.tabs];
    }

    _activeContentIndex = index;
    
    
    
}


#pragma mark - Private Methods

- (void)setActiveContentIndex:(NSInteger)activeContentIndex
{

    UIViewController *viewController = [self viewControllerAtIndex:activeContentIndex];

    if (!viewController) {
        viewController = [[UIViewController alloc] init];
        viewController.view = [[UIView alloc] init];
    }

    if (activeContentIndex == self.activeContentIndex) {

        [self.pageViewController setViewControllers:@[ viewController ]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];

    } else {

        NSInteger direction = 0;
        if (activeContentIndex == self.contents.count - 1 && self.activeContentIndex == 0) {
            direction = UIPageViewControllerNavigationDirectionReverse;
        } else if (activeContentIndex == 0 && self.activeContentIndex == self.contents.count - 1) {
            direction = UIPageViewControllerNavigationDirectionForward;
        } else if (activeContentIndex < self.activeContentIndex) {
            direction = UIPageViewControllerNavigationDirectionReverse;
        } else {
            direction = UIPageViewControllerNavigationDirectionForward;
        }

        [self.pageViewController setViewControllers:@[ viewController ]
                                          direction:direction
                                           animated:YES
                                         completion:^(BOOL completed){// none
                                         }];
    }

    _activeContentIndex = activeContentIndex;
}

- (void)selectTabAtIndex:(NSUInteger)index
{
    if (index >= self.tabCount) {
        return;
    }

    [self setActiveContentIndex:index];
}

- (UIView *)tabViewAtIndex:(NSUInteger)index
{
    return [self.tabs objectAtIndex:index];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (index >= self.tabCount) {
        return nil;
    }

    return [self.contents objectAtIndex:index];
}

- (NSUInteger)indexForViewController:(UIViewController *)viewController
{
    return [self.contents indexOfObject:viewController];
}



@end
