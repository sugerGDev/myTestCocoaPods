//
//  PhotoBrowserCell.h
//  MyTestCocoaPods
//
//  Created by suger on 16/8/15.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "PhotoBrowserController.h"

@interface PhotoBrowserCell : UICollectionViewCell

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic , weak) PhotoBrowserController* wVContrl;

@end
