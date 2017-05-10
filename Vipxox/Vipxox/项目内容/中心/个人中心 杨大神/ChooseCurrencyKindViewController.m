//
//  ChooseCurrencyKindViewController.m
//  Vipxox
//
//  Created by Brady on 16/2/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ChooseCurrencyKindViewController.h"

@interface ChooseCurrencyKindViewController ()

@property(nonatomic,strong)UIButton *button1;
@property(nonatomic,strong)UIButton *button2;
@property(nonatomic,strong)UIButton *button3;
@property(nonatomic,strong)UIButton *button4;
@property(nonatomic,strong)UIButton *button5;

@property(nonatomic,strong)NSString *currency;

@property(nonatomic,assign)BOOL cantTouch;   //0为能点击   1为不能点击

@end

@implementation ChooseCurrencyKindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self makeNavi];
    self.navigationController.navigationBarHidden=NO;
    self.title=@"选择币种";
    [self makeView];
    _currency=[[NSString alloc]init];
    NSLog(@"%@",[UserSession instance].currency);
    if ([[UserSession instance].currency isEqualToString:@"¥"]) {
        _button1.selected=YES;
        [self selectButton1:_button1];
    }else if ([[UserSession instance].currency isEqualToString:@"$"]){
        _button2.selected=YES;
        [self selectButton2:_button2];
    }else if ([[UserSession instance].currency isEqualToString:@"J￥"]){
        _button3.selected=YES;
        [self selectButton3:_button3];
    }else if ([[UserSession instance].currency isEqualToString:@"C$"]){
        _button4.selected=YES;
        [self selectButton4:_button4];
    }else if ([[UserSession instance].currency isEqualToString:@"€"]){
        _button5.selected=YES;
        [self selectButton5:_button5];
    }

    
    
//    _button1.selected=YES;
}

-(void)makeView{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64)];
    view.backgroundColor=RGBCOLOR(247, 247, 247, 1);
    [self.view addSubview:view];
//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
    _button1=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(64),KScreenWidth, ACTUAL_HEIGHT(61))];
    _button1.backgroundColor=[UIColor clearColor];
    [_button1 setTitle:@"人民币" forState:0];
    [_button1 setTitleColor:RGBCOLOR(180, 181, 182, 1) forState:0];
    [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _button1.titleLabel.font = [UIFont systemFontOfSize:16];//title字体大小
    _button1.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    _button1.titleEdgeInsets=UIEdgeInsetsMake(ACTUAL_HEIGHT(25), ACTUAL_WIDTH(20), ACTUAL_HEIGHT(20),ACTUAL_WIDTH(196));
    [_button1.layer setBorderColor:RGBCOLOR(240, 240, 240, 1).CGColor];
    [_button1.layer setBorderWidth:0.8];
    [_button1.layer setMasksToBounds:YES];
    [_button1 addTarget:self action:@selector(selectButton1:) forControlEvents:UIControlEventTouchDown];
    [_button1 setImage:[UIImage imageNamed:@"whiteBall"] forState:UIControlStateNormal];
    [_button1 setImage:[UIImage imageNamed:@"blackBall"] forState:UIControlStateSelected];
     _button1.imageEdgeInsets =UIEdgeInsetsMake(ACTUAL_HEIGHT(25), ACTUAL_WIDTH(310), ACTUAL_HEIGHT(20),ACTUAL_WIDTH(45));
    [self.view addSubview:_button1];
    
    UIImageView *imageview1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"国旗_中国"]];
    imageview1.frame=CGRectMake(ACTUAL_WIDTH(10), ACTUAL_HEIGHT(75), ACTUAL_WIDTH(40), ACTUAL_HEIGHT(40));
    [self.view addSubview:imageview1];
    //－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
    _button2=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(125),KScreenWidth, ACTUAL_HEIGHT(61))];
    _button2.backgroundColor=[UIColor clearColor];
    [_button2 setTitle:@"美元" forState:0];
    [_button2 setTitleColor:RGBCOLOR(180, 181, 182, 1) forState:0];
    [_button2 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _button2.titleLabel.font = [UIFont systemFontOfSize:16];//title字体大小
    _button2.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    _button2.titleEdgeInsets=UIEdgeInsetsMake(ACTUAL_HEIGHT(25), ACTUAL_WIDTH(30), ACTUAL_HEIGHT(20),ACTUAL_WIDTH(186));
    [_button2.layer setBorderColor:RGBCOLOR(240, 240, 240, 1).CGColor];
    [_button2.layer setBorderWidth:0.8];
    [_button2.layer setMasksToBounds:YES];
    [_button2 addTarget:self action:@selector(selectButton2:) forControlEvents:UIControlEventTouchDown];
    [_button2 setImage:[UIImage imageNamed:@"whiteBall"] forState:UIControlStateNormal];
    [_button2 setImage:[UIImage imageNamed:@"blackBall"] forState:UIControlStateSelected];
    _button2.imageEdgeInsets =UIEdgeInsetsMake(ACTUAL_HEIGHT(25), ACTUAL_WIDTH(310), ACTUAL_HEIGHT(20),ACTUAL_WIDTH(45));

    [self.view addSubview:_button2];
    
    UIImageView *imageview2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"国旗_美国"]];
    imageview2.frame=CGRectMake(ACTUAL_WIDTH(10), ACTUAL_HEIGHT(136), ACTUAL_WIDTH(40), ACTUAL_HEIGHT(40));
    [self.view addSubview:imageview2];
    //－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
    _button3=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(186),KScreenWidth, ACTUAL_HEIGHT(61))];
    _button3.backgroundColor=[UIColor clearColor];
    [_button3 setTitle:@"日元" forState:0];
    [_button3 setTitleColor:RGBCOLOR(180, 181, 182, 1) forState:0];
    [_button3 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _button3.titleLabel.font = [UIFont systemFontOfSize:16];//title字体大小
    _button3.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    _button3.titleEdgeInsets=UIEdgeInsetsMake(ACTUAL_HEIGHT(25), ACTUAL_WIDTH(30), ACTUAL_HEIGHT(20),ACTUAL_WIDTH(186));
    [_button3.layer setBorderColor:RGBCOLOR(240, 240, 240, 1).CGColor];
    [_button3.layer setBorderWidth:0.8];
    [_button3.layer setMasksToBounds:YES];
    [_button3 addTarget:self action:@selector(selectButton3:) forControlEvents:UIControlEventTouchDown];
    [_button3 setImage:[UIImage imageNamed:@"whiteBall"] forState:UIControlStateNormal];
    [_button3 setImage:[UIImage imageNamed:@"blackBall"] forState:UIControlStateSelected];
    _button3.imageEdgeInsets =UIEdgeInsetsMake(ACTUAL_HEIGHT(25), ACTUAL_WIDTH(310), ACTUAL_HEIGHT(20),ACTUAL_WIDTH(45));

    [self.view addSubview:_button3];
    
    UIImageView *imageview3=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"国旗_日本"]];
    imageview3.frame=CGRectMake(ACTUAL_WIDTH(10), ACTUAL_HEIGHT(197), ACTUAL_WIDTH(40), ACTUAL_HEIGHT(40));
    [self.view addSubview:imageview3];

    //－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
    _button4=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(247),KScreenWidth, ACTUAL_HEIGHT(61))];
    _button4.backgroundColor=[UIColor clearColor];
    [_button4 setTitle:@"加币" forState:0];
    [_button4 setTitleColor:RGBCOLOR(180, 181, 182, 1) forState:0];
    [_button4 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _button4.titleLabel.font = [UIFont systemFontOfSize:16];//title字体大小
    _button4.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    _button4.titleEdgeInsets=UIEdgeInsetsMake(ACTUAL_HEIGHT(25), ACTUAL_WIDTH(30), ACTUAL_HEIGHT(20),ACTUAL_WIDTH(186));
    [_button4.layer setBorderColor:RGBCOLOR(240, 240, 240, 1).CGColor];
    [_button4.layer setBorderWidth:0.8];
    [_button4.layer setMasksToBounds:YES];
    [_button4 addTarget:self action:@selector(selectButton4:) forControlEvents:UIControlEventTouchDown];
    [_button4 setImage:[UIImage imageNamed:@"whiteBall"] forState:UIControlStateNormal];
    [_button4 setImage:[UIImage imageNamed:@"blackBall"] forState:UIControlStateSelected];
    _button4.imageEdgeInsets =UIEdgeInsetsMake(ACTUAL_HEIGHT(25), ACTUAL_WIDTH(310), ACTUAL_HEIGHT(20),ACTUAL_WIDTH(45));

    [self.view addSubview:_button4];
    
    UIImageView *imageview4=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"国旗_加拿大"]];
    imageview4.frame=CGRectMake(ACTUAL_WIDTH(10), ACTUAL_HEIGHT(258), ACTUAL_WIDTH(40), ACTUAL_HEIGHT(40));
    [self.view addSubview:imageview4];
    
    //－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
    _button5=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(308),KScreenWidth, ACTUAL_HEIGHT(61))];
    _button5.backgroundColor=[UIColor clearColor];
    [_button5 setTitle:@"欧元" forState:0];
    [_button5 setTitleColor:RGBCOLOR(180, 181, 182, 1) forState:0];
    [_button5 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _button5.titleLabel.font = [UIFont systemFontOfSize:16];//title字体大小
    _button5.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    _button5.titleEdgeInsets=UIEdgeInsetsMake(ACTUAL_HEIGHT(25), ACTUAL_WIDTH(30), ACTUAL_HEIGHT(20),ACTUAL_WIDTH(186));
    [_button5.layer setBorderColor:RGBCOLOR(240, 240, 240, 1).CGColor];
    [_button5.layer setBorderWidth:0.8];
    [_button5.layer setMasksToBounds:YES];
    [_button5 addTarget:self action:@selector(selectButton5:) forControlEvents:UIControlEventTouchDown];
    [_button5 setImage:[UIImage imageNamed:@"whiteBall"] forState:UIControlStateNormal];
    [_button5 setImage:[UIImage imageNamed:@"blackBall"] forState:UIControlStateSelected];
    _button5.imageEdgeInsets =UIEdgeInsetsMake(ACTUAL_HEIGHT(25), ACTUAL_WIDTH(310), ACTUAL_HEIGHT(20),ACTUAL_WIDTH(45));

    [self.view addSubview:_button5];
    
    UIImageView *imageview5=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"国旗_欧盟"]];
    imageview5.frame=CGRectMake(ACTUAL_WIDTH(10), ACTUAL_HEIGHT(319), ACTUAL_WIDTH(40), ACTUAL_HEIGHT(40));
    [self.view addSubview:imageview5];

    
     //－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(18), ACTUAL_HEIGHT(452), ACTUAL_WIDTH(341), ACTUAL_HEIGHT(50))];
    [button setTitle:@"确定" forState:0];
    button.layer.cornerRadius=5;
    [button setTitleColor:[UIColor whiteColor] forState:0];
    button.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    button.titleLabel.font=[UIFont systemFontOfSize:18];
    [button addTarget:self action:@selector(sureCurrency) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}
//blackBall
-(void)makeNavi{
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(34),KScreenWidth, ACTUAL_WIDTH(19))];
    titleLabel.text=@"选择币种";
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
-(void)selectButton1:(UIButton*)sender{
    _button1.selected=YES;
    _button2.selected=NO;
    _button3.selected=NO;
    _button4.selected=NO;
    _button5.selected=NO;
    
    _currency=@"CNY";
}

-(void)selectButton2:(UIButton*)sender{
    _button1.selected=NO;
    _button2.selected=YES;
    _button3.selected=NO;
    _button4.selected=NO;
    _button5.selected=NO;
    
    _currency=@"USD";
    
}

-(void)selectButton3:(UIButton*)sender{
    _button1.selected=NO;
    _button2.selected=NO;
    _button3.selected=YES;
    _button4.selected=NO;
    _button5.selected=NO;
    
    _currency=@"JPY";
}

-(void)selectButton4:(UIButton*)sender{
    _button1.selected=NO;
    _button2.selected=NO;
    _button3.selected=NO;
    _button4.selected=YES;
    _button5.selected=NO;
    
    _currency=@"CAD";
    
}

-(void)selectButton5:(UIButton*)sender{
    _button1.selected=NO;
    _button2.selected=NO;
    _button3.selected=NO;
    _button4.selected=NO;
    _button5.selected=YES;
    
    _currency=@"EUR";
}

-(void)sureCurrency{
    
    if (_cantTouch==0) {
        [self chooseCUrrentJiekou];
        _cantTouch=1;
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(toZero:) userInfo:nil repeats:NO];
    }else{
        
    }
    
}

-(void)toZero:(NSTimer*)timer{
    _cantTouch=0;
    timer=0;
    [timer invalidate];
    
}


-(void)chooseCUrrentJiekou{
    //http://www.vipxox.cn/?  m=appapi&s=membercenter&act=currency&currency=CAD&uid=1
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"currency",@"currency":_currency,@"uid":[UserSession instance].uid};
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        NSLog(@"%@",number);
        
        if ([number isEqualToString:@"0"]) {
            //            [self autoLogin];
            //通知首页更新   美食更新
            [UserSession instance].currency=data[@"data"];
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"操作成功！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"HomeAndFoodReload" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
            
            
            
        }
        
    }];
    
}

//-(void)autoLogin{
//    NSUserDefaults*defaults= [NSUserDefaults standardUserDefaults];
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
//            [self sendNotifi];
//            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"操作成功！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alter show];
//            
//
//            
//        }else{
//            [JRToast showWithText:@"更换币种失败 请重新登录！" duration:2.0];
//            
//        }
//    }];
//}


//-(void)sendNotifi{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"foodNeedReloadBecauseMoney" object:nil];
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
