//
//  PhotoPickerController.h
//  MyTestCocoaPods
//
//  Created by suger on 16/8/12.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

#import "ZLPhotoTool.h"
#import "PhotoPickerCell.h"
//cell identifier
UIKIT_EXTERN NSString * const reuseIdentifier;
/*!
 *  图片挑选Layout
 */
@interface PhotoPickerLayout : UICollectionViewFlowLayout

@end

/*!
 *  图片挑选UI
 */


@interface PhotoPickerController : UICollectionViewController
<PHPhotoLibraryChangeObserver>{
    NSMutableArray* _dataSourceArray;
}

@end
/*!
 *  图片挑选UI(CollectionView)
 */
@interface PhotoPickerController (CV)

@end
