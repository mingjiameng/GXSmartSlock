//
//  GXAddPasswordViewController.m
//  GXSmartSlock
//
//  Created by zkey on 10/23/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXAddPasswordViewController.h"

#import "MICRO_COMMON.h"

#import "GXSelectBluetoothPasswordTypeViewController.h"

@interface GXAddPasswordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, nonnull) UITableView *addedApproachTableView;

@end

@implementation GXAddPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.addedApproachTableView];
}

- (void)configNavigationBar
{
    self.navigationItem.title = @"添加方式";
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"通过蓝牙连接添加";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"通过远程中继器添加";
        if (!self.hasRepeater) {
            cell.userInteractionEnabled = NO;
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        GXSelectBluetoothPasswordTypeViewController *selectPasswordTypeVC = [[GXSelectBluetoothPasswordTypeViewController alloc] init];
        selectPasswordTypeVC.deviceIdentifire = self.deviceIdentifire;
        [self.navigationController pushViewController:selectPasswordTypeVC animated:YES];
        
    } else if (indexPath.row == 1) {

    }
}

- (UITableView *)addedApproachTableView
{
    if (!_addedApproachTableView) {
        _addedApproachTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE) style:UITableViewStyleGrouped];
            
            tableView.delegate = self;
            tableView.dataSource = self;
            
            tableView;
        });
    }
    
    return _addedApproachTableView;
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

@end
