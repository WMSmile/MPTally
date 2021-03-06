//
//  MPWalletTableViewController.m
//  MPTally
//
//  Created by Maple on 2017/3/4.
//  Copyright © 2017年 Maple. All rights reserved.
//

#import "MPAccountTableViewController.h"
#import "MPAccountTableViewCell.h"
#import "MPAccountBalanceHeaderView.h"
#import "MPAccountManager.h"
#import "MPAccountAddView.h"
#import "MPCreateAccountViewController.h"
#import "MPAccountDetailViewController.h"

#define kRowHeight 60
#define kWalletAddViewH 50

@interface MPAccountTableViewController ()

/// 余额Header
@property (nonatomic, strong) MPAccountBalanceHeaderView *balanceHeaderView;
/// 模型数组
@property (nonatomic, strong) RLMResults *accountArray;
/// 添加视图
@property (nonatomic, strong) MPAccountAddView *addView;
/// 通知token
@property (nonatomic, strong) RLMNotificationToken *token;

@end

@implementation MPAccountTableViewController

static NSString *WalletCellID = @"WalletCellID";

- (instancetype)init
{
  return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = colorWithRGB(245, 245, 245);
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(MPAccountTableViewCell.class) bundle:nil] forCellReuseIdentifier:WalletCellID];
  self.tableView.rowHeight = kRowHeight;
  self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
  __weak typeof(self) weakSelf = self;
  self.token = [self.accountArray addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
      _accountArray = nil;
    [weakSelf.tableView reloadData];
  }];
}

/// 跳转至创建钱包的视图
- (void)pushCreateWallerVC
{
  MPCreateAccountViewController *vc = [[MPCreateAccountViewController alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accountArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WalletCellID forIndexPath:indexPath];
  cell.account = self.accountArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  return self.balanceHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return kRowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
  return self.addView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return kWalletAddViewH;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  MPAccountDetailViewController *vc = [[MPAccountDetailViewController alloc] init];
  vc.accountModel = self.accountArray[indexPath.row];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - get
- (MPAccountAddView *)addView
{
  if(_addView == nil)
  {
    _addView = [MPAccountAddView viewFromNib];
    __weak typeof(self) weakSelf = self;
    [_addView setClickBlock:^{
      [weakSelf pushCreateWallerVC];
    }];
  }
  return _addView;
}
- (RLMResults *)accountArray
{
  if(_accountArray == nil)
  {
    _accountArray = [[MPAccountManager shareManager] getAccountList];
  }
  return _accountArray;
}

- (MPAccountBalanceHeaderView *)balanceHeaderView
{
  if(_balanceHeaderView == nil)
  {
    _balanceHeaderView = [MPAccountBalanceHeaderView viewFromNib];
  }
  return _balanceHeaderView;
}

@end
