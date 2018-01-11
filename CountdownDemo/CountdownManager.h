//
//  CountdownManager.h
//  CountdownDemo
//
//  Created by 程科 on 2018/1/11.
//  Copyright © 2018年 程科. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CountdownModel.h"

@interface CountdownManager : NSObject

/**
 单例类初始化

 @return 返回一个单例类
 */
+ (instancetype)shareManager;


/**
 注册一个倒计时

 @param time 倒计时总时长
 @param precision 精度
 @param receiver 对象
 @param block block回调
 */
- (void)registerCountdownRequiredTime:(NSInteger)time
                            precision:(CountdownPrecision)precision
                             Receiver:(id)receiver
                                block:(CountdownBack)block;

@end
