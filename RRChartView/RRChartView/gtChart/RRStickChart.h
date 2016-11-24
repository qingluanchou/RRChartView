//
//  RRStickChart.h
//  Cocoa-Charts
//
//  Created by wenliang on 16/1/5.
//  Copyright © 2016年 renrencaopan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRGridChart.h"

/**
 RRStickChart是在RRGridChart上绘制柱状数据的图表、如果需要支持显示均线，请参照
 RRMAStickChart。
 */
@interface RRStickChart : RRGridChart

 /** 表示柱条用的数据*/
@property(strong, nonatomic) NSArray *stickData;

 /** 表示柱条的边框颜色*/
@property(strong, nonatomic) UIColor *stickBorderColor;

 /** 表示柱条的填充颜色*/
@property(strong, nonatomic) UIColor *stickFillColor;

 /** 网格纬线的数量*/
@property(assign, nonatomic) CCUInt latitudeNum;

/** z轴刻度数量*/
@property(assign, nonatomic) CCUInt zAxisNum;

 /** 网格经线的数量*/
@property(assign, nonatomic) CCUInt longitudeNum;

 /** 表示柱条的最大数量*/
@property(assign, nonatomic) CCUInt maxSticksNum;

 /** 被选中的柱条*/
@property(assign, nonatomic) CCUInt selectedStickIndex;

 /** Y轴显示最大值*/
@property(assign, nonatomic) CCFloat maxValue;

 /** Y轴显示最小值*/
@property(assign, nonatomic) CCFloat minValue;

@property(assign, nonatomic) CCFloat maxValue1;

 /** Y轴显示最小值*/
@property(assign, nonatomic) CCFloat minValue1;

 /** Y轴显示值的快速计算子（表示刻度＝ 计算刻度/axisCalc）*/
@property(assign, nonatomic) CCUInt axisCalc;

 /** 两个相同类型图表之间传值用对象*/
@property(assign, nonatomic) RRStickChart *coChart;

/**
 *  使用数据绘制柱条图表
 */
- (void)drawData:(CGRect)rect;

/**
 *  初始化Y轴的刻度
 */
- (void)initAxisY;

/**
 *  初始化X轴的刻度
 */
- (void)initAxisX;

/**
 *  计算选中的列索引
 */
- (void)calcSelectedIndex;

/**
 *  设置选中的点并重新绘制图表
 */
- (void)setSelectedPointAddReDraw:(CGPoint)point;

/**
 *  计算真实数据范围
 */
- (void)calcDataValueRange;

/**
 *  估算真实数据范围，设置最大值，最小值
 */
- (void)calcValueRangePaddingZero;

- (void)calcValueRange;

@end
