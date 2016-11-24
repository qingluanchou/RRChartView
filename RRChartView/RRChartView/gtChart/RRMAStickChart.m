//
//  RRMAStickChart.m
//  Cocoa-Charts
//
//  Created by wenliang on 16/1/5.
//  Copyright © 2016年 renrencaopan. All rights reserved.
//

#import "RRMAStickChart.h"
#import "RRTitledLine.h"
#import "RRLineData.h"
#import "UIColor+RRChart.h"

@implementation RRMAStickChart

@synthesize linesData = _linesData;

- (void)initProperty {

    [super initProperty];
    //初始化颜色
    self.linesData = nil;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (void)drawData:(CGRect)rect {
    //调用父类的绘制方法
    [super drawData:rect];

    //绘制折线图
    [self drawLinesData:rect];
    
    //绘制移动纵线
    [self drawCrossLines:rect];
    
    //绘制小圆球
    [self drawDotPath:rect];
}

- (void)drawDotPath:(CGRect)rect
{
    CCFloat lineLength;
     if (self.linesData != NULL)
     {
         for (CCUInt i = 0; i < [self.linesData count]; i++)
         {
             RRTitledLine *line = [self.linesData objectAtIndex:i];
             if (i == 0)
             {
                 [[UIColor caoPanRateColor] setFill];
             }
             else
             {
                [[UIColor hs300RateColor] setFill];
             }
             
             if (line != NULL){
             NSArray *lineDatas = line.data;
             //需要取到第二个值，连成折线
             if ([line.data count] > 1)
             {
                 // 点线距离
                 if (self.maxSticksNum < self.virtualSticksNum)
                 {
                     // 蜡烛棒宽度
                     lineLength = ((rect.size.width - self.axisMarginLeft - self.axisMarginRight) * 1.0 / self.virtualSticksNum);
                 }
                 else
                 {
                     // 蜡烛棒宽度
                     lineLength = ((rect.size.width - self.axisMarginLeft - self.axisMarginRight) * 1.0 / self.maxSticksNum);
                 }
                     int z = (self.singleTouchPoint.x - self.axisMarginLeft-lineLength / 2) / lineLength ;
                     if ((self.singleTouchPoint.x - self.axisMarginLeft-lineLength / 2) < 0) return;
                     if (z < 0 || (z > [line.data count] - 2)) return;
                     RRLineData *lineData1 = [lineDatas objectAtIndex:z];
                     RRLineData *lineData2 = [lineDatas objectAtIndex:z+1];
                     CCFloat valueY1 = ((1 - (lineData1.value - self.minValue1)*1.0 / (self.maxValue1 - self.minValue1)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);
                     CCFloat valueY2 = ((1 - (lineData2.value - self.minValue1)*1.0 / (self.maxValue1 - self.minValue1)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);
                     CGFloat valueY = valueY1 + (valueY2 - valueY1) * (self.singleTouchPoint.x - z * lineLength - self.axisMarginLeft-lineLength /2)*1.0 / lineLength;
                     UIBezierPath *dotPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.singleTouchPoint.x - 4, valueY-4, 8, 8)];
                     [dotPath fill];
                 }
         }
       }
    }

}

- (void)drawLinesData:(CGRect)rect
{
    //起始点
    CCFloat lineLength;
    // 起始位置
    CCFloat startX;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);

    if (self.linesData != NULL) {
        //逐条输出MA线
        for (CCUInt i = 0; i < [self.linesData count]; i++) {
            RRTitledLine *line = [self.linesData objectAtIndex:i];
            if (line != NULL) {
                //设置线条颜色
                CGContextSetStrokeColorWithColor(context, line.color.CGColor);
                //获取线条数据
                NSArray *lineDatas = line.data;
                if ([line.data count] > 0)
                {
                    //判断Y轴的位置设置从左往右还是从右往左绘制
                    if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
                        // 点线距离
                        if (self.maxSticksNum < self.virtualSticksNum)
                        {
                            // 蜡烛棒宽度
                            lineLength = ((rect.size.width - self.axisMarginLeft - self.axisMarginRight) * 1.0 / self.virtualSticksNum) - 1;
                        }
                        else
                        {
                            // 蜡烛棒宽度
                            lineLength = ((rect.size.width - self.axisMarginLeft - self.axisMarginRight) * 1.0 / self.maxSticksNum) - 1;
                        }

                        //起始点
                        startX = super.axisMarginLeft + lineLength / 2;
                        //遍历并绘制线条
                        for (CCUInt j = 0; j < [lineDatas count]; j++) {
                            RRLineData *lineData = [lineDatas objectAtIndex:j];
                            //获取终点Y坐标
                            CCFloat valueY = ((1 - (lineData.value - self.minValue1) / (self.maxValue1 - self.minValue1)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);
                            //绘制线条路径
                            if (j == 0) {
                                CGContextMoveToPoint(context, startX, valueY);
                            }
                            else {
                                if (((RRLineData *) [lineDatas objectAtIndex:j - 1]).value != 0) {
                                    CGContextAddLineToPoint(context, startX, valueY);
                                } else {
                                    CGContextMoveToPoint(context, startX - lineLength / 2, valueY);
                                    CGContextAddLineToPoint(context, startX, valueY);
                                }
                            }
                            //X位移
                            startX = startX + 1 + lineLength;
                        }
                        
                    }
                }

                //绘制路径
                CGContextStrokePath(context);
            }
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //父类的点击事件
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //调用父类的触摸事件
    [super touchesMoved:touches withEvent:event];
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

- (void)drawCrossLines:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, self.crossLinesColor.CGColor);
    CGContextSetFillColorWithColor(context, self.crossLinesColor.CGColor);
    if (self.axisXPosition == CCSGridChartXAxisPositionBottom) {
        if (self.singleTouchPoint.y <= 0) {
            self.singleTouchPoint = CGPointMake(self.singleTouchPoint.x, 1);
        }
        if (self.singleTouchPoint.y >= rect.size.height - self.axisMarginBottom) {
            self.singleTouchPoint = CGPointMake(self.singleTouchPoint.x, rect.size.height - self.axisMarginBottom - 1);
        }
    } else {
        if (self.singleTouchPoint.y <= self.axisMarginTop) {
            self.singleTouchPoint = CGPointMake(self.singleTouchPoint.x, self.axisMarginTop + 1);
        }
        if (self.singleTouchPoint.y >= rect.size.height) {
            self.singleTouchPoint = CGPointMake(self.singleTouchPoint.x, rect.size.height - 1);
        }
    }
    
    if (self.singleTouchPoint.x <= 0) {
        self.singleTouchPoint = CGPointMake(1, self.singleTouchPoint.y);
    }
    if (self.singleTouchPoint.x >= rect.size.width - self.axisMarginRight) {
        self.singleTouchPoint = CGPointMake(rect.size.width - self.axisMarginRight - 1, self.singleTouchPoint.y);
    }
    
    if (self.axisXPosition == CCSGridChartXAxisPositionBottom && self.axisYPosition == CCSGridChartYAxisPositionLeft) {
        //界定点击有效范围
        if (self.singleTouchPoint.x >= self.axisMarginLeft
            && self.singleTouchPoint.y > 0
            && self.singleTouchPoint.x < rect.size.width
            && self.singleTouchPoint.y < rect.size.height - self.axisMarginBottom) {
            //绘制横线
            if (self.displayCrossXOnTouch) {
                //还原半透明
                CGContextSetAlpha(context, 1);
                
                CGContextMoveToPoint(context, self.singleTouchPoint.x, 0);
                CGContextAddLineToPoint(context, self.singleTouchPoint.x, rect.size.height - self.axisMarginBottom);
                CGContextStrokePath(context);
            }
            //绘制纵线与刻度
            if (self.displayCrossYOnTouch) {
                CGContextSetAlpha(context, 1);
                
                CGContextMoveToPoint(context, self.axisMarginLeft, self.singleTouchPoint.y);
                CGContextAddLineToPoint(context, rect.size.width, self.singleTouchPoint.y);
                CGContextStrokePath(context);
                
            }
        }
    } else if (self.axisXPosition == CCSGridChartXAxisPositionBottom && self.axisYPosition == CCSGridChartYAxisPositionRight) {
        //界定点击有效范围
        if (self.singleTouchPoint.x >= self.axisMarginLeft
            && self.singleTouchPoint.y > 0
            && self.singleTouchPoint.x < rect.size.width - self.axisMarginRight
            && self.singleTouchPoint.y < rect.size.height - self.axisMarginBottom) {
            //绘制横线
            if (self.displayCrossXOnTouch) {
                //还原半透明
                CGContextSetAlpha(context, 1);
                
                CGContextMoveToPoint(context, self.singleTouchPoint.x, 0);
                CGContextAddLineToPoint(context, self.singleTouchPoint.x, rect.size.height - self.axisMarginBottom);
                
                CGContextStrokePath(context);
            }
            
            //绘制纵线与刻度
            if (self.displayCrossYOnTouch) {
                
                CGContextSetAlpha(context, 1);
                CGContextMoveToPoint(context, 0, self.singleTouchPoint.y);
                CGContextAddLineToPoint(context, rect.size.width - self.axisMarginRight, self.singleTouchPoint.y);
                CGContextStrokePath(context);
            }
        }
        
    } else if (self.axisXPosition == CCSGridChartXAxisPositionTop && self.axisYPosition == CCSGridChartYAxisPositionLeft) {
        //界定点击有效范围
        if (self.singleTouchPoint.x >= self.axisMarginLeft
            && self.singleTouchPoint.y > self.axisMarginTop
            && self.singleTouchPoint.x < rect.size.width
            && self.singleTouchPoint.y < rect.size.height) {
            //绘制横线
            if (self.displayCrossXOnTouch) {
                
                //还原半透明
                CGContextSetAlpha(context, 1);
                
                CGContextMoveToPoint(context, self.singleTouchPoint.x, self.axisMarginTop);
                CGContextAddLineToPoint(context, self.singleTouchPoint.x, rect.size.height);
                CGContextStrokePath(context);
            }
            //绘制纵线与刻度
            if (self.displayCrossYOnTouch) {
                CGContextSetAlpha(context, 1);
                CGContextMoveToPoint(context, self.axisMarginLeft, self.singleTouchPoint.y);
                CGContextAddLineToPoint(context, rect.size.width, self.singleTouchPoint.y);
                CGContextStrokePath(context);
            }
        }
        
    } else if (self.axisXPosition == CCSGridChartXAxisPositionTop && self.axisYPosition == CCSGridChartYAxisPositionRight) {
        //界定点击有效范围
        if (self.singleTouchPoint.x >= self.axisMarginLeft
            && self.singleTouchPoint.y > self.axisMarginTop
            && self.singleTouchPoint.x < rect.size.width - self.axisMarginRight
            && self.singleTouchPoint.y < rect.size.height) {
            
            
            //绘制横线
            if (self.displayCrossXOnTouch) {
                //还原半透明
                CGContextSetAlpha(context, 1);
                CGContextMoveToPoint(context, self.singleTouchPoint.x, self.axisMarginTop);
                CGContextAddLineToPoint(context, self.singleTouchPoint.x, rect.size.height);
                CGContextStrokePath(context);
            }
            //绘制纵线与刻度
            if (self.displayCrossYOnTouch) {
                //还原半透明
                CGContextSetAlpha(context, 1);
                
                CGContextMoveToPoint(context, 0, self.singleTouchPoint.y);
                CGContextAddLineToPoint(context, rect.size.width - self.axisMarginRight, self.singleTouchPoint.y);
                CGContextStrokePath(context);
            }
        }
    }
}



@end
