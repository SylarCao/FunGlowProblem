//
//  MethodDictionary.m
//  GlowFun
//
//  Created by sylar on 2017/1/6.
//  Copyright © 2017年 sylar. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////////////////////////////
#import "MethodDictionary.h"
#import "MethodReference3.h"
#import <pthread.h>
////////////////////////////////////////////////////////////////////////////////////////////////////////
extern NSString *endIndexKey;
////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MethodDictionary ()

@property (nonatomic, strong) NSString *startFrame;
@property (nonatomic, strong) NSString *endFrame;
@property (nonatomic, assign) NSInteger maxMoveSteps;

@property (nonatomic, strong) NSMutableDictionary *frames;  // already exist frames
@property (nonatomic, strong) NSArray *currentFrames;
@property (nonatomic, strong) NSMutableArray *nextFrames;

@property (nonatomic, strong) NSMutableArray *answers;

@property (nonatomic, assign) BOOL isThreadRunning;

@property (nonatomic, strong) NSMutableArray *threads;
@property (nonatomic, assign) BOOL switchedQueue;
@property (nonatomic, assign) NSInteger threadCount;
@property (nonatomic, assign) NSInteger availableThreadCount;

@property (nonatomic, assign) pthread_mutex_t routesQueueMutexLock;
@property (nonatomic, assign) pthread_mutex_t routesIndexMutexLock;
@property (nonatomic, assign) pthread_mutex_t move;
@property (nonatomic, assign) pthread_mutex_t framesLock;

@end
////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MethodDictionary

+ (instancetype)share {
    static MethodDictionary *inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[MethodDictionary alloc] init];
    });
    return inst;
}

- (id)init {
    self = [super init];
    if (self) {
        _startFrame = @"wrbbrrbbrrbbrrbb";
        _endFrame   = @"wbrbbrbrrbrbbrbr";
        _frames = [[NSMutableDictionary alloc] init];
        _maxMoveSteps = 50;
        _nextFrames = [[NSMutableArray alloc] init];
        _answers = [[NSMutableArray alloc] init];
        
        pthread_mutex_init(&_routesQueueMutexLock, NULL);
        pthread_mutex_init(&_routesIndexMutexLock, NULL);
        pthread_mutex_init(&_move, NULL);
        pthread_mutex_init(&_framesLock, NULL);
    }
    return self;
}

- (void)method1 {
    
    _isThreadRunning = YES;
    
    
    ReferenceObje1 *one = [[ReferenceObje1 alloc] init];
    one.steps = @"";
    one.value = _startFrame;
    [_nextFrames addObject:one];
    
    
    
    _threads = [[NSMutableArray alloc] init];
    
    _availableThreadCount = 1;
    NSInteger threadCount = _availableThreadCount;
    
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
            
            
            pthread_mutex_lock(&_routesIndexMutexLock);
            
            
            if (_threadCount == 0) {
                
                if (_answers.count > 0 && _threadCount == 0) {
                    _isThreadRunning = NO;
                    ReferenceObje1 *aa = [_answers lastObject];
                    
//                    NSLog(@"sylar :  answers = %@(%@, %@)", _answers, aa.steps, aa.value);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"sylar :  main.answers = %@(%@, %@)", _answers, aa.steps, aa.value);
                        CFAbsoluteTime t2 = CFAbsoluteTimeGetCurrent();
                        NSLog(@"sylar :  time(finish) = %f", t2-t1);
                        _isThreadRunning = NO;
                    });
                    pthread_mutex_unlock(&_routesIndexMutexLock);
                    break;
                } else {
                    _switchedQueue = YES;
                    _threadCount = _threadCount + 1;
                    
                    _currentFrames = [[NSArray alloc] initWithArray:_nextFrames];
                    [_nextFrames removeAllObjects];
                    
                    for (NSThread *thread in _threads) {
                        thread.threadDictionary[endIndexKey] = @0;
                    }
                    
                }
                
            }
            
            
            pthread_mutex_unlock(&_routesIndexMutexLock);
            
            
            BOOL shouldSleep = [[NSThread currentThread].threadDictionary[endIndexKey] integerValue] == -1;
            if (shouldSleep) {
                [NSThread sleepForTimeInterval:0];
            } else {
                
                if (_currentFrames.count > 0) {
                    ReferenceObje1 *last = [_currentFrames lastObject];
                    NSLog(@"sylar :  aaa = %ld - %ld", last.steps.length, _currentFrames.count);
                    
                    if (last.steps.length == 20) {
                        CFAbsoluteTime t2 = CFAbsoluteTimeGetCurrent();
                        NSLog(@"sylar :  time(20) = %f", t2-t1);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"sylar :  main.time(20) = %f", t2-t1);
                        });
                    }
                }
                
                
                pthread_mutex_lock(&_routesIndexMutexLock);
                if (_switchedQueue == YES) {
                    _switchedQueue = NO;
                } else {
                    _threadCount += 1;
                }
                
                
                int threadIndex = [[NSThread currentThread].name intValue];
                int indexLimit = (int)(_currentFrames.count / _availableThreadCount) + 1;
                int indexOffset = indexLimit * threadIndex;
                int beginIndex = 0 + indexOffset;
                int endIndex = indexOffset + (indexLimit - 1);
                
                NSLog(@"sylar :  thread(%ld), frames(%ld) begin-end(%ld,%ld)", threadIndex, _currentFrames.count, beginIndex, endIndex);
                
                pthread_mutex_unlock(&_routesIndexMutexLock);
                
                CFAbsoluteTime t1 = CFAbsoluteTimeGetCurrent();
                for (int index = beginIndex; index <= endIndex; index++) {
                    
                    if (index >= _currentFrames.count) {
                        //                        NSLog(@"sylar :  out of counttttttttt(%ld, %ld)", beginIndex, endIndex);
                        break;
                    }
                    
                    ReferenceObje1 *obj = [_currentFrames objectAtIndex:index];
                    // left
                    //                    pthread_mutex_lock(&_move);
                    NSString *left = [obj moveLeft];
                    //                    pthread_mutex_unlock(&_move);
                    
                    if (left) {
                        if ([_frames objectForKey:left] == nil) {
                            // new frame
                            pthread_mutex_lock(&_framesLock);
//                            [_frames addObject:left];
                            [_frames setObject:left forKey:left];
                            pthread_mutex_unlock(&_framesLock);
                            
                            ReferenceObje1 *newObj = [[ReferenceObje1 alloc] init];
                            newObj.value = left;
                            newObj.steps = [NSString stringWithFormat:@"%@L", obj.steps];
                            pthread_mutex_lock(&_routesQueueMutexLock);
                            [_nextFrames addObject:newObj];
                            pthread_mutex_unlock(&_routesQueueMutexLock);
                            
                            if ([left isEqualToString:_endFrame]) {
                                [_answers addObject:newObj];
                            }
                        }
                    }
                    
                    // right
                    //                    pthread_mutex_lock(&_move);
                    NSString *right = [obj moveRight];
                    //                    pthread_mutex_unlock(&_move);
                    if (right) {
//                        pthread_mutex_lock(&_framesLock);
//                        BOOL contain = [_frames containsObject:right];
//                        pthread_mutex_unlock(&_framesLock);
                        if ([_frames objectForKey:right] == nil) {
                            // new frame
                            pthread_mutex_lock(&_framesLock);
                            [_frames setObject:right forKey:right];
                            pthread_mutex_unlock(&_framesLock);
                            
                            ReferenceObje1 *newObj = [[ReferenceObje1 alloc] init];
                            newObj.value = right;
                            newObj.steps = [NSString stringWithFormat:@"%@R", obj.steps];
                            pthread_mutex_lock(&_routesQueueMutexLock);
                            [_nextFrames addObject:newObj];
                            pthread_mutex_unlock(&_routesQueueMutexLock);
                            
                            
                            if ([right isEqualToString:_endFrame]) {
                                [_answers addObject:newObj];
                            }
                        }
                    }
                    
                    // down
                    //                    pthread_mutex_lock(&_move);
                    left = [obj moveDown];
                    //                    pthread_mutex_unlock(&_move);
                    if (left) {
//                        pthread_mutex_lock(&_framesLock);
//                        BOOL contain = [_frames containsObject:left];
//                        pthread_mutex_unlock(&_framesLock);
                        if ([_frames objectForKey:left] == nil) {
                            // new frame
                            pthread_mutex_lock(&_framesLock);
                            [_frames setObject:left forKey:left];
                            pthread_mutex_unlock(&_framesLock);
                            
                            ReferenceObje1 *newObj = [[ReferenceObje1 alloc] init];
                            newObj.value = left;
                            newObj.steps = [NSString stringWithFormat:@"%@D", obj.steps];
                            pthread_mutex_lock(&_routesQueueMutexLock);
                            [_nextFrames addObject:newObj];
                            pthread_mutex_unlock(&_routesQueueMutexLock);
                            
                            
                            if ([left isEqualToString:_endFrame]) {
                                [_answers addObject:newObj];
                            }
                        }
                    }
                    
                    // up
                    //                    pthread_mutex_lock(&_move);
                    left = [obj moveUp];
                    //                    pthread_mutex_unlock(&_move);
                    if (left) {
//                        pthread_mutex_lock(&_framesLock);
//                        BOOL contain = [_frames containsObject:left];
//                        pthread_mutex_unlock(&_framesLock);
                        if ([_frames objectForKey:left] == nil) {
                            // new frame
                            pthread_mutex_lock(&_framesLock);
                            [_frames setObject:left forKey:left];
                            pthread_mutex_unlock(&_framesLock);
                            
                            
                            ReferenceObje1 *newObj = [[ReferenceObje1 alloc] init];
                            newObj.value = left;
                            newObj.steps = [NSString stringWithFormat:@"%@U", obj.steps];
                            pthread_mutex_lock(&_routesQueueMutexLock);
                            [_nextFrames addObject:newObj];
                            pthread_mutex_unlock(&_routesQueueMutexLock);
                            
                            
                            if ([left isEqualToString:_endFrame]) {
                                [_answers addObject:newObj];
                            }
                        }
                    }
                    
                }
                CFAbsoluteTime t2 = CFAbsoluteTimeGetCurrent();
                
                NSLog(@"sylar :  time = %f (begin(%ld)-end(%ld))", t2-t1, beginIndex, endIndex);
                // Finished this round, put thread into sleep
                [NSThread currentThread].threadDictionary[endIndexKey] = @(-1);
                pthread_mutex_lock(&_routesIndexMutexLock);
                _threadCount -= 1;
                pthread_mutex_unlock(&_routesIndexMutexLock);
                
                
            }
            
            
            
            
            
            
            //            for (ReferenceObje1 *obj in _currentFrames) {
            //
            //                // left
            //                NSString *left = [obj moveLeft];
            //                if (left) {
            //                    if ([_frames containsObject:left] == NO) {
            //                        // new frame
            //                        [_frames addObject:left];
            //
            //                        ReferenceObje1 *newObj = [[ReferenceObje1 alloc] init];
            //                        newObj.value = left;
            //                        newObj.steps = [NSString stringWithFormat:@"%@L", obj.steps];
            //                        [_nextFrames addObject:newObj];
            //
            //                        if ([left isEqualToString:_endFrame]) {
            //                            [_answers addObject:newObj];
            //                        }
            //                    }
            //                }
            //
            //                // right
            //                NSString *right = [obj moveRight];
            //                if (right) {
            //                    if ([_frames containsObject:right] == NO) {
            //                        // new frame
            //                        [_frames addObject:right];
            //
            //                        ReferenceObje1 *newObj = [[ReferenceObje1 alloc] init];
            //                        newObj.value = right;
            //                        newObj.steps = [NSString stringWithFormat:@"%@R", obj.steps];
            //                        [_nextFrames addObject:newObj];
            //
            //                        if ([right isEqualToString:_endFrame]) {
            //                            [_answers addObject:newObj];
            //                        }
            //                    }
            //                }
            //
            //                // down
            //                left = [obj moveDown];
            //                if (left) {
            //                    if ([_frames containsObject:left] == NO) {
            //                        // new frame
            //                        [_frames addObject:left];
            //
            //                        ReferenceObje1 *newObj = [[ReferenceObje1 alloc] init];
            //                        newObj.value = left;
            //                        newObj.steps = [NSString stringWithFormat:@"%@D", obj.steps];;
            //                        [_nextFrames addObject:newObj];
            //
            //                        if ([left isEqualToString:_endFrame]) {
            //                            [_answers addObject:newObj];
            //                        }
            //                    }
            //                }
            //                
            //                // up
            //                left = [obj moveUp];
            //                if (left) {
            //                    if ([_frames containsObject:left] == NO) {
            //                        // new frame
            //                        [_frames addObject:left];
            //                        
            //                        ReferenceObje1 *newObj = [[ReferenceObje1 alloc] init];
            //                        newObj.value = left;
            //                        newObj.steps = [NSString stringWithFormat:@"%@U", obj.steps];;
            //                        [_nextFrames addObject:newObj];
            //                        
            //                        if ([left isEqualToString:_endFrame]) {
            //                            [_answers addObject:newObj];
            //                        }
            //                    }
            //                }
            //            }
            
            
        }  // auto release pool
    }
    
}

@end
