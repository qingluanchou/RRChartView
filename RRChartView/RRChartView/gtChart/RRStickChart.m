//
//  RRStickChart.m
//  Cocoa-Charts
//
//  Created by wenliang on 16/1/5.
//  Copyright © 2016年 renrencaopan. All rights reserved.
//

#import "RRStickChart.h"
#import "RRStickChartData.h"


@implementation RRStickChart


- (void)initProperty {
    //初始化父类的熟悉
    [super initProperty];

    self.stickBorderColor = [UIColor colorWithRed:220/255.0 green:237/255.0 blue:247/255.0 alpha:1.0];
    self.stickFillColor = [UIColor colorWithRed:220/255.0 green:237/255.0 blue:247/255.0 alpha:1.0];
    //self.latitudeNum = 3;
    //self.longitudeNum = 3;
    self.virtualSticksNum = 10;
    self.maxValue = 100;
    self.minValue = 0;
    self.selectedStickIndex = 0;
    self.axisMarginLeft = 32;
    self.axisMarginTop = 3;
    self.axisCalc = 1;
    //self.orginMaxSticksNum = self.maxSticksNum;
}

#pragma mark - **************** 初始化X轴刻度的标题数组和位置
- (void)initAxisX {
    NSMutableArray *TitleX = [[NSMutableArray alloc] init];
     NSMutableArray *TitleXPosition = [[NSMutableArray alloc] init];
    if (self.stickData != NULL && [self.stickData count] > 0) {
        CCFloat average = self.maxSticksNum * 1.0 / self.longitudeNum ;
        RRStickChartData *chartdata = nil;
        if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
            //处理刻度
            for (CCUInt i = 0; i < self.longitudeNum; i++) {
              // CCUInt index = (CCUInt) floor(i * average);
                CCUInt index = (CCUInt)(i * average);
                if (index > self.maxSticksNum - 1) {
                    index = self.maxSticksNum - 1;
                }
                chartdata = [self.stickData objectAtIndex:index];
                //追加标题
                [TitleX addObject:[NSString stringWithFormat:@"%@", chartdata.date]];
                [TitleXPosition addObject:@(index)];
            }
            chartdata = [self.stickData objectAtIndex:self.maxSticksNum - 1];
        }
        else {
            //处理刻度
            for (CCUInt i = 0; i < self.longitudeNum; i++) {
                CCUInt index = [self.stickData count] - self.maxSticksNum + (CCUInt) floor(i * average);
                if (index > [self.stickData count] - 1) {
                    index = [self.stickData count] - 1;
                }
                chartdata = [self.stickData objectAtIndex:index];
                //追加标题
                [TitleX addObject:[NSString stringWithFormat:@"%@", chartdata.date]];
            }
            chartdata = [self.stickData objectAtIndex:[self.stickData count] - 1];
            //追加标题
            [TitleX addObject:[NSString stringWithFormat:@"%@", chartdata.date]];
        }

    }
    self.longitudeTitles = TitleX;
    self.longitudePositions = TitleXPosition;
}


#pragma mark - **************** 初始化Y轴刻度的标题数组和位置
- (void)initAxisY {
    //计算取值范围
    if (self.maxValue == 0. && self.minValue == 0.) {
        self.latitudeTitles = nil;
        return;
    }
    NSMutableArray *TitleY = [[NSMutableArray alloc] init];
    CCFloat average = (CCUInt) ((self.maxValue - self.minValue) / self.latitudeNum);
    //处理刻度
    for (CCUInt i = 0; i <= self.latitudeNum; i++) {
        if (self.axisCalc == 1) {
            CCUInt degree = floor(self.minValue + i * average) / self.axisCalc;
            NSString *value = [[NSNumber numberWithUnsignedInteger:degree]stringValue];
            [TitleY addObject:value];
        } else {
            NSString *value = [NSString stringWithFormat:@"%-.2f", floor(self.minValue + i * average) / self.axisCalc];
            [TitleY addObject:value];
        }
    }
    self.latitudeTitles = TitleY;
}

#pragma mark - **************** 初始化Z轴刻度的标题数组
- (void)initAxisZ {
    //计算取值范围
    if (self.maxValue1 == 0. && self.minValue1 == 0.)
    {
        self.zAxisTitles = nil;
        return;
    }
    NSMutableArray *TitleY = [[NSMutableArray alloc] init];
    CCFloat average =  (self.maxValue1 - self.minValue1) / self.zAxisNum;
    //处理刻度
    for (CCUInt i = 0; i < self.zAxisNum; i++)
    {
        NSString *value = [NSString stringWithFormat:@"%-.2f", self.minValue1 + i * average / self.axisCalc];
        [TitleY addObject:value];
    }
    //处理最大值
    NSString *value = [NSString stringWithFormat:@"%-.2f", (self.maxValue1) / self.axisCalc];
    [TitleY addObject:value];
    self.zAxisTitles = TitleY;
}




- (void)drawRect:(CGRect)rect
{
    //初始化XY轴
    [self initAxisY];
    [self initAxisX];
    [self initAxisZ];
    
    [super drawRect:rect];
    //绘制数据
    [self drawData:rect];
}

- (void)drawData:(CGRect)rect
{
    // 蜡烛棒宽度
    CCFloat stickWidth = 0.0;
    if (self.maxSticksNum < self.virtualSticksNum)
    {
        // 蜡烛棒宽度（默认）
        stickWidth = ((rect.size.width - self.axisMarginLeft - self.axisMarginRight) / self.virtualSticksNum) - 1;
    }
    else
    {
        // 蜡烛棒宽度
        stickWidth = ((rect.size.width - self.axisMarginLeft - self.axisMarginRight) / self.maxSticksNum) - 1;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, self.stickBorderColor.CGColor);
    CGContextSetFillColorWithColor(context, self.stickFillColor.CGColor);
    if (self.stickData != NULL && [self.stickData count] > 0) {

        if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
            // 蜡烛棒起始绘制位置
            CCFloat stickX = self.axisMarginLeft + 1;
            //判断显示为方柱或显示为线条
            for (CCUInt i = 0; i < [self.stickData count]; i++) {
                RRStickChartData *stick = [self.stickData objectAtIndex:i];
                CCFloat highY = ((1 - (stick.high - self.minValue) / (self.maxValue - self.minValue)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);
                CCFloat lowY = ((1 - (stick.low - self.minValue) / (self.maxValue - self.minValue)) * (rect.size.height - self.axisMarginBottom - 2 * self.axisMarginTop ) + self.axisMarginTop);

                if (stick.high == 0)
                {
                    // ------没有值的情况下不绘制
                } else {
                    // ------绘制数据，根据宽度判断绘制直线或方柱
                    if (stickWidth >= 2) {
                        CGContextAddRect(context, CGRectMake(stickX, highY, stickWidth, lowY - highY));
                        //填充路径
                        CGContextFillPath(context);
                    } else {
                        CGContextMoveToPoint(context, stickX, highY);
                        CGContextAddLineToPoint(context, stickX, lowY);
                        CGContextStrokePath(context);
                    }
                }
                // ------X位移
                stickX = stickX + 1 + stickWidth;
            }
        }
    }
}

- (NSString *)calcAxisXGraduate:(CGRect)rect
{
    return nil;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //父类的点击事件
    [super touchesBegan:touches withEvent:event];
    //计算选中的索引
    [self calcSelectedIndex];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //调用父类的触摸事件
    [super touchesMoved:touches withEvent:event];
    //计算选中的索引
    [self calcSelectedIndex];
    NSArray *allTouches = [touches allObjects];
    //处理点击事件
    if ([allTouches count] == 1) {

        CGPoint pt = CGPointMake(self.singleTouchPoint.x, self.coChart.singleTouchPoint.y);
        //获取选中点
        self.coChart.singleTouchPoint = pt;
        [self.coChart performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0];

    } else if ([allTouches count] == 2) {

    } else {

    }

}

- (void)calcSelectedIndex
{
    //X在系统范围内、进行计算
    if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
        if (self.singleTouchPoint.x > self.axisMarginLeft
                && self.singleTouchPoint.x < self.frame.size.width) {
            CCFloat stickWidth = 0.0;
            if (self.maxSticksNum < self.virtualSticksNum)
            {
                // 蜡烛棒宽度
                stickWidth = ((self.frame.size.width - self.axisMarginLeft - self.axisMarginRight) / self.virtualSticksNum);
            }
            else
            {
                // 蜡烛棒宽度
                stickWidth = ((self.frame.size.width - self.axisMarginLeft - self.axisMarginRight) / self.maxSticksNum);
            }
            CCFloat valueWidth = self.singleTouchPoint.x - self.axisMarginLeft;
            if (valueWidth > 0){
                CCUInt index = (CCUInt) (valueWidth / stickWidth);
                //如果超过则设置位最大
                if (index >= self.maxSticksNum) {
                    index = self.maxSticksNum - 1;
                }
                //设置选中的index
                self.selectedStickIndex = index;
            }
        }
    } else {
        if (self.singleTouchPoint.x > self.axisMarginLeft
                && self.singleTouchPoint.x < self.frame.size.width - self.axisMarginRight) {
            CCFloat stickWidth = 1.0 * ((self.frame.size.width - self.axisMarginLeft - self.axisMarginRight) / self.maxSticksNum);
            CCFloat valueWidth = self.singleTouchPoint.x - self.axisMarginLeft;
            if (valueWidth > 0) {
                CCUInt index = (CCUInt) ([self.stickData count] - self.maxSticksNum + (valueWidth / stickWidth));
                //如果超过则设置位最大
                if (index >= [self.stickData count]) {
                    index = [self.stickData count] - 1;
                }
                //设置选中的index
                self.selectedStickIndex = index;
            }
        }
    }

}

- (void)setSelectedPointAddReDraw:(CGPoint)point
{
    point.y = 1;
    self.singleTouchPoint = point;
    [self calcSelectedIndex];

    [self setNeedsDisplay];
}


- (void) setSingleTouchPoint:(CGPoint) point
{
    _singleTouchPoint = point;
    
    [self calcSelectedIndex];
    
    if (self.chartDelegate && [self.chartDelegate respondsToSelector:@selector(CCSChartBeTouchedOn:indexAt:)]) {
        [self.chartDelegate CCSChartBeTouchedOn:point indexAt:self.selectedStickIndex];
    }
}

- (void)calcDataValueRange
{
    
}

- (void)calcValueRangePaddingZero
{
    
}


- (void)calcValueRange
{
    
}

@end
