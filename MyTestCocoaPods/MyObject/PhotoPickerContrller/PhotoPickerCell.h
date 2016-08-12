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

@interface PhotoPickerCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnSelected;
@property (weak, nonatomic) PHAsset* asset;

@end
