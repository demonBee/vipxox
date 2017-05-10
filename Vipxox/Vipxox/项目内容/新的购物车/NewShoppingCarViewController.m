//
//  NewShoppingCarViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/19.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "NewShoppingCarViewController.h"

@interface NewShoppingCarViewController ()

@end

@implementation NewShoppingCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor redColor];
    [self addSegementedControl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addSegementedControl{
    UISegmentedControl*segment=[[UISegmentedControl alloc]initWithItems:@[@"商城",@"代购",@"网红专区"]];
    segment.frame=CGRectMake(0, 0, 180, 30);
    segment.selectedSegmentIndex=0;
    self.navigationItem.titleView=segment;
    [segment addTarget:self action:@selector(touchSegment:) forControlEvents:UIControlEventValueChanged];
    
}

-(void)touchSegment:(UISegmentedControl*)sender{
    NSLog(@"%lu",sender.selectedSegmentIndex);
    switch (sender.selectedSegmentIndex) {
        case 0:
            //商城
            
            break;
        case 1:
            //代购
            
            break;
        case 2:
            //百货
            
            break;
            
        default:
            break;
    }
    
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
