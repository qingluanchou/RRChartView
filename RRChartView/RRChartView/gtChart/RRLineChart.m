//
//  RRLineChart.h
//  Cocoa-Charts
//
//  Created by wenliang on 16/1/5.
//  Copyright © 2016年 renrencaopan. All rights reserved.
//

#import "RRLineChart.h"
#import "RRTitledLine.h"
#import "RRLineData.h"
#import "UIBezierPath+curved.h"
#import "UIColor+RRChart.h"

@interface RRLineChart ()

@property (nonatomic,strong)CAShapeLayer *shapeLayer;

@property (strong, nonatomic) CAGradientLayer *gradient;

/** Y轴坐标显示最大值*/
@property(assign, nonatomic) CCFloat zuobiaoMaxValue;

/** Y轴坐标显示最小值*/
@property(assign, nonatomic) CCFloat zuobiaoMinValue;

/** 展示日期的点*/
@property(strong, nonatomic) NSMutableArray *xPositions;

@end

@implementation RRLineChart

- (void)initProperty {

    [super initProperty];

    //默认y刻度有7个
    self.longitudeNum = 6;
    self.maxValue = CCIntMin;
    self.minValue = CCIntMax;
    self.selectedIndex = 0;
    self.axisCalc = 1;
    self.lineAlignType = CCSLineAlignTypeCenter;
    //默认一页展示数据点个数
    self.xPositionNum = 25;
}


- (void)drawRect:(CGRect)rect {

    //初始化XY轴
    [self initAxisY];
    [self initAxisX];

    [super drawRect:rect];
    
    [self drawData:rect];
    
    [self drawDotPath:rect];
}

#pragma mark - **************** 绘制小圆
- (void)drawDotPath:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor colorWithRed:74/255.0 green:189/255.0 blue:237/255.0 alpha:1.0] setStroke];
    [[UIColor whiteColor] setFill];
    CCFloat lineLength;
    // 起始位置
    CCFloat startX;
    
    if (self.linesData.count <= 0){
        return;
    }
    if (self.linesData != NULL)
    {
        for (CCUInt i = 0; i < [self.linesData count]; i++)
        {
            RRTitledLine *line = [self.linesData objectAtIndex:i];
            if (line != NULL)
            {
                NSArray *lineDatas = line.data;
                lineLength= ((rect.size.width - self.axisMarginLeft -  self.axisMarginRight) / (self.xPositionNum));
                startX = super.axisMarginLeft + lineLength / 2;
                for (CCUInt j = 0; j < [lineDatas count]; j++) {
                    RRLineData *lineData = [lineDatas objectAtIndex:j];
                    //获取终点Y坐标
                    CCFloat valueY = ((1 - (lineData.value - self.zuobiaoMinValue ) / (self.zuobiaoMaxValue - self.zuobiaoMinValue)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);
                    
                    UIBezierPath *dotPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(startX - 2, valueY-2, 4, 4)];
                    
                    CGContextAddPath(ctx, dotPath.CGPath);
                    CGContextDrawPath(ctx, kCGPathFillStroke);
                    // ------x的位移
                    startX = startX + lineLength;
                }
                
            }
        }
    }
    
}

#pragma mark - **************** 绘制线条
- (void)drawData:(CGRect)rect {
    
    CCFloat startX = 0;
    CCFloat lineLength = 0;
    CGContextRef context = UIGraphicsGetCurrentContext();
   // CGContextSaveGState(context);
    CGContextSetAllowsAntialiasing(context, YES);
    UIBezierPath *path=[UIBezierPath bezierPath];
    if (self.linesData == NULL){
        return;
    }
    for (CCUInt i = 0; i < [self.linesData count]; i++) {
        RRTitledLine *line = [self.linesData objectAtIndex:i];
        if (line == NULL) {
            continue;
        }
        [[UIColor colorWithRed:74/255.0 green:189/255.0 blue:237/255.0 alpha:1.0] setStroke];
        [path setLineWidth:1.0];
        //获取线条数据
        NSArray *lineDatas = line.data;
        
        //判断Y轴的位置设置从左往右还是从右往左绘制
        if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
            
            if (self.lineAlignType == CCSLineAlignTypeCenter) {
                lineLength= ((rect.size.width - self.axisMarginLeft -  self.axisMarginRight) / (self.xPositionNum));
                startX = super.axisMarginLeft + lineLength / 2;
            }
            for (CCUInt j = 0; j < [lineDatas count]; j++) {
                RRLineData *lineData = [lineDatas objectAtIndex:j];
                //获取终点Y坐标
                CCFloat valueY = ((1 - (lineData.value - self.zuobiaoMinValue ) / (self.zuobiaoMaxValue - self.zuobiaoMinValue)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);
                if (j == 0) {
                    [path moveToPoint:CGPointMake(startX, valueY)];
                } else {
                    [path addLineToPoint:CGPointMake(startX, valueY)];
                }
                //X位移
                startX = startX + lineLength;
            }
        }
        
        //绘制路径
        path=[path smoothedPathWithGranularity:10];
        CGContextAddPath(context, path.CGPath);
        //备份路径
        CGPathRef linePath = CGContextCopyPath(context);
        CGContextDrawPath(context, kCGPathStroke);
        CGContextAddPath(context, linePath);
        CCFloat originValueY = ((1 - (0 - self.zuobiaoMinValue ) / (self.zuobiaoMaxValue - self.zuobiaoMinValue)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);
        CCFloat originX = super.axisMarginLeft + lineLength / 2;
        CGContextAddLineToPoint(context, startX - lineLength, originValueY);
        CGContextAddLineToPoint(context, originX, originValueY);
        CGPathRef wholePath = CGContextCopyPath(context);
        CGContextClosePath(context);
        
        CAShapeLayer *maskLayer = self.shapeLayer;
        maskLayer.frame = self.bounds;
        maskLayer.path = wholePath;
        self.gradient.frame = self.bounds;
        self.gradient.colors = @[(__bridge id)[UIColor colorWithRed:183/255.0 green:224/255.0 blue:255/255.0 alpha:0.0].CGColor,
                                 (__bridge id)[UIColor colorWithRed:183/255.0 green:224/255.0 blue:255/255.0 alpha:1.0].CGColor];
        self.gradient.mask = maskLayer;
        [self.layer addSublayer:self.gradient];
        [[UIColor clearColor] setStroke];
        CGContextAddPath(context, wholePath);
        CGContextDrawPath(context, kCGPathStroke);
        
    }
}


#pragma mark - **************** 设置x轴坐标
- (void)drawXAxisTitles:(CGRect)rect {
    if (self.lineAlignType == CCSLineAlignTypeJustify) {
        [super drawXAxisTitles:rect];
        return;
    }
    
    if (self.displayLongitude == NO) {
        return;
    }
    
    if (self.displayLongitudeTitle == NO) {
        return;
    }
    
    if ([self.longitudeTitles count] <= 0) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, self.longitudeColor.CGColor);
    CGContextSetFillColorWithColor(context, self.longitudeFontColor.CGColor);
    
    CCFloat postOffset;
    CCFloat offset = 0.0;
    CCFloat offsetX = 0.0;
    if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
        postOffset = ((rect.size.width - self.axisMarginLeft -  self.axisMarginRight) / (self.xPositionNum));
    } else {
        //TODO
        postOffset = (rect.size.width - 2 * self.axisMarginLeft - self.axisMarginRight) / ([self.longitudeTitles count]);
    }
    
    offsetX = super.axisMarginLeft + postOffset / 2;
    NSMutableParagraphStyle *textStyle=[[NSMutableParagraphStyle alloc]init];
    textStyle.alignment=NSTextAlignmentCenter;
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:[UIColor colorLongitude],NSParagraphStyleAttributeName:textStyle};
    for (CCUInt i = 0; i < [self.longitudeTitles count]; i++) {
        if (self.axisXPosition == CCSGridChartXAxisPositionBottom) {
            NSString *str = (NSString *) [self.longitudeTitles objectAtIndex:i];
            offset = offsetX + postOffset * [[self.xPositions objectAtIndex:i] integerValue];
            CGRect strRect = [self rectOfNSString:str attribute:attribute];
            CGRect textRect = CGRectMake(offset - strRect.size.width / 2.0 , rect.size.height - self.axisMarginBottom -strRect.size.height, strRect.size.width, strRect.size.height);
            [str drawInRect:textRect withAttributes:attribute];
            
        }
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

#pragma mark - **************** 设置Y轴坐标
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
    NSMutableParagraphStyle *textStyle=[[NSMutableParagraphStyle alloc]init];//段落样式
    textStyle.alignment=NSTextAlignmentRight;
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor colorLongitude],NSParagraphStyleAttributeName:textStyle};
    for (CCUInt i = 0; i <= [self.latitudeTitles count]; i++) {
        if (self.axisYPosition == CCSGridChartYAxisPositionLeft)
        {
            if (i < [self.latitudeTitles count])
            {
                NSString *str = (NSString *) [self.latitudeTitles objectAtIndex:i];
                str = [NSString stringWithFormat:@"%@%%",str];
    
                CGRect textRect= CGRectMake(0, offset - i * postOffset - self.latitudeFontSize-1, self.axisMarginLeft, self.latitudeFontSize);
                //绘制字体
                [str drawInRect:textRect withAttributes:attribute];
            }
                
            
            
        }
    }
}

#pragma mark - **************** 绘制纬线
- (void)drawLatitudeLines:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, self.latitudeColor.CGColor);
    
    if (self.displayLatitude == NO) {
        return;
    }
    
    if ([self.latitudeTitles count] <= 0){
        return ;
    }
    //设置线条为点线
//    if (self.dashLatitude) {
//        CGFloat lengths[] = {2.0, 2.0};
//        CGContextSetLineDash(context, 0.0, lengths, 2);
//    }
    
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
            CGContextMoveToPoint(context, self.axisMarginLeft - 5, offset - i * postOffset);
            CGContextAddLineToPoint(context, rect.size.width - self.axisMarginRight, offset - i * postOffset);
        }
    }
    CGContextStrokePath(context);
    //还原线条
    CGContextSetLineDash(context, 0, nil, 0);
    CCFloat offset0 = rect.size.height - self.axisMarginBottom - self.axisMarginTop;
    for (CCUInt i = 0; i < [self.latitudeTitles count]; i++)
    {
        
        if ([self.latitudeTitles[i] integerValue] == 0 && self.axisX0repeatLatitude)
        {
            [[UIColor colorXaxis] setStroke];
            CGContextSetLineWidth(context, 1.0f);
            CGContextMoveToPoint(context,self.axisMarginLeft - 5 , offset0 - i * postOffset);
            CGContextAddLineToPoint(context, rect.size.width - self.axisMarginRight, offset - i * postOffset);
            CGContextStrokePath(context);
            
        }
        
    }
    
    
}


#pragma mark - **************** 初始化Y坐标值
- (void)initAxisY {
    if (self.maxValue == 0. && self.minValue == 0.) {
        self.latitudeTitles = nil;
        return;
    }
    
    if (self.maxValue < 0)
    {
        self.maxValue = 0;
    }
    
    if (self.minValue > 0)
    {
        self.minValue = 0;
    }
    CCFloat chaZhi =  self.maxValue - self.minValue;
    CCInt zuobiaoYMax = 3;
    CCInt zuobiaoMin = -3;
    CCInt jizhi = 6;
    CCUInt rate = [self dealWithYValue:chaZhi];
    zuobiaoYMax = zuobiaoYMax * rate;
    zuobiaoMin= zuobiaoMin * rate;
    if (self.maxValue > 3 * rate ) {
        zuobiaoYMax = ((CCInt)(self.maxValue / rate)) * rate  + rate;
        zuobiaoMin = -(jizhi * rate - zuobiaoYMax);
    }else if(self.minValue < - 3.0 * rate ){
        zuobiaoMin = ((CCInt)(self.minValue / rate)) * rate  - rate;
        zuobiaoYMax = jizhi * rate + zuobiaoMin;
    }
    
    NSMutableArray *TitleY = [[NSMutableArray alloc] init];
    CCInt average =  (zuobiaoYMax - zuobiaoMin) / self.longitudeNum;
    //处理刻度
    for (CCUInt i = 0; i < self.longitudeNum; i++) {
        NSString *value = [NSString stringWithFormat:@"%ld", zuobiaoMin + i * average / self.axisCalc];
        [TitleY addObject:value];
    }
    //处理最大值
    NSString *value = [NSString stringWithFormat:@"%ld", zuobiaoYMax];
    [TitleY addObject:value];
    self.zuobiaoMaxValue = zuobiaoYMax;
    self.zuobiaoMinValue = zuobiaoMin;

    self.latitudeTitles = TitleY;
    
}

- (CCInt)dealWithYValue:(CCFloat)chaZhi
{
    CCUInt rate = 0;
    CCInt jizhi = 6;
    for (int i = 1; i < 20; i ++) {
        rate ++;
        if (chaZhi < jizhi * rate - rate) {
            return rate;
        }
    }
    return 1;

}


#pragma mark - **************** 初始化Y坐标值
- (void)initAxisX {
    NSMutableArray *TitleX = [[NSMutableArray alloc] init];
    NSMutableArray *positionX = [[NSMutableArray alloc] init];
    if (self.linesData != NULL && [self.linesData count] > 0) {
        //以第1条线作为X轴的标示
        RRTitledLine *line = [self.linesData objectAtIndex:0];
        if ([line.data count] > 0) {
            //处理刻度
            for (CCUInt i = 0; i < [line.data count]; i++){
                if (i % 3 == 0)
                {
                    RRLineData *lineData = [line.data objectAtIndex:i];
                    //追加标题
                    [TitleX addObject:[NSString stringWithFormat:@"%@", lineData.date]];
                    [positionX addObject:@(i)];
                    
                }
                
            }
        }
    }
    self.longitudeTitles = TitleX;
    self.xPositions = positionX;
}



- (NSString *)calcAxisXGraduate:(CGRect)rect {
    CCFloat value = [self touchPointAxisXValue:rect];
    NSString *result = @"";
    if (self.linesData != NULL) {
        RRTitledLine *line = [self.linesData objectAtIndex:0];
        if (line != NULL && [line.data count] > 0) {
            if (value >= 1) {
                result = ((RRLineData *) [line.data objectAtIndex:[line.data count] - 1]).date;
            } else if (value <= 0) {
                result = ((RRLineData *) [line.data objectAtIndex:0]).date;
            } else {
                CCUInt index = (CCUInt) round([line.data count] * value);

                if (index < [line.data count]) {
                    self.displayCrossXOnTouch = YES;
                    self.displayCrossYOnTouch = YES;
                    result = ((RRLineData *) [line.data objectAtIndex:index]).date;
                } else {
                    self.displayCrossXOnTouch = NO;
                    self.displayCrossYOnTouch = NO;
                }
            }
        }
    }
    return result;
}

- (void) setLinesData:(NSArray *)linesData
{
    _linesData = linesData;
    
    self.maxValue = CCIntMin;
    self.minValue = CCIntMax;
}

- (CAShapeLayer *)shapeLayer
{
    if (_shapeLayer == nil) {
        _shapeLayer = [[CAShapeLayer alloc] init];
    }
    return _shapeLayer;
}

- (CAGradientLayer *)gradient
{
    
    if (_gradient == nil) {
        _gradient = [CAGradientLayer layer];
    }
    return _gradient;
}


@end
