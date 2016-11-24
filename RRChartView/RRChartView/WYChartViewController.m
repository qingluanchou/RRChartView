//
//  OneRunChartController.m
//  RRCP
//
//  Created by wenliang on 15/12/10.
//  Copyright © 2015年 renrencaopan. All rights reserved.
//

#import "WYChartViewController.h"
#import "ProductChart.h"
#import "RRLineChart.h"
#import "RRLineData.h"
#import "RRTitledLine.h"
#import "CustomLabel.h"
#import "Masonry.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;
@interface WYChartViewController ()

@property (nonatomic,strong)UIView *noLoginView;

@property (nonatomic,strong)NSDateFormatter *formatter;

@property (nonatomic,strong)UIView *noChartView;

@end

@implementation WYChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"当月hs300变化曲线";
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wydata" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *data = [dict objectForKey:@"data"];
    NSArray *productList = [ProductChart getProductChartList:data];
    [self showWyControlChart:productList];
}

- (void)showWyControlChart:(NSArray *)allContentArray
{
    NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:allContentArray.count];
    [allContentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        ProductChart *pc = (ProductChart *)obj;
        if (pc.hs300Rate)
        {
            [contentArray addObject:pc];
        }
    }];
    CustomLabel *titleLabel = [CustomLabel setCustomLabelText:@"沪深300指数" font:14 textColor:[UIColor colorWithRed:51/255.0 green:51/255.0  blue:51/255.0  alpha:1.0]];
    [self.view addSubview:titleLabel];
    WEAKSELF(weakSelf);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(120);
        make.centerX.equalTo(weakSelf.view);
    }];
    double toplevel = 1;
    double bottomlevel = -1;
    RRLineChart *linechart = [[RRLineChart alloc] init];
    if (contentArray.count == 0)
    {
        linechart.maxValue = 1;
        linechart.minValue = -1;
    }
    else
    {
        NSDateFormatter *dateFormatter = self.formatter;
        [dateFormatter setDateFormat:@"MM-dd"];
        
        ProductChart *pc0 = (ProductChart *)contentArray[0];
        double initValue  = pc0.hs300Rate;
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:contentArray.count];
        for (ProductChart *pChart in contentArray)
        {
            double differ = (pChart.hs300Rate - initValue) * 100;
            toplevel = (toplevel < differ) ? differ : toplevel;
            bottomlevel = (bottomlevel > differ) ? differ : bottomlevel;
            pChart.hs300Rate = differ;
            long long time = [pChart.tradingDate longLongValue] /1000;
            NSString *timeStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
            pChart.tradingDate = timeStr;
            [tempArray addObject:pChart];
        }
        NSMutableArray *linedata = [[NSMutableArray alloc] init];
        NSMutableArray *singlelinedatas = [[NSMutableArray alloc] init];
        [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ProductChart *chart = (ProductChart *)obj;
            [singlelinedatas addObject:[[RRLineData alloc] initWithValue:chart.hs300Rate date:chart.tradingDate]];
        }];
        RRTitledLine *singleline = [[RRTitledLine alloc] init] ;
        singleline.data = singlelinedatas.copy;
        [linedata addObject:singleline];
        singleline.color = [UIColor colorWithRed:74/255.0 green:189/255.0 blue:237/255.0 alpha:1.0];
        singleline.title = @"沪深300指数";
        linechart.linesData = linedata;
        if (tempArray.count < 10){
            linechart.xPositionNum = 10;
        }
        else{
            linechart.xPositionNum = tempArray.count;
        }
    }
    linechart.maxValue = toplevel;
    linechart.minValue = bottomlevel;
    linechart.backgroundColor = [UIColor whiteColor];
    linechart.lineWidth = 1.5;
    linechart.latitudeColor = [UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:0.5];
    linechart.axisYColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    linechart.displayCrossXOnTouch = YES;
    linechart.displayCrossYOnTouch = YES;
    linechart.axisX0repeatLatitude = YES;
    linechart.lineAlignType = CCSLineAlignTypeCenter;
    //上偏移量
    linechart.axisMarginTop = 10;
    linechart.axisMarginRight = 17;
    linechart.axisMarginLeft = 25;
    
    [self.view addSubview:linechart];
    [linechart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(150);
        make.right.equalTo(weakSelf.view).offset(-5);
        make.left.equalTo(weakSelf.view).offset(12);
        make.height.mas_equalTo(@(screenW *0.5));
    }];
}


- (NSDateFormatter *)formatter
{
    if (_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
    }
    return _formatter;
}




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
