//
//  UIColor+RRChart.m
//  RRCP
//
//  Created by wenliang on 15/12/10.
//  Copyright © 2016年 renrencaopan. All rights reserved.
//

#import "UIColor+RRChart.h"

@implementation UIColor (RRChart)

+ (UIColor *)colorWithHex:(UInt32)hex {
    return [UIColor colorWithHex:hex alpha:1.f];
}

+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:alpha];
}



+(UIColor *)colorLongitude
{
    return [UIColor colorWithHex:0x666666];
}

+(UIColor *)colorXaxis
{
   return [UIColor colorWithHex:0x000000 alpha:0.5];
}

+(UIColor *)latitudeFontColor
{
    return [UIColor colorWithHex:0x343434];
}

+(UIColor *)zAxisFontColor
{
    return [UIColor colorWithHex:0x343434];
}

+(UIColor *)caoPanRateColor
{
    return [UIColor colorWithHex:0xFF4747];
}

+(UIColor *)hs300RateColor
{
    return [UIColor colorWithHex:0x59ABCD];
}


@end
