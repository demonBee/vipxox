//
//  NewDepartmentOrderViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/15.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "NewDepartmentOrderViewController.h"
#import "YJSegmentedControl.h"
#import "DepartmentHeader.h"
#import "DepartmentFooter.h"
#import "DepartmentOrderTableViewCell.h"
#import "DepartmentOrderModel.h"
#import "DepartmentOrderShoppingModel.h"


#import "DepartmentDetailViewController.h"    //商品详情页
#import "EditCommentViewController.h"    //评价界面


#define HEADER   @"DepartmentHeader"
#define FOOTER   @"DepartmentFooter"
#define SECTIONCELL  @"DepartmentOrderTableViewCell"


@interface NewDepartmentOrderViewController ()<UITableViewDelegate,UITableViewDataSource,YJSegmentedControlDelegate,UIAlertViewDelegate,EditCommentViewControllerDelegate>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UIAlertView*refundAlertView;
@property(nonatomic,strong)UIAlertView*getGoodsAlertView;


@property(nonatomic,strong)NSMutableArray*allDatasModel;  //所有数据的model
@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;
@property(nonatomic,assign)NSInteger whichSection;
@property(nonatomic,assign)DepartmentOrder order;


@end

@implementation NewDepartmentOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pagen=10;
    self.pages=0;
    self.order=DepartmentOrderTrade;
    self.title=@"网红专区订单";
    self.view.backgroundColor=[UIColor whiteColor];
    [self makeTopChooseView];
    [self.view addSubview:self.tableView];
    [self setupRefresh];
    
    [self.tableView registerNib:[UINib nibWithNibName:HEADER bundle:nil] forHeaderFooterViewReuseIdentifier:HEADER];
    [self.tableView registerNib:[UINib nibWithNibName:FOOTER bundle:nil] forHeaderFooterViewReuseIdentifier:FOOTER];
    [self.tableView registerNib:[UINib nibWithNibName:SECTIONCELL bundle:nil] forCellReuseIdentifier:SECTIONCELL];
    
    
}

#pragma mark  --tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allDatasModel.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    DepartmentOrderModel*model=self.allDatasModel[section];
    
    return model.product_list.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    DepartmentOrderModel*bigModel=self.allDatasModel[indexPath.section];
    DepartmentOrderShoppingModel*model=bigModel.product_list[indexPath.row];
    
    
    cell=[tableView dequeueReusableCellWithIdentifier:SECTIONCELL forIndexPath:indexPath];
    cell.selectionStyle=NO;
    
    
    UIImageView*imageView=[cell viewWithTag:1];
    imageView.backgroundColor=[UIColor whiteColor];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"placeholder_375x375"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    UILabel*titleLabel=[cell viewWithTag:2];
    titleLabel.text=model.name;
    
    UILabel*attrLabel=[cell viewWithTag:3];
    attrLabel.text=model.attr_options;
    
    UILabel*priceLabel=[cell viewWithTag:4];
    CGFloat aa=[model.price floatValue];
    priceLabel.text=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,aa];
    
    UILabel*numberLabel=[cell viewWithTag:5];
    numberLabel.text=[NSString stringWithFormat:@"x%@",model.num];
    
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DepartmentOrderModel*bigModel=self.allDatasModel[indexPath.section];
    DepartmentOrderShoppingModel*model=bigModel.product_list[indexPath.row];

    
    DepartmentDetailViewController*vc=[[DepartmentDetailViewController alloc]init];
    vc.dictJiekou=@{@"id":model.pid};
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10+45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 105;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:HEADER];
    view.frame=CGRectMake(0, 0, KScreenWidth, 55);
    
    DepartmentOrderModel*bigModel=self.allDatasModel[section];
    
    UILabel*orderNumLabel=[view viewWithTag:11];
    orderNumLabel.text=[NSString stringWithFormat:@"订单编号：%@",bigModel.order_id];
    
    UILabel*statusLabel=[view viewWithTag:2];
    statusLabel.text=bigModel.status_str;
    
    
    return view;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    DepartmentFooter*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:FOOTER];
     view.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    view.frame=CGRectMake(0, 0, KScreenWidth, 105);
     DepartmentOrderModel*bigModel=self.allDatasModel[section];
    
    UILabel*numberLabel=[view viewWithTag:1];
    numberLabel.text=[NSString stringWithFormat:@"共%@件商品",bigModel.product_num];
    
    
    NSMutableAttributedString*mtString=[[NSMutableAttributedString alloc]initWithString:@"实付" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(68, 68, 68, 1)}];
    CGFloat aa=[bigModel.product_price floatValue];
    NSString*str=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,aa];
    NSMutableAttributedString*money=[[NSMutableAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:RGBCOLOR(206, 11, 36, 1)}];
    [mtString appendAttributedString:money];
    
    
    //多少钱
    
    UILabel*moneyLabel=[view viewWithTag:2];
    moneyLabel.attributedText=mtString;
    
    
    //
    UIButton*button=[view viewWithTag:3];
    button.layer.borderColor=RGBCOLOR(68, 68, 68, 1).CGColor;
    button.layer.borderWidth=1;
    if ([bigModel.status_str isEqualToString:@"已取消"]) {
        [button setTitle:@"已取消" forState:UIControlStateNormal];
        
    }else if ([bigModel.status_str isEqualToString:@"已完成"]){
        [button setTitle:@"已完成" forState:UIControlStateNormal];
    }
    else if ([bigModel.status_str isEqualToString:@"待发货"]){
        [button setTitle:@"申请退款" forState:UIControlStateNormal];
        
    }else if ([bigModel.status_str isEqualToString:@"待收货"]){
        [button setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if ([bigModel.status_str isEqualToString:@"待评价"]){
        [button setTitle:@"去评价" forState:UIControlStateNormal];
    }
    
    
#pragma mark   touch
    view.OKBlock=^{
        button.layer.borderWidth=1;
        if ([bigModel.status_str isEqualToString:@"已取消"]) {
          //点击没反应
            
            
        }else if ([bigModel.status_str isEqualToString:@"已完成"]){
           //点击没反应
            
        }
        else if ([bigModel.status_str isEqualToString:@"待评价"]){
            //点击之后 跳去评价
            EditCommentViewController*vc=[[EditCommentViewController alloc]init];
            vc.orderID=bigModel.order_id;
            vc.delegate=self;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        else if ([bigModel.status_str isEqualToString:@"待发货"]){
         //点击之后   退款
            self.whichSection=section;
            self.refundAlertView=[[UIAlertView alloc]initWithTitle:@"退款" message:@"确定要申请退款？" delegate:self cancelButtonTitle:@"我再看看" otherButtonTitles:@"确定", nil];
            [self.refundAlertView show];
            
            
            
            
        }else if ([bigModel.status_str isEqualToString:@"待收货"]){
            
             //点击之后    确认收货
             self.whichSection=section;
            self.getGoodsAlertView=[[UIAlertView alloc]initWithTitle:@"确认收货" message:@"确定已经收到货了？" delegate:self cancelButtonTitle:@"我再看看" otherButtonTitles:@"确定", nil];
            [self.getGoodsAlertView show];

            
        }

        
        
        
        
        
    };
    
    
    
    return view;
}

#pragma mark  ---  MJRefresh
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
    
    self.pages=0;
    [self getDatas];
    
    
    
    
}

- (void)footerRereshing
{
    
    self.pages++;
    [self getDatas];
    
    
}


#pragma mark  --UI
-(void)makeTopChooseView{
   YJSegmentedControl*view=[YJSegmentedControl segmentedControlFrame:CGRectMake(0, 64, KScreenWidth, 44) titleDataSource:@[@"交易中的订单",@"待确定",@"历史"] backgroundColor:[UIColor whiteColor] titleColor:RGBCOLOR(172, 173, 174, 1) titleFont:[UIFont systemFontOfSize:14] selectColor:[UIColor blackColor] buttonDownColor:[UIColor blackColor] Delegate:self];
    [self.view addSubview:view];
    
}


#pragma mark  --data
-(void)getDatas{
//     www.vipxox.cn/?m=app&s=baihuo&act=order_list&status=1   pages   uid
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*status=[NSString stringWithFormat:@"%ld",self.order];
    NSString*uid=[UserSession instance].uid;
    NSDictionary*params=@{@"m":@"app",@"s":@"baihuo",@"act":@"order_list"
                          ,@"uid":uid,@"status":status,@"pages":pages,@"pagen":pagen};
    
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            if (self.pages==0) {
                [self.allDatasModel removeAllObjects];
            }
            
            
            for (NSDictionary*dict in data[@"data"]) {
                DepartmentOrderModel*model=[DepartmentOrderModel yy_modelWithDictionary:dict];
                
                [self.allDatasModel addObject:model];
            }
            
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
    
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    
}


-(void)applyRemoney{
    //        www.vipxox.cn/?m=app&s=baihuo&act=tuikuan&order_id=
    NSLog(@"%lu",self.whichSection);
    DepartmentOrderModel*model=self.allDatasModel[self.whichSection];
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"app",@"s":@"baihuo",@"act":@"tuikuan",@"order_id":model.order_id,@"uid":[UserSession instance].uid};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"退款" message:@"退款成功，款项已存入您的账户" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [self.tableView headerBeginRefreshing];

            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        
    }];
    
    
}



//确认得到货了
-(void)sureGetGoods{
//    www.vipxox.cn/?m=app&s=baihuo&act=confirm&order_id=3
    
      DepartmentOrderModel*model=self.allDatasModel[self.whichSection];
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"app",@"s":@"baihuo",@"act":@"confirm",@"order_id":model.order_id,@"uid":[UserSession instance].uid};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"确认收货" message:@"确认收货成功,请去历史中完成对本次订单的评价" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [self.tableView headerBeginRefreshing];

            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
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

#pragma mark  -- delegate
-(void)segumentSelectionChange:(NSInteger)selection{
    NSLog(@"%ld",(long)selection);
     self.order=selection+1;
    [self.tableView headerBeginRefreshing];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1&&[alertView isEqual:self.refundAlertView]) {
        //申请退款
//        www.vipxox.cn/?m=app&s=baihuo&act=tuikuan&order_id=
        [self applyRemoney];
        
        
    }else if (buttonIndex==1&&[alertView isEqual:self.getGoodsAlertView]){
        //确认收货
          [self sureGetGoods];
        
    }
    
}

//评论完  刷新数据
-(void)delegateForCompleteCommitToReload{
    [self.tableView headerBeginRefreshing];
}


#pragma mark -- set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+64, KScreenWidth, KScreenHeight-44-64) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(NSMutableArray *)allDatasModel{
    if (!_allDatasModel) {
        _allDatasModel=[NSMutableArray array];
    }
    
    return _allDatasModel;
}

@end
