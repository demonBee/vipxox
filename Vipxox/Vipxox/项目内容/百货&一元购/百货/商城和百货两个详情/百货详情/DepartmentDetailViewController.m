//
//  DepartmentDetailViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/3.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "DepartmentDetailViewController.h"
#import "NewGoodHeaderView.h"     //header
#import "BrandTableViewCell.h"    //  品牌
#import "CommitTableViewCell.h"   //评论
#import "BottomHeaderView.h"      //猜你喜欢的 底部header
#import "DepartmentBottomView.h"     //立即购买的视图
#import "NewChooseView.h"    //选择视图。。

#import "BrandViewController.h"   //品牌界面
//#import "CommitListViewController.h"    //评论列表控制器
#import "DepartmentCommitListViewController.h"
#import "EnterAPPViewController.h"        //登录
#import "DepartShoppingCarViewController.h"   //购物车


#import "DepartmentDetailModel.h"   //大model
#import "DetailHeaderModel.h"   //header 需要传给他特定的
#import "goodsModel.h"    //商品model
#import "GuessLikeModel.h"   //猜你喜欢 model
#import "UITableView+FDTemplateLayoutCell.h" 


#define NEWHEADER   @"NewGoodHeaderView"
#define BRANDCELL   @"BrandTableViewCell"
#define COMMIT      @"CommitTableViewCell"

#define BOOTOMHEADER   @"BottomHeaderView"

@interface DepartmentDetailViewController ()<UITableViewDelegate,UITableViewDataSource,bottomCollectionVViewDelegate,NewChooseViewDelegate>


@property(nonatomic,strong)UIScrollView*bottomScrollView;
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UIScrollView*otherScrollView;

@property(nonatomic,strong)NewChooseView*chooseView;   //选择的视图
@property(nonatomic,strong)UIView*cover;     //蒙版



@property(nonatomic,strong)DepartmentBottomView*bottomBuyView;   //加入购物车按钮



#pragma mark  ---数据处理   两种可能  吊的接口也都是不一样的
@property(nonatomic,assign)CGFloat nowY;    //滚动显示与否下面 按钮栏
@property(nonatomic,strong)NSDictionary*allChoose_goodsDatas;  //所有种类的商品  用于选择 传递给  选择跳窗
//

#pragma mark --数据
@property(nonatomic,strong)DepartmentDetailModel*bigModel;   //大model
@property(nonatomic,strong)brandModel*brandmodel;   //品牌
@property(nonatomic,strong)NSMutableArray*alldianping;   //所有的点评
@property(nonatomic,strong)NSMutableArray*tuijian;   //所有的推荐



@end

@implementation DepartmentDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.title=@"详情";
    self.navigationController.navigationBarHidden=NO;
    [self.view addSubview:self.bottomScrollView];
    [self.bottomScrollView addSubview:self.tableView];
    [self.bottomScrollView addSubview:self.otherScrollView];
    
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:NEWHEADER];
    [self.tableView registerNib:[UINib nibWithNibName:BRANDCELL bundle:nil] forCellReuseIdentifier:BRANDCELL];
    [self.tableView registerNib:[UINib nibWithNibName:COMMIT bundle:nil] forCellReuseIdentifier:COMMIT];
    [self.tableView registerClass:[BottomHeaderView class] forHeaderFooterViewReuseIdentifier:BOOTOMHEADER];
    
    
    [self MJRefresh];
    //底部的 按钮 创建
    [self creatTwoButtonView];
    
    [self navigationBarRightItem];
    
    [self getDatas];
}

#pragma mark  --UI
-(void)navigationBarRightItem{
    
    UIButton*button0=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    [button0 setBackgroundImage:[UIImage imageNamed:@"购物车right"] forState:UIControlStateNormal];
    [button0 addTarget:self action:@selector(touchOpenShoppingCar) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*rightItem1=[[UIBarButtonItem alloc]initWithCustomView:button0];
    
    
    //没有收藏
    //    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    //    [button setBackgroundImage:[UIImage imageNamed:@"爱心"] forState:UIControlStateNormal];
    //    [button setBackgroundImage:[UIImage imageNamed:@"爱心_红"] forState:UIControlStateSelected];
    //    [button addTarget:self action:@selector(touchCollection:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    UIBarButtonItem*rightItem2=[[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItems=@[rightItem1];
    
    
}

-(void)creatTwoButtonView{
    self.bottomBuyView= [[NSBundle mainBundle]loadNibNamed:@"DepartmentBottomView" owner:nil options:nil].firstObject;
    self.bottomBuyView.frame=CGRectMake(0, KScreenHeight-47, KScreenWidth, 47);
    [self.view addSubview:self.bottomBuyView];
    
    __weak typeof(self)weakSelf =self;
    
    
    
#pragma ---点击加入购物车
    self.bottomBuyView.AddCarBlock=^{
        
        if (![UserSession instance].isLogin) {
            
            //跳登录 界面
            EnterAPPViewController*vc=[[EnterAPPViewController alloc]init];
           [weakSelf presentViewController:vc animated:YES completion:nil];
            
        }else{
        
        
         weakSelf.cover.alpha=0;
       [UIView animateWithDuration:0.5 animations:^{
            

             weakSelf.cover.alpha=0.6;
            [weakSelf getHeight];
            
            
        }];

        [weakSelf getChooseDatas];
        
        }
        
        

            
        

        
    };
    
    
}

-(void)otherscrollViewAddImageView{
    NSArray*array=_bigModel.pic_more;
    NSMutableArray*mtArray=[NSMutableArray array];
    [mtArray addObjectsFromArray:array];
    CGFloat top=0;
    for (int i=0; i<mtArray.count; i++) {
        UIImageView*imageview=[self.view viewWithTag:7777+i];
        if (!imageview) {
            imageview=[[UIImageView alloc]init];
            imageview.tag=7777+i;
            [self.otherScrollView addSubview:imageview];
        }
        
        [imageview sd_setImageWithURL:[NSURL URLWithString:mtArray[i]] placeholderImage:[UIImage imageNamed:@"placeholder_375x375"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        imageview.x=0;
        imageview.y=top;
        imageview.width=KScreenWidth;
        imageview.height=imageview.image.size.height/(imageview.image.size.width/KScreenWidth);
        
        
        top=top+imageview.height;
        
        
        
    }
    
    
    self.otherScrollView.contentSize=CGSizeMake(0, top);
    
}


#pragma 得到高

-(void)getHeight{
    

        CGFloat xxx= [self.chooseView calculatarHeight];
        self.chooseView.y=KScreenHeight-xxx;
        self.chooseView.height=xxx;

   
    
   
}


#pragma mark  ----隐藏跳窗
-(void)dismiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.cover.alpha=0;
        self.chooseView.y=KScreenHeight*1.5;
        
        
    }];
    
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        
        if ( self.alldianping.count<3) {
            return self.alldianping.count;
        }else{
            return 3;
        }
        
        
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section==0) {
        //品牌
        
        BrandTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:BRANDCELL];
        cell.selectionStyle=NO;
        cell.entity=self.brandmodel;
        return cell;
    }else if (indexPath.section==1){
        //评论   点评
        CommitTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:COMMIT];
        cell.selectionStyle=NO;
        
        [self configurecell:cell atIndexPath:indexPath];
        return cell;
        
    }else if (indexPath.section==2){
        //这个  0.01  看不到cell
        return cell;
    }
    
    cell.textLabel.text=@"1111";
    
    
    
    return cell;
}

//评论这里
-(void)configurecell:(CommitTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
    DetailCommitModel*model=self.alldianping[indexPath.row];
    
    [cell FourCan:isShoppingDetail andDict:model];
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        BrandViewController*vc=[[BrandViewController alloc]init];
        vc.bid=_brandmodel.brandID;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (indexPath.section==1){
        DepartmentCommitListViewController*vc=[[DepartmentCommitListViewController alloc]init];
        vc.pid=_bigModel.detailID;
        vc.howmuchCommit=_bigModel.dianping[@"number"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        NewGoodHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:NEWHEADER];
        view.allDatas=[self createFalueDatas];
        
        view.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageWithColor:[UIColor whiteColor]]];
        
        
        view.labelTitle.preferredMaxLayoutWidth=KScreenWidth-100;
        return view;
        
    }else if (section==1){
        UIView*bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
        bottomView.backgroundColor=[UIColor whiteColor];
        UIButton*clearButton=[[UIButton alloc]init];
        clearButton.frame=bottomView.frame;
        clearButton.backgroundColor=[UIColor clearColor];
        [clearButton addTarget:self action:@selector(touchToCommitList) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:clearButton];
        
        
        UILabel*leftLabel=[[UILabel alloc]init];
        leftLabel.text=@"会员点评";
        leftLabel.font=[UIFont systemFontOfSize:14];
        [bottomView addSubview:leftLabel];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bottomView.left).offset(15);
            make.top.mas_equalTo(bottomView.top).offset(12);
            
        }];
        
        
        UIImageView*rightArr=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"右箭头"]];
        [bottomView addSubview:rightArr];
        [rightArr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bottomView.right).offset(-15);
            make.centerY.mas_equalTo(leftLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(16, 16));
            
        }];
        
        //数字是红色的
        UILabel*rightLabel=[[UILabel alloc]init];
        rightLabel.font=[UIFont systemFontOfSize:13];
        rightLabel.textColor=RGBCOLOR(186, 186, 186, 1);
        
        //        NSString*numberStr=@"1501";
        //        NSAttributedString*attStr=@{NSForegroundColorAttributeName:[]}
        
        rightLabel.text=[NSString stringWithFormat:@"查看全部%@条点评",_bigModel.dianping[@"number"]];
        [bottomView addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(leftLabel.mas_centerY);
            make.right.mas_equalTo(rightArr.mas_left).offset(-8);
            
        }];
        
        
        return bottomView;
    }else if (section==2){
        BottomHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:BOOTOMHEADER];
        //设置 代理是自己
        view.aa=self;
        view.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageWithColor:[UIColor whiteColor]]];
        
        NSMutableArray*saveAllModel=[NSMutableArray array];
        for (goodsModel*oldModel in self.tuijian) {
            GuessLikeModel*model=[[GuessLikeModel alloc]init];
            model.pic=oldModel.pic;
            model.idd=oldModel.goodsID;
            model.price=oldModel.price;
            model.title=oldModel.name;
            
            [saveAllModel addObject:model];
        }
        
        view.allDatas=[saveAllModel copy];
        
        //        view.allDatas=@[@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{},@{}];
        
        
        
        return view;
        
        
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return [tableView fd_heightForHeaderFooterViewWithIdentifier:NEWHEADER configuration:^(id headerFooterView) {
            NewGoodHeaderView*aa=   (NewGoodHeaderView*) headerFooterView;
            aa.allDatas=[self createFalueDatas];
        }];
    }else if (section==2){
        CGFloat with =(KScreenWidth-50)/3;
        CGFloat height =170-with+ACTUAL_HEIGHT(with);
        
        return 44+height+8+height+8+20;
        
    }
    
    else{
        return 44;
    }
    
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 140;
    }else if (indexPath.section==1){
        return [tableView fd_heightForCellWithIdentifier:COMMIT cacheByIndexPath:indexPath configuration:^(id cell) {
            [self configurecell:cell atIndexPath:indexPath];
            
        }];
        
        
    }else if (indexPath.section==2){
        //        CGFloat with =(KScreenWidth-50)/3;
        //        CGFloat height =170-with+ACTUAL_HEIGHT(with);
        //
        //        return 44+height+8+height+8+20+20;
        return 0.001;
        
    }
    return 44;
}




#pragma mark ----   datas
//这个是 得到所有的数据
-(void)getDatas{
//  www.vipxox.cn/?m =app&s=baihuo&act=pro_detail&pid=89
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"app",@"s":@"baihuo",@"act":@"pro_detail",@"pid":self.dictJiekou[@"id"],@"uid":[UserSession instance].uid};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            DepartmentDetailModel*model=[DepartmentDetailModel yy_modelWithDictionary:data[@"data"]];
            
           
            self.bigModel=model;
            self.brandmodel=model.brand;
//            self.alldianping=model.dianping;
            NSArray*array=model.dianping[@"list"];
            for (NSDictionary*dict in array) {
                DetailCommitModel*detailModel=[DetailCommitModel yy_modelWithDictionary:dict];
                
                [self.alldianping addObject:detailModel];
                
                
            }
            
            
            self.tuijian=[model.tuijian mutableCopy];
            [self otherscrollViewAddImageView];
            
            [self.tableView reloadData];
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    
    
    
    
    
}

//选择商品的种类选择
-(void)getChooseDatas{

    
//    http://www.vipxox.cn/?m=app&s=baihuo&act=setmeal_list&pid=1
    
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
//    _bigModel.detailID;
    NSDictionary*params=@{@"m":@"app",@"s":@"baihuo",@"act":@"setmeal_list",@"pid":_bigModel.detailID};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            NSArray*array=data[@"data"];
            self.chooseView.allDatas=array;
              [self getHeight];
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        
    }];
    
    
}


//header 的数据
-(DetailHeaderModel*)createFalueDatas{
    //没办法   为了适应 另一个详情页    _bigModel.marketPrice
    
    DetailHeaderModel*model=[[DetailHeaderModel alloc]init];
    
    
    
    model.labelTitle=_bigModel.name;
    model.images=_bigModel.pic_more;
    model.priceLabel=_bigModel.price;
    model.marketLabel=_bigModel.market_price;
    
    
    
    return model;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat aa=  scrollView.contentOffset.y-_nowY;
    if (aa>30) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomBuyView.frame=CGRectMake(0, KScreenHeight, KScreenWidth, 47);
        }];
    }else if (scrollView.contentOffset.y<=20){
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomBuyView.frame=CGRectMake(0, KScreenHeight-47, KScreenWidth, 47);
        }];
        
        
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomBuyView.frame=CGRectMake(0, KScreenHeight-47, KScreenWidth, 47);
        }];
        
    }
    
    
    
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.nowY=scrollView.contentOffset.y;
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

#pragma mark   ----- delegate
-(void)delegateFromCollectionTouch:(NSInteger)viewTag andIndexPath:(NSIndexPath *)indexPath andthisRowDict:(NSDictionary *)dict{
    NSLog(@"%@",dict);
    DepartmentDetailViewController*vc=[[DepartmentDetailViewController alloc]init];
    vc.dictJiekou=@{@"id":dict[@"id"]};
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(void)ShowViewDismiss{
    [self dismiss];
}


#pragma mark  --touch
//右上角1个按钮
-(void)touchOpenShoppingCar{
    if (![UserSession instance].isLogin) {
        
        //跳登录 界面
        EnterAPPViewController*vc=[[EnterAPPViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
        
    }else{
        DepartShoppingCarViewController*vc=[[DepartShoppingCarViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
  
    
    
    
}

-(void)touchCollection:(UIButton*)sender{
    if (sender.selected) {
        sender.selected=NO;
    }else{
        sender.selected=YES;
    }
    
    
}

//点击到 详情列表
-(void)touchToCommitList{
    DepartmentCommitListViewController*vc=[[DepartmentCommitListViewController alloc]init];
    vc.pid=_bigModel.detailID;
    vc.howmuchCommit=_bigModel.dianping[@"number"];
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark   tableView  scrollView  he   scrollView
-(UIScrollView *)bottomScrollView{
    if (!_bottomScrollView) {
        _bottomScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _bottomScrollView.backgroundColor=[UIColor whiteColor];
        _bottomScrollView.contentSize=CGSizeMake(KScreenWidth, 2*KScreenHeight);
        _bottomScrollView.pagingEnabled=YES;
        _bottomScrollView.scrollEnabled=NO;
    }
    return _bottomScrollView;
    
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(UIScrollView *)otherScrollView{
    if (!_otherScrollView) {
        _otherScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, KScreenHeight+64, KScreenWidth, KScreenHeight-64) ];
//        _otherScrollView.backgroundColor=[UIColor greenColor];
        _otherScrollView.contentSize=CGSizeMake(0, 2*KScreenHeight-64);
        _otherScrollView.alwaysBounceVertical=YES;
        //        _otherScrollView.bounces=NO;
        _otherScrollView.delegate=self;
        _otherScrollView.scrollEnabled=YES;
    }
    return _otherScrollView;
    
}





#pragma mark    ----MJRefresh
-(void)MJRefresh{
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.otherScrollView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    
    
}

-(void)headerRereshing{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.bottomScrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        [self.otherScrollView headerEndRefreshing];
    }];
    
    
}

-(void)footerRereshing{
    [self otherscrollViewAddImageView];

    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.bottomScrollView.contentOffset = CGPointMake(0, KScreenHeight);
        
    } completion:^(BOOL finished) {
        //结束加载
        [self.tableView footerEndRefreshing];
    }];
    
}



#pragma mark  --set
-(NewChooseView *)chooseView{
    if (!_chooseView) {
        _chooseView=[[NewChooseView alloc]initWithFrame:CGRectMake(0, KScreenHeight*1.5, KScreenWidth, 100)];
        _chooseView.bigMModel=_bigModel;
        _chooseView.delegate=self;
        
        UIWindow*window=[UIApplication sharedApplication].keyWindow;
        [window addSubview:_chooseView];
        [window bringSubviewToFront:_chooseView];
        __weak typeof (self)weakSelf=self;
        _chooseView.cancelBlock=^{
            [weakSelf dismiss];
            
        };
        
        
    }
    return _chooseView;
}

-(UIView *)cover{
    if (!_cover) {
        _cover=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _cover.backgroundColor=[UIColor blackColor];
        _cover.alpha=0.0;
        UIWindow*window=[UIApplication sharedApplication].keyWindow;
        [window addSubview:_cover];
        
        
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [_cover addGestureRecognizer:tap];
        
    }
    return _cover;
}


-(NSMutableArray *)tuijian{
    
    if (!_tuijian) {
        _tuijian=[NSMutableArray array];
    }
    return _tuijian;

}

-(NSMutableArray *)alldianping{
    if (!_alldianping) {
        _alldianping=[NSMutableArray array];
    }
    return _alldianping;
    
}

@end
