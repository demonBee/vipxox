//
//  WithdrawDespositViewController.m
//  weimao
//
//  Created by Tian Wei You on 16/2/21.
//  Copyright © 2016年 Tian Wei You. All rights reserved.
//

#import "WithdrawDespositViewController.h"

@interface WithdrawDespositViewController ()

@property(nonatomic,strong)UITextField*text1;
@property(nonatomic,strong)UITextField*text2;

@end

@implementation WithdrawDespositViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self makeNavi];
    self.title=@"提现申请";
    self.navigationController.navigationBarHidden=NO;
    [self makeView];
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(18), ACTUAL_HEIGHT(357), ACTUAL_WIDTH(331), ACTUAL_HEIGHT(48))];
    button.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    [button setTitleColor:[UIColor whiteColor] forState:0];
    [button setTitle:@"申请提现" forState:0];
    [button addTarget:self action:@selector(drawCrash) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)makeNavi{
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(34),KScreenWidth, ACTUAL_WIDTH(19))];
    titleLabel.text=@"提现申请";
    titleLabel.textAlignment=1;
    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton*button=[UIButton buttonWithType:0];
    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)dismissTo{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)makeView{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64)];
    view.backgroundColor=RGBCOLOR(247, 247, 247, 1);
    [self.view addSubview:view];
    
    UILabel*label1=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(17), ACTUAL_HEIGHT(87), ACTUAL_WIDTH(334), ACTUAL_HEIGHT(71))];
    
    label1.text=@"支付宝";
    label1.font=[UIFont fontWithName:@"Arial" size:18];
    [self.view addSubview:label1];
    
    _text2=[[UITextField alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(95), ACTUAL_HEIGHT(110),KScreenWidth-ACTUAL_WIDTH(130), ACTUAL_HEIGHT(25))];
    _text2.textColor=RGBCOLOR(239, 97, 101, 1);
    _text2.font=[UIFont fontWithName:@"Arial" size:20];
    _text2.placeholder=@"请输入帐号";
//    _text2.backgroundColor=[UIColor redColor];
    _text2.textAlignment=NSTextAlignmentCenter;
    [_text2 setValue:[UIFont boldSystemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:_text2];
    
    _text1=[[UITextField alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(95), ACTUAL_HEIGHT(219),KScreenWidth-ACTUAL_WIDTH(130), ACTUAL_HEIGHT(25))];
    _text1.textColor=RGBCOLOR(239, 97, 101, 1);
    _text1.keyboardType=UIKeyboardTypeNumberPad;
    _text1.font=[UIFont fontWithName:@"Arial" size:20];
    _text1.textAlignment=NSTextAlignmentCenter;
    _text1.placeholder=@"请输入金额";
//    _text1.backgroundColor=[UIColor blueColor];
    [_text1 setValue:[UIFont boldSystemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:_text1];
    
    UILabel*label2=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(17), ACTUAL_HEIGHT(156), ACTUAL_WIDTH(334), ACTUAL_HEIGHT(50))];
    label2.text=@"提现金额";
    label2.font=[UIFont fontWithName:@"Arial" size:16];
    [self.view addSubview:label2];
    
    UILabel*label3=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(17), ACTUAL_HEIGHT(207), ACTUAL_WIDTH(34), ACTUAL_HEIGHT(50))];
    label3.text=[NSString stringWithFormat:@"%@",[UserSession instance].currency];
    label3.font=[UIFont systemFontOfSize:22];
    [self.view addSubview:label3];
    
    UILabel*label4=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(17), ACTUAL_HEIGHT(269), ACTUAL_WIDTH(334), ACTUAL_HEIGHT(46))];
    float floatString = [[UserSession instance].cash floatValue];
    label4.text=[NSString stringWithFormat:@"当前零钱余额：%@%0.2f",[UserSession instance].currency,floatString];
    label4.font=[UIFont fontWithName:@"Arial" size:14];
    label4.textColor=[UIColor grayColor];
    [self.view addSubview:label4];
    
    UILabel*label5=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(325),KScreenWidth, ACTUAL_HEIGHT(18))];
    label5.text=@"24小时内到账";
    label5.textAlignment=1;
    label5.font=[UIFont fontWithName:@"Arial" size:12];
    label5.textColor=[UIColor grayColor];
    [self.view addSubview:label5];

}
-(void)drawCrash{
//http://www.vipxox.cn/?  m=appapi&s=membercenter&act=withdraw_apply&uid=8&money=200&cardno=961252552
 
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"withdraw_apply",@"uid":[UserSession instance].uid,@"money":_text1.text,@"cardno":_text2.text};
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];

    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        NSLog(@"%@",number);
        
        if ([number isEqualToString:@"0"]) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"操作成功！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
        }else{
            NSLog(@"%@",data[@"errorMessage"]);
            UIAlertView *alter1 = [[UIAlertView alloc] initWithTitle:data[@"errorMessage"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter1 show];
        }
    }];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
