//
//  NewSectionTableViewCell.m
//  Vipxox
//
//  Created by Tian Wei You on 16/3/24.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "NewSectionTableViewCell.h"

@implementation NewSectionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.payButton.hidden=NO;
    self.payButton.backgroundColor=[UIColor blueColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
