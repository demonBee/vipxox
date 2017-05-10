//
//  ChooseVIew.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ChooseVIew.h"

@implementation ChooseVIew

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)creatVCWithFrame:(CGRect)rect{
  ChooseVIew*view=  [[NSBundle mainBundle]loadNibNamed:@"ChooseVIew" owner:self options:nil].firstObject;
    view.frame=rect;
    return view;
}

- (IBAction)immediately:(id)sender {
    if (self.ImmediatelyBlock) {
        self.ImmediatelyBlock();
    }
    
}

- (IBAction)addShoppingCar:(id)sender {
    if (self.addCarBlock) {
        self.addCarBlock();
    }
}

@end
