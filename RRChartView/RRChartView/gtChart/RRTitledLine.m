//
//  TiltledLine.m
//  Cocoa-Charts
//
//  Created by wenliang on 16/1/5.
//  Copyright © 2016年 renrencaopan. All rights reserved.
//

#import "RRTitledLine.h"


@implementation RRTitledLine

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (id)initWithData:(NSMutableArray *)data color:(UIColor *)color title:(NSString *)title
{
    self = [self init];
    if (self){
        self.data = data;
        self.color = color;
        self.title = title;
    }
    return self;
}


@end
