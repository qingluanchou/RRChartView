//
//  UIColor+RRChart.h
//  RRCP
//
//  Created by wenliang on 15/12/10.
//  Copyright © 2016年 renrencaopan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RRChart)

/**
 *  横轴坐标颜色
 */
+(UIColor *)colorLongitude;

/**
 *  X坐标轴颜色
 */
+(UIColor *)colorXaxis;

/**
 *  纬线标题颜色
 */
+(UIColor *)latitudeFontColor;

/**
 *  Z轴刻度颜色
 */
+(UIColor *)zAxisFontColor;

/**
 *  操盘人曲线颜色
 */
+(UIColor *)caoPanRateColor;

/**
 *  hs300曲线颜色
 */
+(UIColor *)hs300RateColor;

@end
