//
//  TiltledLine.h
//  Cocoa-Charts
//
//  Created by wenliang on 16/1/5.
//  Copyright © 2016年 renrencaopan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRBaseData.h"

@interface RRTitledLine : RRBaseData

/** 线条数据*/
@property(strong, nonatomic) NSArray *data;

/** 线条颜色*/
@property(strong, nonatomic) UIColor *color;

/** 线条标题*/
@property(copy, nonatomic) NSString *title;

- (id)initWithData:(NSMutableArray *)data color:(UIColor *)color title:(NSString *)title;

@end
