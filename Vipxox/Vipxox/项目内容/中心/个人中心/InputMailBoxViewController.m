//
//  InputMailBoxViewController.m
//  weimao
//
//  Created by 黄佳峰 on 16/2/17.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import "InputMailBoxViewController.h"
#import "ForgetPasswardViewController.h"
#import "HttpManager.h"

@interface InputMailBoxViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UITextField*textField;
@property(nonatomic,strong)UIAlertView*alert;
@end

@implementation InputMailBoxViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(64), KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(64)) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.scrollEnabled=NO;
     
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];

    [self.view addSubview:self.tableView];
}

-(void)makeNavi{
    
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(156), ACTUAL_HEIGHT(34), ACTUAL_WIDTH(69), ACTUAL_WIDTH(19))];
    titleLabel.text=@"输入邮箱";
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    
//    UIButton*button=[UIButton buttonWithType:0];
//    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(25), ACTUAL_HEIGHT(25));
//    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
//    [button setTitle:@"" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
    UIButton*button=[UIButton buttonWithType:0];
    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    
    
    UIButton*nextButton=[UIButton buttonWithType:0];
    nextButton.frame=CGRectMake(ACTUAL_WIDTH(328), ACTUAL_HEIGHT(37), ACTUAL_WIDTH(40), ACTUAL_HEIGHT(15));
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    nextButton.titleLabel.font=[UIFont systemFontOfSize:11];
    [nextButton addTarget:self action:@selector(touchNextButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    
}

-(void)dismissTo{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchNextButton{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
//    http://www.vipxox.cn/?       m=appapi&s=forget_pwd&act=get_code&email=963523556@qq.com
    
      NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"forget_pwd",@"act":@"get_code",@"email":self.textField.text};
    HttpManager *manager=[[HttpManager alloc]init];
[manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
    NSLog(@"%@",data);

    NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
    NSLog(@"%@",number);

    if ([number isEqualToString:@"0"]) {
        
        self.alert=[[UIAlertView alloc]init];
        self.alert.message=@"验证码已发送到您的邮箱";
        [self.alert show];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
        
        ForgetPasswardViewController *vc=[[ForgetPasswardViewController alloc]init];
        vc.getEmail=self.textField.text;
        [self.navigationController pushViewController:vc animated:YES];


    }else{
         [JRToast showWithText:[data objectForKey:@"errorMessage"]];
    }

}];
    
  }

- (void)performDismiss:(NSTimer *)timer
{
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
    [timer invalidate];
    timer = nil;
  
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    self.textField=[[UITextField alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(21), ACTUAL_HEIGHT(12), ACTUAL_WIDTH(245), ACTUAL_HEIGHT(18))];
    self.textField.placeholder=@"请输入您的邮箱账号";
    self.textField.font=[UIFont systemFontOfSize:12];
    [cell.contentView addSubview:self.textField];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ACTUAL_HEIGHT(40);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ACTUAL_HEIGHT(ACTUAL_HEIGHT(23));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

//touch began
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}


- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}


@end
