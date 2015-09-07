//
//  GXSelectContactViewController.m
//  GXSmartSlock
//
//  Created by zkey on 9/6/15.
//  Copyright (c) 2015 guosim. All rights reserved.
//

#import "GXSelectContactViewController.h"

#import <AddressBook/AddressBook.h>

#import "GXContactModel.h"

@interface GXSelectContactViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_contanctArray;
    
}
@end

@implementation GXSelectContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // do something...
    
    
}

- (void)configNavigationBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAddUser)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAddUser)];
}


- (void)requestContactAuthority
{
    ABAddressBookRef addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
    
    //获取通讯录权限
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    // 循环获取联系人中的信息
    for (NSInteger i = 0; i < CFArrayGetCount(allPeople); ++i) {
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        NSString *firstName = (__bridge NSString*) ABRecordCopyValue(person, kABPersonFirstNameProperty);
        if (firstName == nil) {
            firstName = @"";
        } else {
            
        }
        firstName = [firstName stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
}

- (void)addUserListTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - tabel  view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contanctArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contact"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contact"];
    }
    
    GXContactModel *contactModel = [_contanctArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = contactModel.nickname;
    
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selected) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selected = NO;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.selected = YES;
    }
}

#pragma mark - user action
- (void)cancelAddUser
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)doneAddUser
{
    NSMutableArray *selectedUserArray = [NSMutableArray array];
    
    for (NSInteger indexRow = 0; indexRow < _contanctArray.count; ++indexRow) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexRow inSection:0];
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        if (cell.selected) {
            [selectedUserArray addObject:[_contanctArray objectAtIndex:indexRow]];
        }
    }
    
    if (self.addUser) {
        self.addUser(selectedUserArray);
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
