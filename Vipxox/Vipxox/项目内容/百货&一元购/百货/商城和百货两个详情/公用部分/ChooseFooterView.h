//
//  ChooseFooterView.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseFooterView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *subtract;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property(nonatomic,assign)int number;
@property(nonatomic,strong)NSString*numberStr;   //数量

@property(nonatomic,copy)void(^touchSureBlock)();  //点击确定购买按钮

@end
