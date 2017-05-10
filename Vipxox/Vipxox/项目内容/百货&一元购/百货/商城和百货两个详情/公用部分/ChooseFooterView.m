//
//  ChooseFooterView.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ChooseFooterView.h"

@implementation ChooseFooterView

-(void)awakeFromNib{
    self.number=1;
    self.numberStr=[NSString stringWithFormat:@"%d",self.number];
    
    self.subtract.layer.borderWidth=1;
    self.subtract.layer.borderColor=RGBCOLOR(204, 204, 204, 1).CGColor;
    
    self.showLabel.layer.borderWidth=1;
    self.showLabel.layer.borderColor=RGBCOLOR(204, 204, 204, 1).CGColor;
    
    self.addButton.layer.borderWidth=1;
    self.addButton.layer.borderColor=RGBCOLOR(204, 204, 204, 1).CGColor;
    
    
}
- (IBAction)subtruct:(id)sender {
    //减
    if (_number>1) {
        _number--;
        self.numberStr=[NSString stringWithFormat:@"%d",self.number];

    }
    
}

- (IBAction)addButton:(id)sender {
    //加
    if (_number<10) {
       _number++;
        self.numberStr=[NSString stringWithFormat:@"%d",self.number];

    }
}

-(void)setNumberStr:(NSString *)numberStr{
    _numberStr=numberStr;
    self.showLabel.text=numberStr;
    
}

- (IBAction)buyOrCar:(id)sender {
    if (self.touchSureBlock) {
        self.touchSureBlock();
    }
    
}

@end
