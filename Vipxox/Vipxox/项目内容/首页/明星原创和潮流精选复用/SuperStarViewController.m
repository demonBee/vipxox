//
//  SuperStarViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/14.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "SuperStarViewController.h"
#import "SuperStarTableViewCell.h"   //cell
#import "SuperStarDetailViewController.h"    //二级子界面




#define SUPERSTAR  @"SuperStarTableViewCell"
@interface SuperStarViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSMutableArray*allButtons;

@property(nonatomic,strong)NSMutableArray*allDatas;
@property(nonatomic,assign)int pages;
@property(nonatomic,assign)int pagen;
@property(nonatomic,strong)NSString*paramsName;


@end

@implementation SuperStarViewController
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(42)+64, KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(42)-64) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allDatas=[NSMutableArray array];
    self.pagen=100;
    self.pages=0;
    //默认状态  2种cate 2个默认

    if (self.cate==isMingxing) {
         self.paramsName=@"明星潮品";
    }else{
        self.paramsName=@"设计新潮";
    }
          [self whichCate];
    [self addTwoButton];
    [self.tableView registerNib:[UINib nibWithNibName:SUPERSTAR bundle:nil] forCellReuseIdentifier:SUPERSTAR];
    [self.view addSubview:self.tableView];
    // 2.集成刷新控件
    [self setupRefresh];

}
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    //不使用
//    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
}

-(void)getDatas{
//    http://www.vipxox.cn/ ?m=appapi&s=home_page&act=home_info&userid=q&get= start&name=&zt=0
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"home_page",@"act":@"home_info",@"userid":[UserSession instance].uid,@"get":@"start",@"zt":@"0",@"name":self.paramsName,@"pagen":pagen,@"pages":pages};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            [self.allDatas addObjectsFromArray:data[@"data"]];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        // 刷新表格
        [self.tableView reloadData];
        
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];

    }];
    
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    self.allDatas=[NSMutableArray array];
    self.pages=0;
    [self getDatas];
    
    
}
#warning ---没有分页类

- (void)footerRereshing
{
    self.pages++;
    
    [self getDatas];
    

}



-(void)whichCate{
    switch (self.cate) {
        case isMingxing:
            self.title=@"明星原创";
            break;
        case ischaoliu:
            self.title=@"潮流优选";
            break;
            
        default:
            break;
    }
    
}

-(void)addTwoButton{
    self.view.backgroundColor=[UIColor whiteColor];
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, ACTUAL_HEIGHT(42))];
    [self.view addSubview:mainView];
    self.allButtons=[NSMutableArray array];
    for (int i=0; i<2; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(i*(KScreenWidth/2), 0, KScreenWidth/2, ACTUAL_HEIGHT(42))];
        [button setTitleColor:RGBCOLOR(160, 160,160, 1) forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR(0, 0, 0, 1) forState:UIControlStateSelected];
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=i;
        [self.allButtons addObject:button];
        if (button.tag==0) {
            if (self.cate==isMingxing) {
                [button setTitle:@"明星潮品" forState:UIControlStateNormal];

            }else{
                [button setTitle:@"设计新潮" forState:UIControlStateNormal];

            }
        button.selected=YES;
        }else{
            if (self.cate==isMingxing) {
                [button setTitle:@"原创潮品" forState:UIControlStateNormal];
                
            }else{
                [button setTitle:@"潮流经典" forState:UIControlStateNormal];
                
            }

            
        }
        [mainView addSubview:button];
        
    }
    
    UIView*shuView=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/2, ACTUAL_HEIGHT(9), 1, ACTUAL_HEIGHT(25))];
    shuView.backgroundColor=[UIColor grayColor];
    [mainView addSubview:shuView];
    
    
}

-(void)touchButton:(UIButton*)sender{
    for (int i=0; i<self.allButtons.count; i++) {
        UIButton*button=self.allButtons[i];
        button.selected=NO;
    }
    
    if (sender.selected) {
        sender.selected=NO;
    }else{
        sender.selected=YES;
        if (sender.tag==0) {
            switch (self.cate) {
                case isMingxing:
                self.paramsName=@"明星潮品";
                    break;
                case ischaoliu:
                self.paramsName=@"设计新潮";
                    break;
    
                default:
                    break;
            }
          
            [self.tableView headerBeginRefreshing];
        }else{
            switch (self.cate) {
                case isMingxing:
                    self.paramsName=@"原创潮牌";
                    break;
                case ischaoliu:
                    self.paramsName=@"潮流经典";
                    break;
                    
                default:
                    break;
            }

           
            [self.tableView headerBeginRefreshing];

        }
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allDatas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SuperStarTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:SUPERSTAR];
    cell.selectionStyle=NO;
    UIImageView*imageView=[cell viewWithTag:11];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.allDatas[indexPath.section][@"pic"]] placeholderImage:[UIImage imageNamed:@"placeholder_375x180"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            imageView.alpha=0.3;
            CGFloat scale = 0.3;
            imageView.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                imageView.alpha=1;
                CGFloat scale = 1.0;
                imageView.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SuperStarDetailViewController*vc=[[SuperStarDetailViewController alloc]init];
    vc.dict=self.allDatas[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ACTUAL_HEIGHT(180);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
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
