//
//  AccountSafeViewController.m
//  weimao
//
//  Created by 黄佳峰 on 16/2/16.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import "AccountSafeViewController.h"
#import "ModifiedCodeTableViewCell.h"
#import "STCountDownButton.h"
#import "InputMailBoxViewController.h"
#import "HttpManager.h"

#define ModifiedCode   @"ModifiedCodeTableViewCell"
#define bangdingEmil   @"ModifiedCodeTableViewCell"


@interface AccountSafeViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UIView*stripeView;
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSMutableArray*fourButtons;
@property(nonatomic,strong)UIView*bottomView;

@property(nonatomic,assign)BOOL isModifiedCode;  //yes  是 修改密码
@property(nonatomic,assign)BOOL canSave;    //判断是否符合
@property(nonatomic,strong)UIAlertView*alert;


//修改密码上的3个空间
@property(nonatomic,strong)UIButton*forgetCode;
@property(nonatomic,strong)UIButton*numberButton;
@property(nonatomic,strong)UILabel*serviceLabel;
@property(nonatomic,strong)UIButton*completeButton;

//绑定邮箱上的
@property(nonatomic,strong)UIButton *buttonNext;
//@property(nonatomic,strong)UIButton *buttonGetCode;
@property (nonatomic, strong, nullable)STCountDownButton *countDownCode; //验证码


@end

@implementation AccountSafeViewController


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 99, KScreenWidth,KScreenHeight -99) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    return _tableView;
}


#pragma mark - --- event response 事件相应 ---

- (void)startCountDown:(STCountDownButton *)button {
        ModifiedCodeTableViewCell*cell1=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString*myEmail= cell1.textField.text;
    if (myEmail.length<6) {
        [JRToast showWithText:@"请正确输入您的邮箱"];
        return;
    }else{
      
    //    http://www.vipxox.cn/?  m=appapi&s=system_setup&act=get_code&email=963523556@qq.com
NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
 
NSDictionary*params=@{@"m":@"appapi",@"s":@"system_setup",@"act":@"get_code",@"email":myEmail,@"uid":[UserSession instance].uid};
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        NSLog(@"%@",number);
        
        if ([number isEqualToString:@"0"]) {
            
              [button start];
            [JRToast showWithText:@"验证码发送成功"];
            
        }else{
            [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
            [JRToast showWithText:[data objectForKey:@"errorMessage"]];
        }
        
    }];
}



}

- (void)stopCountDown
{
    [self.countDownCode stop];
}
#pragma mark - --- private methods 私有方法 ---

#pragma mark - --- getters and setters 属性 ---
- (STCountDownButton *)countDownCode
{
    if (!_countDownCode) {
        _countDownCode = [[STCountDownButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(275), 0 , ACTUAL_WIDTH(104), ACTUAL_HEIGHT(44))];
        _countDownCode.backgroundColor = RGBCOLOR(238, 97, 101, 1);
        _countDownCode.titleLabel.font=[UIFont systemFontOfSize:14];
        [_countDownCode setSecond:90];
        [_countDownCode addTarget:self
                           action:@selector(startCountDown:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _countDownCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isModifiedCode=YES;
//    [self makeNavi];
    self.title=[[InternationalLanguage bundle]localizedStringForKey:@"账号与安全" value:nil table:@"Language"];
    [self createView];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[ModifiedCodeTableViewCell class] forCellReuseIdentifier:ModifiedCode];
    [self.tableView registerClass:[ModifiedCodeTableViewCell class] forCellReuseIdentifier:bangdingEmil];
}

//-(void)makeNavi{
//    
//    self.view.backgroundColor=RGBCOLOR(70,73,70,1);
//    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(34), KScreenWidth, ACTUAL_WIDTH(19))];
//    titleLabel.text=@"账号与安全";
//    titleLabel.font=[UIFont systemFontOfSize:16];
//    titleLabel.textColor=[UIColor whiteColor];
//    titleLabel.textAlignment=1;
//    [self.view addSubview:titleLabel];
//    
//    UIButton*button=[UIButton buttonWithType:0];
//    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
//    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//
//    
// }

//-(void)dismissTo{
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(void)compelete{
    if (self.isModifiedCode==YES) {
        
        _canSave=NO;
        NSString *str= [self judgeCanSave];
        
        if (!_canSave) {
            [JRToast showWithText:str];
        }else{

//        http://www.vipxox.cn/?    m=appapi&s=system_setup&act=changepwd&uid=1&pwd=123456&oldPwd=987654
        NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
        ModifiedCodeTableViewCell*cell1=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSString*oldCode= cell1.textField.text;
        
        ModifiedCodeTableViewCell*cell2=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        NSString*newCode= cell2.textField.text;

        
//        www.vipxox.com/?  m=appapi&s=system_setup&act=changepwd&oldPwd=&pwd=&uid=
        
        NSDictionary*params=@{@"m":@"appapi",@"s":@"system_setup",@"act":@"changepwd",@"uid":[UserSession instance].uid,@"pwd":newCode,@"oldPwd":oldCode};
        HttpManager *manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            NSLog(@"%@",data);
            
            NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
            NSLog(@"%@",number);
            
            if ([number isEqualToString:@"0"]) {
                self.alert=[[UIAlertView alloc]init];
                self.alert.message=[NSString stringWithFormat:@"密码修改成功，您的账号为%@！！！",data[@"data"][@"msmessage"][@"user"]];
                
                [self.alert show];
                [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
                [self.navigationController popViewControllerAnimated:YES];
                
                
                
            }else{
                [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
                [JRToast showWithText:[data objectForKey:@"errorMessage"]];
            }
        
        }];
    
        }
}
}


- (void)performDismiss:(NSTimer *)timer
{
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
    [timer invalidate];
    timer = nil;
    
   
        
        
    }



-(NSString*)judgeCanSave{
    _canSave=YES;
    ModifiedCodeTableViewCell*cell1=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString*oldCode= cell1.textField.text;
    
    ModifiedCodeTableViewCell*cell2=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString*newCode= cell2.textField.text;
    
    ModifiedCodeTableViewCell*cell3=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    NSString*nextCode= cell3.textField.text;

    
    NSLog(@"%@",oldCode);
    NSLog(@"%@",newCode);
    NSLog(@"%@",nextCode);
    
    if (oldCode.length<6) {
        _canSave=NO;
        return @"原密码不能小于6位";
    }
    
    if (newCode.length<6) {
        _canSave=NO;
        return @"新密码不能小于6位";
    }
    
    
    if (![newCode isEqualToString:nextCode]) {
        _canSave=NO;
        return @"两次密码输入不一致";
    }
    
    
    return @"滚犊子";
}


//选项条
-(void)createView{
    self.fourButtons=[NSMutableArray array];
    
    self.stripeView=[[UIView alloc]initWithFrame:CGRectMake(0,64, KScreenWidth, 35)];
    self.stripeView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.stripeView];
    
    //0
    UIButton*button0=[UIButton buttonWithType:UIButtonTypeCustom];
    [button0 setTitle:@"修改密码" forState:UIControlStateNormal];
    button0.titleLabel.textAlignment=1;
    [button0 setTitleColor:RGBCOLOR(204, 204, 204, 1) forState:UIControlStateNormal];
    [button0 setTitleColor:RGBCOLOR(70,73,70,1) forState:UIControlStateSelected];
    button0.titleLabel.font=[UIFont systemFontOfSize:14];
    button0.frame=CGRectMake(ACTUAL_WIDTH(0),10, KScreenWidth/2, 15);
    [button0 addTarget:self action:@selector(touchButton0:) forControlEvents:UIControlEventTouchUpInside];
    button0.tag=0;
    [self.fourButtons addObject:button0];
    [self.stripeView addSubview:button0];
    //默认的为0
      button0.selected=YES;
    [self creatButton];
    self.bottomView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), 33, KScreenWidth/2, 2)];
    self.bottomView.backgroundColor=RGBCOLOR(70,73,70,1);
    [self.stripeView addSubview:self.bottomView];
    
    
    //1
    UIButton*button1=[UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"修改绑定的邮箱" forState:UIControlStateNormal];
    button1.titleLabel.textAlignment=1;
    [button1 setTitleColor:RGBCOLOR(204, 204, 204, 1) forState:UIControlStateNormal];
    [button1 setTitleColor:RGBCOLOR(70,73,70,1) forState:UIControlStateSelected];
    button1.titleLabel.font=[UIFont systemFontOfSize:14];
    button1.frame=CGRectMake(KScreenWidth/2, 10, KScreenWidth/2,15);
    [button1 addTarget:self action:@selector(touchButton1:) forControlEvents:UIControlEventTouchUpInside];
    [self.stripeView addSubview:button1];
    button1.tag=1;
    [self.fourButtons addObject:button1];
    
    
    
  }


-(void)touchButton0:(UIButton*)sender{
    for (UIButton*button in self.fourButtons) {
        button.selected=NO;
    }
    
    if (sender.selected) {
        
        sender.selected=NO;
    }else{
        sender.selected=YES;
        [UIView animateWithDuration:0.3 animations:^{
            
            self.bottomView.frame=CGRectMake(ACTUAL_WIDTH(0),33,KScreenWidth/2, 2);
        }];
        
    }
 
    //
    self.isModifiedCode=YES;
    [self.completeButton removeFromSuperview];
    [self.forgetCode removeFromSuperview];
    [self.numberButton removeFromSuperview];
    [self.serviceLabel removeFromSuperview];
    [self.buttonNext removeFromSuperview];
//    self.buttonNext.backgroundColor=[UIColor yellowColor];
    [self.countDownCode removeFromSuperview];
    [self.tableView reloadData];
      [self creatButton];
}
-(void)touchButton1:(UIButton*)sender{
    for (UIButton*button in self.fourButtons) {
        button.selected=NO;
    }
    if (sender.selected) {
        sender.selected=NO;
        
        
    }else{
        sender.selected=YES;
        [UIView animateWithDuration:0.3 animations:^{
            
            self.bottomView.frame=CGRectMake(KScreenWidth/2,33,KScreenWidth/2, 2);
        }];
        
        
    }
        self.isModifiedCode=NO;
      [self.completeButton removeFromSuperview];
    [self.forgetCode removeFromSuperview];
    [self.numberButton removeFromSuperview];
    [self.serviceLabel removeFromSuperview];
    [self.buttonNext removeFromSuperview];
     [self.countDownCode removeFromSuperview];

        [self.tableView reloadData];
         [self creatTwoButton];
    
 
}


#pragma mark ------tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isModifiedCode==YES) {
        return 2;
    }else{
        return 2;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isModifiedCode==YES) {
        if (section==0) {
            return 1;
        }else if (section==1){
            return 2;
        }
        
    }else{
        return 1;
    }
    
    return 0;
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ModifiedCodeTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ModifiedCode];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    cell.textField.text=@"";
    if (self.isModifiedCode==YES) {
        ModifiedCodeTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ModifiedCode];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        if (indexPath.section==0&&indexPath.row==0) {
           cell.label.text=@"原密码";
    
            cell.textField.placeholder=@"请输入原密码";
            cell.textField.secureTextEntry=YES;
        }else if (indexPath.section==1&&indexPath.row==0){
            cell.label.text=@"新密码";
            cell.textField.placeholder=@"字母或者数字6-12位";
            cell.textField.secureTextEntry=YES;
            
        }else if (indexPath.section==1&&indexPath.row==1){
            cell.label.text=@"重复密码";
            cell.textField.placeholder=@"重复输入一次新密码";
            cell.textField.secureTextEntry=YES;
        }
     
//        [self creatButton];
              return cell;
    }else{
        ModifiedCodeTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"celll"];
        if (!cell) {
            cell=[[ModifiedCodeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"celll"];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        //绑定邮箱
        if (indexPath.section==0) {
            cell.label.text=@"新邮箱";
            cell.textField.placeholder=@"请输入邮箱地址";
            [cell.contentView addSubview:self.countDownCode];
        }else if (indexPath.section==1){
            cell.label.text=@"验证码";
            cell.textField.placeholder=@"请输入邮箱验证码";
        }
//        [self creatTwoButton];
        return cell;
    }
  
    return cell;
}
//修改密码的
-(void)creatButton{
    self.forgetCode=[UIButton buttonWithType:0];
    self.forgetCode.frame=CGRectMake(ACTUAL_WIDTH(290), ACTUAL_HEIGHT(204), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(30));
//    self.forgetCode.titleLabel.text=@"忘记密码？";
//    self.forgetCode.backgroundColor=[UIColor blueColor];
    self.forgetCode.titleLabel.font=[UIFont systemFontOfSize:12];
    [self.forgetCode setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [self.forgetCode setTitleColor:RGBCOLOR(166, 166, 166, 1) forState:UIControlStateNormal];
    [self.forgetCode addTarget:self action:@selector(forgetCoding) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:self.forgetCode];
    
    
    self.serviceLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(242), ACTUAL_WIDTH(150), ACTUAL_HEIGHT(15))];
    self.serviceLabel.text=@"客服热线:";
    self.serviceLabel.font=[UIFont systemFontOfSize:14];
    self.serviceLabel.textAlignment=2;
    self.serviceLabel.textColor=RGBCOLOR(119, 119, 119, 1);
    [self.tableView addSubview:self.serviceLabel];
    
    self.numberButton=[UIButton buttonWithType:0];
    self.numberButton.frame=CGRectMake(ACTUAL_WIDTH(150), ACTUAL_HEIGHT(242), ACTUAL_WIDTH(160), ACTUAL_HEIGHT(15));
    self.numberButton.titleLabel.textAlignment=0;
    self.numberButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.numberButton setTitleColor:RGBCOLOR(75, 75, 75, 1) forState:UIControlStateNormal];
    [self.numberButton addTarget:self action:@selector(touchNumber) forControlEvents:UIControlEventTouchUpInside];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"86-02158179796"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [self.numberButton setAttributedTitle:str forState:UIControlStateNormal];
    [self.tableView addSubview:self.numberButton];
    
    //完成按钮
    self.completeButton=[UIButton buttonWithType:0];
     self.completeButton.frame=CGRectMake(ACTUAL_WIDTH(330), ACTUAL_HEIGHT(36), ACTUAL_WIDTH(45), ACTUAL_WIDTH(16));
    [ self.completeButton setTitle:@"完成" forState:UIControlStateNormal];
     self.completeButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [ self.completeButton addTarget:self action:@selector(compelete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.completeButton];

    
    
}
//绑定邮箱的
-(void)creatTwoButton{
    self.buttonNext=[UIButton buttonWithType:0];
    self.buttonNext.frame=CGRectMake(ACTUAL_WIDTH(17), ACTUAL_HEIGHT(168), ACTUAL_WIDTH(345), ACTUAL_HEIGHT(49));
//    self.buttonNext.titleLabel.text=@"下一步";
    [self.buttonNext setTitle:@"完成" forState:UIControlStateNormal];
    self.buttonNext.titleLabel.textColor=[UIColor whiteColor];
    self.buttonNext.layer.cornerRadius=3;
    self.buttonNext.backgroundColor=RGBCOLOR(70,73,70,1);
    [self.buttonNext addTarget:self action:@selector(bindingEmail) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:self.buttonNext];
    
}
//绑定邮箱  完成按钮
-(void)bindingEmail{
    //
    ModifiedCodeTableViewCell*cell1=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString*myEmail= cell1.textField.text;
    
    ModifiedCodeTableViewCell*yanzhenCode=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString*showCode= yanzhenCode.textField.text;

    if (myEmail.length<6) {
        [JRToast showWithText:@"请正确输入您的邮箱"];
        return;
    }else if (showCode.length<6){
        [JRToast showWithText:@"请正确输入您的邮箱验证码"];
        return;

    }
    
    else{
//http://www.vipxox.cn/?    m=appapi&s=system_setup&act=Bind_mailbox&email=963523556@qq.com&uid=47&code=456
        NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
NSDictionary*params=@{@"m":@"appapi",@"s":@"system_setup",@"act":@"Bind_mailbox",@"email":myEmail,@"uid":[UserSession instance].uid,@"code":showCode};
        HttpManager *manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            NSLog(@"%@",data);
            
            NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
            NSLog(@"%@",number);
            
            if ([number isEqualToString:@"0"]) {
                
                
                [JRToast showWithText:@"绑定成功"];
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }else{
                [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
                [JRToast showWithText:[data objectForKey:@"errorMessage"]];
            }
            
        }];

    }
}

-(void)touchNumber{
    
    
}
-(void)forgetCoding{
    //忘记密码：
    InputMailBoxViewController*vc=[[InputMailBoxViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isModifiedCode==NO) {
        if (section==0) {
            return ACTUAL_HEIGHT(25);
        }else if (section==1){
            return ACTUAL_HEIGHT(10);
        }
            }
    
    return ACTUAL_HEIGHT(25);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.isModifiedCode==NO) {
        return 0.001;
    }
    
    return ACTUAL_HEIGHT(12);
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ACTUAL_HEIGHT(44);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
