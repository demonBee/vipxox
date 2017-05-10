//
//  TRCollectionViewCell.m
//  UICollectionView
//
//  Created by 吴伯程 on 15/4/23.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRCollectionViewCell.h"

@implementation TRCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        self.label.textAlignment = NSTextAlignmentCenter;
//        [self.contentView addSubview:self.label];
        
        self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        self.imageView.backgroundColor=[UIColor yellowColor];
        [self.contentView addSubview:self.imageView];
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
