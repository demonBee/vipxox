//
//  OneYuanTableViewCell.m
//  Vipxox
//
//  Created by Tian Wei You on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "OneYuanTableViewCell.h"

@implementation OneYuanTableViewCell

- (void)awakeFromNib {
    self.payAgainBTN.layer.borderColor = [UIColor redColor].CGColor;
    self.payAgainBTN.layer.borderWidth = 1.f;
    self.payAgainBTN.layer.cornerRadius = 6.f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(OneYuanModel *)model{
    if (!model)return;
    _model = model;
    [self modelDataSet];
}

- (void)modelDataSet{
    __weak typeof(self)weakSelf = self;
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:[UIImage imageNamed:@"placeholder_100x100"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.showImageView.alpha=0.3;
        CGFloat scale = 0.3;
        weakSelf.showImageView.transform = CGAffineTransformMakeScale(scale, scale);
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.showImageView.alpha=1;
            CGFloat scale = 1.0;
            weakSelf.showImageView.transform = CGAffineTransformMakeScale(scale, scale);
        }];
    }];
    self.nameLabel.text = self.model.title;
    self.idLabel.text = [NSString stringWithFormat:@"期号: %@",self.model.user_code];
    self.joinCountLabel.text = [NSString stringWithFormat:@"我已参与:%@人次",self.model.num];
    NSMutableAttributedString * nameStr =[[NSMutableAttributedString alloc]initWithString:@"获得者: " attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#878787"],NSFontAttributeName:[UIFont systemFontOfSize:16.f]}];
    NSString * winnerName;
    if (self.model.prize_winner) {
        winnerName = self.model.prize_winner;
    }else{
        winnerName = @"";
    }
    NSMutableAttributedString * name=[[NSMutableAttributedString alloc]initWithString:winnerName attributes:@{NSForegroundColorAttributeName:[UIColor blueColor],NSFontAttributeName:[UIFont systemFontOfSize:16.f]}];
    [nameStr appendAttributedString:name];
    self.personNameLabel.attributedText = nameStr;    
    
    NSArray * btnTittlaArr = @[@"再次购买",@"待开奖",@"已揭奖",@"填写地址",@"发奖中",@"奖品已发送"];
    NSInteger status = [self.model.status integerValue];// 1待开奖2已揭奖3中奖4发奖中5奖品已发送
    if (status == 1 && [self.model.number integerValue] > [self.model.num integerValue]) {
        [self.payAgainBTN setTitle:btnTittlaArr[status - 1] forState:UIControlStateNormal];
    }else{
        [self.payAgainBTN setTitle:btnTittlaArr[status] forState:UIControlStateNormal];
    }
}


- (IBAction)buyAgainBtnAction:(id)sender {
    NSInteger status = [self.model.status integerValue];//判读是否获奖
    if (status == 1 && [self.model.number integerValue] <= [self.model.num integerValue]){
        self.rePayBlock(0);//待开奖（达到购买上限）
    }else{
        self.rePayBlock(status);
    }
}


@end
