//
//  DepartmentFooter.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/15.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "DepartmentFooter.h"

@implementation DepartmentFooter


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
         UIButton*button=[self viewWithTag:3];
        [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}


-(void)touchButton:(UIButton*)sender{
    if (self.OKBlock) {
        self.OKBlock();
    }
    
}

@end
