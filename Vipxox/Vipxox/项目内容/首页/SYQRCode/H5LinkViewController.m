//
//  H5LinkViewController.m
//  GKAPP
//
//  Created by FoREVer_SaD on 15/11/24.
//  Copyright © 2015年 qiyuexinxi. All rights reserved.
//

#import "H5LinkViewController.h"

@interface H5LinkViewController ()

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIView *naviBackgroundView;

@end

@implementation H5LinkViewController

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.naviBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, StatusBarHeight)];
    self.navigationController.navigationBar.backgroundColor = ManColor;
    self.naviBackgroundView.backgroundColor = ManColor;
    [self.navigationController.view addSubview:self.naviBackgroundView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.naviBackgroundView removeFromSuperview];

    if(self.isFromPersonal)
    {
        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    }
}

//http://player.youku.com/embed/XMTQwNjU3NTI0MA==
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.h5LinkString);
    self.view.backgroundColor = ManColor;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64);
    // Do any additional setup after loading the view from its nib.
    //self.h5LinkString = @"http://player.youku.com/embed/XMTQwNjU3NTI0MA==";
    if ([self.h5LinkString rangeOfString:@"http://"].location ==NSNotFound) {
        self.h5LinkString = [NSString stringWithFormat:@"http://%@", self.h5LinkString];
    }
    
    if (self.isVideoUrl){
        self.webView.frame = CGRectMake(0, (KScreenHeight-8.0/15*KScreenWidth)/2-64, KScreenWidth, 8.0/15*KScreenWidth);
    } else {
        self.webView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64);
    }
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.h5LinkString]]]];
    //self.view.backgroundColor = [UIColor redColor];
    //self.webView.backgroundColor = [UIColor greenColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"%@", NSStringFromCGRect(self.webView.frame));
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
