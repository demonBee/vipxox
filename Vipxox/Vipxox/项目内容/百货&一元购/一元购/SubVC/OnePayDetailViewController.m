//
//  OnePayDetailViewController.m
//  Vipxox
//
//  Created by Tian Wei You on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "OnePayDetailViewController.h"
#import "OnePayComfiredViewController.h"
#import "EnterAPPViewController.h"

#import "PayCountView.h"
#import "OnePayDetailModel.h"

#import "SDCycleScrollView.h"
#import "HttpObject.h"

#import "OnePayNowTableViewCell.h"
#import "OnePayOneTableViewCell.h"

#define ONEPAYNOWCELL @"OnePayNowTableViewCell"
#define ONEPAYONECELL @"OnePayOneTableViewCell"

@interface OnePayDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic,strong)PayCountView * payView;
@property (nonatomic,strong)OnePayDetailModel * detailModel;

@end

@implementation OnePayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerTableView];
    [self setupRefresh];
    [self makeNavi];
    

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if (self.payView)[self.payView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self requestDetailData];
    

}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerTableView{
    [self.tableView registerNib:[UINib nibWithNibName:ONEPAYONECELL bundle:nil] forCellReuseIdentifier:ONEPAYONECELL];
    [self.tableView registerNib:[UINib nibWithNibName:ONEPAYNOWCELL bundle:nil] forCellReuseIdentifier:ONEPAYNOWCELL];
}

- (void)makeNavi{
    self.backBtn.layer.cornerRadius = 16.f;
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(8.f, 8.f, self.backBtn.width - 16.f, self.backBtn.width - 16.f)];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = [UIImage imageNamed:@"zuo"];
    [self.backBtn addSubview:imgView];
}

- (void)showBuy{
    if ([self.detailModel.branch integerValue] == [self.detailModel.is_branch integerValue]) {
        //已经购买完了
        [self showHUDWithStr:@"Products have been sold out，Please wait for the lottery"];
        
    }else if ([self.detailModel.number integerValue] > 0) {
        //未达到购买上限
        NSInteger payMax = [self.detailModel.number integerValue] > ([self.detailModel.branch integerValue] - [self.detailModel.is_branch integerValue]) ? ([self.detailModel.branch integerValue] - [self.detailModel.is_branch integerValue]): [self.detailModel.number integerValue];//购买最大数，购买上限与开奖剩余份额的较小值
        
        self.payView = [[PayCountView alloc]initWithMaxPay:payMax withOne:self.detailModel.one withCurrency:self.detailModel.currency];
        [self.view addSubview:self.payView];
        
        __weak typeof(self)weakSelf = self;
        self.payView.payBlock = ^(){
            if ([UserSession instance].isLogin) {
                OnePayComfiredViewController * vc = [[OnePayComfiredViewController alloc]init];
                vc.idd = weakSelf.idd;
                vc.name = weakSelf.detailModel.title;
                vc.number = weakSelf.payView.numberView.numberLab.text;
                vc.one = weakSelf.detailModel.one;
                vc.isLottery = [self.detailModel.branch integerValue]==([weakSelf.payView.numberView.numberLab.text integerValue] + [self.detailModel.is_branch integerValue]) ? YES:NO;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                EnterAPPViewController*vc=[[EnterAPPViewController alloc]init];
                [weakSelf presentViewController:vc animated:YES completion:nil];
            }
        };
    }else{
        //购买上限
        [self showHUDWithStr:@"Has reached the purchase limit"];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 1) {
//        return 100.f;
//    }
    return 100.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return ACTUAL_WIDTH(470.f);
    }
    return 15.f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView * mainView=[[UIView alloc]initWithFrame:CGRectMake(0,0 , KScreenWidth,ACTUAL_WIDTH(470.f) )];
        mainView.backgroundColor=[UIColor whiteColor];
        NSMutableArray * imgArr = [[NSMutableArray alloc]initWithCapacity:0];
        NSMutableAttributedString * tittleStr;
        
        if (self.detailModel) {
            [imgArr addObjectsFromArray:self.detailModel.pic];
             tittleStr =[[NSMutableAttributedString alloc]initWithString:self.detailModel.title attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:15.f]}];
            NSMutableAttributedString * tittle=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"   %@",self.detailModel.con] attributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:15.f]}];
            [tittleStr appendAttributedString:tittle];
            
        }else{
            [imgArr addObjectsFromArray:@[@"placeholder_375x180"]];
            tittleStr= [[NSMutableAttributedString alloc]initWithString:@"" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:16.f]}];
        }
        SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth,ACTUAL_WIDTH(410.f)) imagesGroup:imgArr andPlaceholder:@"placeholder_375x180"];
        cycleScrollView.autoScrollTimeInterval = 3.0;
        
        [mainView addSubview:cycleScrollView];
        
        
        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16.f]};
        CGRect conRect = [[NSString stringWithFormat:@"%@   %@",self.detailModel.title,self.detailModel.con] boundingRectWithSize:CGSizeMake(KScreenWidth - 20.f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        UILabel * tittleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f,ACTUAL_WIDTH(420.f), KScreenWidth - 20.f, conRect.size.height)];
        tittleLabel.attributedText = tittleStr;
        tittleLabel.numberOfLines = 0;
        tittleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        tittleLabel.textAlignment = NSTextAlignmentCenter;
        [mainView addSubview:tittleLabel];
        
        return mainView;
    }
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KScreenWidth, 15.f)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    return headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)return 0;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 1) {
//        OnePayNowTableViewCell * payNowCell = [tableView dequeueReusableCellWithIdentifier:ONEPAYNOWCELL];
//        payNowCell.allPayBlock = ^(){
//            //全价购买
//        };
//        
//        return payNowCell;
//    }
    
    OnePayOneTableViewCell * payOneCell = [tableView dequeueReusableCellWithIdentifier:ONEPAYONECELL];
    payOneCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.detailModel) {
        payOneCell.priceLabel.text = [NSString stringWithFormat:@"%@%.2f",self.detailModel.currency,[self.detailModel.price floatValue]];
    }
    
    

    
    
    payOneCell.onePayBlock = ^(){
        [self showBuy];
    };
    
    
    
    return payOneCell;
}

//不悬停
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 15.f;
    CGFloat sectionFooterHeight = 0.f;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= sectionHeaderHeight && offsetY <= scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight && offsetY <= scrollView.contentSize.height - scrollView.frame.size.height)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight), 0);
    }
}

#pragma mark - TableView Refresh
- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
}
- (void)headerRereshing
{
    [self requestDetailData];
}

#pragma mark - MBProgressHUD
- (void)showHUDWithStr:(NSString *)showHud{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = showHud;
    hud.dimBackground = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.7];
}

#pragma mark - HTTP
- (void)requestDetailData{
    NSDictionary * program;
    if ([UserSession instance].isLogin) {
        program = @{@"id":self.idd,@"uid":[UserSession instance].uid};
    }else{
        program = @{@"id":self.idd,@"currency":[UserSession instance].currency};
    }
    [[HttpObject manager]postDataWithType:OnePayType_SHOP_DETAIL withPragram:program success:^(id responsObj) {
        [self.tableView headerEndRefreshing];
        MyLog(@"Shop Detail is %@",responsObj);
        MyLog(@"Shop Detail Program is %@",program);
        self.detailModel = [OnePayDetailModel yy_modelWithDictionary:responsObj[@"data"]];
        [self.tableView reloadData];
        if (self.showBuyView) {
            [self showBuy];
            self.showBuyView =NO;
        }
    } failur:^(NSError *error) {
        [self.tableView headerEndRefreshing];
        MyLog(@"Shop Error is %@",error);
    }];
}


@end
