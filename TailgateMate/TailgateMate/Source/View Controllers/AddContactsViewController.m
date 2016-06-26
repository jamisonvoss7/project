//
//  AddContactsViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 6/23/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AddContactsViewController.h"
#import <Contacts/Contacts.h>
#import "NavbarView.h"

@interface AddContactsViewController ()
@property (nonatomic) NavbarView *navbarView;
@property (nonatomic) NSArray *contacts;
@end

@implementation AddContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navbarView = [NavbarView instanceFromDefaultNib];
    self.navbarView.titleLabel.text = @"Contacts";
    self.navbarView.leftButton.text = @"Close";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeView:)];
    tap.numberOfTapsRequired = 1;
    [self.navbarView.leftButton addGestureRecognizer:tap];
    
    [self.view addSubview:self.navbarView];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.contacts = [[NSArray alloc] init];
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can use contacts" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:TRUE completion:nil];
        return;
    }
    
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        // make sure the user granted us access
        
        if (!granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // user didn't grant access;
                // so, again, tell user here why app needs permissions in order  to do it's job;
                // this is dispatched to the main queue because this request could be running on background thread
            });
            return;
        }
        
        // build array of contacts
        
        NSMutableArray *contacts = [NSMutableArray array];
        
        NSError *fetchError;
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactIdentifierKey, CNContactPhoneNumbersKey , [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName]]];
        
        BOOL success = [store enumerateContactsWithFetchRequest:request error:&fetchError usingBlock:^(CNContact *contact, BOOL *stop) {
            [contacts addObject:contact];
        }];
        
        if (success) {
            self.contacts = contacts;
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    CNContact *contact = [self.contacts objectAtIndex:indexPath.row];
    cell.textLabel.text = contact.givenName;
    return cell;
}

- (void)closeView:(UITapGestureRecognizer *)sender {
    [self.baseDelegate dismissViewController:self];
}
@end
