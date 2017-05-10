//
//  CommitListViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/28.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "CommitListViewController.h"
#import "CommitTableViewCell.h"


#import "UITableView+FDTemplateLayoutCell.h" 
#define COMMITLIST   @"CommitTableViewCell"

@interface CommitListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSMutableArray*allDatas;
@property(nonatomic,assign)NSInteger pages;
@property(nonatomic,assign)NSInteger pagen;
@end

@implementation CommitListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"评论";
    if (self.howmuchCommit!=nil) {
        self.title=[NSString stringWithFormat:@"查看%@条点评",self.howmuchCommit];

    }
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:COMMITLIST bundle:nil] forCellReuseIdentifier:COMMITLIST];
    // 2.集成刷新控件
    [self setupRefresh];

    
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    self.pagen=20;
    self.pages=0;
    self.allDatas=[NSMutableArray array];
    [self getPinlunDatas];
    
//    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//    [self.tableView headerEndRefreshing];
    
}

- (void)footerRereshing
{
    self.pagen=20;
    self.pages++;
    [self getPinlunDatas];
    
//    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//    [self.tableView footerEndRefreshing];
    
}


//接口
-(void)getPinlunDatas{
//    http://www.vipxox.com  /?m=appapi&s=home_page&act=comment&pid=866&pagen=6&pages=0&uid=q
    
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSString*pagen=[NSString stringWithFormat:@"%lu",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%lu",self.pages];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"home_page",@"act":@"comment",@"pid":self.pid,@"pagen":pagen,@"pages":pages,@"uid":[UserSession instance].uid};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            [self.allDatas addObjectsFromArray:data[@"data"]];
            // 刷新表格
            [self.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
        
        
    }];

    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allDatas.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
       CommitTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:COMMITLIST];
       cell.selectionStyle=NO;
    
    if (self.allDatas.count<=0) {
        return cell;
    }
    

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configureCell:(CommitTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
 
    NSDictionary*dict=self.allDatas[indexPath.row];
    
    //userimg user con  score  attr create_time  没有时间字段和赞字段 多了个属性字段
//    NSDictionary*newDict=@{@"userimg":dict[@"userimg"],@"user":dict[@"user"],@"con":dict[@"con"],@"score":dict[@"score"],@"attr":dict[@"attr"],@"create_time":dict[@"create_time"]};
    
    DetailCommitModel*model=[[DetailCommitModel alloc]init];
    model.userimg=dict[@"userimg"];
    model.user=dict[@"user"];
    model.con=dict[@"con"];
    model.score=dict[@"score"];
    model.attr=dict[@"attr"];
    model.create_time=dict[@"create_time"];
    
    
    [cell FourCan:isOldCommitList andDict:model];

   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:COMMITLIST cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    
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

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
