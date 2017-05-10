//
//  NewCloudWareViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/4.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "NewCloudWareViewController.h"
#import "YJSegmentedControl.h"

#import "AffirmOrderViewController.h"   //那个 快递订单
#import "cloudModel.h"   //model
// 缺少自定义cell

#define CLOUDBOTTOMVIEW   @"CloudWareBottomView"
#define   TRADEORDER      @"TradeOrder"


@interface NewCloudWareViewController ()<YJSegmentedControlDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UIView*bottomView;


@property(nonatomic,strong)NSMutableArray*mtAllDatas;  //所有数据
@property(nonatomic,assign)int pagen;   //每页多少条
@property(nonatomic,assign)int pages;   //第几页
@property(nonatomic,assign)int zt;   //“0”=>”超期”,“1”=>”过期”,“2”=>”历史”,“3”=>”当前库存”,

@property(nonatomic,assign)CGFloat allPrice;
@property(nonatomic,assign)CGFloat allWeight;

@end

@implementation NewCloudWareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createtopView];
    self.category=0;
    self.pagen=10;
    self.pages=0;
    self.zt=3;
    self.mtAllDatas=[NSMutableArray array];
    self.title=@"云仓库";
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:TRADEORDER bundle:nil] forCellReuseIdentifier:TRADEORDER];
    
    [self addBottomView];
    [self setupRefresh];
    
}

#pragma mark  UI
-(void)createtopView{

    self.title=@"云仓库";
    
    NSArray*aa=@[@"当前库存",@"快过期",@"历史库存"];
  UIView*view=  [YJSegmentedControl segmentedControlFrame:CGRectMake(0, 64, KScreenWidth, 44) titleDataSource:aa backgroundColor:[UIColor whiteColor] titleColor:RGBCOLOR(210, 210,210, 1) titleFont:[UIFont systemFontOfSize:14] selectColor:RGBCOLOR(70, 73, 70, 1) buttonDownColor:RGBCOLOR(70, 73, 70, 1) Delegate:self];
    [self.view addSubview:view];
    
}

-(void)addBottomView{
//    UIView*bottomVIew=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-100, KScreenWidth, 100)];
//    bottomVIew.backgroundColor=[UIColor greenColor];
//    [self.view addSubview:bottomVIew];
    
    self.bottomView=[[NSBundle mainBundle]loadNibNamed:CLOUDBOTTOMVIEW owner:nil options:nil].firstObject;
    self.bottomView.frame=CGRectMake(0, KScreenHeight-80, KScreenWidth, 80);
    [self.view addSubview:self.bottomView];
    
    UIButton*allChoose=[self.bottomView viewWithTag:1];
    [allChoose setBackgroundImage:[UIImage imageNamed:@"notAllSelect"] forState:UIControlStateNormal];
    [allChoose setBackgroundImage:[UIImage imageNamed:@"allSelect"] forState:UIControlStateSelected];
    [allChoose addTarget:self action:@selector(touchAllChoose:) forControlEvents:UIControlEventTouchUpInside];
    [allChoose setAdjustsImageWhenHighlighted:NO];
    
    UIButton*okButton=[self.bottomView viewWithTag:4];
    [okButton addTarget:self action:@selector(touchOkButton:) forControlEvents:UIControlEventTouchUpInside];
    [okButton setAdjustsImageWhenHighlighted:NO];
}

#pragma mark  tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mtAllDatas.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:TRADEORDER];
    if (self.mtAllDatas.count<1) {
        return cell;
    }
    
    cell.selectionStyle=NO;
    cloudModel*model=self.mtAllDatas[indexPath.row];
  
    [self orginCellControl:model andCell:cell];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 192;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.category==1) {
        return;
    }
    
       cloudModel*model=self.mtAllDatas[indexPath.row];
    model.isSelected=!model.isSelected;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    BOOL BottomViewSelected =YES;
    for (int i=0; i<self.mtAllDatas.count; i++) {
        cloudModel*model=self.mtAllDatas[i];
        if (!model.isSelected) {
            BottomViewSelected=NO;
        }
        
    }
    if (BottomViewSelected) {
        
        //让底部的也变成选中
        UIButton*bottomButton=[self.bottomView viewWithTag:1];
        bottomButton.selected=YES;
        
    }
    
    
}

-(void)orginCellControl:(cloudModel*)model andCell:(UITableViewCell*)cell{
    UIImageView*imageView0=[cell viewWithTag:1];
    imageView0.hidden=YES;
    UILabel*label0Jiage=[cell viewWithTag:5];
    label0Jiage.hidden=YES;
    UILabel*label0Num=[cell viewWithTag:6];
    label0Num.hidden=YES;
    UIButton*buttonShow=[cell viewWithTag:10];
    buttonShow.hidden=YES;
    
    //1
    UIButton*selectButton=[cell viewWithTag:1111];
    if (!selectButton) {
        selectButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 12, 22, 22)];
        selectButton.tag=1111;
        [selectButton setBackgroundImage:[UIImage imageNamed:@"shopCar_whiteBall"] forState:UIControlStateNormal];
        [selectButton setBackgroundImage:[UIImage imageNamed:@"shopCar_blackBall"] forState:UIControlStateSelected];
        [cell.contentView addSubview:selectButton];
    }
    if (model.isSelected==YES) {
        selectButton.selected=YES;
    }else{
        selectButton.selected=NO;
    }
    
    //2
    UILabel*labelTop=[cell viewWithTag:2];
    labelTop.text=model.order_id;
    
    //tupian
    UIImageView*imageViewPHoto=[cell viewWithTag:3];
    [imageViewPHoto sd_setImageWithURL:[NSURL URLWithString:model.pro_pic] placeholderImage:[UIImage imageNamed:@"placeholder_375x375"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    //title
    UILabel*labelTitle=[cell viewWithTag:4];
    labelTitle.text=model.title;
    
    //attr
    UILabel*attLabel=[cell viewWithTag:7];
    attLabel.text=model.attr_desc;
    
    //
    UILabel*numLabel=[cell viewWithTag:11];
    numLabel.text=[NSString stringWithFormat:@"商品数量：%@",model.num];
    
    //price
    UILabel*moneyLabel=[cell viewWithTag:12];
    moneyLabel.text=[NSString stringWithFormat:@"净重：%@",model.weight];
    
    //订单状态
    UILabel*labelStatus=[cell viewWithTag:13];
    labelStatus.text=[NSString stringWithFormat:@"订单状态：%@",model.status];
    
    
    //计算价格
    [self calculatorPrice];
    
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{

    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];

    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    #warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    self.pages=0;
    self.mtAllDatas=[NSMutableArray array];
    
    [self getDatas];
    
    
}

- (void)footerRereshing
{
    self.pages++;
    [self getDatas];
    
}


#pragma mark   Touch
-(void)segumentSelectionChange:(NSInteger)selection{
    NSLog(@"%ld",selection);
    switch (selection) {
        case 0:
            self.zt=3;
            self.category=0;
            self.tableView.frame=CGRectMake(0, 64+44, KScreenWidth, KScreenHeight-64-44-80);
            self.bottomView.hidden=NO;
            
            //好像不会刷新
            [self.tableView headerBeginRefreshing];
            break;
        case 1:
            self.zt=2;
            self.category=0;
            self.tableView.frame=CGRectMake(0, 64+44, KScreenWidth, KScreenHeight-64-44-80);
            self.bottomView.hidden=NO;

            //好像不会刷新
            [self.tableView headerBeginRefreshing];
            break;
        case 2:
            self.zt=1;
            self.category=cantSeleced;
            self.tableView.frame=CGRectMake(0, 64+44, KScreenWidth, KScreenHeight-64-44);
            self.bottomView.hidden=YES;

            //好像不会刷新
            [self.tableView headerBeginRefreshing];
            break;

            
        default:
            break;
    }
    
    
}

-(void)touchAllChoose:(UIButton*)sender{
    if (sender.selected) {
        sender.selected=NO;
    }else{
        sender.selected=YES;
    }
    
    for (cloudModel*model in self.mtAllDatas) {
        model.isSelected=sender.selected;
    }
    
    [self.tableView reloadData];
    
    
}

-(void)touchOkButton:(UIButton*)sender{
    //提交运送
    NSMutableArray*array=[NSMutableArray array];
    for (cloudModel*model in self.mtAllDatas) {
        if (model.isSelected) {
            [array addObject:model];
        }
    }
    
    if (array.count<1) {
        [JRToast showWithText:@"请选择需要提交的商品"];
        return;
    }else{
        
//   http://www.vipxox.cn/?m=appapi&s=membercenter&act=cloud_logistics&uid=1&pids=
        NSMutableArray*saveIdArray=[NSMutableArray array];
        for (int i=0; i<array.count; i++) {
            cloudModel *model=array[i];
            [saveIdArray addObject:model.idd];
            
        }
        
        NSString*strIDD=[saveIdArray componentsJoinedByString:@","];
        NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
        NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"cloud_logistics"
                              ,@"uid":[UserSession instance].uid,@"pids":strIDD};
        
        HttpManager*manager=[[HttpManager alloc]init];
        [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
            NSLog(@"%@",data);
            
            NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
            
            if ([number isEqualToString:@"0"]) {
                AffirmOrderViewController*vc=[[AffirmOrderViewController alloc]init];
                vc.allDatas=data[@"data"];
                vc.addressDic=data[@"address"];
                vc.pidStr=strIDD;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                [JRToast showWithText:data[@"errorMessage"]];
            }

            
        }];
        
        
    }
    
    
}


#pragma mark   jiekou

-(void)getDatas{
//http://www.vipxox.cn/?  m=appapi&s=membercenter&act=cloud_warehouse&uid=1&pagen=6&pages=1&zt=3

    
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*zt=[NSString stringWithFormat:@"%d",self.zt];
    
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"cloud_warehouse"
                          ,@"uid":[UserSession instance].uid,@"pagen":pagen,@"pages":pages,@"zt":zt};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            NSArray*array=data[@"data"];
            for (int i=0; i<array.count; i++) {
                cloudModel*model=[[cloudModel alloc]initWithShopDict:array[i]];

                
                [self.mtAllDatas addObject:model];
                
            }
            
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];

    }];
    
    
    
    
    
}


//计算价格
-(void)calculatorPrice{
    self.allPrice=0;
    self.allWeight=0;
    for (cloudModel*model in self.mtAllDatas) {
        
        if (model.isSelected) {
            NSString*moneyStr=model.price;
            NSString*weightStr=model.weight;
            
            CGFloat moneyFloat=[moneyStr floatValue];
            CGFloat weightFloat=[weightStr floatValue];
            
            self.allPrice=self.allPrice+moneyFloat;
            self.allWeight=self.allWeight+weightFloat;

        }
        
    }
    
    
    UILabel*priceLabel=[self.bottomView viewWithTag:2];
    priceLabel.text=[NSString stringWithFormat:@"总价值：%@%.2f",[UserSession instance].currency,self.allPrice];
    
    UILabel*weightLabel=[self.bottomView viewWithTag:3];
    weightLabel.text=[NSString stringWithFormat:@"包裹重量：%.2f克",self.allWeight];
    
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

#pragma mark --get
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+44, KScreenWidth, KScreenHeight-64-44-80) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
