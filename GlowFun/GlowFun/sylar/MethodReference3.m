//
//  MethodReference3.m
//  GlowFun
//
//  Created by sylar on 2017/1/5.
//  Copyright © 2017年 sylar. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
#import "MethodReference3.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MethodReference3()

@property (nonatomic, strong) NSString *startFrame;
@property (nonatomic, strong) NSString *endFrame;
@property (nonatomic, assign) NSInteger maxMoveSteps;

@property (nonatomic, strong) NSMutableArray *frames;  // already exist frames
@property (nonatomic, strong) NSArray *currentFrames;
@property (nonatomic, strong) NSMutableArray *nextFrames;

@property (nonatomic, strong) NSMutableArray *answers;

@property (nonatomic, assign) BOOL isThreadRunning;

@end
////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MethodReference3

+ (instancetype)share {
    static MethodReference3 *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[MethodReference3 alloc] init];
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
        _frames = [[NSMutableArray alloc] init];
        _nextFrames = [[NSMutableArray alloc] init];
        _answers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)reference1 {
    
    _isThreadRunning = YES;
    
    
    ReferenceObje1 *one = [[ReferenceObje1 alloc] init];
    one.steps = @"";
    one.value = _startFrame;
    [_nextFrames addObject:one];
    
    NSLog(@"sylar :  begin");
    CFAbsoluteTime t1 = CFAbsoluteTimeGetCurrent();
    [self startCalcOnThread];
    
    NSLog(@"sylar :  end");
    CFAbsoluteTime t2 = CFAbsoluteTimeGetCurrent();
    
    NSLog(@"sylar :  time = %f", t2-t1);
    
    // time = 341.700994   for NSString
    
    
    
    
    
}

- (void)startCalcOnThread {
    
    while (_isThreadRunning) {
        
        if (_answers.count > 0) {
            _isThreadRunning = NO;
            ReferenceObje1 *aa = [_answers lastObject];
            
            NSLog(@"sylar :  answers = %@(%@, %@)", _answers, aa.steps, aa.value);
            
            break;
        }
        
        _currentFrames = [[NSArray alloc] initWithArray:_nextFrames];
        [_nextFrames removeAllObjects];
        
        
        if (_currentFrames.count > 0) {
            ReferenceObje1 *last = [_currentFrames lastObject];
            NSLog(@"sylar :  aaa = %ld - %d", last.steps.length, _currentFrames.count);
        }
        
        
        for (ReferenceObje1 *obj in _currentFrames) {
            
            // left
            NSString *left = [obj moveLeft];
            if (left) {
                if ([_frames containsObject:left] == NO) {
                    // new frame
                    [_frames addObject:left];
                    
                    ReferenceObje1 *newObj = [[ReferenceObje1 alloc] init];
                    newObj.value = left;
                    newObj.steps = [NSString stringWithFormat:@"%@L", obj.steps];
                    [_nextFrames addObject:newObj];
                    
                    if ([left isEqualToString:_endFrame]) {
                        [_answers addObject:newObj];
                    }
                }
            }
            
            // right
            NSString *right = [obj moveRight];
            if (right) {
                if ([_frames containsObject:right] == NO) {
                    // new frame
                    [_frames addObject:right];
                    
                    ReferenceObje1 *newObj = [[ReferenceObje1 alloc] init];
                    newObj.value = right;
                    newObj.steps = [NSString stringWithFormat:@"%@R", obj.steps];
                    [_nextFrames addObject:newObj];
                    
                    if ([right isEqualToString:_endFrame]) {
                        [_answers addObject:newObj];
                    }
                }
            }
            
            // down
            left = [obj moveDown];
            if (left) {
                if ([_frames containsObject:left] == NO) {
                    // new frame
                    [_frames addObject:left];
                    
                    ReferenceObje1 *newObj = [[ReferenceObje1 alloc] init];
                    newObj.value = left;
                    newObj.steps = [NSString stringWithFormat:@"%@D", obj.steps];;
                    [_nextFrames addObject:newObj];
                    
                    if ([left isEqualToString:_endFrame]) {
                        [_answers addObject:newObj];
                    }
                }
            }
            
            // up
            left = [obj moveUp];
            if (left) {
                if ([_frames containsObject:left] == NO) {
                    // new frame
                    [_frames addObject:left];
                    
                    ReferenceObje1 *newObj = [[ReferenceObje1 alloc] init];
                    newObj.value = left;
                    newObj.steps = [NSString stringWithFormat:@"%@U", obj.steps];;
                    [_nextFrames addObject:newObj];
                    
                    if ([left isEqualToString:_endFrame]) {
                        [_answers addObject:newObj];
                    }
                }
            }
        }
        
        
    }
    
}



@end


@implementation ReferenceObje1

- (id)init {
    self = [super init];
    if (self) {
        _steps = @"";
    }
    return self;
}

- (NSString *)moveLeft {
    //    NSLog(@"sylar :  moveLeft");
    NSString *rt = nil;
    NSInteger index = [_value rangeOfString:@"w"].location;
    if (index != NSNotFound) {
        NSInteger row = index%4;
        if (row > 0) {
            NSString *temp = [_value substringWithRange:NSMakeRange(index-1, 1)];
            rt = [_value stringByReplacingCharactersInRange:NSMakeRange(index-1, 1) withString:@"w"];
            rt = [rt stringByReplacingCharactersInRange:NSMakeRange(index, 1) withString:temp];
        }
    }
    return rt;
}

- (NSString *)moveRight {
    //    NSLog(@"sylar :  moveRight");
    NSString *rt = nil;
    NSInteger index = [_value rangeOfString:@"w"].location;
    if (index != NSNotFound) {
        NSInteger row = index%4;
        if (row < 3) {
            NSString *temp = [_value substringWithRange:NSMakeRange(index+1, 1)];
            rt = [_value stringByReplacingCharactersInRange:NSMakeRange(index+1, 1) withString:@"w"];
            rt = [rt stringByReplacingCharactersInRange:NSMakeRange(index, 1) withString:temp];
        }
    }
    return rt;
}

- (NSString *)moveUp {
    //    NSLog(@"sylar :  moveUp");
    NSString *rt = nil;
    NSInteger index = [_value rangeOfString:@"w"].location;
    if (index != NSNotFound) {
        if (index >= 4) {
            NSString *temp = [_value substringWithRange:NSMakeRange(index-4, 1)];
            rt = [_value stringByReplacingCharactersInRange:NSMakeRange(index-4, 1) withString:@"w"];
            rt = [rt stringByReplacingCharactersInRange:NSMakeRange(index, 1) withString:temp];
        }
    }
    return rt;
}

- (NSString *)moveDown {
    //    NSLog(@"sylar :  moveDown");
    NSString *rt = nil;
    NSInteger index = [_value rangeOfString:@"w"].location;
    if (index != NSNotFound) {
        if (index <= 11) {
            NSString *temp = [_value substringWithRange:NSMakeRange(index+4, 1)];
            rt = [_value stringByReplacingCharactersInRange:NSMakeRange(index+4, 1) withString:@"w"];
            rt = [rt stringByReplacingCharactersInRange:NSMakeRange(index, 1) withString:temp];
        }
    }
    return rt;
}


@end
