//
//  OnePayComfiredViewController.m
//  Vipxox
//
//  Created by Tian Wei You on 16/8/2.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "OnePayComfiredViewController.h"
#import "AccountRechargeViewController.h"
#import "OneYuanPurchaseViewController.h"

#import "HttpObject.h"

#import "OnePayComfiredTableViewCell.h"
#import "OnePayCfrPriceTableViewCell.h"

#define ONECFRCELL @"OnePayComfiredTableViewCell"
#define ONECFRPRICECELL @"OnePayCfrPriceTableViewCell"


@interface OnePayComfiredViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign)BOOL isShow;//cell是否展开

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@end

@implementation OnePayComfiredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"确认订单";
    self.submitBtn.layer.cornerRadius = 5.f;
    [self showPrice];
    [self tableViewRegisterCell];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPrice{
    NSMutableAttributedString * priceStr =[[NSMutableAttributedString alloc]initWithString:@"实付款: " attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:15.f]}];
    NSMutableAttributedString * priceApp=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"C$%.2f",[self.number floatValue]] attributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:17.f]}];
    [priceStr appendAttributedString:priceApp];
    self.priceLabel.attributedText = priceStr;
}

- (void)tableViewRegisterCell{
    [self.tableView registerNib:[UINib nibWithNibName:ONECFRCELL bundle:nil] forCellReuseIdentifier:ONECFRCELL];
    [self.tableView registerNib:[UINib nibWithNibName:ONECFRPRICECELL bundle:nil] forCellReuseIdentifier:ONECFRPRICECELL];
}

- (IBAction)submitbtnAction:(id)sender {
    CGFloat price = [self.one floatValue] * [self.number integerValue];
    CGFloat cash = [[UserSession instance].cash floatValue];
    if (cash >= price) {
        //足额
        [self.submitBtn setUserInteractionEnabled:NO];
        [self requestPay];
    }else{
        //不足额,充值
        AccountRechargeViewController * vc=[[AccountRechargeViewController alloc]init];
        vc.num = price - cash + 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)showCellBtnAction{
    self.isShow = !self.isShow;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70.f;
    }
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 44.f;
    }else{
        return 0.0001f;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KScreenWidth, 44.f)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 0.f, 100.f, 44.f)];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
        titleLabel.text = [NSString stringWithFormat:@"共 %@件商品",self.number];
        [headerView addSubview:titleLabel];
        
        UIButton * showCellBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 30.f, 17.f, 10.f, 15.f)];
        [showCellBtn setImage:[UIImage imageNamed:@"ringArr"] forState:UIControlStateNormal];
        showCellBtn.transform = CGAffineTransformRotate(showCellBtn.transform, M_PI_2 * (self.isShow * 2 + 1));
        [showCellBtn addTarget:self action:@selector(showCellBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:showCellBtn];
        
        return headerView;
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
    if (section == 0) {
        return self.isShow;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        OnePayComfiredTableViewCell * comfiredCell = [tableView dequeueReusableCellWithIdentifier:ONECFRCELL];
        comfiredCell.selectionStyle = UITableViewCellSelectionStyleNone;
        comfiredCell.nameLabel.text = self.name;
        comfiredCell.countLabel.text = [NSString stringWithFormat:@"%@人次",self.number];
        return comfiredCell;
    }
    OnePayCfrPriceTableViewCell * cPriceCell = [tableView dequeueReusableCellWithIdentifier:ONECFRPRICECELL];
    cPriceCell.selectionStyle = UITableViewCellSelectionStyleNone;
    cPriceCell.priceLabel.text = [NSString stringWithFormat:@"%.2fC$",[self.number floatValue]];
    return cPriceCell;
}

#pragma mark - HTTP
- (void)requestPay{
    NSDictionary * program = @{@"uid":[UserSession instance].uid,@"num":self.number,@"id":self.idd};
    [[HttpObject manager]getDataWithType:OnePayType_SHOP_PAY withPragram:program success:^(id responsObj) {
        MyLog(@"One Pay is %@",responsObj[@"data"]);
        if (self.isLottery) {
            [self showHUDWithStr:@"Please wait for the lottery" withSuccess:YES];
        }else{
            [self showHUDWithStr:@"Success" withSuccess:YES];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            OneYuanPurchaseViewController * vc = [[OneYuanPurchaseViewController alloc]init];
            [self.submitBtn setUserInteractionEnabled:YES];
            [self.navigationController pushViewController:vc animated:YES];
        });
        
    } failur:^(id errorData, NSError *error) {
        MyLog(@"One Pay Erroe is %@",error);
        MyLog(@"One Pay program is %@",errorData);
        [self.submitBtn setUserInteractionEnabled:YES];
        [self showHUDWithStr:errorData[@"errorMessage"] withSuccess:NO];
    }];
    
}

#pragma mark - MBProgressHUD
- (void)showHUDWithStr:(NSString *)showHud withSuccess:(BOOL)isSuccess{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = showHud;
    hud.dimBackground = YES;
    if (isSuccess) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.7];
}


@end
