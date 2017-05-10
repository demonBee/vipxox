//
//  IOInspectLogisticsTableViewCell.m
//  Vipxox
//
//  Created by Tian Wei You on 16/3/30.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "IOInspectLogisticsTableViewCell.h"

@implementation IOInspectLogisticsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(10), ACTUAL_HEIGHT(5), ACTUAL_WIDTH(170), ACTUAL_HEIGHT(20))];
//        _leftLabel.backgroundColor=[UIColor redColor];
        _leftLabel.font=[UIFont systemFontOfSize:15];
        [self addSubview:_leftLabel];
        
        _rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(170), ACTUAL_HEIGHT(5), ACTUAL_WIDTH(180), ACTUAL_HEIGHT(20))];
//        _rightLabel.backgroundColor=[UIColor greenColor];
        _rightLabel.font=[UIFont systemFontOfSize:15];
        [self addSubview:_rightLabel];
        
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
