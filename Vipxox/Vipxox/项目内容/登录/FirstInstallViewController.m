//
//  FirstInstallViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/4/5.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "FirstInstallViewController.h"
#import "YLWTabBarController.h"

@interface FirstInstallViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)NSArray*allDatas;
@property(nonatomic,strong)UIScrollView*scrollView;
@property(nonatomic,strong)UIPageControl*pageControl;
@end

@implementation FirstInstallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor=[UIColor redColor];
    [self getDatas];
    [self addScrollView];

}

-(void)getDatas{
    self.allDatas=@[@"lb1",@"lb2",@"lb3",@"lb4",@"lb5"];
    
    
}

-(void)addScrollView{
    _scrollView=[[UIScrollView alloc]initWithFrame:self.view.frame];
    _scrollView.backgroundColor=[UIColor whiteColor];
    _scrollView.contentSize=CGSizeMake(KScreenWidth*5, KScreenHeight);
    _scrollView.pagingEnabled=YES;
    _scrollView.bounces=NO;
    _scrollView.delegate=self;
    [self.view addSubview:_scrollView];
    
    self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(KScreenWidth/2-ACTUAL_WIDTH(40),KScreenHeight-ACTUAL_HEIGHT(80), ACTUAL_WIDTH(80), ACTUAL_HEIGHT(25))];
    self.pageControl.numberOfPages=5;
    self.pageControl.currentPage=0;
    [self.pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];  //用户点击UIPageControl的响应函数
    [self.view addSubview:self.pageControl];  //将UIPageControl添加到主界面上。
    
    
    for (int i=0; i<5; i++) {
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*KScreenWidth, 0, KScreenWidth, KScreenHeight)];
//        imageView.backgroundColor=[UIColor whiteColor];r
        imageView.contentMode=UIViewContentModeScaleAspectFit;

        [_scrollView addSubview:imageView];
        imageView.image=[UIImage imageNamed:self.allDatas[i]];
        
        
    }
    
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(4*KScreenWidth, 0, KScreenWidth, kScreen_Height)];
//    button.backgroundColor=[UIColor greenColor];
//    [button setBackgroundImage:[UIImage imageNamed:@"点击进入"] forState:UIControlStateNormal];j
    [button addTarget:self action:@selector(touchButton) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
    
}


//其次是UIScrollViewDelegate的scrollViewDidEndDecelerating函数，用户滑动页面停下后调用该函数。


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [self.pageControl setCurrentPage:offset.x / bounds.size.width];
//    NSLog(@"%f",offset.x / bounds.size.width);
}

//然后是点击UIPageControl时的响应函数pageTurn


- (void)pageTurn:(UIPageControl*)sender
{
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = _scrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [_scrollView scrollRectToVisible:rect animated:YES];
}


-(void)touchButton{
    NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
    [user setObject:@"YES" forKey:ISFIRSTINSTALL];
    
    YLWTabBarController*vc=[[YLWTabBarController alloc]init];
    UIWindow*window=[[UIApplication sharedApplication] keyWindow];
    window.rootViewController=vc;
    
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
