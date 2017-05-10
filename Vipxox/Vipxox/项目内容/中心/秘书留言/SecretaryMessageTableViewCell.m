//
//  SecretaryMessageTableViewCell.m
//  Vipxox
//
//  Created by Brady on 16/3/3.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "SecretaryMessageTableViewCell.h"

@implementation SecretaryMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor=[UIColor whiteColor];
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(75), ACTUAL_HEIGHT(20), ACTUAL_WIDTH(300), ACTUAL_HEIGHT(18))];
        _titleLabel.text=@"新版云仓库规则公告";
        _titleLabel.font=[UIFont systemFontOfSize:16];
        _titleLabel.textColor=[UIColor blackColor];
        _titleLabel.textAlignment=0;
        [self addSubview:_titleLabel];
        
        _dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(75), ACTUAL_HEIGHT(47), ACTUAL_WIDTH(150), ACTUAL_HEIGHT(12))];
        _dateLabel.text=@"2015-9-13";
        _dateLabel.font=[UIFont systemFontOfSize:12];
        _dateLabel.textColor=RGBCOLOR(168, 168, 168, 1);
        _dateLabel.textAlignment=0;
        [self addSubview:_dateLabel];
        
        _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(235), ACTUAL_HEIGHT(47), ACTUAL_WIDTH(58), ACTUAL_HEIGHT(12))];
        _timeLabel.font=[UIFont systemFontOfSize:12];
        _timeLabel.textColor=RGBCOLOR(168, 168, 168, 1);
        _timeLabel.textAlignment=0;
        [self addSubview:_timeLabel];
        
        _contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(75), ACTUAL_HEIGHT(60), ACTUAL_WIDTH(248), ACTUAL_HEIGHT(48))];
        _contentLabel.text=@"新版拥吻汇已正式上线，为带给会员更极致的使用体验，云仓库实用流程及操作周期均进行大幅优化，同时使用规则也有较大变化，亲们......";
        _contentLabel.font=[UIFont systemFontOfSize:12];
        _contentLabel.textColor=RGBCOLOR(168, 168, 168, 1);
        _contentLabel.numberOfLines=3;
        _contentLabel.textAlignment=0;
        [self addSubview:_contentLabel];


    }
    return self;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
