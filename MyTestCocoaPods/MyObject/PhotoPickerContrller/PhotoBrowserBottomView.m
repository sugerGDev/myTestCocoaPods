//
//  PhotoBrowserBottomView.m
//  MyTestCocoaPods
//
//  Created by suger on 16/8/15.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import "PhotoBrowserBottomView.h"

@implementation PhotoBrowserBottomView

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

-(IBAction)doTapConfirmAction:(id)sender {
    
}

@end
