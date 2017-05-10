//
//  EditCommentTableViewCell.m
//  shashou
//
//  Created by 黄佳峰 on 16/7/6.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import "EditCommentTableViewCell.h"

@implementation EditCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)commentStarBtnAction:(id)sender {
    //tag 1-5，即为star星数
    UIButton * btn = (UIButton *)sender;
    self.starCount(btn.tag);
}










@end
