//
//  ABoutWeViewController.m
//  weimao
//
//  Created by 黄佳峰 on 16/2/15.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import "ABoutWeViewController.h"

@interface ABoutWeViewController ()<UITextViewDelegate>

@property(nonatomic,strong)UITableView*tableView;

@end

@implementation ABoutWeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self makeNavi];
    [self makeView];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=[[InternationalLanguage bundle]localizedStringForKey:@"关于我们" value:nil table:@"Language"];
//    self.view.backgroundColor=RGBCOLOR(70,73,70,1);
}

//-(void)makeNavi{
//    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(34), KScreenWidth, ACTUAL_WIDTH(19))];
//    titleLabel.text=@"关于Vipxox";
//    titleLabel.font=[UIFont systemFontOfSize:16];
//    titleLabel.textAlignment=1;
//    titleLabel.textColor=[UIColor whiteColor];
//    [self.view addSubview:titleLabel];
//    
//    UIButton*button=[UIButton buttonWithType:0];
//    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
//    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//    
//    
//}

-(void)makeView{
    UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), 64, KScreenWidth, KScreenHeight-64)];
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:16];
    textView.scrollEnabled =YES;
    textView.editable = NO;
    textView.text=@"        拥吻汇vipxox app是一款由上海镀锐信息科技公司研发帮助海外华人购买国货思念故乡的平台，对接了淘宝天猫等国内大型电商的上千万款商品，通过提供网红导购，专业仓储以及强大的国内外物流配送帮助海外华人用更短的时间更少的金钱轻松海淘国货并获得更好的购物体验，vipxox为全球200多个国家1000多万用户提供贴心周到的服务，让您在国外轻松吃到海底捞老干妈。\n\n功能介绍：\n\n1.商城：包含男装/女装/童装/生活用品等一系列爆款商品, vipxox自主采购并提供全球包邮政策。\n\n2.华人超市：中国特色海底捞,有友鸡爪,老干妈,卫龙等一系列零食小吃，北美地区海外仓专业仓储，满50包邮，价格横扫大统华。\n\n3.逛街：在中国大型电商网站里寻找您喜爱的宝贝，vipxox帮您代购，提供中国仓储以及一系列国际物流配送最优方案。\n\n4.转运：提供中国仓储，作为您国内最忠实的'亲戚'帮您代收货。\n\n5.用户中心：了解所有订单处理进度，查询包裹行踪，消费记录，财务信息，一切尽在掌握。\n\nvipxox官方微信：拥吻汇vipxox\n\n        vipxox, 拥吻汇, 海淘, 逆向代购, 华人超市, 北美生活, 北美吃货, dotdotbuy, panli, 日本零食, 韩国零食, 海外淘宝, 北美省钱快报, 北美泡妞, 北美交友, 加拿大省钱快报, 华人社区, 北美找丢网";
    
    [self.view addSubview:textView];
}


-(void)dismissTo{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
