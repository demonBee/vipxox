//
//  OnePayNowTableViewCell.m
//  Vipxox
//
//  Created by Tian Wei You on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "OnePayNowTableViewCell.h"

@implementation OnePayNowTableViewCell

- (void)awakeFromNib {
    self.payAllBtn.layer.cornerRadius = 5.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (IBAction)payAllBtnAction:(id)sender {
    self.allPayBlock();
}



@end
