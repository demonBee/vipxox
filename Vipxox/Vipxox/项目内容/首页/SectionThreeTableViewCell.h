//
//  SectionThreeTableViewCell.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/2/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionThreeTableViewCellDelegate <NSObject>

-(void)touchImageButton:(UIButton*)sender andThisCellAllDatas:(NSArray*)array;

@end

@interface SectionThreeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIButton *button0;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;

@property(nonatomic,weak)id<SectionThreeTableViewCellDelegate>delegate;
@end
