//
//  RRLineChart.h
//  Cocoa-Charts
//
//  Created by wenliang on 16/1/5.
//  Copyright © 2016年 renrencaopan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRGridChart.h"
#import "RRStickChart.h"

typedef enum {
    CCSLineAlignTypeCenter,
    CCSLineAlignTypeJustify
} CCSLineAlignType;


@interface RRLineChart : RRGridChart

/** 表示线条用的数据*/
@property(strong, nonatomic) NSArray *linesData;

/** 显示纬线数 */
@property(assign, nonatomic) CCUInt latitudeNum;

/** 显示经线数*/
@property(assign, nonatomic) CCUInt longitudeNum;

/** 选中的方柱位置*/
@property(assign, nonatomic) CCUInt selectedIndex;

/** Y轴数据最大值*/
@property(assign, nonatomic) CCFloat maxValue;

/** Y轴数据最小值*/
@property(assign, nonatomic) CCFloat minValue;

/** 线宽*/
@property(assign, nonatomic) CCFloat lineWidth;

/** Y轴显示值的快速计算子*/
@property(assign, nonatomic) CCUInt axisCalc;

@property(assign, nonatomic) CCSLineAlignType lineAlignType;

/** 总共x坐标轴占有点数*/
@property(assign, nonatomic) CCUInt xPositionNum;

/** 使用数据绘制线条,图表的rect*/
- (void)drawData:(CGRect)rect;

@end
