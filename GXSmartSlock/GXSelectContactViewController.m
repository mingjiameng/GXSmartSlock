//
//  GXSelectContactViewController.m
//  GXSmartSlock
//
//  Created by zkey on 8/30/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXSelectContactViewController.h"

#import <AddressBook/AddressBook.h>

@interface GXSelectContactViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) ABAddressBookRef addressBook;
@property (nonatomic, strong) NSArray *contactArray;

@end

@implementation GXSelectContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something...
    
    
}

- (void)checkAddressBookAuthorizedStatus:(CGRect)frame
{
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if (authStatus != kABAuthorizationStatusAuthorized) {
        
        ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
            if (error != nil) {
                NSLog(@"fetch address book error:%@", (__bridge NSError *)error );
                return;
            }
            
            if (!granted) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法访问通讯录" message:@"请您在授权91分红访问通讯录，否则无法从通讯录中批量导入用户名" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
            ABAddressBookRevert(_addressBook);
            
        });
    }
    
    ABAddressBookRevert(_addressBook);
    
}

- (void)addContactTableView:(CGRect)frame
{
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}
@end
