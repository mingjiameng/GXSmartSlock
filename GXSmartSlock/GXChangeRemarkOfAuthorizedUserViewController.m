//
//  GXChangeRemarkOfAuthorizedUserViewController.m
//  GXSmartSlock
//
//  Created by zkey on 9/20/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXChangeRemarkOfAuthorizedUserViewController.h"

#import "MICRO_COMMON.h"


@interface GXChangeRemarkOfAuthorizedUserViewController () <UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *remarkTextField;

@end


@implementation GXChangeRemarkOfAuthorizedUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNavigationBar];
    [self addRemarkTableView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TOP_SPACE_IN_NAVIGATION_MODE)];
}

- (void)configNavigationBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelChangeRemarkName)];
    self.navigationItem.title = @"修改备注";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneChangeRemarkName)];
}

- (void)addRemarkTableView:(CGRect)frame
{
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (_remarkTextField == nil) {
        _remarkTextField = [[UITextField alloc] initWithFrame:CGRectMake(110.0f, 0, tableView.frame.size.width - 110.0f, 30.0f)];
        _remarkTextField.text = self.remarkName;
        _remarkTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _remarkTextField.borderStyle = UITextBorderStyleNone;
        _remarkTextField.delegate = self;
    }
    
    cell.accessoryView = _remarkTextField;
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)cancelChangeRemarkName
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)doneChangeRemarkName
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_remarkTextField becomeFirstResponder];
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
