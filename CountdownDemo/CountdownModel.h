//
//  CountdownModel.h
//  CountdownDemo
//
//  Created by 程科 on 2018/1/11.
//  Copyright © 2018年 程科. All rights reserved.
//

#import <Foundation/Foundation.h>

// 倒计时精度
typedef enum : NSUInteger {
    CountdownPrecisionDefault = 0, // 默认1秒为基础单位
    CountdownPrecisionSmall, // 0.1秒为基础单位
} CountdownPrecision;

/**
 倒计时回调
 
 @param leftTime 剩余时间
 @param isStop 为YES时，该任务结束
 */
typedef void(^CountdownBack)(long leftTime, BOOL * isStop);

@interface CountdownModel : NSObject

@property (nonatomic, assign) CountdownPrecision precision; // 精度
@property (nonatomic, strong) id receiver; // 注册对象
@property (nonatomic, assign) NSInteger allTime; // 总时长（单位：秒）
@property (nonatomic, assign) long leftTime; // 剩余时间（单位：毫秒）
@property (nonatomic, copy) CountdownBack block; // block回调

@end
