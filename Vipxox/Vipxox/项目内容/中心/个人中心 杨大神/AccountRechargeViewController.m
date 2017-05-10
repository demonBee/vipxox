//
//  AccountRechargeViewController.m
//  weimao
//
//  Created by Tian Wei You on 16/2/21.
//  Copyright © 2016年 Tian Wei You. All rights reserved.
//

#import "AccountRechargeViewController.h"
#import "WXApiRequestHandler.h"    //微信

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "APAuthV2Info.h"

#import "alibaba.h"

//paypal
#import "PayPalMobile.h"
#import <QuartzCore/QuartzCore.h>



#define kPayPalEnvironment PayPalEnvironmentNoNetwork

@interface AccountRechargeViewController ()<PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate, UIPopoverControllerDelegate,UITextFieldDelegate,UITextFieldDelegate>

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic ,strong)UIButton*button1;
@property(nonatomic ,strong)UIButton*button2;
@property(nonatomic ,strong)UIButton*button3;
@property(nonatomic ,strong)UIButton*button4;
@property(nonatomic ,strong)UIButton*button5;

@property(nonatomic,strong)NSMutableArray*allButtons;

@property(nonatomic,strong)UITextField*text;


@property(nonatomic,strong) UILabel*label1;  //因为PayPal  所以要改
@property(nonatomic,strong) UILabel*label2;   //还是因为payPal
//paypal
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic, strong, readwrite) NSString *resultText;
//@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;


//用于按钮锁定
//@property(nonatomic,assign)BOOL cantTouch;   //0能点击   1不能点击。
//立即充值 按钮
@property(nonatomic,strong)UIButton*immButton;
@end

@implementation AccountRechargeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"账户充值";
    self.allButtons=[NSMutableArray array];
    self.view.backgroundColor=RGBCOLOR(239, 97, 101, 1);
//    self.navigationController.navigationBarHidden=NO;
    [self makeNavi];
    [self makeView];
    
    if (self.num==0) {
        return;
    }else{
        self.text.text=[NSString stringWithFormat:@"%.0f",self.num];

    }
}

-(void)makeNavi{
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(156), ACTUAL_HEIGHT(34), ACTUAL_WIDTH(79), ACTUAL_WIDTH(19))];
    titleLabel.text=@"账户充值";
    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton*button=[UIButton buttonWithType:0];
    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
    [button setBackgroundImage:[UIImage imageNamed:@"NaviBack"] forState:UIControlStateNormal];
        button.size=button.currentBackgroundImage.size;
    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)getCurrent{
    if ([[UserSession instance].currency isEqualToString:@"¥"]) {
        _label1.text=@"充值金额CNY:";
    }else if ([[UserSession instance].currency isEqualToString:@"$"]) {
        _label1.text=@"充值金额USD:";
    }else if ([[UserSession instance].currency isEqualToString:@"C$"]) {
        _label1.text=@"充值金额CAD:";
    }else if ([[UserSession instance].currency isEqualToString:@"€"]) {
        _label1.text=@"充值金额EUR:";
    }else if ([[UserSession instance].currency isEqualToString:@"J￥"]) {
        _label1.text=@"充值金额JPY:";
    }

    
}

-(void)getFuhao{
    if ([[UserSession instance].currency isEqualToString:@"C$"]||[[UserSession instance].currency isEqualToString:@"J￥"]) {
        _label2.frame=CGRectMake(ACTUAL_WIDTH(200), ACTUAL_HEIGHT(112), ACTUAL_WIDTH(50), ACTUAL_HEIGHT(30));
        _label2.text=[UserSession instance].currency;
    }else{
        _label2.frame=CGRectMake(ACTUAL_WIDTH(200), ACTUAL_HEIGHT(112), ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30));
        _label2.text=[UserSession instance].currency;
    }

}

-(void)makeView{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(227), KScreenWidth,KScreenHeight)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    _label1=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(117), ACTUAL_WIDTH(200), ACTUAL_HEIGHT(26))];
    [self getCurrent];
    
    [_label1 setTextColor:[UIColor whiteColor]];
    _label1.textAlignment=NSTextAlignmentRight;
    _label1.font=[UIFont systemFontOfSize:18];
    _label1.textAlignment=2;
    [self.view addSubview:_label1];
    
    
    _label2=[[UILabel alloc]init];
    
       [_label2 setTextColor:[UIColor whiteColor]];
    _label2.font=[UIFont systemFontOfSize:28];
    [self getFuhao];
    [self.view addSubview:_label2];
    
    _text=[[UITextField alloc]init];
    _text.keyboardType=UIKeyboardTypeNumberPad;
    _text.delegate=self;
    if ([[UserSession instance].currency isEqualToString:@"C$"]||[[UserSession instance].currency isEqualToString:@"J￥"]) {
        _text.frame=CGRectMake(ACTUAL_WIDTH(250), ACTUAL_HEIGHT(107), ACTUAL_WIDTH(120), ACTUAL_HEIGHT(40));
    }else{
        _text.frame=CGRectMake(ACTUAL_WIDTH(225), ACTUAL_HEIGHT(107), ACTUAL_WIDTH(145), ACTUAL_HEIGHT(40));
    }
    
    _text.textColor=[UIColor whiteColor];
    _text.textAlignment= NSTextAlignmentLeft;
    _text.font=[UIFont systemFontOfSize:28];
    _text.placeholder=@"0";
    [_text setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_text setValue:[UIFont boldSystemFontOfSize:30] forKeyPath:@"_placeholderLabel.font"];
    _text.delegate=self;
    [self.view addSubview:_text];

    
//==========================================================================
    
    UILabel*label3=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0),ACTUAL_HEIGHT(205), KScreenWidth, ACTUAL_HEIGHT(24))];
    label3.text=@"请用以下方式进行支付";
    [label3 setTextColor:[UIColor whiteColor]];
    label3.textAlignment=NSTextAlignmentCenter;
    label3.font=[UIFont systemFontOfSize:13];
    label3.textAlignment=1;
    [self.view addSubview:label3];
    

//==========================================================================
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(18), ACTUAL_HEIGHT(582), ACTUAL_WIDTH(341), ACTUAL_HEIGHT(50))];
    [button setTitle:@"立即充值" forState:0];
    [button addTarget:self action:@selector(touchLijichongzhi:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    button.enabled=YES;
    button.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    button.titleLabel.font=[UIFont systemFontOfSize:18];
    button.layer.cornerRadius=5;
    
    self.immButton=button;
    [self.view addSubview:button];
//=========================================================================
    UILabel*label4=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(160), ACTUAL_HEIGHT(291), ACTUAL_WIDTH(185), ACTUAL_HEIGHT(20))];
    label4.text=@"第三方手续费：4%＋$0.3";
    label4.textAlignment=NSTextAlignmentRight;
    label4.font=[UIFont systemFontOfSize:11];
    label4.textColor=[UIColor grayColor];
    label4.textAlignment=2;
    [self.view addSubview:label4];
    
    _button1=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(18), ACTUAL_HEIGHT(258), ACTUAL_WIDTH(343), ACTUAL_HEIGHT(58))];
    _button1.backgroundColor=[UIColor clearColor];

    [_button1 setTitle:@"国际信用卡" forState:0];
    [_button1 setTitleColor:[UIColor blackColor] forState:0];
    _button1.titleLabel.font = [UIFont systemFontOfSize:15];//title字体大小
    _button1.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    _button1.titleEdgeInsets=UIEdgeInsetsMake(ACTUAL_HEIGHT(20), ACTUAL_WIDTH(20), ACTUAL_HEIGHT(20),ACTUAL_WIDTH(210));
    
    [_button1 setImage:[UIImage imageNamed:@"whiteBall"] forState:0];//给button添加image
    [_button1 setImage:[UIImage imageNamed:@"blackBall"] forState:UIControlStateSelected];
    _button1.tag=0;
    [self.allButtons addObject:_button1];
    [_button1 addTarget:self action:@selector(selectButton1:) forControlEvents:UIControlEventTouchDown];
    
    _button1.imageEdgeInsets=UIEdgeInsetsMake(ACTUAL_HEIGHT(18), ACTUAL_WIDTH(8),ACTUAL_HEIGHT(18), ACTUAL_WIDTH(313));
    
    [_button1.layer setBorderColor:RGBCOLOR(240, 240, 240, 1).CGColor];
    [_button1.layer setBorderWidth:0.8];
    [_button1.layer setMasksToBounds:YES];

    [self.view addSubview:_button1];
    
    UIImageView*imageView1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"VISA"]];
    imageView1.frame=CGRectMake(ACTUAL_WIDTH(281), ACTUAL_HEIGHT(269), ACTUAL_WIDTH(32), ACTUAL_HEIGHT(20));
//    imageView1
    [self.view addSubview:imageView1];
    
    UIImageView*imageView2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MasterCard"]];
    imageView2.frame=CGRectMake(ACTUAL_WIDTH(323), ACTUAL_HEIGHT(269), ACTUAL_WIDTH(32), ACTUAL_HEIGHT(20));
    [self.view addSubview:imageView2];
    
    
//-------------------------------------------------------------------------
    
    UILabel*label5=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(160), ACTUAL_HEIGHT(351), ACTUAL_WIDTH(185), ACTUAL_HEIGHT(20))];
    label5.text=@"第三方手续费：3%＋$0.3";
    label5.textAlignment=NSTextAlignmentRight;
    label5.font=[UIFont systemFontOfSize:11];
    label5.textColor=[UIColor grayColor];
    label5.textAlignment=2;
    [self.view addSubview:label5];
    
    _button2=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(18), ACTUAL_HEIGHT(316), ACTUAL_WIDTH(343), ACTUAL_HEIGHT(58))];
    _button2.backgroundColor=[UIColor clearColor];
    
    [_button2 setTitle:@"Paypal" forState:0];
    [_button2 setTitleColor:[UIColor blackColor] forState:0];
    _button2.titleLabel.font = [UIFont systemFontOfSize:15];//title字体大小
    _button2.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    _button2.titleEdgeInsets=UIEdgeInsetsMake(ACTUAL_HEIGHT(20), ACTUAL_WIDTH(20), ACTUAL_HEIGHT(20),ACTUAL_WIDTH(231));
    
    [_button2 setImage:[UIImage imageNamed:@"whiteBall"] forState:UIControlStateNormal];//给button添加image
    [_button2 setImage:[UIImage imageNamed:@"blackBall"] forState:UIControlStateSelected];
    
    [_button2 addTarget:self action:@selector(selectButton2:) forControlEvents:UIControlEventTouchDown];
    _button2.imageEdgeInsets=UIEdgeInsetsMake(ACTUAL_HEIGHT(18), ACTUAL_WIDTH(8),ACTUAL_HEIGHT(18), ACTUAL_WIDTH(313));
    [_button2.layer setBorderColor:RGBCOLOR(240, 240, 240, 1).CGColor];
    [_button2.layer setBorderWidth:0.5];
    [_button2.layer setMasksToBounds:YES];
    _button2.tag=1;
    [self.allButtons addObject:_button2];
    
    [self.view addSubview:_button2];
    
    UIImageView*imageView3=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PayPal"]];
    imageView3.frame=CGRectMake(ACTUAL_WIDTH(301), ACTUAL_HEIGHT(328), ACTUAL_WIDTH(58), ACTUAL_HEIGHT(20));
    [self.view addSubview:imageView3];

//-------------------------------------------------------------------------
    _button3=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(18), ACTUAL_HEIGHT(374), ACTUAL_WIDTH(343), ACTUAL_HEIGHT(58))];
    _button3.backgroundColor=[UIColor clearColor];
    
    [_button3 setTitle:@"微信" forState:0];
    [_button3 setTitleColor:[UIColor blackColor] forState:0];
    _button3.titleLabel.font = [UIFont systemFontOfSize:15];//title字体大小
    _button3.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    _button3.titleEdgeInsets=UIEdgeInsetsMake(ACTUAL_HEIGHT(20), ACTUAL_WIDTH(20), ACTUAL_HEIGHT(20),ACTUAL_WIDTH(241));
    
    [_button3 setImage:[UIImage imageNamed:@"whiteBall"] forState:UIControlStateNormal];//给button添加image
    [_button3 setImage:[UIImage imageNamed:@"blackBall"] forState:UIControlStateSelected];
    
    [_button3 addTarget:self action:@selector(selectButton3:) forControlEvents:UIControlEventTouchDown];
    _button3.imageEdgeInsets=UIEdgeInsetsMake(ACTUAL_HEIGHT(18), ACTUAL_WIDTH(8),ACTUAL_HEIGHT(18), ACTUAL_WIDTH(313));
    
    [_button3.layer setBorderColor:RGBCOLOR(240, 240, 240, 1).CGColor];
    [_button3.layer setBorderWidth:0.5];
    [_button3.layer setMasksToBounds:YES];
    _button3.tag=2;
    [self.allButtons addObject:_button3];
    
    [self.view addSubview:_button3];
    
    UIImageView*imageView4=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"微信支付"]];
    imageView4.frame=CGRectMake(ACTUAL_WIDTH(290), ACTUAL_HEIGHT(390), ACTUAL_WIDTH(63), ACTUAL_HEIGHT(20));
    [self.view addSubview:imageView4];

//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
    UILabel*label6=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(160), ACTUAL_HEIGHT(468), ACTUAL_WIDTH(185), ACTUAL_HEIGHT(20))];
    label6.text=@"第三方手续费：3%＋$0.3";
    label6.textAlignment=NSTextAlignmentRight;
    label6.font=[UIFont systemFontOfSize:11];
    label6.textColor=[UIColor grayColor];
    label6.textAlignment=2;
    [self.view addSubview:label6];
    
    _button4=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(18), ACTUAL_HEIGHT(432), ACTUAL_WIDTH(343), ACTUAL_HEIGHT(58))];
    _button4.backgroundColor=[UIColor clearColor];
    
    [_button4 setTitle:@"支付宝" forState:0];
    [_button4 setTitleColor:[UIColor blackColor] forState:0];
    _button4.titleLabel.font = [UIFont systemFontOfSize:15];//title字体大小
    _button4.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    _button4.titleEdgeInsets=UIEdgeInsetsMake(ACTUAL_HEIGHT(20), ACTUAL_WIDTH(25), ACTUAL_HEIGHT(20),ACTUAL_WIDTH(231));
    
    [_button4 setImage:[UIImage imageNamed:@"whiteBall"] forState:UIControlStateNormal];//给button添加image
    [_button4 setImage:[UIImage imageNamed:@"blackBall"] forState:UIControlStateSelected];
    
    [_button4 addTarget:self action:@selector(selectButton4:) forControlEvents:UIControlEventTouchDown];
    _button4.imageEdgeInsets=UIEdgeInsetsMake(ACTUAL_HEIGHT(18), ACTUAL_WIDTH(8),ACTUAL_HEIGHT(18), ACTUAL_WIDTH(313));
    
    [_button4.layer setBorderColor:RGBCOLOR(240, 240, 240, 1).CGColor];
    [_button4.layer setBorderWidth:0.5];
    [_button4.layer setMasksToBounds:YES];
    _button4.tag=3;
    [self.allButtons addObject:_button4];
    
    [self.view addSubview:_button4];
    
    UIImageView*imageView5=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"支付宝"]];
    imageView5.frame=CGRectMake(ACTUAL_WIDTH(297), ACTUAL_HEIGHT(445), ACTUAL_WIDTH(58), ACTUAL_HEIGHT(22));
    [self.view addSubview:imageView5];
    
//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
    _button5=[[UIButton alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(18), ACTUAL_HEIGHT(490), ACTUAL_WIDTH(343), ACTUAL_HEIGHT(58))];
    _button5.backgroundColor=[UIColor clearColor];
    
    [_button5 setTitle:@"国内银行卡" forState:0];
    [_button5 setTitleColor:[UIColor blackColor] forState:0];
    _button5.titleLabel.font = [UIFont systemFontOfSize:15];//title字体大小
    _button5.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    _button5.titleEdgeInsets=UIEdgeInsetsMake(ACTUAL_HEIGHT(20), ACTUAL_WIDTH(25), ACTUAL_HEIGHT(20),ACTUAL_WIDTH(201));
    
    [_button5 setImage:[UIImage imageNamed:@"whiteBall"] forState:UIControlStateNormal];//给button添加image
    
    [_button5 setImage:[UIImage imageNamed:@"blackBall"] forState:UIControlStateSelected];
    
    [_button5 addTarget:self action:@selector(selectButton5:) forControlEvents:UIControlEventTouchDown];

    _button5.imageEdgeInsets=UIEdgeInsetsMake(ACTUAL_HEIGHT(18), ACTUAL_WIDTH(8),ACTUAL_HEIGHT(18), ACTUAL_WIDTH(313));
    
    [_button5.layer setBorderColor:RGBCOLOR(240, 240, 240, 1).CGColor];
    [_button5.layer setBorderWidth:0.8];
    [_button5.layer setMasksToBounds:YES];
    _button5.tag=4;
    [self.allButtons addObject:_button5];
    [self.view addSubview:_button5];
    
    UIImageView*imageView6=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"银联"]];
    imageView6.frame=CGRectMake(ACTUAL_WIDTH(297), ACTUAL_HEIGHT(512), ACTUAL_WIDTH(58), ACTUAL_HEIGHT(22));
    [self.view addSubview:imageView6];
    
}

-(void)canTouch:(NSTimer*)timer{
    timer=nil;
    [timer invalidate];
    self.immButton.enabled=YES;
   }
//点击立即充值
-(void)touchLijichongzhi:(UIButton*)sender{
    if ([_text.text floatValue]>0) {
    for (int i=0; i<self.allButtons.count;i++ ) {
        UIButton*button=self.allButtons[i];
        if (button.selected) {
            switch (button.tag) {
                case 0:
                    //国际信用卡
                    [JRToast showWithText:@"5月震撼上线"];
                    break;
                case 1:
                    //paypal

                    sender.enabled=NO;
                    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(canTouch:) userInfo:nil repeats:NO];
                    [self  usepayPal];
                    break;
                case 2:
                    sender.enabled=NO;
                    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(canTouch:) userInfo:nil repeats:NO];

                        //微信
                        [self weixinchongzhi];
                    
                    
                        break;
                case 3:
                    sender.enabled=NO;
                    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(canTouch:) userInfo:nil repeats:NO];
                    //支付宝
                    [self zhifubaoPayPPP];
//                    [self zhifubaoPay];
//                    [JRToast showWithText:@"3月震撼上线"];
                    break;
                case 4:
                    //国内银行卡
                    [JRToast showWithText:@"6月震撼上线"];
                    break;
    
                default:
                    break;
            }
        }
    }
    }else{
        [JRToast showWithText:@"请输入充值金额！"];
    }
}

#pragma mark-------用payPal支付
-(void)usepayPal{
    //两个   mock   sandbox   live
    self.environment = @"live";
    [PayPalMobile preconnectWithEnvironment:self.environment];

                   
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
#if HAS_CARDIO
    // You should use the PayPal-iOS-SDK+card-Sample-App target to enable this setting.
    // For your apps, you will need to link to the libCardIO and dependent libraries. Please read the README.md
    // for more details.
    _payPalConfig.acceptCreditCards = YES;
#else
    _payPalConfig.acceptCreditCards = NO;
#endif
    _payPalConfig.merchantName = @"上海镀锐信息科技有限公司";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    
    // Setting the payPalShippingAddressOption property is optional.
    //
    // See PayPalConfiguration.h for details.
    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    // Do any additional setup after loading the view, typically from a nib.
    
  
    
    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);

    
    
    
    [self payMoney];
}
//- (BOOL)acceptCreditCards {
//    return self.payPalConfig.acceptCreditCards;
//}
-(void)payMoney{
    // Remove our last completed payment, just for demo purposes.
    self.resultText = nil;
    
    //   Note: For purposes of illustration, this example shows a payment that includes
    //         both payment details (subtotal, shipping, tax) and multiple items.
    //         You would only specify these if appropriate to your situation.
    //         Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //         and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    NSString*strr=self.text.text;
    PayPalItem *item1 = [PayPalItem itemWithName:@"充值"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:strr]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00037"];
       NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"充值";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = NO;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];

    
    
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
  
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}


- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    [JRToast showWithText:@"defeated"];
    [self dismissViewControllerAnimated:YES completion:nil];

//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    //这些信息要给后台

    
#warning ----此处需要接口

    
    
//    http://www.vx.dev/  ?m=appapi&s=mall&act=pay_order
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"mall",@"act":@"pay_order",@"operate":@"paypal",@"money":self.text.text,@"uid":[UserSession instance].uid,@"pid":completedPayment.confirmation[@"response"][@"id"]};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
//        [self PayPalchangeYue];
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            UserSession*user=[UserSession instance];
            user.cash=data[@"data"][@"cash"];
            user.unreachable=data[@"data"][@"unreachable"];
            user.point=data[@"data"][@"point"];
            
            NSString*str2=[NSString stringWithFormat:@"本次充值$%@",self.text.text];
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"充值成功" message:str2 delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alert show];
            
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [JRToast showWithText:data[@""]];
        }

        
        
    }];
    
    
//    NSString*str2=[NSString stringWithFormat:@"本次充值$%@",self.text.text];
//    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"充值成功" message:str2 delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    
//    [alert show];
}



#pragma mark-------支付宝支付
-(void)zhifubaoPayPPP{
    NSString*str1=self.text.text;
    if ([str1 isEqualToString:@"0"]) {
        [JRToast showWithText:@"请输入金额"];
    }else{
        
        //    http://www.vx.dev/? m=appapi&s=mall&act=pay_order&money＝0.01&operate＝alipay&uid＝
        
        NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
        NSString*money=self.text.text;
        NSDictionary*params=@{@"m":@"appapi",@"s":@"mall",@"act":@"pay_order",@"money":money,@"operate":@"alipay",@"uid":[UserSession instance].uid};
        HttpManager*manager= [[HttpManager alloc]init];
        [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            NSLog(@"%@",data);
            if ([data[@"errorCode"] isEqualToString:@"0"]) {
                
                
                     NSString *appScheme = @"aaalisdkdemo";
                
                NSString*signedString=data[@"data"][@"sign"];
                NSString*orderSpec=data[@"data"][@"orderSpec"];
                
                NSString *orderString = nil;
                if (signedString != nil) {
                    orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                   orderSpec, signedString, @"RSA"];
                    
                    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        NSLog(@"reslut = %@",resultDic);
                        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"支付结果" message:@"支付成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                            [self changeYue];
                            
                        }
                        
                        
                    }];
                }
                }else{
                [JRToast showWithText:data[@"errorMessage"]];
            }
        }];
    }
}

#pragma mark --------PayPal改变余额

//改变余额
//-(void)PayPalchangeYue{
//    //    	http://www.vx.dev/? m=appapi&s=membercenter&act=get_money&operate=wechat
//    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
//    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"get_money",@"operate":@"wechat",@"uid":[UserSession instance].uid};
//    HttpManager*manager=[[HttpManager alloc]init];
//    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
//        NSLog(@"%@",data);
//        if ([data[@"errorCode"] isEqualToString:@"0"]) {
//            UserSession*user=[UserSession instance];
//            user.cash=data[@"data"][0];
//            user.unreachable=data[@"data"][1];
//            user.point=data[@"data"][2];
//            
//            NSString*str2=[NSString stringWithFormat:@"本次充值$%@",self.text.text];
//            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"充值成功" message:str2 delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            
//            [alert show];
//
//            
//            [self.navigationController popViewControllerAnimated:YES];
//            
//        }else{
//            [JRToast showWithText:data[@"errorMessage"]];
//        }
//        
//    }];
//    
//}



#pragma mark --------
//改变余额
-(void)changeYue{
    //    	http://www.vx.dev/? m=appapi&s=membercenter&act=get_money&operate=wechat
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"get_money",@"operate":@"wechat",@"uid":[UserSession instance].uid};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            UserSession*user=[UserSession instance];
            user.cash=data[@"data"][0];
            user.unreachable=data[@"data"][1];
            user.point=data[@"data"][2];
            
            [self.navigationController popViewControllerAnimated:YES];
            

        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
    }];
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}


#pragma mark-------------------微信充值
-(void)weixinchongzhi{
    NSString*str1=self.text.text;
    if ([str1 isEqualToString:@"0"]) {
        [JRToast showWithText:@"请输入金额"];
    }else{
    
    
    NSString *res = [WXApiRequestHandler jumpToBizPay:(NSString*)self.text.text];
    if( ![@"" isEqual:res] ){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
           }

    }
}

//-(void)selectButton1:(UIButton*)sender{
//    if (!sender.selected) {
//        sender.selected=YES;
//    }else{
//        sender.selected=NO;
//    }
//}

-(void)selectButton1:(UIButton*)sender{
    _button1.selected=YES;
    _button2.selected=NO;
    _button3.selected=NO;
    _button4.selected=NO;
    _button5.selected=NO;
    [self getCurrent];
    [self getFuhao];
}

-(void)selectButton2:(UIButton*)sender{
    _button1.selected=NO;
    _button2.selected=YES;
    _button3.selected=NO;
    _button4.selected=NO;
    _button5.selected=NO;
    
#pragma mark  ----------- payPal 只能充值美刀
     _label1.text=@"充值金额USD:";
     _label2.text=@"$";
    
    
}

-(void)selectButton3:(UIButton*)sender{
    _button1.selected=NO;
    _button2.selected=NO;
    _button3.selected=YES;
    _button4.selected=NO;
    _button5.selected=NO;
    [self getCurrent];
     [self getFuhao];

}

-(void)selectButton4:(UIButton*)sender{
    _button1.selected=NO;
    _button2.selected=NO;
    _button3.selected=NO;
    _button4.selected=YES;
    _button5.selected=NO;
    [self getCurrent];
     [self getFuhao];

}

-(void)selectButton5:(UIButton*)sender{
    _button1.selected=NO;
    _button2.selected=NO;
    _button3.selected=NO;
    _button4.selected=NO;
    _button5.selected=YES;
    [self getCurrent];
     [self getFuhao];

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)dismissTo{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.placeholder=@"";
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
