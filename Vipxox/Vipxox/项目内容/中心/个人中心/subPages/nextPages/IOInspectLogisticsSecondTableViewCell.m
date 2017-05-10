//
//  IOInspectLogisticsSecondTableViewCell.m
//  Vipxox
//
//  Created by Tian Wei You on 16/3/30.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "IOInspectLogisticsSecondTableViewCell.h"

@implementation IOInspectLogisticsSecondTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _firstLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(10), ACTUAL_HEIGHT(5), ACTUAL_WIDTH(350), ACTUAL_HEIGHT(20))];
//        _firstLabel.backgroundColor=[UIColor yellowColor];
        _firstLabel.font=[UIFont systemFontOfSize:15];
        [self addSubview:_firstLabel];
        
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
