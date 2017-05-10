//
//  MyCollectViewController.m
//  weimao
//
//  Created by 黄佳峰 on 16/2/5.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import "MyCollectViewController.h"



#define MyCollectCell  @"MyCollectCell"


@interface MyCollectViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIView *stripeView;

@property(nonatomic,strong)NSArray*allDatas;
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSMutableArray*fourButtons;


@end

@implementation MyCollectViewController
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight+NavigationBarHeight+ACTUAL_HEIGHT(15), KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self modifiedNavi];
    
    
    
    
    
    self.fourButtons=[NSMutableArray array];
    
    [self getDatas];
    [self createView];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:MyCollectCell bundle:nil] forCellReuseIdentifier:MyCollectCell];
    
}
-(void)goBackAction{
    
    // 在这里增加返回按钮的自定义动作
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)modifiedNavi{
    self.navigationController.navigationBar.backgroundColor=RGBCOLOR(255, 93, 94, 1);
    self.view.backgroundColor=[UIColor blackColor];
    
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(KScreenWidth/2-40, 1000, 90, 20)];
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textColor=[UIColor whiteColor];
    [titleText setFont:[UIFont systemFontOfSize:13]];
    [titleText setText:@"     国际运单"];
    self.navigationItem.titleView=titleText;
    
    //
    [self.navigationItem setHidesBackButton:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(30, 1000, 10, 10);
    btn.backgroundColor=[UIColor yellowColor];
    //    [btn setBackgroundImage:[UIImage imageNamed:@"按钮-返回1.png"] forState:UIControlStateNormal];
    
    [btn addTarget: self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=back;
    
    
    
    
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bigShadow.png"] forBarMetrics:UIBarMetricsCompact];
    self.navigationController.navigationBar.layer.masksToBounds = YES;
    
    
    //    CGRect frameOfNavigationBar = [UIScreen mainScreen].bounds;
    //    frameOfNavigationBar.size.height = 20+(30*(CGFloat)320/375);
    CGRect frameOfNavigationBar=CGRectMake(0, 0, KScreenWidth,20+(30*(CGFloat)320/375));
    [self.navigationController.navigationBar setFrame:frameOfNavigationBar];
    NSLog(@"%f",KScreenWidth);
    NSLog(@"%@",NSStringFromCGRect(self.navigationController.navigationBar.frame));
    
}


-(void)getDatas{
    NSDictionary *dict0 = @{@"image":@"shangpin01",@"content":@"2015秋寒版女鞋内增高厚底高帮鞋运动休闲鞋松糕鞋中跟潮流鞋子",@"money":@"¥46"};
    NSDictionary *dict1 = @{@"image":@"shangpin01",@"content":@"2015秋寒版女鞋内增高厚底高帮鞋运动休闲鞋松糕鞋中跟潮流鞋子",@"money":@"¥46"};
     NSDictionary *dict2 = @{@"image":@"shangpin01",@"content":@"2015秋寒版女鞋内增高厚底高帮鞋运动休闲鞋松糕鞋中跟潮流鞋子",@"money":@"¥46"};
    
    self.allDatas=[NSArray arrayWithObjects:dict0,dict1,dict2, nil];
    
    
    
}


-(void)createView{
    self.stripeView=[[UIView alloc]initWithFrame:CGRectMake(0, 45, KScreenWidth, ACTUAL_HEIGHT(40))];
    self.stripeView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.stripeView];
    
    //0
    UIButton*button0=[UIButton buttonWithType:UIButtonTypeSystem];
    [button0 setTitle:@"全部宝贝" forState:UIControlStateNormal];
    [button0 setTitleColor:RGBCOLOR(173, 173, 173, 1) forState:UIControlStateNormal];
    [button0 setTitleColor:RGBCOLOR(255, 99, 99, 1) forState:UIControlStateSelected];
    
    button0.titleLabel.font=[UIFont systemFontOfSize:12];
    button0.frame=CGRectMake(ACTUAL_WIDTH(52), ACTUAL_HEIGHT(12), ACTUAL_WIDTH(60), ACTUAL_HEIGHT(15));
    [button0 addTarget:self action:@selector(touchButton0:) forControlEvents:UIControlEventTouchUpInside];
    button0.tag=0;
    [self.fourButtons addObject:button0];
    [self.stripeView addSubview:button0];
    
    UIImageView*imageView0=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuxian"]];
    imageView0.frame=CGRectMake(ACTUAL_WIDTH(141), ACTUAL_HEIGHT(12), 1, ACTUAL_HEIGHT(15));
    imageView0.backgroundColor=[UIColor whiteColor];
    imageView0.contentMode=UIViewContentModeScaleAspectFit;

    [self.stripeView addSubview:imageView0];
    
    //1
    UIButton*button1=[UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:@"全部店铺" forState:UIControlStateNormal];
    [button1 setTitleColor:RGBCOLOR(173, 173, 173, 1) forState:UIControlStateNormal];
    [button1 setTitleColor:RGBCOLOR(255, 99, 99, 1) forState:UIControlStateSelected];
    button1.titleLabel.font=[UIFont systemFontOfSize:12];
    button1.frame=CGRectMake(ACTUAL_WIDTH(168), ACTUAL_HEIGHT(12), ACTUAL_WIDTH(60), ACTUAL_HEIGHT(15));
    [button1 addTarget:self action:@selector(touchButton1:) forControlEvents:UIControlEventTouchUpInside];
    [self.stripeView addSubview:button1];
    button1.tag=1;
    [self.fourButtons addObject:button1];
    
    UIImageView*imageView1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shuxian"]];
    imageView1.frame=CGRectMake(ACTUAL_WIDTH(257), ACTUAL_HEIGHT(12), 1, ACTUAL_HEIGHT(15));
    imageView1.backgroundColor=[UIColor whiteColor];
    imageView1.contentMode=UIViewContentModeScaleAspectFit;

    [self.stripeView addSubview:imageView1];
    
    //2
    UIButton*button2=[UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"我的清单" forState:UIControlStateNormal];
    [button2 setTitleColor:RGBCOLOR(173, 173, 173, 1) forState:UIControlStateNormal];
    [button2 setTitleColor:RGBCOLOR(255, 99, 99, 1) forState:UIControlStateSelected];
    button2.titleLabel.font=[UIFont systemFontOfSize:12];
    button2.frame=CGRectMake(ACTUAL_WIDTH(282), ACTUAL_HEIGHT(12), ACTUAL_WIDTH(60), ACTUAL_HEIGHT(15));
    [button2 addTarget:self action:@selector(touchButton2:) forControlEvents:UIControlEventTouchUpInside];
    [self.stripeView addSubview:button2];
    button2.tag=2;
    [self.fourButtons addObject:button2];
    
    
}


-(void)touchButton0:(UIButton*)sender{
    for (UIButton*button in self.fourButtons) {
        button.selected=NO;
    }
    
    if (sender.selected) {
        
        sender.selected=NO;
    }else{
        sender.selected=YES;
    }
    
}
-(void)touchButton1:(UIButton*)sender{
    for (UIButton*button in self.fourButtons) {
        button.selected=NO;
    }
    if (sender.selected) {
        sender.selected=NO;
        
    }else{
        sender.selected=YES;
        
    }
    
}
-(void)touchButton2:(UIButton*)sender{
    for (UIButton*button in self.fourButtons) {
        button.selected=NO;
    }
    
    if (sender.selected) {
        sender.selected=NO;
        
    }else{
        sender.selected=YES;
        
    }
    
}

#pragma mark --------- tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allDatas.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:MyCollectCell];
    
    UIImageView*imageViewTag1=[cell viewWithTag:1];
    imageViewTag1.backgroundColor=[UIColor whiteColor];
    imageViewTag1.contentMode=UIViewContentModeScaleAspectFit;

    imageViewTag1.image=[UIImage imageNamed:self.allDatas[indexPath.row][@"image"]];

    
    UILabel*labelTag2=[cell viewWithTag:2];
    labelTag2.text=self.allDatas[indexPath.row][@"content"];
    
      UILabel*labelTag3=[cell viewWithTag:3];
    labelTag3.text=self.allDatas[indexPath.row][@"money"];
    
    //wait
    UIButton*buttonTag4=[cell viewWithTag:4];
    
    UIButton*buttonTag5=[cell viewWithTag:5];

   
    
    
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    return ACTUAL_HEIGHT(134);
    return 134;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* topView=[[UIView alloc]init];
    topView.frame=CGRectMake(0, 0, KScreenWidth, 25);
    topView.backgroundColor=RGBCOLOR(249, 249, 249, 1);
    
    UILabel*label=[[UILabel alloc]init];
    label.text=@"最近1个月收藏";
    label.frame=CGRectMake(10, 8, 85, 13);
    label.font=[UIFont systemFontOfSize:11];
    label.textColor=RGBCOLOR(165, 167, 173, 1);
    [topView addSubview:label];
    
    return topView;
    
    
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
