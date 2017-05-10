//
//  OnePayOneTableViewCell.h
//  Vipxox
//
//  Created by Tian Wei You on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnePayOneTableViewCell : UITableViewCell

@property(nonatomic,copy)void(^onePayBlock)();
@property (weak, nonatomic) IBOutlet UIButton *payOneBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


- (IBAction)payOneBtnAction:(id)sender;
@end
