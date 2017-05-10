//
//  DepartShoppingCarViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/8.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "DepartShoppingCarViewController.h"
#import "ShoppingCarHeaderView.h"
#import "ShoppingCarFooterView.h"
#import "NewShoppingCarTableViewCell.h"

#import "SurePayVIew.h"

#import "UIImage+imageColor.h"
#import "ShoppingCarADDView.h"
#import "DepartShoppingCarModel.h"


#import "TMAddressViewController.h"   //跳转到填收货地址的界面
#import "AccountRechargeViewController.h"   //充值界面

#define HEADER  @"ShoppingCarHeaderView"
#define HEADERXIB   @"headerXIB"
#define FOOTER  @"ShoppingCarFooterView"
#define SECTION0CELL    @"NewShoppingCarTableViewCell"

@interface DepartShoppingCarViewController ()<UITableViewDelegate,UITableViewDataSource,TMAddressViewControllerDelegate>

@property(nonatomic,strong)UITableView*tableView;
//bottom Control
@property(nonatomic,strong)UILabel*priceLabel;
@property(nonatomic,strong)UILabel*conponLabel;
//header allSelected button
@property(nonatomic,strong)UIButton*headerBUtton;
//sure View
@property(nonatomic,strong)SurePayVIew*sureView;
@property(nonatomic,strong)UIView*cover;
//rightItem
@property(nonatomic,strong)UIButton*rightButton;



@property(nonatomic,assign)NSInteger pages;
@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,strong)NSMutableArray*maModel;   //所有数据
@property(nonatomic,assign)CGFloat allPrice;
@property(nonatomic,assign)BOOL isEdit;    //是否是编辑状态



@end

@implementation DepartShoppingCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pages=0;
    self.pagen=10;
    
    [self.view addSubview:self.tableView];
    

    
    [self.tableView registerNib:[UINib nibWithNibName:HEADERXIB bundle:nil] forHeaderFooterViewReuseIdentifier:HEADER];
    [self.tableView registerNib:[UINib nibWithNibName:FOOTER bundle:nil] forHeaderFooterViewReuseIdentifier:FOOTER];
    [self.tableView registerNib:[UINib nibWithNibName:SECTION0CELL bundle:nil] forCellReuseIdentifier:SECTION0CELL];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    

    [self setupRefresh];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    
    
      self.isEdit=NO;
    self.rightButton.selected=NO;
    
    if (![UserSession instance].isLogin) {
            self.navigationItem.rightBarButtonItem=nil;
        
        
    }else{
        
//        self.navigationItem.rightBarButtonItem=item;
//        self.parentViewController.parentViewController.navigationItem.rightBarButtonItem=item;
//        self.navigationController.navigationItem.rightBarButtonItem=item;
//        self.parentViewController.navigationController.navigationItem.rightBarButtonItem=item;
        
        
        
//        if ([self.navigationController isEqual:self.parentViewController.navigationController]) {
//            NSLog(@"11");
//            
//        }
//
        UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
        
        self.navigationItem.rightBarButtonItem=item;
        
        [self.tableView headerBeginRefreshing];

        
    }

    
  
    

    
}


#pragma mark ----- UI
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (![UserSession instance].isLogin) {
        return 0;
    }
    
    

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.maModel.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewShoppingCarTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:SECTION0CELL];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    DepartShoppingCarModel*model=self.maModel[indexPath.row];
    ShoppingCarADDView*addView=[cell viewWithTag:4];
    addView.currentStr=model.num;
    addView.AddBlock=^(NSInteger number){
        model.num=[NSString stringWithFormat:@"%ld",(long)number];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self changeShoppingCarWithDeleteID:nil andChangeNumber:model.num andShoppingID:model.idd];
        
        
    };
    addView.SubBlock=^(NSInteger number){
        model.num=[NSString stringWithFormat:@"%ld",(long)number];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

  [self changeShoppingCarWithDeleteID:nil andChangeNumber:model.num andShoppingID:model.idd];
        
    };
    
    UIButton*button=[cell viewWithTag:1];
    if (model.isSelected) {
        [button setSelected:YES];
    }else{
        [button setSelected:NO];
    }
    
    //点击之后 刷新
    cell.CellButtonBlock=^(BOOL yesOrNo){
        model.isSelected=yesOrNo;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    };
    
    
    UIImageView*headImageView=[cell viewWithTag:2];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"placeholder_375x375"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (cacheType!=2) {
            headImageView.alpha=0.3;
            CGFloat scale = 0.3;
            headImageView.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                headImageView.alpha=1;
                CGFloat scale = 1.0;
                headImageView.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }

    }];
    
    
    UILabel*titleLabel=[cell viewWithTag:3];
    titleLabel.text=[NSString stringWithFormat:@"%@%@",model.name,model.setmeal];
    
    UILabel*priceLabel=[cell viewWithTag:5];
    priceLabel.text=[NSString stringWithFormat:@"%@%@",[UserSession instance].currency,model.price];
    
    UIButton*deleteButton=[cell viewWithTag:99];
    deleteButton.imageEdgeInsets=UIEdgeInsetsMake(8-1, 5+5, 5, 13+15+5);
    cell.CellDeleteBlock=^{
        //删除 cell
              DepartShoppingCarModel*model=self.maModel[indexPath.row];
        [self.maModel removeObject:model];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];


        
        [self changeShoppingCarWithDeleteID:@"1" andChangeNumber:nil andShoppingID:model.idd];
        
    };
    
    //价格 和 删除 只存在一个
    if (self.isEdit) {
        priceLabel.hidden=YES;
        deleteButton.hidden=NO;
    }else{
        priceLabel.hidden=NO;
        deleteButton.hidden=YES;

        
    }
    
    
    
    [self calculatorPrice];
    
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ShoppingCarHeaderView*header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:HEADER];
    header.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
    //全选 或者怎样
    header.selectAllBlock=^(BOOL yesOrNO){
        MyLog(@"%d",yesOrNO);
        for (DepartShoppingCarModel*model in self.maModel) {
            model.isSelected=yesOrNO;
        }
        
        [self.tableView reloadData];

    };
    
    
    //去凑单
    header.ToBuyBlock=^{
        //跳 购买的列表
        MyLog(@"去购买");
        
        
    };
    
    //button
    UIButton*button=[header viewWithTag:999];
    self.headerBUtton=button;
    
    
    
    //title
    UILabel*titleLabel=[header viewWithTag:2];
    titleLabel.text=@"全选";
    
    
    return header;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    ShoppingCarFooterView*footer=[tableView dequeueReusableHeaderFooterViewWithIdentifier:FOOTER];
    footer.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageWithColor:[UIColor whiteColor]]];

    
    UILabel*priceLabel=[footer viewWithTag:1];
    self.priceLabel=priceLabel;
    
    
    UILabel*coupon=[footer viewWithTag:2];
//    coupon.text=@"优惠";
    self.conponLabel=coupon;
    
    
    UIButton*okButton=[footer viewWithTag:3];
//    [okButton setTitle:@"结算2" forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(settlementGoods) forControlEvents:UIControlEventTouchUpInside];
    
    
    return footer;
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
- ( NSArray<UITableViewRowAction*> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction*delete=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        DepartShoppingCarModel*model=self.maModel[indexPath.row];
        [self.maModel removeObject:model];
      

        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    
      
        //吊接口删除
        
        //1 的话 就删除
        [self changeShoppingCarWithDeleteID:@"1" andChangeNumber:nil andShoppingID:model.idd];
       
        
        
    }];
    
    
//    UITableViewRowAction*collectionView=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"移入收藏" handler:^(UITableViewRowAction * _Nonnull actionn, NSIndexPath * _Nonnull indexPath) {
////        actionn.backgroundColor=[UIColor grayColor];
//        
//        
//        [self.maModel removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
////吊接口加入收藏
//        
//        
//    }];
    
    delete.backgroundColor=RGBCOLOR(252, 76, 30, 1);
//    collectionView.backgroundColor=[UIColor grayColor];
    
    
    
    return @[delete];
}





-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
#pragma mark ----   data

#pragma 初始的购物车数据
-(void)getDatas{

    
    
//     www.vipxox.cn/?m=app&s=baihuo&act=cart_list
    NSString*pages=[NSString stringWithFormat:@"%ld",self.pages];
    NSString*pagen=[NSString stringWithFormat:@"%ld",self.pagen];
    
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"app",@"s":@"baihuo",@"act":@"cart_list",@"uid":[UserSession instance].uid,@"pages":pages,@"pagen":pagen};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            if (self.pages==0) {
                [self.maModel removeAllObjects];
            }
            
            
            NSArray*array=data[@"data"];
            for (NSDictionary*dict in array) {
                DepartShoppingCarModel*model=[DepartShoppingCarModel yy_modelWithDictionary:dict];
                [self.maModel addObject:model];

                
            }
            
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
        
    }];
    
    
    
    
}

#pragma 修改购物车   删除和改数量 不共存 只有存在一个
-(void)changeShoppingCarWithDeleteID:(NSString*)yesOrNO andChangeNumber:(NSString*)AddNumber andShoppingID:(NSString*)shoppingID{
//    www.vipxox.cn/?m=app&s=baihuo&act=up_cart&cid=3&del=1&num=2
    NSMutableDictionary*params=[NSMutableDictionary dictionary];
    if (yesOrNO) {
        [params setObject:yesOrNO forKey:@"del"];
        
    }
    if (AddNumber) {
        [params setObject:AddNumber forKey:@"num"];
    }
    
    
    
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*dict=@{@"m":@"app",@"s":@"baihuo",@"act":@"up_cart",@"cid":shoppingID,@"uid":[UserSession instance].uid};
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [params setObject:obj forKey:key];
        
    }];
    
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            
            
        }else{
            [self.tableView headerBeginRefreshing];
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self.tableView headerBeginRefreshing];
        
    }];
    
    
    
}


-(void)giveSureViewDatas{
    NSMutableArray*saveID=[NSMutableArray array];
    for (DepartShoppingCarModel*model in _maModel) {
        if (model.isSelected) {
            [saveID addObject:model.idd];
        }
        
        
    }
    
    if (saveID.count<1) {
        [JRToast showWithText:@"请选择具体商品"];
        return;
    }
    
    
    NSString*idStr=[saveID componentsJoinedByString:@","];
    
    
    
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"app",@"s":@"baihuo",@"act":@"show_cart_price",@"uid":[UserSession instance].uid,@"id":idStr};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            self.sureView.allDatas=data[@"data"];
            
            
          
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        
    }];

    [UIView animateWithDuration:0.5 animations:^{
        self.cover.alpha=0.6;
        self.sureView.frame=CGRectMake(0, KScreenHeight-245, KScreenWidth, 245);
    }];

}


//确认购买
-(void)sureToBuy:(NSString*)money andChooseID:(NSString*)idd{
    //需要判断钱够不够  不够去充值
    CGFloat GoodsMoney=[money floatValue];
    CGFloat ownerMoney=[[UserSession instance].cash floatValue];
    
    
    
    
    if (ownerMoney<GoodsMoney) {
        //去充值
        CGFloat cha=GoodsMoney-ownerMoney;
        [self dismiss];
        AccountRechargeViewController*vc=[[AccountRechargeViewController alloc]init];
        vc.num=cha;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
    
    
    
    
//     www.vipxox.cn/?m=app&s=baihuo&act=pay_order&id=5,7,8,9
    NSMutableArray*saveID=[NSMutableArray array];
    for (DepartShoppingCarModel*model in _maModel) {
        if (model.isSelected) {
            [saveID addObject:model.idd];
        }
        
        
    }
    
    if (saveID.count<1) {
        [JRToast showWithText:@"请选择具体商品"];
        return;
    }
    
    
//    NSString*idStr=[saveID componentsJoinedByString:@","];
    NSString*idStr=idd;
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];

    NSDictionary*params=@{@"m":@"app",@"s":@"baihuo",@"act":@"pay_order",@"id":idStr,@"uid":[UserSession instance].uid};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"付款信息" message:@"付款成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
            [self.tableView headerBeginRefreshing];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
        [self dismiss];
        
}
}


//calculator
-(void)calculatorPrice{
    self.allPrice=0.0f;
    
    BOOL allSelected=YES;
    for (DepartShoppingCarModel*model in self.maModel) {
        if (model.isSelected) {
            NSString*priceStr=model.price;
            CGFloat priceFloat=[priceStr floatValue];
            
            NSString*numberStr=model.num;
            CGFloat numberFloat=[numberStr floatValue];
            
            CGFloat moneyFloat=priceFloat*numberFloat;
            
            self.allPrice= self.allPrice+moneyFloat;

        }else{
            allSelected=NO;
        }
        
        
        
    }
    
    if (allSelected) {
        [self.headerBUtton setSelected:YES];
        
    }else{
        [self.headerBUtton setSelected:NO];
    }
    
    
    
    self.priceLabel.text=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,self.allPrice];
    
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

#pragma mark   ---  touch

-(void)dismiss{
   
    [UIView animateWithDuration:0.5 animations:^{
         self.cover.alpha=0;
        self.sureView.frame=CGRectMake(0, KScreenHeight, KScreenWidth, 245);
    }];
}


-(void)touchEdit:(UIButton*)sender{
 
    if (sender.selected) {
        sender.selected=NO;
        self.isEdit=sender.selected;
        
    }else{
        sender.selected=YES;
        self.isEdit=sender.selected;

    }
    
    
     [self.tableView reloadData];
       MyLog(@"%d",self.isEdit);
    
    
}

//结算所有的商品
-(void)settlementGoods{
    //接口
//      www.vipxox.cn/?m=app&s=baihuo&act=show_cart_price&id=3,6,9    uid
    
    
    [self giveSureViewDatas];
    
    
    
}


#pragma mark  -----delegate
//地址那里的代理
-(void)DelegateForSendValueToAddress:(NSDictionary *)dict{
//    NSLog(@"%@",dict);
    [self giveSureViewDatas];
}



#pragma mark  ---  MJRefresh
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    
//    [self.tableView headerBeginRefreshing];
    
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



#pragma mark ------ set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(SurePayVIew *)sureView{
    if (!_sureView) {
        _sureView=[[SurePayVIew alloc]initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 245)];
        _sureView.backgroundColor=[UIColor whiteColor];
        __weak typeof (self)weakSelf=self;
        _sureView.cancelBlock=^{
            [weakSelf dismiss];
        };
        
        
        _sureView.changeAddressBlock=^{
            [weakSelf dismiss];
            
            TMAddressViewController*vc=[[TMAddressViewController alloc]init];
            vc.delegate=weakSelf;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        };
        
        
        //确认购买
        _sureView.sureBlock=^(NSString*money,NSString*id){
            [weakSelf sureToBuy:money andChooseID:id];
            
        };
        
        
    UIWindow*window= [UIApplication sharedApplication].keyWindow;
    [window addSubview:_sureView];
    }
    return _sureView;
    
}

-(UIView *)cover{
    if (!_cover) {
        _cover=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _cover.backgroundColor=[UIColor blackColor];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [_cover addGestureRecognizer:tap];
        _cover.alpha=0;
        UIWindow*window= [UIApplication sharedApplication].keyWindow;
        [window addSubview:_cover];
    }
    
    return _cover;
}


-(NSMutableArray *)maModel{
    if (!_maModel) {
        _maModel=[NSMutableArray array];
    }
    
    return _maModel;
}

//-(UIBarButtonItem *)rightItem{
//    if (!_rightItem) {
//        UIButton*rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
//        [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
//        [rightButton setTitle:@"完成" forState:UIControlStateSelected];
//        rightButton.frame=CGRectMake(0, 0, 40, 18);
//        rightButton.titleLabel.font=[UIFont systemFontOfSize:14];
//        [rightButton addTarget:self action:@selector(touchEdit:) forControlEvents:UIControlEventTouchUpInside];
//        _rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
//
//    }
//    return _rightItem;
//    
//}

-(UIButton *)rightButton{
    if (!_rightButton) {
         _rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_rightButton setTitle:@"完成" forState:UIControlStateSelected];
        _rightButton.frame=CGRectMake(0, 0, 40, 18);
        _rightButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [_rightButton addTarget:self action:@selector(touchEdit:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _rightButton;
    
}

@end
