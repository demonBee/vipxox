//
//  ChooseViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ChooseViewController.h"
#import "ChooseTableViewCell.h"
#import "RealChooseViewController.h"
#import "ZhekouViewController.h"

#define chooseTable  @"ChooseTableViewCell"
@interface ChooseViewController ()<UITableViewDataSource,UITableViewDelegate,RealChooseViewControllerDelegate,ZhekouViewControllerDelegate>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSArray*xuanze;  //性别  品牌
@property(nonatomic,strong)NSArray*jieguo;  //所有品牌 所有颜色
@property(nonatomic,strong)NSIndexPath*touIndexPath;    //当前点击的哪一行

@property(nonatomic,assign)BOOL cantTouch;  //能够点击   1为不能点击   0为能点击
@end


@implementation ChooseViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView.backgroundColor=[UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:chooseTable bundle:nil] forCellReuseIdentifier:chooseTable];
    [self getDatas];
    
    
}

-(void)getDatas{
    self.xuanze=@[@"性别",@"品牌",@"品类",@"颜色",@"价格",@"产地"];
    self.jieguo=@[@"全部",@"所有品牌",@"所有品类",@"所有颜色",@"所有价格",@"所有产地"];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.xuanze.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell) {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        
//    }
    ChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:chooseTable];
    cell.xuanze.text=self.xuanze[indexPath.row];
    cell.jieguo.text=self.jieguo[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
//    cell.isSelected=NO;
    self.touIndexPath=indexPath;

    
    if (self.cantTouch==YES) {
        return;
    }else{
        
        if ([self.delegate respondsToSelector:@selector(chooseWhichRow:)]) {
            [self.delegate chooseWhichRow:indexPath];
        }

        self.cantTouch=YES;
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(twoSecondDismiss:) userInfo:nil repeats:NO];
        
      
        
    }
    
   
    
}

-(void)twoSecondDismiss:(NSTimer*)timer{
    self.cantTouch=NO;
    timer=0;
    [timer invalidate];
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

-(void)backGoods:(NSString *)mainGoods subGoods:(NSString *)subgoods andTag:(NSInteger)tag{
    NSLog(@"%@",mainGoods);
    ChooseTableViewCell*cell=[self.tableView cellForRowAtIndexPath:self.touIndexPath];
    if (self.touIndexPath.row==2&&![mainGoods isEqualToString:@"所有品类"]) {
        cell.jieguo.text=subgoods;
    }else{
          cell.jieguo.text=mainGoods;
    }
    
  
    
}
#pragma mark  --------代理啊
-(void)delegateForClear{
    [self.tableView reloadData];
}
-(void)delegateForSendOK{
  
    NSMutableArray*arrayAllValue=[NSMutableArray array];
    for (int i=0; i<self.xuanze.count; i++) {
        ChooseTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [arrayAllValue addObject:cell.jieguo.text];
    }
    NSLog(@"%@",arrayAllValue);
    NSDictionary*dic=@{@"key":arrayAllValue};
// 得到了 这6个值    通知bottom控制器scroll回0 －20位置        通知discount控制器刷新
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tongzhipianyiheshuaxin" object:nil userInfo:dic];
    
    

    
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
