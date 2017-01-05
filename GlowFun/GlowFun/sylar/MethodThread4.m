//
//  MethodThread4.m
//  GlowFun
//
//  Created by sylar on 2017/1/5.
//  Copyright © 2017年 sylar. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
#import "MethodThread4.h"
#import "MethodReference3.h"
////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MethodThread4 ()

@property (nonatomic, strong) NSString *startFrame;
@property (nonatomic, strong) NSString *endFrame;
@property (nonatomic, assign) NSInteger maxMoveSteps;

@property (nonatomic, strong) NSMutableArray *frames;  // already exist frames
@property (nonatomic, strong) NSArray *currentFrames;
@property (nonatomic, strong) NSMutableArray *nextFrames;

@property (nonatomic, strong) NSMutableArray *answers;

@property (nonatomic, assign) BOOL isThreadRunning;

@property (nonatomic, strong) NSMutableArray *threads;


@end
////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MethodThread4

+ (instancetype)share {
    static MethodThread4 *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[MethodThread4 alloc] init];
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

- (void)thread1 {
    
    _isThreadRunning = YES;
    
    
    ReferenceObje1 *one = [[ReferenceObje1 alloc] init];
    one.steps = @"";
    one.value = _startFrame;
    [_nextFrames addObject:one];
    
    
    
    _threads = [[NSMutableArray alloc] init];
    
    NSInteger threadCount = 2;
    
    for (int i=0; i<threadCount; i++) {
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(GO) object:nil];
        thread.qualityOfService = NSQualityOfServiceUserInitiated;
        thread.name = [NSString stringWithFormat:@"%i", i];
        [_threads addObject:thread];
    }
    
    for (NSThread *thread in _threads) {
        [thread start];
    }
    
    
}

- (void)GO {
    
    NSLog(@"sylar :  GOOOO");
    
    [self startCalcOnThread];
    
    
}



- (void)startCalcOnThread {
    
    CFAbsoluteTime t1 = CFAbsoluteTimeGetCurrent();
    
    while (_isThreadRunning) {
        
        @autoreleasepool {
            
        
        
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
            NSLog(@"sylar :  aaa = %ld - %ld", last.steps.length, _currentFrames.count);
            
            if (last.steps.length == 20) {
                CFAbsoluteTime t2 = CFAbsoluteTimeGetCurrent();
                NSLog(@"sylar :  time = %f", t2-t1);
            }
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
        
        
    }  // auto release pool
    }
    
}



@end


