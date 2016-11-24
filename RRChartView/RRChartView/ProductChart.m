//
//  ProductChart.m
//  RRCP
//
//  Created by wenliang on 15/12/10.
//  Copyright © 2015年 renrencaopan. All rights reserved.
//

#import "ProductChart.h"

@implementation ProductChart

+ (instancetype)productChartWithDict:(NSDictionary *)dict{
    
    return [[self alloc] initWithDict:dict];
    
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
    
}


- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


//字典数组转化为模型数组
+ (NSArray *)getProductChartList:(NSArray *)array
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dict in array)
    {
        ProductChart  *pc  = [ProductChart  productChartWithDict:dict];
        [tempArray addObject:pc];
    }
    return tempArray.copy;
    
}

-(NSString*) description{
    return [NSString stringWithFormat:@"%f,%@",self.hs300Rate,self.tradingDate];
}






@end
