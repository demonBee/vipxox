//
//  DepartmentViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/11.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "DepartmentViewController.h"
#import "SDCycleScrollView.h"
#import "DepartmentSection0TableViewCell.h"
#import "DepartmentSection1TableViewCell.h"

#import "brandModel.h"
#import "goodsModel.h"
//跳转的界面
#import "BrandViewController.h"   //跳转到品牌
#import "DepartmentDetailViewController.h"    //跳转到商品


#define SECTION0  @"DepartmentSection0TableViewCell"
#define SECTION1  @"DepartmentSection1TableViewCell"

@interface DepartmentViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property(nonatomic,strong)UITableView*tableView;


@property(nonatomic,strong)NSMutableArray*bannerModel;
@property(nonatomic,strong)NSMutableArray*brandModel;
@property(nonatomic,strong)NSMutableArray*cellModel;
@end

@implementation DepartmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets=YES;
    self.view.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:SECTION0 bundle:nil] forCellReuseIdentifier:SECTION0];
    [self.tableView registerNib:[UINib nibWithNibName:SECTION1 bundle:nil] forCellReuseIdentifier:SECTION1];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    [self setupRefresh];
    
}

#pragma mark --- UI
- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [self.tableView headerBeginRefreshing];
//    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}
- (void)headerRereshing
{
    [self getDatas];
    
}
//- (void)footerRereshing
//{
//    
//   
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  
        return self.cellModel.count+1;
  
    
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     __weak typeof (self)weakSelf=self;
    
    if (indexPath.section==0) {
       DepartmentSection0TableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:SECTION0];
         cell.selectionStyle=NO;
        
        NSInteger num=0;
        if ( self.brandModel.count>5) {
            num=5;
        }else{
            num=self.brandModel.count;
        }
      
        //先全部隐藏
        for (int i=0; i<5; i++) {
            UIImageView*imageView=[cell viewWithTag:i+1];
            imageView.hidden=YES;;
        }
        
        //有值的显示
        for (int i=0; i<num; i++) {
            UIImageView*imageView=[cell viewWithTag:i+1];
            imageView.hidden=NO;
            imageView.contentMode=UIViewContentModeScaleAspectFit;
            brandModel*model=self.brandModel[i];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"placeholder_375x375"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            
        }
        
        
        //点击 cell 0 上的内容
        cell.tapBlock=^(NSInteger integer){
            
            NSLog(@"%ld",(long)integer);
            //这个要  -1 的
            brandModel*model=self.brandModel[integer-1];
            BrandViewController*vc=[[BrandViewController alloc]init];
            vc.bid=model.brandID;
            [self.navigationController pushViewController:vc animated:YES];



            
            
        };
        
        return cell;
        
    }else{
        
#pragma mark  --第二层的cell
       DepartmentSection1TableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:SECTION1];
         cell.selectionStyle=NO;
        //给值  从第二项开始 所以要-1
        brandModel*model=self.cellModel[indexPath.section-1];
        NSArray*goodsArray=model.prolist;
        
        cell.allDatasModel=goodsArray;
        
        UIButton*brandButton=[cell viewWithTag:1];
        brandButton.backgroundColor=[UIColor clearColor];
        brandButton.adjustsImageWhenHighlighted=NO;
        //imageView
        UIImageView*imageView=[cell viewWithTag:11];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"placeholder_375x375"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        
//        brandButton.contentMode=UIViewContentModeScaleAspectFit;
//        [brandButton sd_setImageWithURL:[NSURL URLWithString:model.logo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_375x375"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//        }];
        
        
        
        cell.tableIndexPath=indexPath;
        
        //品牌 跳转
        cell.buttonBlock=^(NSIndexPath*tableIndexPath){
//            _bigBrannerBlock(tableIndexPath);
            BrandViewController*vc=[[BrandViewController alloc]init];
            vc.bid=model.brandID;
            [weakSelf.navigationController pushViewController:vc animated:YES];

        };
        
        //商品跳转
        cell.collectionViewBlock=^(NSString*goodsID){
//            _shopBlock(tableIndexPath,collectionIndexPath);
            DepartmentDetailViewController*vc=[[DepartmentDetailViewController alloc]init];
            NSDictionary*dict=@{@"id":goodsID};
            vc.dictJiekou=dict;
            
            [weakSelf.navigationController pushViewController:vc animated:YES];

            
        };
        
        return cell;
        
    }
    
    
    
    
    }
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return ACTUAL_HEIGHT(82);
    }else{
        return 180-130+ACTUAL_HEIGHT(130)+ACTUAL_HEIGHT(193);
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return ACTUAL_HEIGHT(180);
    }
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        NSMutableArray*allImage=[NSMutableArray array];
        for (int i=0; i<self.bannerModel.count; i++) {
            brandModel*model=self.bannerModel[i];
            [allImage addObject:model.logo];
            
        }
        
        if (allImage.count<1) {
            return nil;
        }
        
        SDCycleScrollView*SDVC=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth,ACTUAL_HEIGHT(180)) imagesGroup:allImage andPlaceholder:@"placeholder_375x180"];
        SDVC.autoScrollTimeInterval=5.0;
        SDVC.delegate=self;
        return SDVC;

    }
    
    return nil;
  }


#pragma mark  -----  datas

-(void)getDatas{
//    http://www.vipxox.cn/?  m=app&s=baihuo&act=index
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"app",@"s":@"baihuo",@"act":@"index",@"uid":[UserSession instance].uid};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        NSNumber *code=data[@"errorCode"];
        NSString *aaa=[NSString stringWithFormat:@"%@",code];
        
        if ([aaa isEqualToString:@"0"]) {
            NSArray*banner=data[@"data"][@"top_big_brand"];
            NSArray*brand=data[@"data"][@"top_small_brand"];
            NSArray*cell=data[@"data"][@"brandpro"];
            
            [self.bannerModel removeAllObjects];
            [self.brandModel removeAllObjects];
            [self.cellModel removeAllObjects];
            
            for (NSDictionary*dict in banner) {
                brandModel*model=[brandModel yy_modelWithDictionary:dict];
                [self.bannerModel addObject:model];
            }
            
            
            for (NSDictionary*dict in brand) {
                brandModel*model=[brandModel yy_modelWithDictionary:dict];
                [self.brandModel addObject:model];

            }
            
            for (NSDictionary*dict in cell) {
                brandModel*model=[brandModel yy_modelWithDictionary:dict];
                [self.cellModel addObject:model];
                
            }

            //打印这3个model 数组
            [self.tableView reloadData];
            
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
    }];
    
    
    
}


#pragma mark   --- delegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%lu",index);
    brandModel*model=self.bannerModel[index];
    BrandViewController*vc=[[BrandViewController alloc]init];
    vc.bid=model.brandID;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




#pragma mark ---- set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(NSMutableArray *)bannerModel{
    if (!_bannerModel) {
        _bannerModel=[NSMutableArray array];
    }
    return _bannerModel;
}

-(NSMutableArray *)brandModel{
    if (!_brandModel) {
        _brandModel=[NSMutableArray array];
    }
    return _brandModel;
}

-(NSMutableArray *)cellModel{
    if (!_cellModel) {
        _cellModel=[NSMutableArray array];
    }
    return _cellModel;
}
@end
