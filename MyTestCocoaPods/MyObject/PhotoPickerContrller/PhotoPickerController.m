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
        
        
    }
    return self;
}

@end

@interface PhotoPickerController()
<PHPhotoLibraryChangeObserver,PhotoPickerCellDelegate,
UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray* dataSourceArray;
@property (nonatomic, strong) NSMutableDictionary* pickedAssetDict;

@end

@implementation PhotoPickerController

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //defualt number
    self.maxPickAssetNumber = 10;
    self.collectionView.contentInset = UIEdgeInsetsMake(2, 0, 52, 0);
    
    // register photoChanged Observer
    [self registePhotoLibraryChangedObserver];
    
    //create bottom View
    [self createBottomView];
    //buid Collection
    [self buildCollectView];
}

- (void)buildCollectView {
    
    //create
    dispatch_queue_t queue =
    dispatch_queue_create("buildingCollectView.PhotoPickerController.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    //group
    dispatch_group_async(group, queue, ^(){
        // register cell classes for collectionView
        [self regstCells];
    });
    dispatch_group_async(group, queue, ^(){
        //load photoAlbum for collectionView
        [self loadPhotoFromAlbum];
    });
    
    //notify
    dispatch_group_notify(group, dispatch_get_main_queue(), ^(){
        [self.collectionView reloadData];
    });
}


#pragma mark -- lazy load

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:50];
    }
    return _dataSourceArray;
}

- (NSDictionary *)pickedAssetDict {
    if (!_pickedAssetDict) {
        _pickedAssetDict = [NSMutableDictionary dictionaryWithCapacity:self.maxPickAssetNumber];
    }
    return _pickedAssetDict;
}


#pragma mark -- Register Photo Observer
- (void)registePhotoLibraryChangedObserver {
    //注册实施监听相册变化
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

//相册变化回调
- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self loadPhotoFromAlbum];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
}

#pragma mark -- PhotoPickerCellDelegate
- (BOOL)isAllowPickTheCell:(__weak PhotoPickerCell *)aCell {
    if (self.pickedAssetDict.count >= self.maxPickAssetNumber
        && aCell.btnSelected.isPicked == NO) {
        NSLog(@"已经超过当前的限制选择数量,不予操作");
        return NO;
    }
    return YES;
}

- (BOOL)isFinishPickTheCell:(__weak PhotoPickerCell *)aCell {
    
    PHAsset *asset = self.dataSourceArray[aCell.btnSelected.tag];
    
    if (NO == aCell.btnSelected.isPicked) { //添加图片到选中数组
        [self.pickedAssetDict setObject:asset forKey:asset.localIdentifier];
        
    } else { //移除图片
        [self.pickedAssetDict removeObjectForKey:asset.localIdentifier];
    }
    
    //统计图片数量
    [self cntPickNumByCellTapAction];
    
    return YES;
}

#pragma mark -- TakePhoto
- (UIImage *)createTakePhotoImage {
    return [UIImage imageNamed:@"add_picture"];
}

- (void)doTakePhotoAction {
    
    ZLPhotoTool* tool = [ZLPhotoTool sharePhotoTool];
    BOOL isAuthority = [tool judgeIsHaveCameraAuthority];
    
    if (NO == isAuthority) {NSLog(@"没有访问摄像头权限"); return;}
    
    //拍照
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //            picker.delegate = self;
        picker.allowsEditing = NO;
        picker.videoQuality = UIImagePickerControllerQualityTypeLow;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        __weak typeof(self) wself = self;
        [self presentViewController:picker animated:YES completion:^{
            picker.delegate = wself;
        }];
    }
    
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    __weak typeof(self) wself = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *reImg = [wself scaleImage:image];
        
        [[ZLPhotoTool sharePhotoTool] saveImageToAblum:reImg completion:^(BOOL suc, PHAsset *asset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (suc) {
                    [self.pickedAssetDict setObject:asset forKey:asset.localIdentifier];
                    
                } else {
                    NSLog(@"保存到相册失败");
                }
            });
        }];
        
    }];
}


/**
 * @brief 这里对拿到的图片进行缩放，不然原图直接返回的话会造成内存暴涨
 */
- (UIImage *)scaleImage:(UIImage *)image{
    
    CGFloat ScalePhotoWidth = 1000;
    CGSize size = CGSizeMake(ScalePhotoWidth, ScalePhotoWidth * image.size.height / image.size.width);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

@implementation PhotoPickerController (CV)

- (void)loadPhotoFromAlbum {
    
    [self.dataSourceArray removeAllObjects];
    //插入第一张拍照
    [self.dataSourceArray addObject:[self createTakePhotoImage]];
    
    NSArray* arr = [[ZLPhotoTool sharePhotoTool] getAllAssetInPhotoAblumWithAscending:NO];
    [self.dataSourceArray addObjectsFromArray:arr];
    
}

- (void)regstCells {
    
    NSBundle* b = [NSBundle bundleForClass:[self class]];
    UINib* nib = [UINib nibWithNibName:reuseIdentifier bundle:b];
    
    [self.collectionView registerNib:nib
          forCellWithReuseIdentifier:reuseIdentifier];
}
#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of items
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoPickerCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                              forIndexPath:indexPath];
    
    // Configure the cell
    NSInteger index = indexPath.row;
    PHAsset* asset = self.dataSourceArray[index];
    
    
    if ([asset isKindOfClass:[UIImage class]]) {
        cell.imgProfile.image = (UIImage *)asset;
        [cell.btnSelected setImage:nil forState:UIControlStateNormal];
        
    }else {
        cell.asset = asset;
        cell.btnSelected.tag = index;
        cell.ppcDelegate = self;
        
        //判断当前的突破是否被选中☑️
        if ([self.pickedAssetDict objectForKey:asset.localIdentifier]) {
            [cell.btnSelected setIsPicked:YES];
        }else {
            [cell.btnSelected setIsPicked:NO];
        }
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset* asset = self.dataSourceArray[indexPath.row];
    if ([asset isKindOfClass:[UIImage class]]) {
        [self doTakePhotoAction];
    }
}

@end

@implementation PhotoPickerController (BV)

- (void )createBottomView {
    
    NSString* s = NSStringFromClass([PhotoPickerBottomView class]);
    NSBundle* b = [NSBundle bundleForClass:[self class]];
    _bottomView = [b loadNibNamed:s owner:self options:nil][0];
    
    [self.view addSubview:_bottomView];
    [self cntPickNumByCellTapAction];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(@40);
    }];
    
}

- (void)cntPickNumByCellTapAction {
    
    //bind data
    NSInteger curNum = [self.pickedAssetDict allKeys].count;
    NSInteger cntNum = self.maxPickAssetNumber;
    
    _bottomView.countLbl.text =
    [NSString stringWithFormat:@"%ld／%ld",(long)curNum,(long)cntNum];
}

@end