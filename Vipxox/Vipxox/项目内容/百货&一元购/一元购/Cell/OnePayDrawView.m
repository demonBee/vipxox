//
//  OnePayDrawView.m
//  Vipxox
//
//  Created by Tian Wei You on 16/8/4.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "OnePayDrawView.h"

@implementation OnePayDrawView


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawHot:self.isHot AndNew:self.isNew];
}

- (void)drawHot:(BOOL)hot AndNew:(BOOL)new{
    if (new) {
        if (hot) {
            //新品&最热
            [self drawWithPoint:CGPointMake((KScreenWidth - 1.f)/2 - 2.f, ACTUAL_WIDTH(8.f)) withStr:@"Hot" withColor:[UIColor colorWithHexString:@"#ff656a"]];
            [self drawWithPoint:CGPointMake((KScreenWidth - 1.f)/2 - 2.f - ACTUAL_WIDTH(30.f), ACTUAL_WIDTH(8.f)) withStr:@"New" withColor:[UIColor greenColor]];
        }else{
            //新品
            [self drawWithPoint:CGPointMake((KScreenWidth - 1.f)/2 - 2.f, ACTUAL_WIDTH(8.f)) withStr:@"New" withColor:[UIColor greenColor]];
        }
    }else if (hot){
        //最热
        [self drawWithPoint:CGPointMake((KScreenWidth - 1.f)/2 - 2.f, ACTUAL_WIDTH(8.f)) withStr:@"Hot" withColor:[UIColor colorWithHexString:@"#ff656a"]];
    }
    
}

- (void)drawWithPoint:(CGPoint)startPoint withStr:(NSString *)str withColor:(UIColor *)color{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [color set];
    CGFloat x =startPoint.x;
    CGFloat y =startPoint.y;
    CGContextMoveToPoint(contextRef, x, y);
    CGContextAddLineToPoint(contextRef, x, y + ACTUAL_WIDTH(33.f));
    CGContextAddLineToPoint(contextRef, x - ACTUAL_WIDTH(11.f), y + ACTUAL_WIDTH(21.f));
    CGContextAddLineToPoint(contextRef, x - ACTUAL_WIDTH(22.f), y + ACTUAL_WIDTH(33.f));
    CGContextAddLineToPoint(contextRef, x - ACTUAL_WIDTH(22.f), y);
    CGContextAddLineToPoint(contextRef, x, y);
    CGContextFillPath(contextRef);
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10.f],NSForegroundColorAttributeName:[UIColor whiteColor]};
    CGRect conRect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.f) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    [str drawInRect:CGRectMake(x - (ACTUAL_WIDTH(22.f) + conRect.size.width)/2, y, conRect.size.width, conRect.size.height) withAttributes:attributes];
}

@end
