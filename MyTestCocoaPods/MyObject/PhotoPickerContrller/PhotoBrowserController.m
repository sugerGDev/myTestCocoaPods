//
//  PhotoBrowserController.m
//  MyTestCocoaPods
//
//  Created by suger on 16/8/15.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import "PhotoBrowserController.h"
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.pagingEnabled = YES;
    
    [self createBottomView];
    self.navigationItem.rightBarButtonItem = [self createRightBarItem];
    
    
    // Do any additional setup after loading the view from its nib.
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
    
    //当前页
    _currentPage = _dataSourceArray.count-self.selectIndex;
    self.title = [NSString stringWithFormat:@"%ld/%ld", (long)_currentPage,
                  (long)_dataSourceArray.count];
    [self regstCells];
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
    aSender.selected = !aSender.selected;
    [aSender playSelectedAnimation];
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
    
}

@end

@implementation PhotoBrowserController (CV)

- (void)regstCells {
    
    [self.collectionView registerClass:[PhotoBrowserCell class]
            forCellWithReuseIdentifier:PhotoBrowser_reuseIdentifier];
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
