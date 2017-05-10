//
//  ChinaSuperMarketViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/2/28.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ChinaSuperMarketViewController.h"

@interface ChinaSuperMarketViewController ()<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)NSArray*allDatas;

@end

@implementation ChinaSuperMarketViewController

//-(UITableView *)tableView{
//    if (!_tableView) {
//        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, KScreenHeight) style:UITableViewStyleGrouped];
//        _tableView.delegate=self;
//        _tableView.dataSource=self;
//    }
//    return _tableView;
//}
-(instancetype)init{
    self=[super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(YesisMark) name:@"isSuperMarket" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NoisMark) name:@"isntSuperMarket" object:nil];
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(64), 0, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [self.view addSubview:_tableView];

        
    }
    return self;
}

-(void)YesisMark{
    self.isSuperMark=YES;
    [self getDatas];
    [self.topView removeFromSuperview];
    [self makeNaviBar];
    [self.tableView reloadData];
}
-(void)NoisMark{
    self.isSuperMark=NO;
    [self getDatas];
    [self.topView removeFromSuperview];
    [self makeNaviBar];

        [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self getDatas];
//    [self makeNaviBar];
//  [self.view addSubview:self.tableView];
    NSLog(@"%d",self.isSuperMark);
//    self.view.backgroundColor=[UIColor yellowColor];
  
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [self getColor];

    
}
-(void)getColor{
#warning 颜色
    if (_xcolor==0) {
        //        [self.navigationController.navigationBar setBarTintColor:ManColor];
        _topView.backgroundColor=ManColor;
        
    }else if (_xcolor==1){
        //        [self.navigationController.navigationBar setBarTintColor:YooPink];
        _topView.backgroundColor=YooPink;
        
    }else if (_xcolor==2){
        //        [self.navigationController.navigationBar setBarTintColor:BoyColor];
        _topView.backgroundColor=BoyColor;
        
    }else if (_xcolor==3){
        _topView.backgroundColor=NorthAmercia;
    }
    
}


-(void)getDatas{
    if (self.isSuperMark==YES) {
          self.allDatas=nil;
        self.allDatas=[NSArray array];
        NSDictionary*dic0=@{@"image":@"",@"title":@"饼干／糕点／甜品"};
        NSDictionary*dic1=@{@"image":@"",@"title":@"休闲／膨化／薯片"};
        NSDictionary*dic2=@{@"image":@"",@"title":@"糖果／软糖／巧克力"};
        NSDictionary*dic3=@{@"image":@"",@"title":@"肉类／海味／坚果／蜜饯"};
        NSDictionary*dic4=@{@"image":@"",@"title":@"茶类／饮品／麦片"};
        NSDictionary*dic5=@{@"image":@"",@"title":@"方便／速食／干货"};
        
        self.allDatas=@[dic0,dic1,dic2,dic3,dic4,dic5];

    }else{
        self.allDatas=nil;
        self.allDatas=[NSArray array];
        NSDictionary*dic0=@{@"title":@"淘宝"};
        NSDictionary*dic1=@{@"title":@"天猫"};
        NSDictionary*dic2=@{@"title":@"聚划算"};
        NSDictionary*dic3=@{@"title":@"京东"};
        NSDictionary*dic4=@{@"title":@"当当"};
        NSDictionary*dic5=@{@"title":@"时尚起义"};
        NSDictionary*dic6=@{@"title":@"苏宁易购"};
        
        self.allDatas=@[dic0,dic1,dic2,dic3,dic4,dic5,dic6];
   
      
        
    }
   }

-(void)makeNaviBar{
    self.topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, ACTUAL_HEIGHT(64))];
//    self.topView.backgroundColor=[UIColor redColor];
    [self.view addSubview:_topView];

    self.spImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,ACTUAL_HEIGHT(24), 0,ACTUAL_HEIGHT(40))];
     self.spImageView.backgroundColor=[UIColor whiteColor];
     self.spImageView.contentMode=UIViewContentModeScaleAspectFit;

    [self.topView addSubview:self.spImageView];
    if (self.isSuperMark==YES) {
        self.spImageView.image=[UIImage imageNamed:@"supermarket.png"];
        
    }else{
        self.spImageView.image=[UIImage imageNamed:@"gostreet"];
        
    }

    self.backButton=[[UIButton alloc]initWithFrame:CGRectMake(0.f,ACTUAL_HEIGHT(31),30.f,ACTUAL_WIDTH(24))];
    [self.backButton setImage:[UIImage imageNamed:@"ringArr"] forState:UIControlStateNormal];
    self.backButton.transform  = CGAffineTransformRotate(self.backButton.transform, M_PI);
    [self.backButton addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.backButton];
    UILabel * tittleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.backButton.frame),self.backButton.y,100.f,self.backButton.height)];
    tittleLabel.text = self.isSuperMark?@"华人超市":@"逛街";
    tittleLabel.font = [UIFont boldSystemFontOfSize:20.f];
    [self.topView addSubview:tittleLabel];

    [self getColor];
}
-(void)gotoBack{
    if ([self.delegate respondsToSelector:@selector(dismissThisVC)]) {
        [self.delegate dismissThisVC];
    }
   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allDatas.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSuperMark) {
//        [_backButton setTitle:@"华人超市Groceies" forState:UIControlStateNormal];

    }else{
//          [_backButton setTitle:@"逛街Finderverthing" forState:UIControlStateNormal];
    }
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
  
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.text=self.allDatas[indexPath.row][@"title"];
        cell.imageView.backgroundColor=[UIColor greenColor];
        cell.textLabel.font=[UIFont systemFontOfSize:12];
    }
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView*naviView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(44))];
//    naviView.backgroundColor=YooPink;
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger aa=indexPath.row;
    NSLog(@"%lu",aa);
    if (self.isSuperMark==YES) {
        //华人超市
        NSLog(@"%lu",indexPath.row);
        NSDictionary*dic=@{@"key":indexPath};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"gotosixCategroy" object:nil userInfo:dic];

        
    }else{
        //逛街
//        if ([self.delegate respondsToSelector:@selector(touchGuangjie:)]) {
//            [self.delegate touchGuangjie:indexPath.row];
//        }
            NSDictionary*dic=@{@"key":indexPath};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoHtml" object:nil userInfo:dic];
        
        NSLog(@"%lu",indexPath.row);

        
        
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
