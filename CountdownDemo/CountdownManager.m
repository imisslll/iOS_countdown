//
//  CountdownManager.m
//  CountdownDemo
//
//  Created by 程科 on 2018/1/11.
//  Copyright © 2018年 程科. All rights reserved.
//

#import "CountdownManager.h"

@interface CountdownManager ()
{
    NSDate * _enterBackgroundTime; // app进入后台时的时间
}

@property (nonatomic, strong) NSTimer * timer; // 计时器
@property (nonatomic, strong) NSMutableArray * countdownArray; // 倒计时数组

@end

@implementation CountdownManager

static CountdownManager * s_CountdownManager = nil;
+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        s_CountdownManager = [CountdownManager new];
    });
    
    return s_CountdownManager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        // app前台进入后台通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
        // app后台进入前台通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    
    return self;
}


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
                                block:(CountdownBack)block {
    
    // 开启计时器
    if (!_timer) [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    // 去重
    for (CountdownModel * model in _countdownArray) {
        
        if (model.receiver == receiver) return;
    }
    // 添加倒计时任务
    CountdownModel * model = [CountdownModel new];
    model.block = block;
    model.allTime = time;
    model.receiver = receiver;
    model.precision = precision;
    model.leftTime = time * 1000; // 毫秒
    [self.countdownArray addObject:model];
}


#pragma mark - -- 方法

#pragma mark 暂停计时器
- (void)pauseTimer {
    
    [self.timer setFireDate:[NSDate distantFuture]];
}
#pragma mark 恢复计时器
- (void)resumeTiemr {
    
    [self.timer setFireDate:[NSDate date]];
}
#pragma mark 关闭计时器
- (void)endTimer {
    
    [_timer invalidate];
    _timer = nil;
}

#pragma mark 任务回调判断
- (void)callBackBlock:(CountdownModel *)model {
    
    // 是否停止该任务
    BOOL isStop = NO;
    // 每0.1秒进行一次回调
    if (model.precision == CountdownPrecisionSmall) {
        
        if (model.block) model.block(model.leftTime, &isStop);
    }
    // 每1秒进行一次回调
    else if (model.precision == CountdownPrecisionDefault) {
        
        // 剩余时间为整数时回调block
        if (model.leftTime % 1000 == 0) {
            
            if (model.block) model.block(model.leftTime, &isStop);
        }
    }
    // 剩余时间为0时，移除该任务
    if (model.leftTime <= 0) {
        
        [_countdownArray removeObject:model];
    }
    // *isStop为YES时，停止该任务
    if (isStop) [_countdownArray removeObject:model];
}


#pragma mark - -- 响应

#pragma mark app前台进入后台通知
- (void)enterBackgroundNotification {

    _enterBackgroundTime = [NSDate date];
    [self pauseTimer];
}
#pragma mark app后台进入前台通知
- (void)becomeActiveNotification {

    // 后台被挂起的时间间隔
    long dealy = [[NSDate date] timeIntervalSinceDate:_enterBackgroundTime];
    // 主线程回调block
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (NSInteger i = _countdownArray.count - 1; i >= 0; i --) {
            
            CountdownModel * model = _countdownArray[i];
            model.leftTime -= dealy * 1000;
            model.leftTime = model.leftTime < 0 ? 0 : model.leftTime;
            [self callBackBlock:model];
        }
    });
    [self resumeTiemr];
}

#pragma mark 计时器响应
- (void)timerAction {
    
    // 没有任务时，移除计时器
    if (_countdownArray.count == 0) {
        
        [self endTimer];
        return;
    }
    // 主线程回调block
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (NSInteger i = _countdownArray.count - 1; i >= 0; i --) {
            
            CountdownModel * model = _countdownArray[i];
            model.leftTime -= 100;
            model.leftTime = model.leftTime < 0 ? 0 : model.leftTime;
            [self callBackBlock:model];
        }
    });
}


#pragma mark - -- 懒加载

- (NSTimer *)timer {
    
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    
    return _timer;
}
- (NSMutableArray *)countdownArray {
    
    if (!_countdownArray) {
        
        _countdownArray = [NSMutableArray new];
    }
    
    return _countdownArray;
}



@end
