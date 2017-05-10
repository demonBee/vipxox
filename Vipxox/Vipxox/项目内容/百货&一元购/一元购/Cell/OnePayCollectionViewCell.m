//
//  OnePayCollectionViewCell.m
//  Vipxox
//
//  Created by Tian Wei You on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "OnePayCollectionViewCell.h"

@implementation OnePayCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(OnePayShopModel *)model{
    if (!model)return;
    _model = model;
    [self modelDataSet];
}

- (void)modelDataSet{
    NSInteger progress = ([self.model.is_branch integerValue] * 100)/[self.model.branch integerValue];
    self.progressView.progress = [self.model.is_branch floatValue]/[self.model.branch floatValue];
    self.introduceLabel.text = self.model.title;
    NSMutableAttributedString * progressStr =[[NSMutableAttributedString alloc]initWithString:@"开奖进度:" attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:KScreenWidth>370?14.f:11.f]}];
    NSString * fuhao = @"%";
    NSMutableAttributedString * progreStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%zi%@",progress,fuhao] attributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:KScreenWidth>370?14.f:11.f]}];
    [progressStr appendAttributedString:progreStr];
    self.progressLabel.attributedText = progressStr;
    
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
    //画标饰
    self.onePayDrawView.isHot = [self.model.hot integerValue];
    self.onePayDrawView.isNew = [self.model.is_new integerValue];
    [self.onePayDrawView setNeedsDisplay];
}

- (IBAction)payNowBtnAction:(id)sender {
    self.payNowBolck();
}




@end
