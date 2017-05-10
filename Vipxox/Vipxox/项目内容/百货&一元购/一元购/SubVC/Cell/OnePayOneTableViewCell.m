//
//  OnePayOneTableViewCell.m
//  Vipxox
//
//  Created by Tian Wei You on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "OnePayOneTableViewCell.h"

@implementation OnePayOneTableViewCell

- (void)awakeFromNib {
    self.payOneBtn.layer.cornerRadius = 5.f;
    
    [self setNeedsDisplay];//画线
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)payOneBtnAction:(id)sender {
    self.onePayBlock();
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [[UIColor colorWithHexString:@"#db3652"] set];
    CGContextMoveToPoint(contextRef, 0.f, 0.f);
    CGContextAddLineToPoint(contextRef, 0.f, 15.f);
    CGContextAddLineToPoint(contextRef, 33.f, 15.f);
    CGContextAddLineToPoint(contextRef, 45.f, 0.f);
    CGContextAddLineToPoint(contextRef, 0.f, 0.f);
    CGContextFillPath(contextRef);
    
    [self drawTextTest];
}
- (void)drawTextTest{
    NSString *str = @" 方式1";
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.f],NSForegroundColorAttributeName:[UIColor whiteColor]};
    [str drawInRect:CGRectMake(0.f, 0.f, 33.f, 15.f) withAttributes:attributes];
}

@end
