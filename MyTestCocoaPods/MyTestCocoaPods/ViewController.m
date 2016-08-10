//
//  ViewController.m
//  MyTestCocoaPods
//
//  Created by suger on 16/8/10.
//  Copyright © 2016年 Nutrition Rite  Co. Ltd. All rights reserved.
//

#import "ViewController.h"
#import "MyCocoaPodsHeader.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MyCocoaPodsObject* mCObject = [[MyCocoaPodsObject alloc]init];
    [mCObject log];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
