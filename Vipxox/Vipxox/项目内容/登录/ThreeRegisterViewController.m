//
//  RegisterViewController.m
//  Vipxox
//
//  Created by Brady on 16/3/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ThreeRegisterViewController.h"
//#import "PersonCenterViewController.h"
#import "STCountDownButton.h"
#import "YLWTabBarController.h"

@interface ThreeRegisterViewController ()
@property(nonatomic,strong)UITextField *consumerNameTextField;
@property(nonatomic,strong) UITextField *mailBoxTextField;
//@property(nonatomic,strong)UITextField *testCodeTextField;
//@property(nonatomic,strong) STCountDownButton *obtainTextCodeButton;
@property(nonatomic,strong)UITextField *secretCodeTextField;
@property(nonatomic,strong) UITextField *sureSecretCodeTextField;

@property(nonatomic,assign)BOOL canSave;
@end

@implementation ThreeRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatView];
}

-(void)creatView{
    
    //设置背景图片
    UIImageView*mainView=[[UIImageView alloc]init];
    mainView.frame=self.view.frame;
    mainView.image=[UIImage imageNamed:@"View"];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:mainView];
    
    //设置“注册拥吻汇Vipxox”标签
    UILabel *LogoLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(125), ACTUAL_HEIGHT(34), ACTUAL_WIDTH(130), ACTUAL_HEIGHT(20))];
    LogoLabel.text=@"注册拥吻汇Vipxox";
    LogoLabel.font=[UIFont systemFontOfSize:16];
    LogoLabel.textColor=RGBCOLOR(236, 237, 238, 1);
    [self.view addSubview:LogoLabel];
    
    //“输入用户名”
    UIView *consumerNameView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(95), ACTUAL_WIDTH(336), ACTUAL_HEIGHT(40))];
    consumerNameView.layer.borderColor = [RGBCOLOR(146, 147, 148, 1)CGColor];
    consumerNameView.layer.borderWidth = 2;
    consumerNameView.layer.cornerRadius=3;
    consumerNameView.backgroundColor=RGBCOLOR(160, 161, 162, 0.5);
    [self.view addSubview:consumerNameView];
    
    _consumerNameTextField=[[UITextField alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(19), ACTUAL_HEIGHT(2), ACTUAL_WIDTH(317), ACTUAL_HEIGHT(36))];
    _consumerNameTextField.backgroundColor=[UIColor clearColor];
    _consumerNameTextField.placeholder=@"输入用户名";
    _consumerNameTextField.textColor=RGBCOLOR(142, 143, 144, 1);
    _consumerNameTextField.keyboardType=UIKeyboardTypeEmailAddress;
    [_consumerNameTextField setValue:RGBCOLOR(198, 199, 200, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_consumerNameTextField setValue:[UIFont boldSystemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    _consumerNameTextField.textColor=[UIColor whiteColor];
    [consumerNameView addSubview:_consumerNameTextField];
    
    
    //“输入邮箱”
    UIView *mailBoxView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(155), ACTUAL_WIDTH(336), ACTUAL_HEIGHT(40))];
    mailBoxView.layer.borderColor = [RGBCOLOR(146, 147, 148, 1)CGColor];
    mailBoxView.layer.borderWidth = 2;
    mailBoxView.layer.cornerRadius=3;
    mailBoxView.backgroundColor=RGBCOLOR(160, 161, 162, 0.5);
    [self.view addSubview:mailBoxView];
    
    _mailBoxTextField=[[UITextField alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(19), ACTUAL_HEIGHT(2), ACTUAL_WIDTH(317), ACTUAL_HEIGHT(36))];
    _mailBoxTextField.backgroundColor=[UIColor clearColor];
    _mailBoxTextField.placeholder=@"输入邮箱";
    _mailBoxTextField.textColor=RGBCOLOR(142, 143, 144, 1);
    _mailBoxTextField.keyboardType=UIKeyboardTypeEmailAddress;
    [_mailBoxTextField setValue:RGBCOLOR(198, 199, 200, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_mailBoxTextField setValue:[UIFont boldSystemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    _mailBoxTextField.textColor=[UIColor whiteColor];
    [mailBoxView addSubview:_mailBoxTextField];
    
//    //“输入验证码”
//    UIView *testCodeView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(217), ACTUAL_WIDTH(182), ACTUAL_HEIGHT(40))];
//    testCodeView.layer.borderColor = [RGBCOLOR(146, 147, 148, 1)CGColor];
//    testCodeView.layer.borderWidth = 2;
//    testCodeView.layer.cornerRadius=3;
//    testCodeView.backgroundColor=RGBCOLOR(160, 161, 162, 0.5);
//    [self.view addSubview:testCodeView];
//    
//    _testCodeTextField=[[UITextField alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(19), ACTUAL_HEIGHT(2), ACTUAL_WIDTH(163), ACTUAL_HEIGHT(36))];
//    _testCodeTextField.backgroundColor=[UIColor clearColor];
//    _testCodeTextField.placeholder=@"输入验证码";
//    _testCodeTextField.textColor=RGBCOLOR(142, 143, 144, 1);
//    _testCodeTextField.keyboardType=UIKeyboardTypeEmailAddress;
//    [_testCodeTextField setValue:RGBCOLOR(198, 199, 200, 1) forKeyPath:@"_placeholderLabel.textColor"];
//    [_testCodeTextField setValue:[UIFont boldSystemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
//    _testCodeTextField.textColor=[UIColor whiteColor];
//    [testCodeView addSubview:_testCodeTextField];
//    
//    //“获取验证码”按钮
//    _obtainTextCodeButton=[[STCountDownButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(231), ACTUAL_HEIGHT(217), ACTUAL_WIDTH(126), ACTUAL_HEIGHT(40))];
//    [_obtainTextCodeButton setTitle:@"获取验证码" forState:0];
//    [_obtainTextCodeButton setTitleColor:[UIColor whiteColor] forState:0];
//    _obtainTextCodeButton.layer.borderWidth = 2;
//    _obtainTextCodeButton.layer.cornerRadius=3;
//    _obtainTextCodeButton.backgroundColor=RGBCOLOR(145, 146, 147, 0.5);
//    _obtainTextCodeButton.layer.borderColor = [RGBCOLOR(155, 156, 157, 1)CGColor];
//    [_obtainTextCodeButton addTarget:self action:@selector(touchObtain:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:_obtainTextCodeButton];
    
    //“输入密码”
    UIView *secretCodeView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(217), ACTUAL_WIDTH(336), ACTUAL_HEIGHT(40))];
    secretCodeView.layer.borderColor = [RGBCOLOR(146, 147, 148, 1)CGColor];
    secretCodeView.layer.borderWidth = 2;
    secretCodeView.layer.cornerRadius=3;
    secretCodeView.backgroundColor=RGBCOLOR(160, 161, 162, 0.5);
    [self.view addSubview:secretCodeView];
    
    _secretCodeTextField=[[UITextField alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(19), ACTUAL_HEIGHT(2), ACTUAL_WIDTH(317), ACTUAL_HEIGHT(36))];
    _secretCodeTextField.backgroundColor=[UIColor clearColor];
    _secretCodeTextField.placeholder=@"输入密码";
    _secretCodeTextField.textColor=RGBCOLOR(142, 143, 144, 1);
    _secretCodeTextField.keyboardType=UIKeyboardTypeEmailAddress;
    _secretCodeTextField.secureTextEntry=YES;
    [_secretCodeTextField setValue:RGBCOLOR(198, 199, 200, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_secretCodeTextField setValue:[UIFont boldSystemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    _secretCodeTextField.textColor=[UIColor whiteColor];
    [secretCodeView addSubview:_secretCodeTextField];
    
    //“确认密码”
    UIView *sureSecretCodeView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(276), ACTUAL_WIDTH(336), ACTUAL_HEIGHT(40))];
    sureSecretCodeView.layer.borderColor = [RGBCOLOR(146, 147, 148, 1)CGColor];
    sureSecretCodeView.layer.borderWidth = 2;
    sureSecretCodeView.layer.cornerRadius=3;
    sureSecretCodeView.backgroundColor=RGBCOLOR(160, 161, 162, 0.5);
    [self.view addSubview:sureSecretCodeView];
    
    _sureSecretCodeTextField=[[UITextField alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(19), ACTUAL_HEIGHT(2), ACTUAL_WIDTH(317), ACTUAL_HEIGHT(36))];
    _sureSecretCodeTextField.backgroundColor=[UIColor clearColor];
    _sureSecretCodeTextField.placeholder=@"确认密码";
    _sureSecretCodeTextField.secureTextEntry=YES;
    _sureSecretCodeTextField.textColor=RGBCOLOR(142, 143, 144, 1);
    _sureSecretCodeTextField.keyboardType=UIKeyboardTypeEmailAddress;
    [_sureSecretCodeTextField setValue:RGBCOLOR(198, 199, 200, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_sureSecretCodeTextField setValue:[UIFont boldSystemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
    _sureSecretCodeTextField.textColor=[UIColor whiteColor];
    [sureSecretCodeView addSubview:_sureSecretCodeTextField];
    
    
    //“确定”按钮
    UIButton *sureButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(336), ACTUAL_WIDTH(338), ACTUAL_HEIGHT(45))];
    sureButton.backgroundColor=RGBCOLOR(205, 206, 207, 1);
    [sureButton setTitle:@"确定" forState:0];
    [sureButton setTitleColor:RGBCOLOR(251, 252, 253, 1) forState:0];
    sureButton.layer.cornerRadius=3;
    [sureButton addTarget:self action:@selector(comeBackToEnterView) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:sureButton];
    
    //“请输入您要的注册邮箱地址”
    UILabel *promptLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(112), ACTUAL_HEIGHT(398), ACTUAL_WIDTH(154), ACTUAL_HEIGHT(20))];
    promptLabel.text=@"请输入您要注册的邮箱地址";
    promptLabel.textColor=[UIColor whiteColor];
    promptLabel.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:promptLabel];
    
    //返回按钮
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(18), ACTUAL_HEIGHT(28), ACTUAL_WIDTH(30), ACTUAL_HEIGHT(30))];
    //    backButton.backgroundColor=[UIColor whiteColor];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:0];
    [backButton addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
}

-(void)touchObtain:(STCountDownButton*)sender{
    if (self.mailBoxTextField.text.length<6) {
        [JRToast showWithText:@"请正确输入您的邮箱" duration:1.0];
    }else{
        
        sender.second=30;
        [sender start];
        //获取验证码
        //    	http://www.vipxox.cn/ ?m=appapi&s=register&zt=1&email=
        NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
        NSDictionary*dict=@{@"m":@"appapi",@"s":@"register",@"zt":@"1",@"email":self.mailBoxTextField.text};
        HttpManager*manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkWithUrl:urlStr parameters:dict compliation:^(id data, NSError *error) {
            
            NSLog(@"%@",data);
            
            if ([data[@"errorCode"] isEqualToString:@"0"]) {
                [JRToast showWithText:data[@"errorMessage"] duration:1.0];
            }else{
                [JRToast showWithText:data[@"errorMessage"] duration:1.0];
            }
            
        }];
    }
}

//确定
-(void)comeBackToEnterView{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    NSString*str=[self judgeCanSave];
    if (!_canSave) {
        [JRToast showWithText:str duration:1.0];
    }else{
        //
//        http://www.vx.dev/  ?m=appapi&s=connect_register
#pragma mark -----重新注册的绑定
        NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
        NSString*user=self.consumerNameTextField.text;
        NSString*pwd=self.secretCodeTextField.text;
        NSString*email=self.mailBoxTextField.text;
    NSDictionary*params=@{@"m":@"appapi",@"s":@"connect_register",@"zt":@"register",@"user":user,@"pwd":pwd,@"email":email,@"cid":self.cid};
       HttpManager*manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            NSLog(@"%@",data);
            if ([data[@"errorCode"] isEqualToString:@"0"]) {
                
                NSDictionary*user=data[@"data"][@"user"];
                NSArray*address=data[@"data"][@"address"];
                
                UserSession*session=[UserSession instance];
                [session setValuesForKeysWithDictionary:user];
                session.address=address;
                //已经登录改为yes
                session.isLogin=YES;
                
                //自动登录
                NSUserDefaults*Nsuser=[NSUserDefaults standardUserDefaults];
//                [Nsuser setObject:session.user forKey:AUTOLOGIN];
//                [Nsuser setObject:self.secretCodeTextField.text forKey:AUTOLOGINCODE];
                [Nsuser removeObjectForKey:AUTOLOGIN];
                [Nsuser removeObjectForKey:AUTOLOGINCODE];
                [Nsuser setObject:@"YES" forKey:ISTHIRDLOGIN];
                [Nsuser setObject:self.params forKey:ISTHIRDPARAMS];

                

            //释放键盘
                
                  [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
                //成功赋值后 跳转
//                [UIApplication sharedApplication].keyWindow.rootViewController = [[YLWTabBarController alloc] init];

                 [[NSNotificationCenter defaultCenter]postNotificationName:@"loginDismiss" object:nil];
                
                
            }else{
                [JRToast showWithText:data[@"errormsg"]];
            }
            
            
            
        }];
        
        
        
        
    }
    
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

-(NSString*)judgeCanSave{
    _canSave=YES;
    if (self.consumerNameTextField.text.length<2) {
        _canSave=NO;
        return @"用户名不能小于2位";
    }else if (self.mailBoxTextField.text.length<6){
        _canSave=NO;
        return @"请正确输入邮箱";
    }else if (self.secretCodeTextField.text.length<6){
        _canSave=NO;
        return @"密码不能小于6位";
    }else if (![self.secretCodeTextField.text isEqualToString:self.sureSecretCodeTextField.text]){
        _canSave=NO;
        return @"两次密码输入不一致";
        
    }
    
    return @"";
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)dismissTo{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
