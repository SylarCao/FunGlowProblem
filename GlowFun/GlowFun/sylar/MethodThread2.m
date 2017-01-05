//
//  MethodThread2.m
//  GlowFun
//
//  Created by sylar on 2017/1/5.
//  Copyright © 2017年 sylar. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
#import "MethodThread2.h"
#import <pthread.h>
# define kReturnNilCondition(condition)    if (condition == nil) {return;}
////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MethodThread2()
@property (nonatomic, strong) NSString *startFrame;
@property (nonatomic, strong) NSString *endFrame;
@property (nonatomic, assign) NSInteger maxMoveSteps;

@property (nonatomic, strong) NSMutableArray *frames;

@property (nonatomic, assign) BOOL running;


@end
////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MethodThread2 {
    pthread_mutex_t _routesIndexMutexLock;
}

+ (instancetype)share {
    static MethodThread2 *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[MethodThread2 alloc] init];
    });
    return inst;
}

- (id)init {
    self = [super init];
    if (self) {
        _startFrame = @"wrbbrrbbrrbbrrbb";
        _endFrame   = @"wbrbbrbrrbrbbrbr";
        _frames = [[NSMutableArray alloc] init];
        _maxMoveSteps = 35;
        _running = NO;
    }
    return self;
}

- (void)calculate1 {
    [_frames removeAllObjects];
    
    
    [self threadCalculate];
    
}

- (void)threadCalculate {
    
    NSInteger thread = 2;
    NSMutableArray *tt = [[NSMutableArray alloc] init];
    
    for (int i=0; i<thread; i++) {
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(thread1) object:nil ];
        thread.qualityOfService = NSQualityOfServiceUserInitiated;
        thread.name = [NSString stringWithFormat:@"%i", i];
        [tt addObject:thread];
    }
    
    for (NSThread *thread in tt) {
        [thread start];
    }
}

- (void)thread1 {
//    @autoreleasepool {
    static int i = 0;
    int var = i++;
        pthread_mutex_lock(&_routesIndexMutexLock);
        NSLog(@"sylar :  begin = %d", var);
        CFAbsoluteTime t1 = CFAbsoluteTimeGetCurrent();
        [self MoveForewardWithValue:_startFrame steps:@""];
        
        NSLog(@"sylar :  end = %d", var);
        CFAbsoluteTime t2 = CFAbsoluteTimeGetCurrent();
        
        NSLog(@"sylar :  time = %f", t2-t1);
        pthread_mutex_unlock(&_routesIndexMutexLock);
//    }
}

- (void)onlyCalculate {
    NSLog(@"sylar :  begin");
    CFAbsoluteTime t1 = CFAbsoluteTimeGetCurrent();
    [self MoveForewardWithValue:_startFrame steps:@""];
    
    NSLog(@"sylar :  end");
    CFAbsoluteTime t2 = CFAbsoluteTimeGetCurrent();
    
    NSLog(@"sylar :  time = %f", t2-t1);
    
    // 50 for   time = 53.985772
    // 40 for   time = 36.021440
    // 35 for   time = 10.301435
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
//        [_frames setObject:step forKey:value];
    [_frames addObject:value];
    
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
