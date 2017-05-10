//
//  PayCountView.h
//  Vipxox
//
//  Created by Tian Wei You on 16/8/2.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayNumberView.h"

@interface PayCountView : UIView<PayNumberViewDelegate>

@property (nonatomic,copy)void(^payBlock)();

@property (nonatomic,assign)NSInteger maxPayCount;//最多购买次数
@property (nonatomic,copy)NSString * one;//一元夺宝币兑换
@property (nonatomic,copy)NSString * currency;


@property (nonatomic,strong)PayNumberView * numberView;
@property (nonatomic,strong)UILabel * priceLabel;

- (instancetype)initWithMaxPay:(NSInteger)maxPay withOne:(NSString *)onePay withCurrency:(NSString *)currency;

@end
