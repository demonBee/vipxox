//
//  DepartmentBottomView.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/11.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "DepartmentBottomView.h"

@implementation DepartmentBottomView




-(void)awakeFromNib{
      
    
    UIButton*okButton=[self viewWithTag:1];
    [okButton addTarget:self action:@selector(addShoppingCar) forControlEvents:UIControlEventTouchUpInside];
    
    
}







-(void)addShoppingCar{
   
    if (self.AddCarBlock) {
        self.AddCarBlock();
    }
    
    
}

@end
