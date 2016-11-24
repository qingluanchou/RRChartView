//
//  RRMAStickChart.h
//  Cocoa-Charts
//
//  Created by wenliang on 16/1/5.
//  Copyright © 2016年 renrencaopan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRStickChart.h"

/**
 RRMAStickChart继承于RRStickChart的，可以在RRStickChart基础上
 显示移动平均等各种分析指标数据。
 */
@interface RRMAStickChart : RRStickChart {
    NSArray *_linesData;
}

 /** 表示线条用的数据*/
@property(strong, nonatomic) NSArray *linesData;

/**
 *  使用数据绘制线条
 */
- (void)drawLinesData:(CGRect)rect;

@end
