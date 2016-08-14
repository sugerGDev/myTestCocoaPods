//
//  PhotoPickerBottomView.m
//  MyTestCocoaPods
//
//  Created by suger on 16/8/14.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import "PhotoPickerBottomView.h"

@implementation PhotoPickerBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)doTapConfirmAction:(UIButton *)sender {
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //    tableCell 补全划线
    CGFloat lineHeight = .5f;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, lineHeight);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextMoveToPoint(context, 0, lineHeight);
    CGContextAddLineToPoint(context, rect.size.width, lineHeight);
    CGContextStrokePath(context);
}

@end
