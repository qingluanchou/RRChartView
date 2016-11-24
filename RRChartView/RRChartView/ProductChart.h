//
//  ProductChart.h
//  RRCP
//
//  Created by wenliang on 15/12/10.
//  Copyright © 2015年 renrencaopan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductChart : NSObject

 /** hs300净值*/
@property (nonatomic,assign)double hs300Rate;

 /** hs300指数*/
@property (nonatomic,assign)double hs300;

 /** 当日净值*/
@property (nonatomic,assign)double unitValue;

 /** 持仓百分比*/
@property (nonatomic,assign)double stockPercentage;

 /** 日期*/
@property (nonatomic,copy)NSString *tradingDate;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)productChartWithDict:(NSDictionary *)dict;

/**
 *  获取曲线模型
 */
+ (NSArray *)getProductChartList:(NSArray *)array;

@end
