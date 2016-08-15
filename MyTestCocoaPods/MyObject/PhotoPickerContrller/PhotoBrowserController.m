//
//  PhotoBrowserController.m
//  MyTestCocoaPods
//
//  Created by suger on 16/8/15.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import "PhotoBrowserController.h"

#import "ZLPhotoTool.h"
#import "PhotoBrowserCell.h"
#import "PhotoBrowserBottomView.h"

#import "UIButton+Animation.h"
NSString* const PhotoBrowser_reuseIdentifier = @"PhotoBrowserCell";

@interface PhotoBrowserController ()
//导航试图右边按钮
@property (nonatomic , strong) UIButton* navRightBtn;
//底部控制Bar
@property (nonatomic , strong) PhotoBrowserBottomView* bottomView;
//图片集合
@property (nonatomic , strong) NSMutableArray<PHAsset* >* dataSourceArray;
//当前索引
@property (nonatomic , assign) NSInteger currentPage;
@end

@implementation PhotoBrowserController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self scrollViewToOffsetBySelectedPage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self showNavBarAndBottomView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.pagingEnabled = YES;
    [self.collectionView setContentOffset:CGPointMake(-100.f, 0)];
    
    //创建Right NavBar
    [self createBottomView];
    self.navigationItem.rightBarButtonItem = [self createRightBarItem];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter 操作
- (void)setAssets:(NSArray<PHAsset *> *)assets {
    
    _dataSourceArray = [NSMutableArray arrayWithCapacity:50];
    @autoreleasepool {
        //做个反向处理,remove last object
        NSEnumerator *enumerator = [assets reverseObjectEnumerator];
        id obj;
        while (obj = [enumerator nextObject]) {
            [_dataSourceArray addObject:obj];
        }
        //删除最后一个image 对象
        [_dataSourceArray removeLastObject];
    }
    
    [self regstCells];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    //改变导航标题
    CGFloat page = scrollView.contentOffset.x/ w;
    NSString *str = [NSString stringWithFormat:@"%.0f", page];
    
    _currentPage =  str.integerValue + 1;
    
    self.title = [NSString stringWithFormat:@"%ld/%ld", _currentPage, _dataSourceArray.count];
    [self changeNavRightBtnStatus];
    
}



@end

@implementation PhotoBrowserController (NavButton)

- (UIBarButtonItem *)createRightBarItem {
    
    _navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _navRightBtn.frame = CGRectMake(0, 0, 25, 25);
    UIImage *normalImg = [UIImage imageNamed:@"PhotoAsset.bundle/btn_circle"];
    UIImage *selImg = [UIImage imageNamed:@"PhotoAsset.bundle/btn_selected"];
    
    [_navRightBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
    [_navRightBtn setBackgroundImage:selImg forState:UIControlStateSelected];
    [_navRightBtn addTarget:self action:@selector(navRightBtn_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    return  [[UIBarButtonItem alloc] initWithCustomView:_navRightBtn];
}

- (void)navRightBtn_Click:(UIButton *)aSender {
    
    if ([_pickPhotosDict allKeys].count >= self.maxSelectCount
        && aSender.selected == NO) {

        NSLog(@"最多只能选择%ld张图片", self.maxSelectCount);
        return;
    }
    
    PHAsset *asset = _dataSourceArray[_currentPage-1];
    if (NO == [self isHaveCurrentPageImage]) {
        
        if (NO == [[ZLPhotoTool sharePhotoTool] judgeAssetisInLocalAblum:asset]) {
            NSLog(@"图片加载中，请稍后");
            return;
        }
        
        [_pickPhotosDict setObject:asset forKey:asset.localIdentifier];
    } else {
        [self removeCurrentPageImage];
    }
    
    [self updateCountForConfirmBtn];
    aSender.selected = !aSender.selected;
    [aSender playSelectedAnimation];
}


- (void)changeNavRightBtnStatus
{
    if ([self isHaveCurrentPageImage]) {
        _navRightBtn.selected = YES;
    } else {
        _navRightBtn.selected = NO;
    }
}
#pragma mark - Style 
- (void)showNavBarAndBottomView
{
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    _bottomView.hidden = NO;
}

- (void)hideNavBarAndBottomView
{
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    _bottomView.hidden = YES;
}


#pragma mark - Help
- (BOOL)isHaveCurrentPageImage{
    
    PHAsset *sAsset = _dataSourceArray[_currentPage-1];
    if ([_pickPhotosDict objectForKey:sAsset.localIdentifier]) {
        return YES;
    }
    return NO;
}

- (void)removeCurrentPageImage{
    
    PHAsset *sAsset = _dataSourceArray[_currentPage-1];
    [_pickPhotosDict removeObjectForKey:sAsset.localIdentifier];
}
@end

@implementation PhotoBrowserController (BottomView)

- (void)createBottomView {
    
    NSString* cls = NSStringFromClass([PhotoBrowserBottomView class]);
    NSBundle* b = [NSBundle bundleForClass:[self class]];
    
    _bottomView =
    (PhotoBrowserBottomView *)[b loadNibNamed:cls owner:self options:nil].firstObject;
    
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(@40);
    }];
 
    [self updateCountForConfirmBtn];
}

- (void)updateCountForConfirmBtn {
    NSString* str = [NSString stringWithFormat:@"确定(%ld)",[_pickPhotosDict allKeys].count];
    [_bottomView.confirmBtn setTitle:str forState:UIControlStateNormal];

}
@end

@implementation PhotoBrowserController (CV)

- (void)regstCells {
    
    [self.collectionView registerClass:[PhotoBrowserCell class]
            forCellWithReuseIdentifier:PhotoBrowser_reuseIdentifier];
}

- (void)scrollViewToOffsetBySelectedPage {
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat x = (self.dataSourceArray.count - self.selectIndex) * w;
    
    CGPoint p = CGPointMake(x, 0);
    [self.collectionView setContentOffset:p];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    return _dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoBrowserCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoBrowserCell"
                                              forIndexPath:indexPath];
    
    PHAsset *asset = _dataSourceArray[indexPath.row];
    cell.asset = asset;
    cell.wVContrl = self;
    return cell;
}

@end



@implementation PhotoBrowserLayout

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        CGSize ks = [UIScreen mainScreen].bounds.size;
        
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //fix scollView's frame offset by x asix !!
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        self.itemSize = CGSizeMake(ks.width , ks.height);
        
        
    }
    return self;
}

@end
