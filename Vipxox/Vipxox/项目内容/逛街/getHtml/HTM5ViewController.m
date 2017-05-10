//
//  HTM5ViewController.m
//  weimao
//
//  Created by 黄佳峰 on 16/2/22.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import "HTM5ViewController.h"
#import "HttpManager.h"
#import "GoodsBuyOnBehalfViewController.h"

@interface HTM5ViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *htmlWeb;
@property(nonatomic,strong)UIButton*leftButton;   //2个返回按钮
@property(nonatomic,strong)UIButton*rightButton;
@property(nonatomic,strong)UIButton*shopCarButton;
@property(nonatomic,strong)UIButton *buyBuyBuy;
@property(nonatomic,strong)NSString * encodingString;
@property(nonatomic,strong)NSString *requesetUrlStr;

@property(nonatomic,strong)NSString*arrUrl;
@property(nonatomic,strong)NSURL *requestURL;
@end

@implementation HTM5ViewController

-(UIWebView *)htmlWeb{
    if (!_htmlWeb) {
        _htmlWeb=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64)];
        NSURL *url=[NSURL URLWithString:self.strHtml];
        _htmlWeb.delegate=self;
        [_htmlWeb loadRequest:[NSURLRequest requestWithURL:url]];
    }
    return _htmlWeb;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //貌似 就是个  bug
    UIView*naviBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, KScreenWidth, 44)];
    naviBackView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:naviBackView];
    [self.view addSubview:self.htmlWeb];
    NSLog(@"%@",NSStringFromCGRect(self.htmlWeb.frame));
    
    UIButton *leftButton=[[UIButton alloc]init];
    leftButton.frame=CGRectMake(0, 0, ACTUAL_WIDTH(20), ACTUAL_HEIGHT(20));
    [leftButton setImage:[UIImage imageNamed:@"fork"] forState:0];
    [leftButton addTarget:self action:@selector(comeBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBBI=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=leftBBI;
    
    
    [self makeNavi];
    
    [self addbottomView];
    
    self.title=self.str1;
    
//    [self.htmlWeb goBack];
//    [self.htmlWeb goForward];
//    self.htmlWeb.canGoBack;
    
}

-(void)addbottomView{
    UIView*bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-ACTUAL_HEIGHT(57), KScreenWidth, ACTUAL_HEIGHT(59))];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-ACTUAL_HEIGHT(58), KScreenWidth, ACTUAL_HEIGHT(1))];
    lineView.backgroundColor=RGBCOLOR(240, 241, 242, 1);
    [self.view addSubview:lineView];
    
    
    _leftButton=[UIButton buttonWithType:0];
    _leftButton.frame=CGRectMake(ACTUAL_WIDTH(34), ACTUAL_HEIGHT(13), ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30));
    [_leftButton addTarget:self action:@selector(aaa) forControlEvents:UIControlEventTouchUpInside];
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"zuohui"] forState:UIControlStateNormal];
    [bottomView addSubview:_leftButton];
    
    
    _rightButton=[UIButton buttonWithType:0];
    _rightButton.frame=CGRectMake(ACTUAL_WIDTH(105), ACTUAL_HEIGHT(13), ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30));
    [_rightButton addTarget:self action:@selector(bbb) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"youhui"] forState:UIControlStateNormal];
    [bottomView addSubview:_rightButton];
    
    self.buyBuyBuy=[UIButton buttonWithType:0];
    _buyBuyBuy.frame=CGRectMake(ACTUAL_WIDTH(230), ACTUAL_HEIGHT(8), ACTUAL_WIDTH(130), ACTUAL_HEIGHT(44));
    [_buyBuyBuy setTitle:@"我要代购" forState:0];
    [_buyBuyBuy setTitleColor:[UIColor whiteColor] forState:0];
    _buyBuyBuy.titleLabel.font=[UIFont systemFontOfSize:16];
    _buyBuyBuy.backgroundColor=RGBCOLOR(70,73,70,1);
    _buyBuyBuy.layer.cornerRadius=5;
    [_buyBuyBuy addTarget:self action:@selector(gotoBuy) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_buyBuyBuy];
}

-(void)gotoBuy{

    GoodsBuyOnBehalfViewController*vc=[[GoodsBuyOnBehalfViewController alloc]init];
        vc.url=self.arrUrl;
        [self.navigationController pushViewController:vc animated:YES];
}
    
-(void)touchShopCar{
    //接口
    
}

-(void)aaa{
    [self.htmlWeb goBack];
    
}

-(void)bbb{
    [self.htmlWeb goForward];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.leftButton.enabled = webView.canGoBack;
    self.rightButton.enabled = webView.canGoForward;
    
    
    
}

//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//
//
//}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //数据给后台
//    NSLog(@"%@",request);
//    NSString*str=request.description;
//    NSLog(@"%@",str);
    
//    _requestURL =[request URL];
//    _requesetUrlStr =[_requestURL absoluteString];
//    NSLog(@"%@",_requesetUrlStr);
//  
//   _encodingString = [_requesetUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    self.arrUrl=_encodingString;
    NSLog(@"%@",request);
    NSURL *requestURL =[request URL];
    NSString *requesetUrlStr =[requestURL absoluteString];
    NSLog(@"%@",requesetUrlStr);
    
    NSString * encodingString = [requesetUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString*string = [encodingString substringToIndex:4];
    
    if ([string isEqualToString:@"http"]) {
         self.arrUrl=encodingString;
        NSLog(@"%@",self.arrUrl);
    }
    
    return YES;
}

-(void)makeNavi{
    
    self.view.backgroundColor=[UIColor whiteColor];
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(156), ACTUAL_HEIGHT(34), ACTUAL_WIDTH(69), ACTUAL_WIDTH(19))];
    titleLabel.text=@"代购订单";
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    
    UIButton*button=[UIButton buttonWithType:0];
    button.frame=CGRectMake(ACTUAL_WIDTH(10), ACTUAL_HEIGHT(37), ACTUAL_WIDTH(10), ACTUAL_HEIGHT(15));
    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

-(void)dismissTo{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)comeBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//错误时
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//    [alterview show];
//    [alterview release];
//}


@end
