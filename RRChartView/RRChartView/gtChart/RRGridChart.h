//
//  RRGridChart.h
//  Cocoa-Charts
//
//  Created by wenliang on 16/1/5.
//  Copyright © 2016年 renrencaopan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRBaseChartView.h"

@protocol CCSChartDelegate <NSObject>
@optional
- (void)CCSChartBeTouchedOn:(CGPoint)point indexAt:(CCUInt) index;
- (void)CCSChartDisplayChangedFrom:(CCUInt)from number:(CCUInt) number;
@end

/**
 Y轴在画面中的表示位置
 */
typedef enum {
    CCSGridChartYAxisPositionLeft,               //Axis Y left
    CCSGridChartYAxisPositionRight,              //Axis Y right
} CCSGridChartYAxisPosition;

/**
 X轴在画面中的表示位置
 */
typedef enum {
    CCSGridChartXAxisPositionTop,                //Axis X top
    CCSGridChartXAxisPositionBottom              //Axis X bottom
} CCSGridChartXAxisPosition;


@interface RRGridChart : RRBaseChartView {
    CGPoint _singleTouchPoint;
}

 /** Y轴标题数组*/
@property(strong, nonatomic) NSMutableArray *latitudeTitles;

 /** Z轴标题数组*/
@property(strong, nonatomic) NSMutableArray *zAxisTitles;

 /** X轴标题数组*/
@property(strong, nonatomic) NSMutableArray *longitudeTitles;

/** X轴刻度坐标位置数组*/
@property(strong, nonatomic) NSMutableArray *longitudePositions;

 /** 蜡烛棒的个数*/
@property(assign, nonatomic) CCUInt orginMaxSticksNum;

/** 默认蜡烛棒的个数*/
@property(assign, nonatomic) CCUInt virtualSticksNum;

 /** 坐标轴X的显示颜色*/
@property(strong, nonatomic) UIColor *axisXColor;

 /** 坐标轴Y的显示颜色*/
@property(strong, nonatomic) UIColor *axisYColor;

 /** 网格经线的显示颜色*/
@property(strong, nonatomic) UIColor *longitudeColor;

 /** 网格纬线的显示颜色*/
@property(strong, nonatomic) UIColor *latitudeColor;

 /** 图边框的颜色*/
@property(strong, nonatomic) UIColor *borderColor;

 /** 经线刻度字体颜色*/
@property(strong, nonatomic) UIColor *longitudeFontColor;

 /** 纬线刻度字体颜色*/
@property(strong, nonatomic) UIColor *latitudeFontColor;

/** Z轴刻度颜色*/
@property(strong, nonatomic) UIColor *zAxisFontColor;

 /** 十字交叉线颜色*/
@property(strong, nonatomic) UIColor *crossLinesColor;

 /** 十字交叉线坐标轴字体颜色*/
@property(strong, nonatomic) UIColor *crossLinesFontColor;

 /** 经线刻度字体大小*/
@property(strong, nonatomic) UIFont *longitudeFont;

 /** 经线刻度字体大小*/
@property(strong, nonatomic) UIFont *latitudeFont;

/** Z轴刻度字体大小*/
@property(strong, nonatomic) UIFont *zAxisFont;

 /** 轴线左边距*/
@property(assign, nonatomic) CCFloat axisMarginLeft;

 /** 轴线下边距*/
@property(assign, nonatomic) CCFloat axisMarginBottom;

 /** 轴线上边距*/
@property(assign, nonatomic) CCFloat axisMarginTop;

 /** 轴线右边距*/
@property(assign, nonatomic) CCFloat axisMarginRight;

 /** 经线刻度字体大小*/
@property(assign, nonatomic) CCUInt longitudeFontSize;

 /** 纬线刻度字体大小*/
@property(assign, nonatomic) CCUInt latitudeFontSize;

 /** X轴显示位置*/
@property(assign, nonatomic) CCSGridChartXAxisPosition axisXPosition;

 /** Y轴显示位置*/
@property(assign, nonatomic) CCSGridChartYAxisPosition axisYPosition;

 /** Y轴上的标题是否显示*/
@property(assign, nonatomic) BOOL displayLatitudeTitle;

/** Z轴上的标题是否显示*/
@property(assign, nonatomic) BOOL displayZAxisTitle;

 /** X轴上的标题是否显示*/
@property(assign, nonatomic) BOOL displayLongitudeTitle;

 /** 经线是否显示*/
@property(assign, nonatomic) BOOL displayLongitude;

/** Z轴是否展示*/
@property(assign, nonatomic) BOOL displayZAxis;

 /** 经线是否显示为虚线*/
@property(assign, nonatomic) BOOL dashLongitude;

 /** 纬线是否显示*/
@property(assign, nonatomic) BOOL displayLatitude;

 /** 纬线是否显示为虚线*/
@property(assign, nonatomic) BOOL dashLatitude;

 /** 控件是否显示边框*/
@property(assign, nonatomic) BOOL displayBorder;

/** 是否纬线自定义*/
@property(assign, nonatomic)BOOL axisX0repeatLatitude;

 /** 在控件被点击时，显示十字竖线线*/
@property(assign, nonatomic) BOOL displayCrossXOnTouch;

 /** 在控件被点击时，显示十字横线线*/
@property(assign, nonatomic) BOOL displayCrossYOnTouch;

 /** 单点触控的选中点*/
@property(assign, nonatomic ) CGPoint singleTouchPoint;

 /** 单点触控的选中点代理*/
@property(assign, nonatomic) UIViewController<CCSChartDelegate> *chartDelegate;

/**
 *  绘制边框
 */
- (void)drawBorder:(CGRect)rect;

/**
 *  绘制X轴
 */
- (void)drawXAxis:(CGRect)rect;

/**
 *  绘制Y轴
 */
- (void)drawYAxis:(CGRect)rect;

/**
 *  绘制纬线
 */
- (void)drawLatitudeLines:(CGRect)rect;

/**
 *  绘制经线
 */
- (void)drawLongitudeLines:(CGRect)rect;

/**
 *  绘制X轴上的刻度
 */
- (void)drawXAxisTitles:(CGRect)rect;

/**
 *  绘制Y轴上的刻度
 */
- (void)drawYAxisTitles:(CGRect)rect;

/**
 *  绘制十字交叉线
 */
- (void)drawCrossLines:(CGRect)rect;

/**
 *  计算经度的表示刻度
 */
- (NSString *)calcAxisXGraduate:(CGRect)rect;

/**
 *  计算纬度的表示刻度
 */
- (NSString *)calcAxisYGraduate:(CGRect)rect;

/**
 *  经度计算结果
 */
- (CCFloat )touchPointAxisXValue:(CGRect)rect;

/**
 *  纬度计算结果
 */
- (CCFloat )touchPointAxisYValue:(CGRect)rect;

/**
 *  缩小
 */
- (void)zoomOut;


/**
 *  放大表示
 */
- (void)zoomIn;
@end
