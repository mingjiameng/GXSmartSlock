//
//  GXSelectBluetoothPasswordTypeViewController.m
//  GXSmartSlock
//
//  Created by zkey on 10/23/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXSelectBluetoothPasswordTypeViewController.h"

#import "MICRO_COMMON.h"

@interface GXSelectBluetoothPasswordTypeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *passwordTypeTableView;

@end



@implementation GXSelectBluetoothPasswordTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNavigationBar];
}

- (void)configNavigationBar
{
    self.navigationItem.title = @"密码类型";
}

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
        cell.textLabel.text = @"添加临时密码";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"添加常用密码";
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
    } else if (indexPath.row == 1) {
        
    }
}

- (UITableView *)passwordTypeTableView
{
    if (!_passwordTypeTableView) {
        _passwordTypeTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE) style:UITableViewStyleGrouped];
            
            tableView.delegate = self;
            tableView.dataSource = self;
            
            tableView;
        });
    }
    
    return _passwordTypeTableView;
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
