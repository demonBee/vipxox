//
//  PayCountView.m
//  Vipxox
//
//  Created by Tian Wei You on 16/8/2.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "PayCountView.h"

@implementation PayCountView

- (instancetype)initWithMaxPay:(NSInteger)maxPay withOne:(NSString *)onePay withCurrency:(NSString *)currency
{
    self = [super init];
    if (self) {
        //背景
        self.frame = CGRectMake(0.f,0.f, KScreenWidth, KScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAtion)];
        [self addGestureRecognizer:tap];
        
        self.maxPayCount = maxPay;
        if (self.maxPayCount >=100)self.maxPayCount =99;
        
        self.one = onePay;
        self.currency = currency;
        
        [self makeUI];
        
    }
    return self;
}

- (void)makeUI{
    //下方视图
    UIView * showView = [[UIView alloc]initWithFrame:CGRectMake(0.f, KScreenHeight, KScreenWidth, ACTUAL_WIDTH(240.f))];
    showView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNoAtion)];
    [showView addGestureRecognizer:tap];
    [self addSubview:showView];
    //标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, KScreenWidth, ACTUAL_WIDTH(38.f))];
    titleLabel.text = @"参与人次";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [showView addSubview:titleLabel];
    //计数
    self.numberView=[[PayNumberView alloc]initWithFrame:CGRectMake((KScreenWidth - ACTUAL_WIDTH(170.f))/2, ACTUAL_WIDTH(38.f), ACTUAL_WIDTH(170.f), ACTUAL_WIDTH(30.f))];
    self.numberView.layer.borderColor = [UIColor blackColor].CGColor;
    self.numberView.layer.borderWidth = 1.f;
    self.numberView.delegate = self;
    [showView addSubview:self.numberView];
    //快捷btn
    CGFloat btnWidth = (self.numberView.width - 30.f)/4;
    CGFloat btnX = self.numberView.x;
    CGFloat btnY = CGRectGetMaxY(self.numberView.frame) + ACTUAL_WIDTH(17.f);
    CGFloat btnH = ACTUAL_WIDTH(25.f);
    NSArray * btnArr = @[@"1",@"3",@"5",@"9"];
    for (int i = 0; i < btnArr.count; i++) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnWidth, btnH)];
        btn.layer.borderWidth = 1.f;
        btn.layer.borderColor = [UIColor colorWithHexString:@"#aeaeae"].CGColor;
        btn.tag = [btnArr[i] integerValue];
        btn.layer.cornerRadius = 3.f;
        btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:btnArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(quickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
        [showView addSubview:btn];
        btnX += 10.f + btnWidth;
    }
    //线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15.f, btnY + btnH + ACTUAL_WIDTH(15.f), KScreenWidth - 30.f, 1.f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#aeaeae"];
    [showView addSubview:lineView];
    //价格显示
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f, CGRectGetMaxY(lineView.frame), KScreenWidth, ACTUAL_WIDTH(50.f))];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    [self priceStrWithCount:1];
    [showView addSubview:self.priceLabel];
    //线
    UIView * linelView = [[UIView alloc]initWithFrame:CGRectMake(0.f, CGRectGetMaxY(self.priceLabel.frame), KScreenWidth, 1.f)];
    linelView.backgroundColor = [UIColor colorWithHexString:@"#aeaeae"];
    [showView addSubview:linelView];
    //pay
    UIButton * payBtn = [[UIButton alloc]initWithFrame:CGRectMake(10.f, CGRectGetMaxY(linelView.frame) + ACTUAL_WIDTH(10.f), KScreenWidth - 20.f, ACTUAL_WIDTH(44.f))];
    payBtn.layer.cornerRadius = 5.f;
    payBtn.backgroundColor = [UIColor colorWithHexString:@"#da3651"];
    [payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:payBtn];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3f];
        showView.frame = CGRectMake(0.f, KScreenHeight - ACTUAL_WIDTH(240.f), KScreenWidth, ACTUAL_WIDTH(240.f));
    }];
    
}

- (void)priceStrWithCount:(NSInteger)count{
    NSString * price = [NSString stringWithFormat:@"%zi",count];
    CGFloat currencyPrice = [self.one floatValue] * count;
    
    NSMutableAttributedString * priceStr =[[NSMutableAttributedString alloc]initWithString:@"共: " attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#adadad"],NSFontAttributeName:[UIFont systemFontOfSize:16.f]}];
    NSMutableAttributedString * priceApp=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@C$/%.2f%@",price,currencyPrice,self.currency] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#da3651"],NSFontAttributeName:[UIFont systemFontOfSize:16.f]}];
    [priceStr appendAttributedString:priceApp];
    self.priceLabel.attributedText = priceStr;
}

- (void)tapAtion{
    [self removeFromSuperview];
}

- (void)tapNoAtion{
    //下部视图无点击
}

- (void)quickAddBtn:(UIButton *)sender{
    NSInteger count = [self.numberView.numberLab.text integerValue] + sender.tag;
    if (count >self.maxPayCount)count = self.maxPayCount;
    self.numberView.numberLab.text = [NSString stringWithFormat:@"%zi",count];
    [self priceStrWithCount:count];
}

- (void)payBtnAction{
    self.payBlock();
}

#pragma mark - PayNumberViewDelegate
- (void)deleteBtnAction:(UIButton *)sender addNumberView:(PayNumberView *)view{
    NSInteger number = [view.numberLab.text integerValue] - 1;
    view.numberLab.text = [NSString stringWithFormat:@"%zi",number];
    [self priceStrWithCount:number];
}
- (void)addBtnAction:(UIButton *)sender addNumberView:(PayNumberView *)view{
    NSInteger number = [view.numberLab.text integerValue] + 1;
    if (number >self.maxPayCount)number = self.maxPayCount;
    
    view.numberLab.text = [NSString stringWithFormat:@"%zi",number];
    [self priceStrWithCount:number];
}

@end
