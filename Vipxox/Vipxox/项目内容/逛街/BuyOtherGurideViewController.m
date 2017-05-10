//
//  BuyOtherGurideViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/5/31.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "BuyOtherGurideViewController.h"

@interface BuyOtherGurideViewController ()

@end

@implementation BuyOtherGurideViewController

- (void)viewDidLoad {
    self.title=@"代购指引";
    self.view.backgroundColor=[UIColor whiteColor];
    [super viewDidLoad];
    [self makeUI];
}

-(void)makeUI{
    UIScrollView*scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    scrollView.contentSize=CGSizeMake(KScreenWidth, KScreenHeight*6);
    [self.view addSubview:scrollView];
    
    for (int i=0; i<6; i++) {
        UIImageView*imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, KScreenHeight*i, KScreenWidth, KScreenHeight)];
        imageV.backgroundColor=[UIColor whiteColor];
        imageV.contentMode=UIViewContentModeScaleAspectFit;
        NSString*str=[NSString stringWithFormat:@"BuyGuride_%d",(i+1)];
        imageV.image=[UIImage imageNamed:str];
        [scrollView addSubview:imageV];
        
    }
    
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
