//
//  CaregroyTwoTableViewCell.m
//  weimao
//
//  Created by 黄佳峰 on 16/2/26.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import "CaregroyTwoTableViewCell.h"

@implementation CaregroyTwoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageBig=[[UIImageView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(18), ACTUAL_HEIGHT(15), ACTUAL_WIDTH(25), ACTUAL_HEIGHT(10))];
        _imageBig.backgroundColor=[UIColor whiteColor];
        _imageBig.contentMode=UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageBig];
        
        self.labelTitle=[[UILabel alloc]init];
        [self.contentView addSubview:self.labelTitle];
        
        self.labelDetail=[[UILabel alloc]init];
        [self.contentView addSubview:self.labelDetail];

        
        UIView*bottomView=[[UIView alloc]init];
        bottomView.backgroundColor=RGBCOLOR(236, 236, 236, 1);
        self.bottomView=bottomView;
        [self.contentView addSubview:bottomView];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    CGSize aaa=[self.labelTitle.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];
//    self.labelTitle.frame=CGRectMake(ACTUAL_WIDTH(53), ACTUAL_HEIGHT(18), aaa.width+ACTUAL_WIDTH(20), aaa.height);
//    self.labelDetail.frame=CGRectMake(self.labelTitle.right+ACTUAL_WIDTH(10), ACTUAL_HEIGHT(21), ACTUAL_WIDTH(90), ACTUAL_HEIGHT(11));
    
    [self.imageBig mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.left).offset(16);
        make.top.mas_equalTo(self.top).offset(15);
        make.size.mas_equalTo(CGSizeMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(20)));
    }];
    
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageBig.mas_right).offset(15);
        make.top.mas_equalTo(self.top).offset(17);
    }];
    
[self.labelDetail  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.labelTitle.mas_right).offset(10);
//    make.top.mas_equalTo(self.top).offset(ACTUAL_HEIGHT(21));
    make.centerY.mas_equalTo(self.labelTitle.mas_centerY).offset(0);
    NSLog(@"%@",NSStringFromCGRect(self.frame));
//    self.backgroundColor=[UIColor redColor];
}];
    
//    self.bottomView.frame=CGRectMake(ACTUAL_WIDTH(53), self.bottom-1, KScreenWidth-ACTUAL_WIDTH(53), 1);
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.left).offset(ACTUAL_WIDTH(53));
        make.bottom.mas_equalTo(self.bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-ACTUAL_WIDTH(53), 1));
    }];

}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
