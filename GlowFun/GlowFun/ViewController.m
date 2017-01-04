//
//  ViewController.m
//  GlowFun
//
//  Created by sylar on 2017/1/4.
//  Copyright © 2017年 sylar. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
#import "ViewController.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ViewController ()

@property (nonatomic, strong) NSString *startFrame;
@property (nonatomic, strong) NSString *endFrame;

@property (nonatomic, strong) NSMutableArray *frames;

@end
////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setInitialValue];
}

- (void)setInitialValue {
    _startFrame = @"wrbbrrbbrrbbrrbb";
    _endFrame = @"wbrbbrbrrbrbbrbr";
    _frames = [[NSMutableArray alloc] init];
}

- (IBAction)btn1:(id)sender {
    [self calculate];
}

- (void)calculate {
    
}



@end
