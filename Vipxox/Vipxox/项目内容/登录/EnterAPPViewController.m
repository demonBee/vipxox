//
//  EnterAPPViewController.m
//  Vipxox
//
//  Created by Brady on 16/3/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "EnterAPPViewController.h"
#import "RegisterViewController.h"
#import "ForgetSecretCodeViewController.h"
//#import "XXTabBarController.h"
#import "UMSocial.h"
#import "YLWTabBarController.h"

#import "ThreePartLoginViewController.h"      //绑定帐号

@interface EnterAPPViewController ()< UMSocialUIDelegate>
@property(nonatomic,assign)BOOL canSave;
@property(nonatomic,strong)UIButton *SCButtom;
@property(nonatomic,strong)UITextField*accountTextField;
@property(nonatomic,strong)UITextField*secretcodeTextField;
@end

@implementation EnterAPPViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self creatView];
    [self addbutton];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissThisView) name:@"loginDismiss" object:nil];
}

-(void)dismissThisView{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

//-(void)autoLogin{
//   NSUserDefaults*defaults= [NSUserDefaults standardUserDefaults];
//    NSString*account=[defaults objectForKey:AUTOLOGIN];
//    NSString*code=[defaults objectForKey:AUTOLOGINCODE];
//    //接口
//    //        http://www.vipxox.cn/? m=appapi&s=login&user=baobao&pwd=123456
//    NSString*url=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
//    NSDictionary*params=@{@"m":@"appapi",@"s":@"login",@"user":account,@"pwd":code};
//    HttpManager*manager=[[HttpManager alloc]init];
//    [manager getDataFromNetworkWithUrl:url parameters:params compliation:^(id data, NSError *error) {
//        NSLog(@"%@",data);
//        if ([data[@"errorCode"] isEqualToString:@"0"]) {
//            NSDictionary*user=data[@"data"][@"user"];
//            NSArray*address=data[@"data"][@"address"];
//            
//            UserSession*session=[UserSession instance];
//            
//            [session setValuesForKeysWithDictionary:user];
//            session.address=address;
//            session.isLogin=YES;
//            
//            //成功赋值后 跳转
//            [UIApplication sharedApplication].keyWindow.rootViewController = [[YLWTabBarController alloc] init];
////           XXTabBarController*vc= [[XXTabBarController alloc]init];
////            [self presentViewController:vc animated:YES completion:nil];
//            
//        }else{
//            NSUserDefaults*user= [NSUserDefaults standardUserDefaults];
//            [user removeObjectForKey:AUTOLOGIN];
//            [user removeObjectForKey:AUTOLOGINCODE];
//            UserSession*session=[UserSession instance];
//            session=nil;
//            [JRToast showWithText:data[@"errorMessage"] duration:1];
//            
//            //登录失败  删除值后跳转
//        [UIApplication sharedApplication].keyWindow.rootViewController = [[YLWTabBarController alloc] init];
////            XXTabBarController*vc= [[XXTabBarController alloc]init];
////            [self presentViewController:vc animated:YES completion:nil];
//
//        }
//    }];
//}



//返回按钮
-(void)addbutton{
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(320),ACTUAL_HEIGHT(40), ACTUAL_WIDTH(30), ACTUAL_HEIGHT(30))];
    [button setBackgroundImage:[UIImage imageNamed:@"close"] forState:0];
    [button addTarget:self action:@selector(touchStart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)touchStart{
//    self.tabBarController.selectedIndex=0;
//    self.tabBarController.selectedIndex… = 下标
    [self dismissViewControllerAnimated:YES completion:nil];

}



-(void)creatView{
    
    //设置背景图片
    UIImageView*mainView=[[UIImageView alloc]init];
    mainView.frame=self.view.frame;
    mainView.image=[UIImage imageNamed:@"View"];
    mainView.backgroundColor=[UIColor whiteColor];
    mainView.contentMode=UIViewContentModeScaleAspectFit;

    [self.view addSubview:mainView];
    
//    self.view.backgroundColor=[UIColor colorWithPatternImage: [UIImage imageNamed:@"View"] ];
    
    //设置“拥吻汇”Logo
    UIImageView *LogoImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LogoTitle"]];
    LogoImageView.frame=CGRectMake(ACTUAL_WIDTH(98), ACTUAL_HEIGHT(100), ACTUAL_WIDTH(210), ACTUAL_HEIGHT(70));
//    LogoImageView.backgroundColor=[UIColor whiteColor];
    LogoImageView.contentMode=UIViewContentModeScaleAspectFit;

    [self.view addSubview:LogoImageView];
    
    //设置账号
    UIView *accountNumberView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(285), ACTUAL_WIDTH(336), ACTUAL_HEIGHT(40))];
    accountNumberView.layer.borderColor = [RGBCOLOR(170, 171, 172, 1)CGColor];
    accountNumberView.layer.borderWidth = 2;
    accountNumberView.layer.cornerRadius=3;
    accountNumberView.backgroundColor=RGBCOLOR(160, 161, 162, 1);
    [self.view addSubview:accountNumberView];
    
    UITextField *accountNumberTextField=[[UITextField alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(51), ACTUAL_HEIGHT(2), ACTUAL_WIDTH(284), ACTUAL_HEIGHT(36))];
//    accountNumberTextField.backgroundColor=[UIColor yellowColor];
    accountNumberTextField.placeholder=@"  账号／邮箱";
    accountNumberTextField.textColor=RGBCOLOR(198, 199, 200, 1);
    accountNumberTextField.keyboardType=UIKeyboardTypeEmailAddress;
    [accountNumberTextField setValue:RGBCOLOR(198, 199, 200, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [accountNumberTextField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    self.accountTextField=accountNumberTextField;
    accountNumberTextField.textColor=[UIColor whiteColor];
    [accountNumberView addSubview:accountNumberTextField];
    
    UIImageView *ANImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"account"]];
    ANImageView.frame=CGRectMake(ACTUAL_WIDTH(18), ACTUAL_HEIGHT(8), ACTUAL_WIDTH(20), ACTUAL_HEIGHT(22));
//    ANImageView.backgroundColor=[UIColor whiteColor];
//    ANImageView.contentMode=UIViewContentModeScaleAspectFit;

    [accountNumberView addSubview:ANImageView];
    
    //设置密码
    UIView *secretCodeView=[[UIView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(340), ACTUAL_WIDTH(336), ACTUAL_HEIGHT(40))];
    secretCodeView.layer.borderColor = [RGBCOLOR(170, 171, 172, 1)CGColor];
    secretCodeView.layer.borderWidth = 2;
    secretCodeView.layer.cornerRadius=3;
    secretCodeView.backgroundColor=RGBCOLOR(160, 161, 162, 1);

    [self.view addSubview:secretCodeView];
    
    _secretcodeTextField=[[UITextField alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(51), ACTUAL_HEIGHT(2), ACTUAL_WIDTH(244), ACTUAL_HEIGHT(36))];
//    secretCodeTextField.backgroundColor=[UIColor yellowColor];
    _secretcodeTextField.placeholder=@"  密码";
    _secretcodeTextField.secureTextEntry=YES;
    _secretcodeTextField.textColor=RGBCOLOR(198, 199, 200, 1);
    _secretcodeTextField.keyboardType=UIKeyboardTypeEmailAddress;
    [_secretcodeTextField setValue:RGBCOLOR(198, 199, 200, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_secretcodeTextField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    self.secretcodeTextField=_secretcodeTextField;
    _secretcodeTextField.textColor=[UIColor whiteColor];
    [secretCodeView addSubview:_secretcodeTextField];
    
    UIImageView *SCImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"secretCode"]];
    SCImageView.frame=CGRectMake(ACTUAL_WIDTH(18), ACTUAL_HEIGHT(8), ACTUAL_WIDTH(20), ACTUAL_HEIGHT(23));
//    SCImageView.backgroundColor=[UIColor whiteColor];
    SCImageView.contentMode=UIViewContentModeScaleAspectFit;

    [secretCodeView addSubview:SCImageView];
    
    _SCButtom=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(295), ACTUAL_HEIGHT(12), ACTUAL_WIDTH(35), ACTUAL_HEIGHT(15))];
//    SCButtom.backgroundColor=[UIColor redColor];
    [_SCButtom setBackgroundImage:[UIImage imageNamed:@"不显示密码"] forState:0];
    [_SCButtom setBackgroundImage:[UIImage imageNamed:@"显示密码"] forState:UIControlStateSelected];
    [_SCButtom addTarget:self action:@selector(showSecretCode) forControlEvents:UIControlEventTouchUpInside];
    [secretCodeView addSubview:_SCButtom];
    
    
    //“登录”按钮
    UIButton *enterButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(394), ACTUAL_WIDTH(337), ACTUAL_HEIGHT(40))];
    enterButton.backgroundColor=RGBCOLOR(205, 206, 207, 1);
    [enterButton setTitle:@"登录" forState:0];
    [enterButton setTitleColor:[UIColor whiteColor] forState:0];
    [enterButton addTarget:self action:@selector(touchEnterButton:) forControlEvents:UIControlEventTouchUpInside];
    enterButton.layer.cornerRadius=3;
    [self.view addSubview:enterButton];
    
    //“忘记密码”按钮
    UIButton *forgetSCButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(298), ACTUAL_HEIGHT(448), ACTUAL_WIDTH(56), ACTUAL_HEIGHT(20))];
    [forgetSCButton setTitle:@"忘记密码" forState:0];
    if (IS_IPHONE_5) {
        forgetSCButton.width=56;
    }
    [forgetSCButton setTitleColor:[UIColor whiteColor] forState:0];
    forgetSCButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [forgetSCButton addTarget:self action:@selector(gotoForgetPasswod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetSCButton];
    
    //“注册”按钮
    UIButton *registerButton=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(122), ACTUAL_HEIGHT(620), ACTUAL_WIDTH(130), ACTUAL_HEIGHT(15))];
//    registerButton.backgroundColor=[UIColor redColor];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"register"] forState:0];
    [registerButton addTarget:self action:@selector(gotoRegisterView) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:registerButton];
    
    
    
    
    
#pragma mark----------懒得写第三方登录了   烦的一比
//    //第三方登录按钮
    //微信登录
    UIButton*button=[UIButton buttonWithType:0];
    [button setBackgroundImage:[UIImage imageNamed:@"微信图标"] forState:UIControlStateNormal];
    button.frame=CGRectMake(ACTUAL_WIDTH(35), ACTUAL_HEIGHT(490), ACTUAL_WIDTH(45), ACTUAL_HEIGHT(45));
    [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=0;
    [self.view addSubview:button];
    
    
    //QQ登录
    UIButton*button1=[UIButton buttonWithType:0];
    [button1 setBackgroundImage:[UIImage imageNamed:@"third_QQ"] forState:UIControlStateNormal];
    button1.frame=CGRectMake(ACTUAL_WIDTH(120), ACTUAL_HEIGHT(490), ACTUAL_WIDTH(45), ACTUAL_HEIGHT(45));
    [button1 addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
    button1.tag=1;
    [self.view addSubview:button1];

    
    
    
    //微博登录
    UIButton*button2=[UIButton buttonWithType:0];
    [button2 setBackgroundImage:[UIImage imageNamed:@"third_xinlang"] forState:UIControlStateNormal];
    button2.frame=CGRectMake(ACTUAL_WIDTH(205), ACTUAL_HEIGHT(490), ACTUAL_WIDTH(45), ACTUAL_HEIGHT(45));
    [button2 addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag=2;
    [self.view addSubview:button2];

    
    //faceBook
    UIButton*button3=[UIButton buttonWithType:0];
    [button3 setBackgroundImage:[UIImage imageNamed:@"facebook"] forState:UIControlStateNormal];
    button3.frame=CGRectMake(ACTUAL_WIDTH(290), ACTUAL_HEIGHT(490), ACTUAL_WIDTH(45), ACTUAL_HEIGHT(45));
    [button3 addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
    button3.tag=3;
    [self.view addSubview:button3];

    
}

-(void)touchButton:(UIButton*)sender{
    //2个保存的参数
    NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
    UMSocialSnsPlatform *snsPlatform = nil;

    
    
    if (sender.tag==0) {
        //微信登录   判断是否授权过   授权过直接调 接口直接能登录    没有授权过那么 用户先确定了 在登录
       snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        //accountEnitity   这个是所有数据的
        UMSocialAccountEntity *accountEnitity = [snsAccountDic valueForKey:snsPlatform.platformName];
      
        //这里判断是否授权      微信登录
        if ([UMSocialAccountManager isOauthAndTokenNotExpired:snsPlatform.platformName]) {
             //已经授权了
#pragma mark ------ 给鲁总的接口
            NSDictionary*params=@{@"m":@"appapi",@"s":@"connect_login",@"platformName":accountEnitity.platformName,@"usid":accountEnitity.usid,@"iconURL":accountEnitity.iconURL,@"userName":accountEnitity.userName};
            
            [self thirdLoginIn:params andAccout:accountEnitity];
        }else {
        //尚未授权    需要调接口  微信
       [self YoumenthirdLogin:@"wxsession"];
       }

        
        
    }else if (sender.tag==1){
        //QQ登录
        //微信登录   判断是否授权过   授权过直接调 接口直接能登录    没有授权过那么 用户先确定了 在登录
        snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
        //accountEnitity   这个是所有数据的
        UMSocialAccountEntity *accountEnitity = [snsAccountDic valueForKey:snsPlatform.platformName];
        
        //这里判断是否授权      微信登录
        if ([UMSocialAccountManager isOauthAndTokenNotExpired:snsPlatform.platformName]) {
            //已经授权了
#pragma mark ------ 给鲁总的接口
            NSDictionary*params=@{@"m":@"appapi",@"s":@"connect_login",@"platformName":accountEnitity.platformName,@"usid":accountEnitity.usid,@"iconURL":accountEnitity.iconURL,@"userName":accountEnitity.userName};
            
            [self thirdLoginIn:params andAccout:accountEnitity];
        }else {
            //尚未授权    需要调接口
            [self YoumenthirdLogin:@"qq"];
        }

        
        
        
        
        
        
        
        
    }else if (sender.tag==2){
        //微信登录   判断是否授权过   授权过直接调 接口直接能登录    没有授权过那么 用户先确定了 在登录
        snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];

        //accountEnitity   这个是所有数据的
        UMSocialAccountEntity *accountEnitity = [snsAccountDic valueForKey:snsPlatform.platformName];
        
        //这里判断是否授权      微信登录
        if ([UMSocialAccountManager isOauthAndTokenNotExpired:snsPlatform.platformName]) {
            //已经授权了
#pragma mark ------ 给鲁总的接口
            NSDictionary*params=@{@"m":@"appapi",@"s":@"connect_login",@"platformName":accountEnitity.platformName,@"usid":accountEnitity.usid,@"iconURL":accountEnitity.iconURL,@"userName":accountEnitity.userName};
            
            [self thirdLoginIn:params andAccout:accountEnitity];
        }else {
            //尚未授权    需要调接口
              [self YoumenthirdLogin:@"sina"];        }

      
        //新浪微博
       
        
        
    }else if (sender.tag==3){
//        //faceBook
//        
//        
//        //微信登录   判断是否授权过   授权过直接调 接口直接能登录    没有授权过那么 用户先确定了 在登录
        snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToFacebook];
        
        //accountEnitity   这个是所有数据的
        UMSocialAccountEntity *accountEnitity = [snsAccountDic valueForKey:snsPlatform.platformName];
        
        //这里判断是否授权      微信登录
        if ([UMSocialAccountManager isOauthAndTokenNotExpired:snsPlatform.platformName]) {
            //已经授权了
#pragma mark ------ 给鲁总的接口
//            NSString *data =accountEnitity.iconURL;
//            NSString* http=[data stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
//            NSString *dataUTF8=[http stringByReplacingOccurrencesOfString:@"?" withString:@"666aaa"];
            
            //这个一张图  .com和cn  没有区别的
            NSDictionary*params=@{@"m":@"appapi",@"s":@"connect_login",@"platformName":accountEnitity.platformName,@"usid":accountEnitity.usid,@"iconURL":@"http://www.vipxox.com/templates/vipxox/images/asdfs.jpg",@"userName":accountEnitity.userName};
            
            [self thirdLoginIn:params andAccout:accountEnitity];
        }else {
            //尚未授权    需要调接口
            [self YoumenthirdLogin:@"facebook"];
        }

    }
    


    
    
    
    
}

#pragma mark-----第三方登录    授权
-(void)YoumenthirdLogin:(NSString*)str{
    NSString*platformName=str;
    
    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //           获取微博用户名、uid、token、第三方的原始用户信息thirdPlatformUserProfile等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse);
            
            
            
#pragma mark ------ 给鲁总的接口
            if ([snsAccount.platformName isEqualToString:@"facebook"]) {
                
//                NSString *data =snsAccount.iconURL;
//                NSString *dataUTF8=[data stringByReplacingOccurrencesOfString:@"?" withString:@"666aaa"];
                
                //这个一张图  没区别的
                NSDictionary*params=@{@"m":@"appapi",@"s":@"connect_login",@"platformName":snsAccount.platformName,@"usid":snsAccount.usid,@"iconURL":@"http://www.vipxox.com/templates/vipxox/images/asdfs.jpg",@"userName":snsAccount.userName};
                
                [self thirdLoginIn:params andAccout:snsAccount];

                
            }else{
            
                NSDictionary*params=@{@"m":@"appapi",@"s":@"connect_login",@"platformName":snsAccount.platformName,@"usid":snsAccount.usid,@"iconURL":snsAccount.iconURL,@"userName":snsAccount.userName};
                
                [self thirdLoginIn:params andAccout:snsAccount];

            
            }
            
            
        }
        
    });
}

#pragma mark ------ 鲁总自己的接口
-(void)thirdLoginIn:(NSDictionary*)params andAccout:(UMSocialAccountEntity*)snsAccount{
    //            http://www.vx.dev/? m=appapi&s=connect_login
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"6"]) {
            
            //6代表着  该账户没有绑定
            ThreePartLoginViewController*vc=[[ThreePartLoginViewController alloc]initWithNibName:@"ThreePartLoginViewController" bundle:nil];
            vc.params=params;
            
            vc.aname=snsAccount.userName;
            vc.ausid=snsAccount.usid;
            vc.aplatformName=snsAccount.platformName;
            vc.aPhoto=snsAccount.iconURL;
            vc.cid=data[@"data"][@"cid"];
            
            [self presentViewController:vc animated:YES completion:nil];
            
            
            
        }else if ([data[@"errorCode"] isEqualToString:@"0"]){
            //直接登录   说明已经绑定过了  微信 直接登录
            
            NSDictionary*user=data[@"data"][@"user"];
            NSArray*address=data[@"data"][@"address"];
            
            UserSession*session=[UserSession instance];
            [session setValuesForKeysWithDictionary:user];
            session.address=address;
            //已经登录改为yes
            session.isLogin=YES;
            
#warning ---这里的自动登录  要变成第三方  自动登录
            
            //自动登录
            NSUserDefaults*Nsuser=[NSUserDefaults standardUserDefaults];
            [Nsuser removeObjectForKey:AUTOLOGIN];
            [Nsuser removeObjectForKey:AUTOLOGINCODE];
            [Nsuser setObject:@"YES" forKey:ISTHIRDLOGIN];
            [Nsuser setObject:params forKey:ISTHIRDPARAMS];
            
           
            
//            [Nsuser setObject:session.user forKey:AUTOLOGIN];
//            [Nsuser setObject:self.secretcodeTextField.text forKey:AUTOLOGINCODE];
            
            //委托购物车 获取数据
            if ([self.delegate respondsToSelector:@selector(delegateForGetDatas)]) {
                [self.delegate delegateForGetDatas];
                
            }
            //美食这里的货币更改（reload）
//            [self sendNotifi];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
            
            
            
        }
        
        
        
        else{
            [JRToast showWithText:data[@"errormsg"]];
        }
        
        
    }];
}








#pragma mark  ---- 之前没登录   点击登录按钮登录   登录之后  需要发送通知把首页的钱变成已设定的币种
-(void)touchEnterButton:(UIButton*)aa{
  
    NSString*str=[self judgeCansave];
    if (_canSave) {
        //接口
//        http://www.vipxox.cn/? m=appapi&s=login&user=baobao&pwd=123456
        NSString*url=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
        NSDictionary*params=@{@"m":@"appapi",@"s":@"login",@"user":self.accountTextField.text,@"pwd":self.secretcodeTextField.text};
        HttpManager*manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkWithUrl:url parameters:params compliation:^(id data, NSError *error) {
            NSLog(@"%@",self.secretcodeTextField.text);
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
//                [Nsuser setObject:@"NO" forKey:ISTHIRDLOGIN];
                [Nsuser removeObjectForKey:ISTHIRDLOGIN];
                [Nsuser removeObjectForKey:ISTHIRDPARAMS];
                [Nsuser setObject:self.accountTextField.text forKey:AUTOLOGIN];
                [Nsuser setObject:self.secretcodeTextField.text forKey:AUTOLOGINCODE];
                
                //委托购物车 获取数据
                if ([self.delegate respondsToSelector:@selector(delegateForGetDatas)]) {
                    [self.delegate delegateForGetDatas];

                }
                //美食这里的货币更改（reload）
//                [self sendNotifi];
                
                [self dismissViewControllerAnimated:YES completion:nil];
//                session.uid=session.userid;
//                [self dismissViewControllerAnimated:<#(BOOL)#> completion:<#^(void)completion#>]
//                XXTabBarController*tabVc=[[XXTabBarController alloc]init];
//                [self presentViewController:tabVc animated:YES completion:nil];
                
                
            }else{
                [JRToast showWithText:data[@"errorMessage"] duration:1];
            }
            
            
        }];
        
        
    }else{
        [JRToast showWithText:str duration:2.0];
    }
    
}

//点击登录套用
//-(void)sendNotifi{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"foodNeedReloadBecauseMoney" object:nil];
//    
//}


-(NSString*)judgeCansave{
      _canSave=NO;
    if (self.accountTextField.text.length>=6) {
        _canSave=YES;
    }else{
          _canSave=NO;
        return @"账号不能小与6位";
    }
    
    if (self.secretcodeTextField.text.length>=6) {
        _canSave=YES;
    }else{
        _canSave=NO;

        return @"密码不能小与6位";
    }
    
    return @"...";
}

-(void)showSecretCode{
    if (_SCButtom.selected==NO) {
        _SCButtom.selected=YES;
        _secretcodeTextField.secureTextEntry=NO;
    }else if(_SCButtom.selected==YES){
        _SCButtom.selected=NO;
        _secretcodeTextField.secureTextEntry=YES;
    }
}

-(void)gotoForgetPasswod{
    ForgetSecretCodeViewController*vc=[[ForgetSecretCodeViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)gotoRegisterView{
    RegisterViewController *vc=[[RegisterViewController alloc]init];
    vc.DismissNextVC=^(){
        [self dismissViewControllerAnimated:NO completion:nil];
        
    };
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
