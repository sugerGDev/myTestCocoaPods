//
//  PhotoPickerController.m
//  MyTestCocoaPods
//
//  Created by suger on 16/8/12.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import "PhotoPickerController.h"
NSString * const reuseIdentifier = @"PhotoPickerCell";

@implementation PhotoPickerLayout

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        CGFloat kw = [UIScreen mainScreen].bounds.size.width;
        //把手机屏幕宽度4等分，并且减去间隔1px等到图片大小
        CGFloat s =  kw / 4.f - 1.f;
        self.itemSize = CGSizeMake(s, s);
        
        self.minimumInteritemSpacing = 1;
        self.minimumLineSpacing = 1;
        
        self.headerReferenceSize = CGSizeMake(kw, 2);
        self.footerReferenceSize = CGSizeMake(kw, 64);
        
        
    }
    return self;
}

@end

@implementation PhotoPickerController

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)loadView {
    [super loadView];
    
    _dataSourceArray = [NSMutableArray arrayWithCapacity:50];
    [self registePhotoLibraryChangedObserver];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    NSBundle* b = [NSBundle bundleForClass:[self class]];
    UINib* nib = [UINib nibWithNibName:reuseIdentifier bundle:b];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];

    [self loadPhotoFromAlbum];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- Register Photo Observer
- (void)registePhotoLibraryChangedObserver {
    //注册实施监听相册变化
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

//相册变化回调
- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    
    [self loadPhotoFromAlbum];
}

- (void)loadPhotoFromAlbum {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [_dataSourceArray removeAllObjects];
        [_dataSourceArray addObjectsFromArray:[[ZLPhotoTool sharePhotoTool] getAllAssetInPhotoAblumWithAscending:NO]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
    
}

@end

@implementation PhotoPickerController (CV)
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of items
    return _dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoPickerCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.asset = _dataSourceArray[indexPath.row];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
 return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 
 }
 */
@end
