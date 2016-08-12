//
//  PhotoPickerCell.m
//  MyTestCocoaPods
//
//  Created by suger on 16/8/12.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import "PhotoPickerCell.h"
#define weakify(var)   __weak typeof(var) weakSelf = var
#define strongify(var) __strong typeof(var) strongSelf = var

@implementation PhotoPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _imgProfile.contentMode = UIViewContentModeScaleAspectFill;
    _imgProfile.clipsToBounds = YES;
    
    // Initialization code
}

- (void)setAsset:(PHAsset *)asset {
    
    _asset = asset;
    
    CGSize size = self.frame.size;
    size.width *= 3;
    size.height *= 3;
    
//    weakify(self);
    [[ZLPhotoTool sharePhotoTool] requestImageForAsset:asset
                                                  size:size resizeMode:PHImageRequestOptionsResizeModeExact
                                            completion:^(UIImage *image, NSDictionary *info) {
//        strongify(weakSelf);
        _imgProfile.image = image;
//        for (ZLSelectPhotoModel *model in strongSelf.arraySelectPhotos) {
//            if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
//                cell.btnSelect.selected = YES;
//                break;
//            }
//        }
    }];
//    cell.btnSelect.tag = indexPath.row;
}
@end
