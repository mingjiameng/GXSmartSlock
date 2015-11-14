//
//  GXSelectOrEnterUserNameViewController.m
//  GXSmartSlock
//
//  Created by zkey on 11/9/15.
//  Copyright © 2015 guosim. All rights reserved.
//

#import "GXSelectOrEnterUserNameViewController.h"

#import "GXContactModel.h"

#import <AddressBook/AddressBook.h>


@interface GXSelectOrEnterUserNameViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong, nonnull) UITableView *contactTableView;
@property (nonatomic, strong, nonnull) UISearchBar *contactSearchBar;
@property (nonatomic, strong, nullable) NSArray *contactArray;

@end




@implementation GXSelectOrEnterUserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
}


#pragma mark - costume getter
- (UITableView *)contactTableView
{
    if (!_contactTableView) {
        _contactTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
            
            [tableView setTableHeaderView:self.contactSearchBar];
            
            tableView.dataSource = self;
            tableView.delegate = self;
            
            tableView;
        });
    }
    
    return _contactTableView;
}

- (UISearchBar *)contactSearchBar
{
    if (!_contactSearchBar) {
        _contactSearchBar = ({
            UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
            
            searchBar.placeholder = @"搜索联系人或输入对方用户名";
            searchBar.barStyle = UIBarStyleDefault;
            searchBar.delegate = self;
            
            searchBar;
        });
    }
    
    return _contactSearchBar;
}

- (NSArray *)contactArray
{
    if (_contactArray) {
        return _contactArray;
    }
    
    ABAddressBookRef addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
    
    //获取通讯录权限
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    NSMutableArray *contactArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < CFArrayGetCount(allPeople); ++i) {
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        
        NSString *firstName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        if (firstName == nil) {
            firstName = @"";
        } else {
            firstName = [firstName stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        if (lastName == nil) {
            lastName = @"";
        } else {
            lastName = [lastName stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        
        NSString *userNickname= [lastName stringByAppendingString:firstName];
        
        ABMultiValueRef phoneArray = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (CFIndex index = 0; index < ABMultiValueGetCount(phoneArray); ++index) {
            NSString *phoneNumber = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneArray, index);
            if (phoneNumber != nil) {
                phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
                phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
                phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                
                GXContactModel *contactModel = [GXContactModel modelWithUserName:phoneNumber nickname:userNickname];
                [contactArr addObject:contactModel];
            }
        }
        
        ABMultiValueRef emailArray = ABRecordCopyValue(person, kABPersonEmailProperty);
        for (CFIndex index = 0; index < ABMultiValueGetCount(emailArray); ++index) {
            NSString *emailAddress = (__bridge NSString *)ABMultiValueCopyValueAtIndex(emailArray, index);
            if (emailAddress != nil) {
                GXContactModel *contactModel = [GXContactModel modelWithUserName:emailAddress nickname:userNickname];
                [contactArr addObject:contactModel];
            }
        }
    }
    
    for (NSInteger index = 0; index < contactArr.count; ++index) {
        GXContactModel *contactModel = [contactArr objectAtIndex:index];
        
        contactModel.tag = index;
        contactModel.selected = NO;
    }
    
    _contactArray = (NSArray *)contactArr;
    
    return _contactArray;
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
