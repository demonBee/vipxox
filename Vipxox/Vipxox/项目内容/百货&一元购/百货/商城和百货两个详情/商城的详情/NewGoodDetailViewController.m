//
//  NewGoodDetailViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/26.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "NewGoodDetailViewController.h"
#import "NewGoodHeaderView.h"
#import "BrandTableViewCell.h"    //  品牌
#import "CommitTableViewCell.h"   //评论
#import "CommitListViewController.h"    //评论列表控制器
#import "BottomHeaderView.h"      //猜你喜欢的 底部header
#import "ChooseVIew.h"     //购买的按钮
#import "BrandViewController.h"   //品牌界面

#import "EnterAPPViewController.h"   //登录界面


//#import "NewChooseView.h"    //选择视图。。
#import "OldChooseColorView.h"

#import "ShopCarViewController.h"  //购物车
#import "ConfirmOrderViewController.h" //确认订单
#import "ShoppingModel.h"    //model 层
#import "DetailHeaderModel.h"    //header  model 层
#import "DetailCommitModel.h"    //评论这里
#import "GuessLikeModel.h"    //猜你喜欢

#import "UITableView+FDTemplateLayoutCell.h" 

#define NEWHEADER   @"NewGoodHeaderView"
#define BRANDCELL   @"BrandTableViewCell"
#define COMMIT      @"CommitTableViewCell"

#define BOOTOMHEADER   @"BottomHeaderView"


@interface NewGoodDetailViewController ()<UITableViewDelegate,UITableViewDataSource,bottomCollectionVViewDelegate,OldChooseColorViewDelegate>





@property(nonatomic,strong)UIScrollView*bottomScrollView;
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UIScrollView*otherScrollView;

@property(nonatomic,strong)OldChooseColorView*oldChooseView;  //旧的选择视图

@property(nonatomic,strong)UIView*cover;     //蒙版
@property(nonatomic,strong)ChooseVIew*buttonView;    //购买的按钮
@property(nonatomic,assign)CGFloat nowY;    //滚动显示与否下面 按钮栏
@property(nonatomic,strong)UIButton*collectionButton;  //收藏按钮


#pragma mark  ---数据处理   两种可能  吊的接口也都是不一样的

@property(nonatomic,strong)NSDictionary*allDatas;  //所有数据
@property(nonatomic,strong)NSArray*threeCommit;   //刚开始的点评数 有几个
@property(nonatomic,strong)NSArray*aboutShopping;   //相关的商品




@end

@implementation NewGoodDetailViewController

+(instancetype)creatNewVCwith:(whichCategory)oldOrNew andDatas:(NSDictionary*)dict{
    NewGoodDetailViewController*vc=[[NewGoodDetailViewController alloc]init];
    //这东西 没用  分开写了
//    vc.category=oldOrNew;
    vc.dictJiekou=dict;
    
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [ self getDatas];
    
    
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
    
    [self creatTwoButtonView];
    
    [self navigationBarRightItem];
}

//下一页的轮播图
-(void)otherscrollViewAddImageView{
    NSArray*array=self.allDatas[@"pic"];
    NSMutableArray*mtArray=[NSMutableArray array];
    [mtArray addObject:self.allDatas[@"related"]];
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

#pragma mark  接口   假数据  用来跳 弹窗 获取数据的接口
//-(void)getChooseDatas{
//    NSString*path=[[NSBundle mainBundle]pathForResource:@"ceshiyong" ofType:@"json"];
//    NSData*data=[NSData dataWithContentsOfFile:path];
//    NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//
//    
//    _allChoose_goodsDatas=dict;
//    
//    
//}



//这个是 得到所有的数据
-(void)getDatas{
//        http://www.vipxox.cn /?m=appapi&s=mall&act=product_detail&pid=11 uid
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSString*pid =self.dictJiekou[@"id"];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"mall",@"act":@"product_detail",@"pid":pid,@"uid":[UserSession instance].uid};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            self.allDatas=[data[@"data"] copy];
            //一开始的评论数
            self.threeCommit=[data[@"data"][@"comment_list"] copy];
            //相关的商品
            self.aboutShopping=[data[@"data"][@"related_pro"] copy];
            
            //判断是否已经被收藏
            [self collectionButtonSelectedOrNo];
            
            //商品 介绍图片  (避免 bug)
            [self otherscrollViewAddImageView];
            [self.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
    

    
    
}

//接口
-(void)collectOrNo:(NSString*)zt{
    //http://www.vipxox.cn/?   m=appapi&s=home_page&act=add_del_collection&userid=q&zt=1&pid=
    //    http://www.vipxox.net/?m=appapi&s=home_page&  act=add_del_ccollection&zt=1&pid=233&userid=7771b897673d68325aa1702c57eca1e9
    
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"home_page",@"act":@"add_del_ccollection",@"userid":[UserSession instance].uid,@"zt":zt,@"pid":self.allDatas[@"id"]};
    
    HttpManager*manager= [[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"])  {
            [JRToast showWithText:data[@"data"]];
#warning 缺少collection 字段
//            self.collectionButton.selected=data[@"collection"];
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
            
        }
        
    }];
    
    
    
}






-(void)collectionButtonSelectedOrNo{
    if ([self.allDatas[@"collect"] isEqualToString:@"0"]) {
        //没有被收藏
        self.collectionButton.selected=NO;
    }else{
        //收藏了
        self.collectionButton.selected=YES;
        
    }
    
}

#pragma mark  ----隐藏跳窗
-(void)dismiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.cover.alpha=0;
        self.oldChooseView.y=KScreenHeight*1.5;
        
        
    }];
    
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        //这个还的看 刚开始返回的评论数
        if (self.threeCommit.count>3) {
            return 3;
        }else{
             return self.threeCommit.count;
        }
       
    }else if (section==0){
        //品牌  没有啊
        return 0;
        
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section==0) {
        //并没有品牌 不会走进去
        
        BrandTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:BRANDCELL];
        cell.selectionStyle=NO;
        cell.entity=@{};
        return cell;
    }else if (indexPath.section==1){
        
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

    NSDictionary*dict=self.allDatas[@"comment_list"][indexPath.row];
    
    //userimg user con  score  attr create_time  没有时间字段和赞字段 多了个属性字段
//    NSDictionary*newDict=@{@"userimg":dict[@"userimg"],@"user":dict[@"user"],@"con":dict[@"con"],@"score":dict[@"score"],@"attr":dict[@"attr"],@"create_time":dict[@"create_time"]};
    
    
    DetailCommitModel*model=[[DetailCommitModel alloc]init];
    model.userimg=dict[@"userimg"];
    model.user=dict[@"user"];
    model.con=dict[@"con"];
    model.score=dict[@"score"];
    model.attr=dict[@"attr"];
    model.create_time=dict[@"create_time"];
    
    
    [cell FourCan:isOldDetail andDict:model];

    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        BrandViewController*vc=[[BrandViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (indexPath.section==1){
        CommitListViewController*vc=[[CommitListViewController alloc]init];
        vc.pid=self.allDatas[@"id"];
        [self.navigationController pushViewController:vc animated:YES];

    }
}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //section 0  头视图
    if (section==0&&self.allDatas!=nil) {
        NewGoodHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:NEWHEADER];
        view.allDatas=[self createFalueDatas];
 
        view.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageWithColor:[UIColor whiteColor]]];
        
   
          view.labelTitle.preferredMaxLayoutWidth=KScreenWidth-100;
        //头视图下面的  view 隐藏  因为 没有品牌
        UIView*grayView=[view viewWithTag:100];
        grayView.hidden=YES;
        return view;

        //点评数至少有一个才有
    }else if (section==1&&self.threeCommit.count>0){
        UIView*bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
        bottomView.backgroundColor=[UIColor whiteColor];
        
        UILabel*leftLabel=[[UILabel alloc]init];
        leftLabel.text=@"客户点评";
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
        NSMutableAttributedString*cha=[[NSMutableAttributedString alloc]initWithString:@"查看全部" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(186, 186,186, 1),NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        
        NSString*num=self.allDatas[@"comment_num"];
        NSMutableAttributedString*number=[[NSMutableAttributedString alloc]initWithString:num attributes:@{NSForegroundColorAttributeName:RGBCOLOR(252, 76, 30, 1),NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        
        NSMutableAttributedString*dianping=[[NSMutableAttributedString alloc]initWithString:@"条点评" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(186, 186,186, 1),NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        [cha appendAttributedString:number];
        [cha appendAttributedString:dianping];
        
//        rightLabel.text=[NSString stringWithFormat:@"查看全部%@条点评",@"1501"];
        rightLabel.attributedText=cha;
        [bottomView addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(leftLabel.mas_centerY);
            make.right.mas_equalTo(rightArr.mas_left).offset(-8);
            
        }];
        
        
        //加个透明的按钮
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/2, 0, KScreenWidth/2, 44)];
        button.backgroundColor=[UIColor clearColor];
        [button addTarget:self action:@selector(Tocommit) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:button];
        
        return bottomView;
        
        //大家都在买
    }else if (section==2&&self.aboutShopping.count>0){
        
        BottomHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:BOOTOMHEADER];
        //设置 代理是自己
        view.aa=self;
//          pic id  price   title  需要改组下aboutShopping  让他每个字典只有4个key
        NSMutableArray*saveArray=[NSMutableArray array];
        for (NSDictionary*dict in self.aboutShopping) {
//            NSMutableDictionary*dic=[NSMutableDictionary dictionary];
//            [dic setObject:dict[@"pic"] forKey:@"pic"];
//             [dic setObject:dict[@"id"] forKey:@"id"];
//             [dic setObject:dict[@"price"] forKey:@"price"];
//             [dic setObject:dict[@"title"] forKey:@"title"];
            
            
            GuessLikeModel*model=[[GuessLikeModel alloc]init];
            model.pic=dict[@"pic"];
            model.idd=dict[@"id"];
            model.price=dict[@"price"];
            model.title=dict[@"title"];
            
            [saveArray addObject:model];
        }
        
        
          view.allDatas=[saveArray copy];
        view.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageWithColor:[UIColor whiteColor]]];
        

        
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
        //section1  公主点评那一行
        if (self.threeCommit.count<=0) {
            return 0.01;
        }
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


-(DetailHeaderModel*)createFalueDatas{
    DetailHeaderModel*model=[[DetailHeaderModel alloc]init];
    
    model.labelTitle=self.allDatas[@"title"];
    model.images=self.allDatas[@"pic"];
    model.priceLabel=self.allDatas[@"price"];
    model.marketLabel=self.allDatas[@"market_price"];
    
    
//    //创建4个字典对应的key   labelTitle   images    priceLabel     marketLabel
//    NSDictionary*dict=@{@"labelTitle":self.allDatas[@"title"],@"images":self.allDatas[@"pic"],@"priceLabel":self.allDatas[@"price"],@"marketLabel":self.allDatas[@"market_price"]};
    return model;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
 CGFloat aa=  scrollView.contentOffset.y-_nowY;
    if (aa>30) {
        [UIView animateWithDuration:0.25 animations:^{
            self.buttonView.frame=CGRectMake(0, KScreenHeight, KScreenWidth, 52);
        }];
    }else if (scrollView.contentOffset.y<=20){
        [UIView animateWithDuration:0.25 animations:^{
            self.buttonView.frame=CGRectMake(0, KScreenHeight-52, KScreenWidth, 52);
        }];

        
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.buttonView.frame=CGRectMake(0, KScreenHeight-52, KScreenWidth, 52);
        }];

    }
    
    
    
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
     self.nowY=scrollView.contentOffset.y;
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//        
//        return 480.0;
//    }
//    return 100;
//}

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
    NewGoodDetailViewController*vc=[[NewGoodDetailViewController alloc]init];
    vc.dictJiekou=dict;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(void)Tocommit{
    CommitListViewController*vc=[[CommitListViewController alloc]init];
    vc.pid=self.allDatas[@"id"];
    vc.howmuchCommit=self.allDatas[@"comment_num"];
    [self.navigationController pushViewController:vc animated:YES];

    
}


#pragma mark   get method
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
        _otherScrollView.contentSize=CGSizeMake(KScreenWidth, 2*KScreenHeight-64);
         _otherScrollView.alwaysBounceVertical=YES;
//        _otherScrollView.bounces=NO;
        _otherScrollView.delegate=self;
        _otherScrollView.scrollEnabled=YES;
    }
    return _otherScrollView;

}

-(OldChooseColorView *)oldChooseView{
    if (!_oldChooseView) {
        _oldChooseView=[[OldChooseColorView alloc]initWithFrame:CGRectMake(0, KScreenHeight*1.5, KScreenWidth, 330)];
        _oldChooseView.delegate=self;
        UIWindow*window=[UIApplication sharedApplication].keyWindow;
        [window addSubview:_oldChooseView];
          [window bringSubviewToFront:_oldChooseView];
        __weak typeof (self)weakSelf=self;
        _oldChooseView.cancelBlock=^{
            [weakSelf dismiss];
            
        };
        
     
    }
    return _oldChooseView;
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

//右上角两个按钮
-(void)touchOpenShoppingCar{
    if (![UserSession instance].isLogin) {
        //没登录
        EnterAPPViewController*vc=[[EnterAPPViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
        
        
    }else{
        //购物车
        ShopCarViewController*vc=[[ShopCarViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
  
    
}

-(void)touchCollection:(UIButton*)sender{
    if (![UserSession instance].isLogin) {
        //没登录
        EnterAPPViewController*vc=[[EnterAPPViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];

        
    }else{
        //登录了
        NSString*str=nil;
        if (sender.selected==YES) {
            sender.selected=NO;
            //取消
            str=@"0";
        }else{
            sender.selected=YES;
            //加入收藏夹
            str=@"1";
        }
        
        //吊接口  然后改正
        [self collectOrNo:str];
        

    }
    
    
    
    
    
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

-(void)navigationBarRightItem{
  
    UIButton*button0=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    [button0 setBackgroundImage:[UIImage imageNamed:@"购物车right"] forState:UIControlStateNormal];
    [button0 addTarget:self action:@selector(touchOpenShoppingCar) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*rightItem1=[[UIBarButtonItem alloc]initWithCustomView:button0];

    
    
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [button setBackgroundImage:[UIImage imageNamed:@"爱心"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"爱心_红"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(touchCollection:) forControlEvents:UIControlEventTouchUpInside];
    self.collectionButton=button;
    UIBarButtonItem*rightItem2=[[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItems=@[rightItem1,rightItem2];
    
    
}


#pragma mark  ---加入购物袋和立即购买
-(void)creatTwoButtonView{
    self.buttonView=[ChooseVIew creatVCWithFrame:CGRectMake(0, KScreenHeight-52, KScreenWidth, 52)];
    [self.view addSubview:self.buttonView];
    
    self.cover.alpha=0;
    
    self.oldChooseView.buyImmedatelyOrAddToCar=immedateBuy;


  #pragma mark ---两个 按钮的点击事件
    __weak typeof(self)weakSelf =self;
    self.buttonView.ImmediatelyBlock=^{
        //立即购买
       NSArray*array=weakSelf.allDatas[@"spe"];
        //设置数据的时候  刷新界面内容
        weakSelf.oldChooseView.allDatas=array;
        
        
        weakSelf.cover.alpha=0;
        
        weakSelf.oldChooseView.buyImmedatelyOrAddToCar=immedateBuy;
    
        
        weakSelf.oldChooseView.allDict=weakSelf.allDatas; //所有数据
     
        
        [UIView animateWithDuration:0.5 animations:^{
            CGFloat ViewHeight=[weakSelf.oldChooseView getViewHeight];
            if (ViewHeight>KScreenHeight-150) {
                weakSelf.oldChooseView.tableView.scrollEnabled=YES;
                 weakSelf.oldChooseView.y=150;
                weakSelf.oldChooseView.height=KScreenHeight-150;
            }else{
                weakSelf.oldChooseView.tableView.scrollEnabled=NO;
                 weakSelf.oldChooseView.y=KScreenHeight-ViewHeight;
                weakSelf.oldChooseView.height=ViewHeight;

            }
            
            weakSelf.cover.alpha=0.6;
          
            
        }];
        
    };
    
    
    
    
    
    self.buttonView.addCarBlock=^{
        //加入购物袋
        NSArray*array=weakSelf.allDatas[@"spe"];
        
     
        
        weakSelf.cover.alpha=0;
        
        weakSelf.oldChooseView.buyImmedatelyOrAddToCar=addToshoppingCar;
        
        //设置数据的时候  刷新界面内容
        weakSelf.oldChooseView.allDict=weakSelf.allDatas; //所有数据
        weakSelf.oldChooseView.allDatas=array;
        
        [UIView animateWithDuration:0.5 animations:^{
            CGFloat ViewHeight=[weakSelf.oldChooseView getViewHeight];
            if (ViewHeight>KScreenHeight-150) {
                weakSelf.oldChooseView.tableView.scrollEnabled=YES;
                weakSelf.oldChooseView.y=150;
                weakSelf.oldChooseView.height=KScreenHeight-150;
            }else{
                weakSelf.oldChooseView.tableView.scrollEnabled=NO;
                weakSelf.oldChooseView.y=KScreenHeight-ViewHeight;
                weakSelf.oldChooseView.height=ViewHeight;
                
            }
            
            weakSelf.cover.alpha=0.6;
            
            
        }];
        
    };
    
    
    

    
}



#pragma mark  ---点击了之后  代理回调
-(void)DelegateBuy:(BUYORADD)immedateBuyy andChooseDict:(NSMutableDictionary *)mtdict andHowMuchChoose:(NSUInteger)alldata_count andgoodsHowMuch:(NSString *)much{
    //是否登录
    if (![UserSession instance].isLogin) {
        //没登录
        [self dismiss];
        EnterAPPViewController*vc=[[EnterAPPViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
        
        
    }else{
       //登录之后
//        if (mtdict.count!=alldata_count||[much isEqualToString:@"0"]) {
//            [JRToast showWithText:@"请完善选择"];
//        }else{
            switch (immedateBuyy) {
                case immedateBuy:{
                    //立即购买
                    NSMutableString*newStr=[[NSMutableString alloc]init];
                    [mtdict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        NSString*str=[NSString stringWithFormat:@"|%@,%@",key,obj];
                        [newStr appendString:str];
                        
                    }];
                    
                    NSString*bb= [newStr substringFromIndex:1];

                    NSMutableDictionary*params=[NSMutableDictionary dictionary];
                NSDictionary*param2=@{@"m":@"appapi",@"s":@"go_shop",@"act":@"Immediate_settlement",@"zt":@"0",@"uid":[UserSession instance].uid,@"num":much,@"id":self.allDatas[@"id"]};
                    [params setValuesForKeysWithDictionary:param2];
                     [params setObject:bb forKey:@"attr"];
                                                
                    [self imedateBuyJiekouWithparams:[params copy]];
                    
                    
                }
                    
                    break;
                case addToshoppingCar:{
                    //加入购物车
                    NSMutableString*newStr=[[NSMutableString alloc]init];
                    [mtdict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        NSString*str=[NSString stringWithFormat:@"|%@,%@",key,obj];
                        [newStr appendString:str];
                        
                    }];
                    
                NSString*bb= [newStr substringFromIndex:1];
                    
                    
                    
                    NSMutableDictionary*params=[NSMutableDictionary dictionary];
                    NSDictionary*dict=@{@"m":@"appapi",@"s":@"go_shop",@"act":@"add_SC",@"uid":[UserSession instance].uid,@"id":self.allDatas[@"id"],@"num":much};
                    [params setValuesForKeysWithDictionary:dict];
                    [params setObject:bb forKey:@"attr"];
                    

                    [self addShoppingCarWithParams:[params copy]];
                    
                }
                    
                    break;
    
                default:
                    break;
            }
            
            
            
            
            
//        }
        
        
        
        
    }

    
    
    
    
}


//加入到购物车
-(void)addShoppingCarWithParams:(NSDictionary*)params{
          NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"])  {
            [JRToast showWithText:@"加入购物车成功"];
            UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"购物车" message:@"加入购物车成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
           
            
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
       
    }
    }];
    
    [self dismiss];


    
}

//立即购买接口
-(void)imedateBuyJiekouWithparams:(NSDictionary*)params{
         NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            
            
            ConfirmOrderViewController*vc=[[ConfirmOrderViewController alloc]init];
            NSMutableArray*array1=[NSMutableArray array];
            for (int i=0; i<[data[@"data"] count]; i++) {
                ShoppingModel *model=[[ShoppingModel alloc]initWithShopDict:data[@"data"][i]];
                [array1 addObject:model];

                
            }
//
            vc.allDatas=array1;
            vc.dizhi=data[@"address"];
            vc.allMoney=[data[@"data"][0][@"price"] floatValue];
            vc.allTrans=[data[@"data"][0][@"freight_price"] floatValue];
            
            vc.immeToBuy=YES;
            vc.attr=params[@"attr"];
            vc.num=params[@"num"];
            vc.idd=params[@"id"];
#warning --- 做的好 后台不给力。。    数量 颜色 尺寸  id  排序的。。    需要舍弃
//            vc.saveThreeParams=@[params[@"num"],@[params[@"颜色"]],@[params[@"尺寸"]],self.allDatas[@"id"]];
            
//            vc.saveThreeParams=@[params[@"num"],@"",@"",self.allDatas[@"id"]];
            
            [self.navigationController pushViewController:vc animated:YES];
//
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
    }];

    
      [self dismiss];
    
}

@end
