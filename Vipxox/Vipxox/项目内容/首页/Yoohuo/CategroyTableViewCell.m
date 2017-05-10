//
//  CategroyTableViewCell.m
//  weimao
//
//  Created by 黄佳峰 on 16/2/26.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import "CategroyTableViewCell.h"

@implementation CategroyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        self.imageBig=[[UIImageView alloc]initWithFrame:CGRectMake(12, ACTUAL_HEIGHT(20), ACTUAL_WIDTH(30), ACTUAL_HEIGHT(27))];
        self.imageBig=[[UIImageView alloc]init];
        self.imageBig.image=[UIImage imageNamed:@"Yoohoo_05"];
        _imageBig.backgroundColor=[UIColor whiteColor];
        _imageBig.contentMode=UIViewContentModeScaleAspectFit;

        [self.contentView addSubview:self.imageBig];
        
        self.labelMain=[[UILabel alloc]init];
        self.labelMain.text=@"男生";
//        self.labelMain.font=[UIFont fontWithName:@"PingFang SC" size:24];
        [self.contentView addSubview:self.labelMain];
        
        self.labelSmall=[[UILabel alloc]init];
        self.labelSmall.text=@"girls";
        [self.contentView addSubview:self.labelSmall];
        
        UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0, self.bottom-1, KScreenWidth, 1)];
        lineView.backgroundColor=RGBCOLOR(236, 236, 236, 1);
        self.lineView=lineView;
        [self.contentView addSubview:lineView];

    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        
          }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    self.imageView.frame=CGRectMake(ACTUAL_WIDTH(12), ACTUAL_HEIGHT(20), ACTUAL_WIDTH(30), ACTUAL_HEIGHT(27));
//    
//    [self.labelMain setNumberOfLines:1];
//    CGSize aaa=[self.labelMain.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
//    
//    self.labelMain.frame=CGRectMake(ACTUAL_WIDTH(52), ACTUAL_HEIGHT(24), aaa.width+ACTUAL_WIDTH(20), aaa.height);
//    
//    self.labelSmall.frame=CGRectMake(self.labelMain.right+ACTUAL_WIDTH(9), ACTUAL_HEIGHT(31), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(12));
    

    [self.imageBig mas_makeConstraints:^(MASConstraintMaker *make) {
       
 
        make.left.mas_equalTo(self.left).offset(ACTUAL_WIDTH(10));
        make.top.mas_equalTo(self.top).offset(ACTUAL_HEIGHT(20));
        make.size.mas_equalTo(CGSizeMake(ACTUAL_WIDTH(22), ACTUAL_HEIGHT(22)));
    }];
    
    
    [self.labelMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageBig.mas_right).offset(ACTUAL_WIDTH(10));
//        make.top.mas_equalTo(self.contentView.top).offset(22);
        make.centerY.mas_equalTo(self.imageBig.mas_centerY);
        
        
    }];

    [self.labelSmall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.labelMain.mas_right).offset(ACTUAL_WIDTH(8));
//        make.top.mas_equalTo(self.top).offset(29);
        make.centerY.mas_equalTo(self.labelMain.mas_centerY);
        
        
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(self.width, 1));
        
    }];
    
}
@end
