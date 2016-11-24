//
//  RRGridChart.m
//  Cocoa-Charts
//
//  Created by wenliang on 16/1/5.
//  Copyright © 2016年 renrencaopan. All rights reserved.
//

#import "RRGridChart.h"
#import "UIColor+RRChart.h"

@implementation RRGridChart

@synthesize singleTouchPoint = _singleTouchPoint;

- (void)initProperty {
    //初始化父类的熟悉
    [super initProperty];

    //初始化相关属性
    self.axisXColor = [UIColor lightGrayColor];
    self.axisYColor = [UIColor lightGrayColor];
    self.borderColor = [UIColor lightGrayColor];
    self.longitudeColor = [UIColor lightGrayColor];
    self.latitudeColor = [UIColor lightGrayColor];
    self.longitudeFontColor = [UIColor lightGrayColor];
    self.latitudeFontColor = [UIColor latitudeFontColor];
    self.crossLinesColor = [UIColor lightGrayColor];
    self.crossLinesFontColor = [UIColor whiteColor];
    self.longitudeFontSize = 11;
    self.latitudeFontSize = 9;
    self.zAxisFont = [UIFont systemFontOfSize:9];
    self.zAxisFontColor = [UIColor zAxisFontColor];
    self.longitudeFont = [UIFont systemFontOfSize:self.longitudeFontSize];
    self.latitudeFont = [UIFont systemFontOfSize:self.latitudeFontSize];
    self.axisMarginLeft = 30;
    self.axisMarginBottom = 16;
    self.axisMarginTop = 3;
    self.axisMarginRight = 30;
    self.axisXPosition = CCSGridChartXAxisPositionBottom;
    self.axisYPosition = CCSGridChartYAxisPositionLeft;
    self.displayLatitudeTitle = YES;
    self.displayLongitudeTitle = YES;
    self.displayZAxisTitle = YES;
    self.displayZAxis = YES;
    self.displayLongitude = YES;
    self.displayLatitude = YES;
    self.dashLongitude = YES;
    self.dashLatitude = YES;
    self.displayBorder = YES;
    self.displayCrossXOnTouch = YES;
    self.displayCrossYOnTouch = YES;
    self.axisX0repeatLatitude = NO;

    //初期化X轴
    self.latitudeTitles = nil;
    //初期化X轴
    self.longitudeTitles = nil;
    self.longitudePositions = nil;
    //设置可以多点触控
    self.multipleTouchEnabled = YES;
    self.userInteractionEnabled = YES;

    [self registerObservers];
}

- (void)registerObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsDisplay) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)drawRect:(CGRect)rect {
    //清理当前画面，设置背景色
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    //消除锯齿
    CGContextSetAllowsAntialiasing(context, YES);

    //绘制边框
    //[self drawBorder:rect];

    if (!self.axisX0repeatLatitude)
    {
        //绘制XYZ轴
        [self drawXAxis:rect];
        
        [self drawYAxis:rect];
        
        [self drawZAxis:rect];
    }
    //绘制纬线
    [self drawLatitudeLines:rect];
    
    //绘制经线
    //[self drawLongitudeLines:rect];
    //绘制X轴标题
    [self drawXAxisTitles:rect];
    [self drawZAxisTitles:rect];
    [self drawYAxisTitles:rect];
    
    //绘制交叉线
    [self drawCrossLines:rect];
}

#pragma mark - **************** 绘制边框
- (void)drawBorder:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0f);

    CGContextMoveToPoint(context, 0.0f, 0.0f);
    CGContextAddRect(context, rect);

    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextStrokePath(context);
}

#pragma mark - **************** 绘制X轴
- (void)drawXAxis:(CGRect)rect {
    if (self.axisXPosition == CCSGridChartXAxisPositionBottom) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.0f);

        CGContextMoveToPoint(context, self.axisMarginLeft, rect.size.height - self.axisMarginBottom);
        CGContextAddLineToPoint(context, rect.size.width - self.axisMarginRight, rect.size.height - self.axisMarginBottom);

        CGContextSetStrokeColorWithColor(context, self.axisXColor.CGColor);
        CGContextStrokePath(context);
    } else
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.0f);

        CGContextMoveToPoint(context, 0.0f, self.axisMarginTop);
        CGContextAddLineToPoint(context, rect.size.width, self.axisMarginTop);

        CGContextSetStrokeColorWithColor(context, self.axisXColor.CGColor);
        CGContextStrokePath(context);
    }
}

#pragma mark - **************** 绘制Y轴
- (void)drawYAxis:(CGRect)rect {
    if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.0f);

        CGContextMoveToPoint(context, self.axisMarginLeft, 0.0f);
        CGContextAddLineToPoint(context, self.axisMarginLeft, rect.size.height - self.axisMarginBottom);
        CGContextSetStrokeColorWithColor(context, self.axisYColor.CGColor);
        CGContextStrokePath(context);
    }
    else {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.0f);

        if (self.axisXPosition == CCSGridChartXAxisPositionBottom) {
            CGContextMoveToPoint(context, rect.size.width - self.axisMarginRight, 0.0f);
            CGContextAddLineToPoint(context, rect.size.width - self.axisMarginRight, rect.size.height - self.axisMarginBottom);
        } else {
            CGContextMoveToPoint(context, rect.size.width - self.axisMarginRight, self.axisMarginTop);
            CGContextAddLineToPoint(context, rect.size.width - self.axisMarginRight, rect.size.height);
        }

        CGContextSetStrokeColorWithColor(context, self.axisYColor.CGColor);
        CGContextStrokePath(context);
    }
}

#pragma mark - **************** 绘制Z轴
- (void)drawZAxis:(CGRect)rect
{
    if (self.displayZAxis == NO) {
        return ;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context, rect.size.width - self.axisMarginRight, 0.0f);
    CGContextAddLineToPoint(context, rect.size.width - self.axisMarginRight, rect.size.height - self.axisMarginBottom);
    CGContextSetStrokeColorWithColor(context, self.axisYColor.CGColor);
    CGContextStrokePath(context);
    
}

#pragma mark - **************** 绘制纬线
- (void)drawLatitudeLines:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, self.latitudeColor.CGColor);
    CGContextSetFillColorWithColor(context, self.latitudeFontColor.CGColor);
    
    if (self.displayLatitude == NO) {
        return;
    }
    
    if ([self.latitudeTitles count] <= 0){
        return ;
    }
    //设置线条为点线
    if (self.dashLatitude) {
        CGFloat lengths[] = {3.0, 3.0};
        CGContextSetLineDash(context, 0.0, lengths, 2);
    }
    
    CCFloat postOffset;
    if (self.axisXPosition == CCSGridChartXAxisPositionBottom) {
        postOffset = (rect.size.height - self.axisMarginBottom - 2 * self.axisMarginTop) * 1.0 / ([self.latitudeTitles count] - 1);
    }
    else {
        postOffset = (rect.size.height - 2 * self.axisMarginBottom - self.axisMarginTop) * 1.0 / ([self.latitudeTitles count] - 1);
    }
    
    CCFloat offset = rect.size.height - self.axisMarginBottom - self.axisMarginTop;
    
    for (CCUInt i = 0; i <= [self.latitudeTitles count]; i++) {
        if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
            CGContextMoveToPoint(context, self.axisMarginLeft, offset - i * postOffset);
            CGContextAddLineToPoint(context, rect.size.width - self.axisMarginRight, offset - i * postOffset);
            
        } else {
            CGContextMoveToPoint(context, 0, offset - i * postOffset);
            CGContextAddLineToPoint(context, rect.size.width - self.axisMarginRight, offset - i * postOffset);
        }
    }
    CGContextStrokePath(context);
    //还原线条
    CGContextSetLineDash(context, 0, nil, 0);
}

#pragma mark - **************** 绘制经线
- (void)drawLongitudeLines:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, self.longitudeColor.CGColor);
    CGContextSetFillColorWithColor(context, self.longitudeFontColor.CGColor);
    
    if (self.displayLongitude == NO) {
        return;
    }
    
    if ([self.longitudeTitles count] <= 0) {
        return;
    }
    //设置线条为点线
    if (self.dashLongitude) {
        CGFloat lengths[] = {3.0, 3.0};
        CGContextSetLineDash(context, 0.0, lengths, 2);
    }
    CCFloat postOffset;
    CCFloat offset;
    
    if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
        postOffset = (rect.size.width - self.axisMarginLeft - 2 * self.axisMarginRight) / ([self.longitudeTitles count] - 1);
        offset = self.axisMarginLeft + self.axisMarginRight;
    }
    else {
        postOffset = (rect.size.width - 2 * self.axisMarginLeft - self.axisMarginRight) / ([self.longitudeTitles count] - 1);
        offset = self.axisMarginLeft;
    }
    
    for (CCUInt i = 0; i <= [self.longitudeTitles count]; i++) {
        if (self.axisXPosition == CCSGridChartXAxisPositionBottom) {
            CGContextMoveToPoint(context, offset + i * postOffset, 0);
            CGContextAddLineToPoint(context, offset + i * postOffset, rect.size.height - self.axisMarginBottom);
        } else {
            CGContextMoveToPoint(context, offset + i * postOffset, self.axisMarginTop);
            CGContextAddLineToPoint(context, offset + i * postOffset, rect.size.height);
        }
    }
    
    CGContextStrokePath(context);
    CGContextSetLineDash(context, 0, nil, 0);
}



#pragma mark - **************** 绘制Y轴坐标标题
- (void)drawYAxisTitles:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, self.latitudeColor.CGColor);
    CGContextSetFillColorWithColor(context, self.latitudeFontColor.CGColor);
    
    if (self.displayLatitude == NO) {
        return;
    }
    
    if (self.displayLatitudeTitle == NO) {
        return;
    }
    
    if ([self.latitudeTitles count] <= 0) {
        return;
    }
    
    CCFloat postOffset;
    if (self.axisXPosition == CCSGridChartXAxisPositionBottom) {
        postOffset = (rect.size.height - self.axisMarginBottom - 2 * self.axisMarginTop) * 1.0 / ([self.latitudeTitles count] - 1);
    } else {
        postOffset = (rect.size.height - 2 * self.axisMarginBottom - self.axisMarginTop) * 1.0 / ([self.latitudeTitles count] - 1);
    }
    
    CCFloat offset = rect.size.height - self.axisMarginBottom - self.axisMarginTop;
    for (CCUInt i = 0; i <= [self.latitudeTitles count]; i++) {
        // 绘制线条
        if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
            NSMutableParagraphStyle *textStyle=[[NSMutableParagraphStyle alloc]init];//段落样式
            textStyle.alignment=NSTextAlignmentRight;
            textStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:self.latitudeFontSize],NSForegroundColorAttributeName:self.latitudeFontColor,NSParagraphStyleAttributeName:textStyle};
            CCFloat titileOffset = 2;
            if (i < [self.latitudeTitles count]) {
                NSString *str = (NSString *) [self.latitudeTitles objectAtIndex:i];
                str = [NSString stringWithFormat:@"%@%%",str];
                CGRect strRect = [self rectOfNSString:str attribute:attribute];
                CGRect textRect = CGRectZero;
                if (i == 0) {
                    textRect= CGRectMake(self.axisMarginLeft - strRect.size.width-titileOffset, offset - i * postOffset - strRect.size.height, strRect.size.width, strRect.size.height);
                } else if (i == [self.latitudeTitles count] - 1) {
                    textRect= CGRectMake(self.axisMarginLeft - strRect.size.width-titileOffset, offset - i * postOffset, strRect.size.width, strRect.size.height);
                } else {
                    textRect= CGRectMake(self.axisMarginLeft - strRect.size.width-titileOffset, offset - i * postOffset - strRect.size.height/ 2.0, strRect.size.width, strRect.size.height);
                }
                //绘制字体
                [str drawInRect:textRect withAttributes:attribute];
                
            }
            
        }
    }
}

#pragma mark - **************** 绘制Z轴坐标标题
- (void)drawZAxisTitles:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, self.zAxisFontColor.CGColor);
    
    if (self.displayZAxis == NO) {
        return;
    }
    
    if (self.displayZAxisTitle == NO) {
        return;
    }
    
    if ([self.zAxisTitles count] <= 0) {
        return;
    }
    
    CCFloat postOffset;
    if (self.axisXPosition == CCSGridChartXAxisPositionBottom) {
        postOffset = (rect.size.height - self.axisMarginBottom - 2 * self.axisMarginTop) * 1.0 / ([self.zAxisTitles count] - 1);
    } else {
        postOffset = (rect.size.height - 2 * self.axisMarginBottom - self.axisMarginTop) * 1.0 / ([self.latitudeTitles count] - 1);
    }
    NSMutableParagraphStyle *textStyle=[[NSMutableParagraphStyle alloc]init];//段落样式
    textStyle.alignment = NSTextAlignmentLeft;
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attribute = @{NSFontAttributeName:self.zAxisFont,NSForegroundColorAttributeName:self.zAxisFontColor,NSParagraphStyleAttributeName:textStyle};
    CCFloat titileOffset = 2;
    CCFloat offset = rect.size.height - self.axisMarginBottom - self.axisMarginTop;
    for (CCUInt i = 0; i < [self.zAxisTitles count]; i++) {
        
        NSString *str = (NSString *) [self.zAxisTitles objectAtIndex:i];
        CGRect strRect = [self rectOfNSString:str attribute:attribute];
        CGRect textRect = CGRectZero;
        if (i == 0) {
            textRect= CGRectMake(rect.size.width - self.axisMarginRight + titileOffset, offset - i * postOffset - strRect.size.height, strRect.size.width, strRect.size.height);
        } else if (i == [self.zAxisTitles count] - 1) {
            textRect= CGRectMake(rect.size.width - self.axisMarginRight + 2, offset - i * postOffset, strRect.size.width, strRect.size.height);
        } else {
            
            textRect= CGRectMake(rect.size.width - self.axisMarginRight +2, offset - i * postOffset - strRect.size.height / 2.0, strRect.size.width, strRect.size.height);
        }
        //绘制字体
        [str drawInRect:textRect withAttributes:attribute];
    }
    
    
}


#pragma mark - **************** 绘制X轴坐标标题
- (void)drawXAxisTitles:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, self.longitudeColor.CGColor);
    CGContextSetFillColorWithColor(context, self.longitudeFontColor.CGColor);
    
    if (self.displayLongitude == NO) {
        return;
    }
    
    if (self.displayLongitudeTitle == NO) {
        return;
    }
    
    if ([self.longitudeTitles count] <= 0) {
        return;
    }
    
    CCFloat postOffset;
    CCFloat offset = 0.0;
    CCFloat offsetX = 0.0;
    if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
        if (self.orginMaxSticksNum < self.virtualSticksNum)
        {
            // 蜡烛棒宽度
            postOffset = ((rect.size.width - self.axisMarginLeft - self.axisMarginRight) * 1.0 / self.virtualSticksNum) - 1;
        }
        else
        {
            postOffset = ((rect.size.width - self.axisMarginLeft - self.axisMarginRight) * 1.0 / self.orginMaxSticksNum) - 1;
        }
        offsetX = self.axisMarginLeft + postOffset / 2;

    } else {
        postOffset = (rect.size.width - 2 * self.axisMarginLeft - self.axisMarginRight) / ([self.longitudeTitles count] - 1);
        offset = self.axisMarginLeft;
    }
    for (CCUInt i = 0; i < [self.longitudeTitles count]; i++) {
        if (self.axisXPosition == CCSGridChartXAxisPositionBottom) {
            NSMutableParagraphStyle *textStyle=[[NSMutableParagraphStyle alloc]init];//段落样式
            textStyle.alignment = NSTextAlignmentCenter;
            textStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attribute = @{NSFontAttributeName:self.longitudeFont,NSForegroundColorAttributeName:self.longitudeFontColor,NSParagraphStyleAttributeName:textStyle};
            NSString *str = (NSString *) [self.longitudeTitles objectAtIndex:i];
            CGRect strRect = [self rectOfNSString:str attribute:attribute];
            offset = offsetX + (1 + postOffset) * [[self.longitudePositions objectAtIndex:i] integerValue];
            CGRect textRect= CGRectMake(offset - strRect.size.width / 2.0, rect.size.height - self.axisMarginBottom, strRect.size.width, strRect.size.height);
                    //绘制字体
            [str drawInRect:textRect withAttributes:attribute];
        }
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


- (NSString *)calcAxisXGraduate:(CGRect)rect {
    return [NSString stringWithFormat:@"%f", [self touchPointAxisXValue:rect]];
}

- (NSString *)calcAxisYGraduate:(CGRect)rect {
    return [NSString stringWithFormat:@"%f", [self touchPointAxisYValue:rect]];
}


- (CCFloat )touchPointAxisXValue:(CGRect)rect {
    if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
        CCFloat length = rect.size.width - self.axisMarginLeft - 2 * self.axisMarginRight;
        CCFloat valueLength = self.singleTouchPoint.x - self.axisMarginLeft - self.axisMarginRight;
        return valueLength / length;
    } else {
        CCFloat length = rect.size.width - 2 * self.axisMarginLeft - self.axisMarginRight;
        CCFloat valueLength = self.singleTouchPoint.x - self.axisMarginLeft;
        return valueLength / length;
    }
}

- (CCFloat )touchPointAxisYValue:(CGRect)rect {
    if (self.axisXPosition == CCSGridChartXAxisPositionBottom) {
        CCFloat length = rect.size.height - self.axisMarginBottom - 2 * self.axisMarginTop;
        CCFloat valueLength = length - self.singleTouchPoint.y + self.axisMarginTop;
        return valueLength / length;
    }
    else {
        CCFloat length = rect.size.height - 2 * self.axisMarginBottom - self.axisMarginTop;
        CCFloat valueLength = length - self.singleTouchPoint.y - self.axisMarginBottom;
        return valueLength / length;
    }
}


CCFloat _startDistance = 0;
CCFloat _minDistance = 8;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //调用父类的触摸事件
    [super touchesBegan:touches withEvent:event];
    NSArray *allTouches = [touches allObjects];
    //处理点击事件
    if ([allTouches count] == 1) {
        //获取选中点
        self.singleTouchPoint = [[allTouches objectAtIndex:0] locationInView:self];
        //重绘
        [self setNeedsDisplay];
    } else if ([allTouches count] == 2) {
        CGPoint pt1 = [[allTouches objectAtIndex:0] locationInView:self];
        CGPoint pt2 = [[allTouches objectAtIndex:1] locationInView:self];

        _startDistance = fabs(pt1.x - pt2.x);
    } else {

    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //调用父类的触摸事件
    [super touchesMoved:touches withEvent:event];
    NSArray *allTouches = [touches allObjects];
    //处理点击事件
    if ([allTouches count] == 1) {
        //获取选中点
        self.singleTouchPoint = [[allTouches objectAtIndex:0] locationInView:self];
        //设置可滚动
        [self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0];
    } else if ([allTouches count] == 2) {
        CGPoint pt1 = [[allTouches objectAtIndex:0] locationInView:self];
        CGPoint pt2 = [[allTouches objectAtIndex:1] locationInView:self];

        CCFloat endDistance = fabs(pt1.x - pt2.x);
        //放大
        if (endDistance - _startDistance > _minDistance) {
            [self zoomOut];
            _startDistance = endDistance;

            [self setNeedsDisplay];
        } else if (endDistance - _startDistance < -_minDistance) {
            [self zoomIn];
            _startDistance = endDistance;

            [self setNeedsDisplay];
        }

    } else {

    }

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //调用父类的触摸事件
    [super touchesEnded:touches withEvent:event];
    _startDistance = 0;
    [self setNeedsDisplay];
}

- (void)zoomOut {
}

- (void)zoomIn {
}

- (void)CCSChartDidTouched:(CGPoint *)point
{
    
}

- (void) setSingleTouchPoint:(CGPoint) point
{
    _singleTouchPoint = point;
    
    if (self.chartDelegate && [self.chartDelegate respondsToSelector:@selector(CCSChartBeTouchedOn:indexAt:)]) {
        [self.chartDelegate CCSChartBeTouchedOn:point indexAt:0];
    }
}

#pragma mark - **************** 获取字体大小
- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}


@end
