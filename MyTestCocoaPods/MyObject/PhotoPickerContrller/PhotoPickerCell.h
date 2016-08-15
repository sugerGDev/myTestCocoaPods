//
//  PhotoPickerCell.h
//  MyTestCocoaPods
//
//  Created by suger on 16/8/12.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "ZLPhotoTool.h"

@class PhotoPickerButton;
@class PhotoPickerCell;

@protocol PhotoPickerCellDelegate <NSObject>

- (BOOL)isAllowPickTheCell:(__weak PhotoPickerCell*)aCell;
- (BOOL)isFinishPickTheCell:(__weak PhotoPickerCell*)aCell;

@end

/*!
 *  相册Cell
 */
@interface PhotoPickerCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet PhotoPickerButton *btnSelected;


@property (nonatomic , weak) PHAsset* asset;
@property (nonatomic , weak) id<PhotoPickerCellDelegate> ppcDelegate;
@end





/*!
 *  相册点击Button
 */
@interface PhotoPickerButton : UIButton
@property (nonatomic , assign) BOOL isPicked;
@end


