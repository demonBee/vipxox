//
//  OnePayViewController.m
//  Vipxox
//
//  Created by Tian Wei You on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "OnePayViewController.h"
#import "HttpObject.h"

#import "SDCycleScrollView.h"
#import "YJSegmentedControl.h"

#import "OnePayCollectionViewCell.h"
#import "OnePayBannerHeader.h"
#import "OnePayRecommendHeader.h"
#import "OnePaySegamentHeader.h"

#import "OnePayModel.h"

#define ONEPAY_CELL @"OnePayCollectionViewCell"
#define ONEPAY_BANNER_HEADER @"OnePayBannerHeader"
#define ONEPAY_RECOMMENT_HEADER @"OnePayRecommendHeader"
#define ONEPAY_SEGAMENT_HEADER @"OnePaySegamentHeader"

@interface OnePayViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,SDCycleScrollViewDelegate,YJSegmentedControlDelegate>

@property (nonatomic,strong)OnePayModel * onePayModel;
@property (nonatomic,strong)NSMutableArray * productArr;
@property (nonatomic,strong)NSArray * requestTypeArr;
@property (nonatomic,assign)NSInteger segmentSelectIndex;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,copy)NSString * pagen;
@property(nonatomic,strong)SDCycleScrollView*cycleScrollView;

@property (nonatomic,strong)OnePaySegamentHeader * segamentHeader;

@end

@implementation OnePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];//初始化请求参数
    
    [self collectionViewRegister];
    [self setupRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getData{
    self.pagen = @"10";
    self.pages = 0;
    self.segmentSelectIndex = 0;
    self.productArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.requestTypeArr = @[@"",@"popular",@"high",@"low"];
}

- (void)collectionViewRegister{
    [self.onePayCollectionView registerNib:[UINib nibWithNibName:ONEPAY_CELL bundle:nil] forCellWithReuseIdentifier:ONEPAY_CELL];
    //Header
    [self.onePayCollectionView registerNib:[UINib nibWithNibName:ONEPAY_BANNER_HEADER bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ONEPAY_BANNER_HEADER];
    [self.onePayCollectionView registerNib:[UINib nibWithNibName:ONEPAY_SEGAMENT_HEADER bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ONEPAY_SEGAMENT_HEADER];
    [self.onePayCollectionView registerNib:[UINib nibWithNibName:ONEPAY_RECOMMENT_HEADER bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ONEPAY_RECOMMENT_HEADER];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(KScreenWidth, ACTUAL_WIDTH(200.f));
    }else if (section == 1){
        return CGSizeMake(KScreenWidth,165.f + 15.f);
    }
    return CGSizeMake(self.view.width, 36.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KScreenWidth-1.f)/2, 210.f);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.f;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 2) {
        return self.productArr.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OnePayCollectionViewCell * onePayCell = [collectionView dequeueReusableCellWithReuseIdentifier:ONEPAY_CELL forIndexPath:indexPath];
    OnePayShopModel * shopModel = self.productArr[indexPath.row];
    onePayCell.model = shopModel;
    
    __weak typeof(shopModel)model =shopModel;
    onePayCell.payNowBolck = ^(){
        OnePayDetailViewController * vc = [[OnePayDetailViewController alloc]init];
        vc.idd = model.shopID;
        vc.showBuyView=YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    
    return onePayCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        OnePayShopModel * shopModel = self.productArr[indexPath.row];
        
        OnePayDetailViewController * vc = [[OnePayDetailViewController alloc]init];
        vc.idd = shopModel.shopID;
        [self.navigationController pushViewController:vc animated:YES];
    }


    
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            OnePayBannerHeader * bannerHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ONEPAY_BANNER_HEADER forIndexPath:indexPath];
            
            NSMutableArray * imageArr = [[NSMutableArray alloc]initWithCapacity:0];
            if (self.onePayModel) {
                for (OnePayAdvModel * advModel in self.onePayModel.adv) {
                    [imageArr addObject:advModel.picName];
                }
                if (imageArr.count<1) {
                [imageArr addObjectsFromArray:@[@"picName",@"picName"]];
                }
                
            }else{
                [imageArr addObjectsFromArray:@[@"picName",@"picName"]];
            }
            
//            if (!cycleScrollView) {
//                cycleScrollView=[[SDCycleScrollView alloc]init];
//                cycleScrollView.tag=111;
//                [bannerHeader addSubview:cycleScrollView];
//            }
//            cycleScrollView.frame=CGRectMake(0, 0, bannerHeader.width,bannerHeader.height);
//            cycleScrollView.imagesGroup=@[@"http://image.baidu.com/search/detail?ct=503316480&z=undefined&tn=baiduimagedetail&ipn=d&word=图片&step_word=&ie=utf-8&in=&cl=2&lm=-1&st=undefined&cs=1519095430,2307521081&os=233489054,767658753&simid=4159270465,626150865&pn=0&rn=1&di=87288970340&ln=1000&fr=&fmq=1470623844554_R&fm=&ic=undefined&s=undefined&se=&sme=&tab=0&width=&height=&face=undefined&is=&istype=0&ist=&jit=&bdtype=0&adpicid=0&pi=0&gsm=0&objurl=http%3A%2F%2Fimg3.redocn.com%2F20101213%2F20101211_0e830c2124ac3d92718fXrUdsYf49nDl.jpg&rpstart=0&rpnum=0",@""];
//            cycleScrollView.placeholder=@"placehoder_375x180";
            
            if (!_cycleScrollView) {
                _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, bannerHeader.width,bannerHeader.height) imagesGroup:imageArr andPlaceholder:@"placeholder_375x180"];
                 [bannerHeader addSubview:_cycleScrollView];

            }
            _cycleScrollView.imagesGroup=imageArr;
       
            _cycleScrollView.delegate = self;
            _cycleScrollView.autoScrollTimeInterval = 5.0;
            
            
            return bannerHeader;
        }else if (indexPath.section == 1){
            OnePayRecommendHeader * recommendHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ONEPAY_RECOMMENT_HEADER forIndexPath:indexPath];
            if (self.onePayModel) {
                recommendHeader.announcedArr = [[NSMutableArray alloc]initWithArray:self.onePayModel.announced];
                [recommendHeader.recommendCollectionView reloadData];
            }
            __weak typeof(self)weakSelf = self;
            
            recommendHeader.recommendClickBolck = ^(NSString * recommendID){
                OnePayDetailViewController * vc = [[OnePayDetailViewController alloc]init];
                vc.idd = recommendID;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return recommendHeader
            ;
        }else{
            if (!self.segamentHeader) {
                self.segamentHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ONEPAY_SEGAMENT_HEADER forIndexPath:indexPath];
                [self.segamentHeader addSubview:[self makeYJSegmentedControl]];
            }
            return self.segamentHeader;
        }
    }
    return nil;
}

#pragma mark - Collection Refresh
- (void)setupRefresh
{
    [self.onePayCollectionView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [self.onePayCollectionView headerBeginRefreshing];
    [self.onePayCollectionView addFooterWithTarget:self action:@selector(footerRereshing)];
}
- (void)headerRereshing
{
    self.pages = 0;
    [self requestOnePayDataWithSegumentIndexPages:0];
}
- (void)footerRereshing
{
    self.pages++;
    [self requestOnePayDataWithSegumentIndexPages:self.pages];
}
#pragma mark - HTTP
- (void)requestOnePayDataWithSegumentIndexPages:(NSInteger)page{
    NSDictionary * pragram = @{@"zt":self.requestTypeArr[self.segmentSelectIndex],@"pagen":self.pagen,@"pages":[NSString stringWithFormat:@"%zi",page]};
    [[HttpObject manager] postDataWithType:OnePayType_Home withPragram:pragram success:^(id responsObj) {
        MyLog(@"OnePay Home pragram is %@",pragram);
        MyLog(@"OnePay Home is %@",responsObj);
        if (page == 0) {
            //下拉刷新
            [self.onePayCollectionView headerEndRefreshing];
            [self.productArr removeAllObjects];
        }else{
            //上拉刷新
            [self.onePayCollectionView footerEndRefreshing];
        }
        self.onePayModel = [OnePayModel yy_modelWithDictionary:responsObj[@"data"]];
        if(self.onePayModel.shop.count <=0)return;//无新数据则返回
        [self.productArr addObjectsFromArray:self.onePayModel.shop];
        [self.onePayCollectionView reloadData];
    } failur:^(NSError *error) {
        MyLog(@"OnePay Home error is%@",error);
        if (page == 0) {
            [self.onePayCollectionView headerEndRefreshing];
        }else{
            [self.onePayCollectionView footerEndRefreshing];
        }
    }];
}

#pragma mark - YJSegmentedControl
- (YJSegmentedControl *)makeYJSegmentedControl{
    return [YJSegmentedControl segmentedControlFrame:CGRectMake(0,0.f, KScreenWidth, 35.f) titleDataSource:@[@"最新",@"人气",@"高价",@"低价"] backgroundColor:[UIColor whiteColor] titleColor:[UIColor colorWithHexString:@"#5d5956"] titleFont:[UIFont systemFontOfSize:14.f] selectColor:[UIColor blackColor] buttonDownColor:[UIColor blackColor] Delegate:self];
}

-(void)segumentSelectionChange:(NSInteger)selection{
    //重置&请求
    self.segmentSelectIndex = selection;
    [self.onePayCollectionView headerBeginRefreshing];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (self.onePayModel.adv.count<1) {
        return;
    }
    OnePayAdvModel * advModel = self.onePayModel.adv[index];
    OnePayDetailViewController * vc = [[OnePayDetailViewController alloc]init];
    vc.idd = advModel.app_data;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
