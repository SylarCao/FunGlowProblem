//
//  ViewController.m
//  GlowFun
//
//  Created by sylar on 2017/1/4.
//  Copyright © 2017年 sylar. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
#import "ViewController.h"
#import "MethodObject1.h"
#import "MethodThread2.h"
#import "MethodReference3.h"
#import "MethodThread4.h"
#import "MethodDictionary.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////
# define kReturnNilCondition(condition)    if (condition == nil) {return;}
////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ViewController ()

@property (nonatomic, strong) NSString *startFrame;
@property (nonatomic, strong) NSString *endFrame;
@property (nonatomic, assign) NSInteger maxMoveSteps;

@property (nonatomic, strong) NSMutableDictionary *frames;  //@{@"wrbbrbb" => @"RRDDRLU"}

@end
////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setInitialValue];
}

- (void)setInitialValue {
    _startFrame = @"wrbbrrbbrrbbrrbb";
    _endFrame   = @"wbrbbrbrrbrbbrbr";
    _frames = [[NSMutableDictionary alloc] init];
    _maxMoveSteps = 50;
}

- (IBAction)btn1:(id)sender {
//    [self calculate];
    
//    [[MethodThread2 share] calculate1];
    
//    [[MethodReference3 share] reference1];
    
//    [[MethodThread4 share] thread1];
    
    [[MethodDictionary share] method1];
}

- (void)calculate {
    NSLog(@"sylar :  calculate");
    
//    NSString *s1 = [self moveDown:@"rbrbbwbrrbrbbrbr"];
//    NSLog(@"sylar :  s1 = %@", s1);
    
    [_frames removeAllObjects];
    
    [self MoveForewardWithValue:_startFrame steps:@""];
}


- (void)MoveForewardWithValue:(NSString *)value steps:(NSString *)step {
    
    kReturnNilCondition(value);
    
    if (step.length > _maxMoveSteps) {
//        NSLog(@"sylar :  max");
        return;
    }
    
    // check if reach end
    BOOL success = [self checkSuccess:value];
    if (success) {
        [self logSuccessWithSteps:step];
        return;
    }
    
    // check exist
    BOOL exist = [self checkExist:value steps:step];
    if (exist) {
        NSString *oldStep = [_frames objectForKey:value];
        if (oldStep.length <= step.length) {
            return;
        } else {
            [_frames setObject:step forKey:value];
        }
        
    }
    
    // add to the frames
    [_frames setObject:step forKey:value];
    
    // move left
    NSString *left = [self moveLeft:value];
    NSString *ll = [NSString stringWithFormat:@"%@L", step];
    [self MoveForewardWithValue:left steps:ll];
    
    // move right
    NSString *right  = [self moveRight:value];
    NSString *rr = [NSString stringWithFormat:@"%@R", step];
    [self MoveForewardWithValue:right steps:rr];
    
    // move up
    NSString *up = [self moveUp:value];
    NSString *uu = [NSString stringWithFormat:@"%@U", step];
    [self MoveForewardWithValue:up steps:uu];
    
    // move down
    NSString *down = [self moveDown:value];
    NSString *dd = [NSString stringWithFormat:@"%@D", step];
    [self MoveForewardWithValue:down steps:dd];
    
    
    
}

- (void)logSuccessWithSteps:(NSString *)steps {
    NSLog(@"sylar :  success.step = %@ (%ld)", steps, (long)steps.length);
}

#pragma mark - helper
- (BOOL)checkSuccess:(NSString *)value {
    BOOL rt = NO;
    if ([_endFrame isEqualToString:value]) {
        rt = YES;
    }
    return rt;
}

- (BOOL)checkExist:(NSString *)value steps:(NSString *)steps {
    BOOL rt = NO;
    
    NSArray *keys = [_frames allKeys];
    if ([keys containsObject:value]) {
        rt = YES;
//        NSString *oldSteps = [_frames objectForKey:value];
//        if (steps.length == oldSteps.length) {
////            NSLog(@"sylar :  same length = %@ - %@", oldSteps, steps);
//        } else if (steps.length < oldSteps.length) {
//            [_frames setObject:steps forKey:value];
//        }
    }
    
    return rt;
}

- (NSString *)moveLeft:(NSString *)value {
//    NSLog(@"sylar :  moveLeft");
    NSString *rt = nil;
    NSInteger index = [value rangeOfString:@"w"].location;
    if (index != NSNotFound) {
        NSInteger row = index%4;
        if (row > 0) {
            NSString *temp = [value substringWithRange:NSMakeRange(index-1, 1)];
            rt = [value stringByReplacingCharactersInRange:NSMakeRange(index-1, 1) withString:@"w"];
            rt = [rt stringByReplacingCharactersInRange:NSMakeRange(index, 1) withString:temp];
        }
    }
    return rt;
}

- (NSString *)moveRight:(NSString *)value {
//    NSLog(@"sylar :  moveRight");
    NSString *rt = nil;
    NSInteger index = [value rangeOfString:@"w"].location;
    if (index != NSNotFound) {
        NSInteger row = index%4;
        if (row < 3) {
            NSString *temp = [value substringWithRange:NSMakeRange(index+1, 1)];
            rt = [value stringByReplacingCharactersInRange:NSMakeRange(index+1, 1) withString:@"w"];
            rt = [rt stringByReplacingCharactersInRange:NSMakeRange(index, 1) withString:temp];
        }
    }
    return rt;
}

- (NSString *)moveUp:(NSString *)value {
//    NSLog(@"sylar :  moveUp");
    NSString *rt = nil;
    NSInteger index = [value rangeOfString:@"w"].location;
    if (index != NSNotFound) {
        if (index >= 4) {
            NSString *temp = [value substringWithRange:NSMakeRange(index-4, 1)];
            rt = [value stringByReplacingCharactersInRange:NSMakeRange(index-4, 1) withString:@"w"];
            rt = [rt stringByReplacingCharactersInRange:NSMakeRange(index, 1) withString:temp];
        }
    }
    return rt;
}

- (NSString *)moveDown:(NSString *)value {
//    NSLog(@"sylar :  moveDown");
    NSString *rt = nil;
    NSInteger index = [value rangeOfString:@"w"].location;
    if (index != NSNotFound) {
        if (index <= 11) {
            NSString *temp = [value substringWithRange:NSMakeRange(index+4, 1)];
            rt = [value stringByReplacingCharactersInRange:NSMakeRange(index+4, 1) withString:@"w"];
            rt = [rt stringByReplacingCharactersInRange:NSMakeRange(index, 1) withString:temp];
        }
    }
    return rt;
}



@end
