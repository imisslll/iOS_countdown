//
//  TestCell.m
//  CountdownDemo
//
//  Created by 程科 on 2018/1/11.
//  Copyright © 2018年 程科. All rights reserved.
//

#import "CountdownManager.h"

#import "TestCell.h"

@interface TestCell ()

@property (nonatomic, strong) UILabel * timeLab;

//
@property (nonatomic, assign) double allTime; // 总时间

@end

@implementation TestCell


- (void)setAllTime:(double)allTime {
    
    _allTime = allTime;
    self.timeLab.text = [NSString stringWithFormat:@"%.1lf", allTime];
    __weak typeof(self) weakself = self;
    [[CountdownManager shareManager] registerCountdownRequiredTime:allTime precision:arc4random() % 2 Receiver:self block:^(long leftTime, BOOL *isStop) {
        
        weakself.timeLab.text = [NSString stringWithFormat:@"%.1lf", leftTime / 1000.0];
        // 随机结束任务
        if (arc4random() % 10 == 0) *isStop = YES;
    }];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.timeLab];
        
        self.allTime = arc4random() % 10 + 5;
    }
    
    return self;
}


#pragma mark - -- 懒加载

- (UILabel *)timeLab {
    
    if (!_timeLab) {
        
        _timeLab = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _timeLab.textAlignment = NSTextAlignmentCenter;
    }
    
    return _timeLab;
}


@end
