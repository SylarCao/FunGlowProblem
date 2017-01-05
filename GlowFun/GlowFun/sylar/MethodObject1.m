//
//  MethodObject1.m
//  GlowFun
//
//  Created by sylar on 2017/1/5.
//  Copyright © 2017年 sylar. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
#import "MethodObject1.h"
# define kReturnNilCondition(condition)    if (condition == nil) {return;}
////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MethodObject1()

@property (nonatomic, strong) NSString *startFrame;
@property (nonatomic, strong) NSString *endFrame;
@property (nonatomic, assign) NSInteger maxMoveSteps;

@property (nonatomic, strong) NSMutableArray *frames;

@end
////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MethodObject1

+ (instancetype)share {
    static MethodObject1 *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[MethodObject1 alloc] init];
    });
    return inst;
}

- (id)init {
    self = [super init];
    if (self) {
        _startFrame = @"wrbbrrbbrrbbrrbb";
        _endFrame   = @"wbrbbrbrrbrbbrbr";
        _frames = [[NSMutableArray alloc] init];
        _maxMoveSteps = 50;
    }
    return self;
}

- (void)calculate1 {
    
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
    BOOL exist = [self checkExist:value];
    if (exist) {
        return;
//        NSString *oldStep = [_frames objectForKey:value];
//        if (oldStep.length <= step.length) {
//            return;
//        } else {
////            [_frames setObject:step forKey:value];
//        }
        
    }
    
    // add to the frames
//    [_frames setObject:step forKey:value];
    
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

- (BOOL)checkSuccess:(NSString *)value {
    BOOL rt = NO;
    if ([_endFrame isEqualToString:value]) {
        rt = YES;
    }
    return rt;
}

- (BOOL)checkExist:(NSString *)value {
    BOOL rt = NO;
    
    if ([_frames containsObject:value]) {
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


#pragma mark - move 
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
