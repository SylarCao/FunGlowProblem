//
//  MethodObject1.h
//  GlowFun
//
//  Created by sylar on 2017/1/5.
//  Copyright © 2017年 sylar. All rights reserved.
//

#import <Foundation/Foundation.h>

# define kReturnNilCondition(condition)    if (condition == nil) {return;}

@interface MethodObject1 : NSObject


/**
 instance

 @return return value description
 */
+ (instancetype)share;

/**
 calculate
 */
- (void)calculate1;



@end
