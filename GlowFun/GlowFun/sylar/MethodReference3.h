//
//  MethodReference3.h
//  GlowFun
//
//  Created by sylar on 2017/1/5.
//  Copyright © 2017年 sylar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MethodReference3 : NSObject

/**
 instance
 
 @return return value description
 */
+ (instancetype)share;

/**
 calculate
 */
- (void)reference1;


@end



@interface ReferenceObje1 : NSObject

@property (nonatomic, strong) NSString *steps;
@property (nonatomic, strong) NSString *value;


- (NSString *)moveLeft;

- (NSString *)moveRight;

- (NSString *)moveUp;

- (NSString *)moveDown;


@end


