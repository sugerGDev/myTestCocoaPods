//
//  PhotoPickerController.h
//  MyTestCocoaPods
//
//  Created by suger on 16/8/12.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <QuartzCore/QuartzCore.h>
#import <Masonry/Masonry.h>

#import "ZLPhotoTool.h"
#import "PhotoPickerCell.h"
#import "PhotoPickerBottomView.h"
#import "PhotoBrowserController.h"
//cell identifier
UIKIT_EXTERN NSString * const PhotoPicker_reuseIdentifier;
/*!
 *  图片挑选Layout
 */
@interface PhotoPickerLayout : UICollectionViewFlowLayout

@end

/*!
 *  图片挑选UI
 */


@interface PhotoPickerController : UICollectionViewController {
    //底部控制视图
    PhotoPickerBottomView* _bottomView;
}
/*!
 *  最大选择照片数
 */
@property (nonatomic , assign) NSInteger maxPickAssetNumber;
@end
/*!
 *  图片挑选UI(CollectionView)
 */
@interface PhotoPickerController (CV)
- (void)regstCells;
- (void)loadPhotoFromAlbum;
@end
/*!
 *  Bottom View
 */
@interface PhotoPickerController (BV)
- (void)createBottomView;
- (void)cntPickNumByCellTapAction;
@end


