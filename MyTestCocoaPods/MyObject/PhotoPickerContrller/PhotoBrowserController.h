//
//  PhotoBrowserController.h
//  MyTestCocoaPods
//
//  Created by suger on 16/8/15.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <Masonry/Masonry.h>


#import "PhotoBrowserCell.h"
#import "PhotoBrowserBottomView.h"

UIKIT_EXTERN NSString* const PhotoBrowser_reuseIdentifier;

/*!
 *  图片预览控制器
 */
@interface PhotoBrowserController : UICollectionViewController

@property (nonatomic, weak) NSArray<PHAsset *> *assets;

@property (nonatomic, weak) NSMutableArray<PHAsset *> *arraySelectPhotos;

@property (nonatomic, assign) NSInteger selectIndex; //选中的图片下标

@property (nonatomic, assign) NSInteger maxSelectCount; //最大选择照片数

@property (nonatomic, assign) BOOL isPresent; //该界面显示方式，预览界面查看大图进来是present，从相册小图进来是push

@property (nonatomic, copy) void (^onSelectedPhotos)(NSArray<PHAsset *> *, BOOL isSelectOriginalPhoto); //点击返回按钮的回调

@property (nonatomic, copy) void (^btnDoneBlock)(NSArray<PHAsset *> *, BOOL isSelectOriginalPhoto); //点击确定按钮回调
@end

@interface PhotoBrowserController (NavButton)
- (UIBarButtonItem *)createRightBarItem;
@end

@interface PhotoBrowserController (BottomView)
- (void)createBottomView;
@end

@interface PhotoBrowserController (CV)
- (void)regstCells;

@end



/*!
 *  图片预览布局
 */
@interface PhotoBrowserLayout : UICollectionViewFlowLayout
@end