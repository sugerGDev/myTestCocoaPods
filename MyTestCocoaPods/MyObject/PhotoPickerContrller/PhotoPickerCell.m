//
//  PhotoPickerCell.m
//  MyTestCocoaPods
//
//  Created by suger on 16/8/12.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import "PhotoPickerCell.h"

@implementation PhotoPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _imgProfile.contentMode = UIViewContentModeScaleAspectFill;
    _imgProfile.clipsToBounds = YES;
    _btnSelected.tintColor = [UIColor whiteColor];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _ppcDelegate = nil;
    _asset = nil;
    
}
- (void)setAsset:(PHAsset *)asset {
    
    _asset = asset;
    
    CGSize size = self.frame.size;
    size.width *= 3;
    size.height *= 3;
    
    ZLPhotoTool* tool = [ZLPhotoTool sharePhotoTool] ;
    [tool requestImageForAsset:asset
                          size:size resizeMode:PHImageRequestOptionsResizeModeExact
                    completion:^(UIImage *image, NSDictionary *info) {
                        _imgProfile.image = image;
                        
                    }];
}


- (IBAction)doTapSelectedAction:(PhotoPickerButton *)sender {
    BOOL isAllow = NO;
    if ([_ppcDelegate respondsToSelector:@selector(isAllowPickTheCell:)]) {
        
        isAllow = [_ppcDelegate isAllowPickTheCell:self];
        if (!isAllow)return;
    }
    
    
    //允许选择☑️

    if([_ppcDelegate respondsToSelector:@selector(isFinishPickTheCell:)]) {
      BOOL isFinish =  [_ppcDelegate isFinishPickTheCell:self];
        
        if (NO == isFinish) {return;}
        
        BOOL oSel = !self.btnSelected.isPicked;
        [self.btnSelected setIsPicked:oSel];
        
        [_btnSelected playSelectedAnimation];
        
        
    }
    

    
}

@end


@implementation PhotoPickerButton


- (void)setIsPicked:(BOOL)isPicked {
    _isPicked = isPicked;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString* imgName = nil;
        if (_isPicked) {
            imgName = @"btn_selected";
        }else {
            imgName = @"btn_original_circle";
        }
        UIImage* img = [UIImage imageNamed:imgName];
        
        dispatch_async(dispatch_get_main_queue(), ^{
              [self setImage:img forState:UIControlStateNormal];
        });
    });
   
    
}

- (void)playSelectedAnimation {
    
    CAKeyframeAnimation* b = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    b.values = @[@(1.0) ,@(1.4), @(0.9), @(1.15), @(0.95), @(1.02), @(1.0)];
    b.duration = 0.7;
    b.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:b forKey:nil];

 
   
    
}

@end

