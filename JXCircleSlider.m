//
//  JXCircleSlider.m
//  JXCircleSlider
//
//  Created by JackXu on 15/6/23.
//  Copyright (c) 2015年 BFMobile. All rights reserved.
//

#import "JXCircleSlider.h"
#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

@implementation JXCircleSlider{
    CGFloat radius;
}

-(id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _lineWidth = 5;
        _angle = 280;
        radius = self.frame.size.width/2 - _lineWidth/2 - _lineWidth*2;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //1.绘制灰色的背景
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, radius, 0, M_PI*2, 0);
    [[UIColor grayColor] setStroke];
    CGContextSetLineWidth(context, _lineWidth);
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextDrawPath(context, kCGPathStroke);
    
    //2.绘制进度
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2,radius,0, ToRad(_angle), 0);
    [[UIColor redColor] setStroke];
    CGContextSetLineWidth(context, _lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextDrawPath(context, kCGPathStroke);
    
    //3.绘制拖动小块
    CGPoint handleCenter =  [self pointFromAngle: (self.angle)];
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 3,[UIColor blueColor].CGColor);
    [[UIColor redColor] setStroke];
    CGContextSetLineWidth(context, _lineWidth*2);
    CGContextAddEllipseInRect(context, CGRectMake(handleCenter.x, handleCenter.y, _lineWidth*2, _lineWidth*2));
    CGContextDrawPath(context, kCGPathStroke);
}

-(CGPoint)pointFromAngle:(int)angleInt{
    //中心点
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - _lineWidth, self.frame.size.height/2 - _lineWidth);
    
    //根据角度得到圆环上的坐标
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(ToRad(angleInt))) ;
    result.x = round(centerPoint.x + radius * cos(ToRad(angleInt)));
    
    return result;
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    return YES;
}


-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    //获取触摸点
    CGPoint lastPoint = [touch locationInView:self];
    //使用触摸点来移动小块
    [self movehandle:lastPoint];
    //发送值改变事件
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

-(void)movehandle:(CGPoint)lastPoint{
    
    //获得中心点
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2,
                                      self.frame.size.height/2);
    
    //计算中心点到任意点的角度
    float currentAngle = AngleFromNorth(centerPoint,
                                        lastPoint,
                                        NO);
    int angleInt = floor(currentAngle);
    
    //保存新角度
    self.angle = angleInt;
    
    //重新绘制
    [self setNeedsDisplay];
}

-(void)changeAngle:(int)angle{
    _angle = angle;
     [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
}

//从苹果是示例代码clockControl中拿来的函数
//计算中心点到任意点的角度
static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}

@end
