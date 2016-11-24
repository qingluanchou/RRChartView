//
//  RRBaseChartView.m
//  Cocoa-Charts
//
//  Created by wenliang on 16/1/5.
//  Copyright © 2016年 renrencaopan. All rights reserved.
//

#import "RRBaseChartView.h"


@implementation RRBaseChartView

- (id)init {
    self = [super init];
    if (self) {
        //初始化属性
        [self initProperty];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //初始化属性
        [self initProperty];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;

        //初始化属性
        [self initProperty];
    }
    return self;
}

- (void)initProperty {
    
   // self.superview.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    //如果父view容器不为空
    if (nil != self.superview) {
        [self.superview touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    //如果父view容器不为空
    if (nil != self.superview) {
        [self.superview touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    //如果父view容器不为空
    if (nil != self.superview) {
        [self.superview touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

    [super touchesEnded:touches withEvent:event];

    //如果父view容器不为空
    if (nil != self.superview) {
        [self.superview touchesCancelled:touches withEvent:event];
    }
}


@end
