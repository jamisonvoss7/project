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
#import "AccountService.h"
#import "AddContactTableViewCell.h"
#import "AddContactTableHeaderView.h"
#import <MessageUI/MessageUI.h>
#import "CNContact+Additions.H"

@interface AddContactsViewController () <MFMessageComposeViewControllerDelegate>
@property (nonatomic) NavbarView *navbarView;
@property (nonatomic) NSArray *availableContacts;
@property (nonatomic) NSArray *addableContacts;
@property (nonatomic) NSArray *invitableContacts;
@property (nonatomic) NSArray *accounts;
@property (nonatomic) NSArray *currentContacts;
@end

@implementation AddContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navbarView = [NavbarView instanceFromDefaultNib];
    self.navbarView.titleLabel.text = @"Add Contacts";
    self.navbarView.leftButton.text = @"Close";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeView:)];
    tap.numberOfTapsRequired = 1;
    [self.navbarView.leftButton addGestureRecognizer:tap];
    
    [self.view addSubview:self.navbarView];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.availableContacts = [[NSArray alloc] init];
    self.addableContacts = [[NSArray alloc] init];
    self.invitableContacts = [[NSArray alloc] init];
    self.accounts = [[NSArray alloc] init];
    [self setupCurrentContacts];
    
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
            self.availableContacts = contacts;
            [self bootStrapData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

- (void)bootStrapData {
    Batch *batch = [Batch create];
    
    NSMutableArray *addableContacts = [[NSMutableArray alloc] initWithCapacity:self.availableContacts.count];
    NSMutableArray *invitableContacts = [[NSMutableArray alloc] initWithCapacity:self.availableContacts.count];
    NSMutableArray *accounts = [[NSMutableArray alloc] initWithCapacity:self.availableContacts.count];
    
    AccountService *service = [[AccountService alloc] init];
    
    for (CNContact *contact in self.availableContacts) {
        if (![self.currentContacts containsObject:[contact phoneNumberString]]) {
            [batch addBatchBlock:^(Batch *batch) {
                [service loadAccountFromPhoneNumber:[contact phoneNumberString]
                                       withComplete:^(Account *account, NSError *error) {
                                           if (account) {
                                               [addableContacts addObject:contact];
                                               [accounts addObject:account];
                                           } else {
                                               [invitableContacts addObject:contact];
                                           }
                                           [batch complete:error];
                                       }];
            }];
        }
    }
        
    [batch executeWithComplete:^(NSError *error) {
        self.addableContacts = addableContacts;
        self.invitableContacts = invitableContacts;
        self.accounts = accounts;
        [self.tableView reloadData];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    AddContactTableHeaderView *view = [AddContactTableHeaderView instanceWithDefaultNib];
    
    if (self.addableContacts.count > 0) {
        if (section == 0) {
            view.textLabel.text = @"Tailgaters";
        } else {
            view.textLabel.text = @"Sally's";
        }
    } else {
        view.textLabel.text = @"Sally's";
    }
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.addableContacts.count > 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.addableContacts.count > 0) {
        if (section == 0) {
            return self.addableContacts.count;
        } else {
            return self.invitableContacts.count;
        }
    } else {
        return self.invitableContacts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addContactCell"];
    if (!cell) {
        cell = [AddContactTableViewCell instanceWithDefaultNib];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CNContact *contact;
    [cell.actionButton setTitle:@"Invite" forState:UIControlStateNormal];
    
    if (self.addableContacts.count > 0) {
        if (indexPath.section == 0) {
            contact = [self.addableContacts objectAtIndex:indexPath.row];
            [cell.actionButton setTitle:@"Add" forState:UIControlStateNormal];
        } else {
            contact = [self.invitableContacts objectAtIndex:indexPath.row];
        }
    } else {
        contact = [self.invitableContacts objectAtIndex:indexPath.row];
    }
  
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.addableContacts.count > 0) {
        if (indexPath.section == 0) {
            [self addContactAtIndexPath:indexPath andTableCell:[tableView cellForRowAtIndexPath:indexPath]];
        } else {
            [self inviteContactAtIndexPath:indexPath adnTableCell:[tableView cellForRowAtIndexPath:indexPath]];
        }
    } else {
        [self inviteContactAtIndexPath:indexPath adnTableCell:[tableView cellForRowAtIndexPath:indexPath]];
    }
}

- (void)closeView:(UITapGestureRecognizer *)sender {
    [self.baseDelegate dismissViewController:self];
}

- (void)addContactAtIndexPath:(NSIndexPath *)indexPath andTableCell:(AddContactTableViewCell *)cell {
    cell.actionButton.userInteractionEnabled = NO;
    
    Account *account = [AppManager sharedInstance].accountManager.profileAccount;
    NSMutableArray *contacts = [NSMutableArray arrayWithArray:account.contacts];
    
    Account *accountToAdd = [self.accounts objectAtIndex:indexPath.row];
    
    Contact *newContact = [[Contact alloc] init];
    newContact.displayName = accountToAdd.displayName;
    newContact.emailAddress = accountToAdd.emailAddress;
    newContact.phoneNumber = accountToAdd.phoneNumber;
    newContact.userName = accountToAdd.userName;
    
    [contacts addObject:newContact];
    account.contacts = contacts;
    
    AccountService *service = [[AccountService alloc] init];
    [service saveAccount:account
            withComplete:^(BOOL success, NSError *error) {
                if (success) {
                    [cell.actionButton setTitle:@"Added" forState:UIControlStateNormal];
                } else {
                    cell.actionButton.userInteractionEnabled = YES;
                }
            }];
}

- (void)inviteContactAtIndexPath:(NSIndexPath *)indexPath adnTableCell:(AddContactTableViewCell *)cell {
    CNContact *contactToInvite = [self.invitableContacts objectAtIndex:indexPath.row];
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Your device doesn't support SMS!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    Account *profile = [AppManager sharedInstance].accountManager.profileAccount;
    
    NSArray *recipents = @[[contactToInvite phoneNumberString]];
    NSString *message = [NSString stringWithFormat:@"%@ wants to you join Tailgate Mate (app store link)", profile.displayName];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed: {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:@"Failed to send SMS!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupCurrentContacts {
    NSArray *contacts = [AppManager sharedInstance].accountManager.profileAccount.contacts;
    NSMutableArray *numbers = [[NSMutableArray alloc] init];
    
    for (Contact *contact in contacts) {
        [numbers addObject:contact.phoneNumber];
    }
    
    self.currentContacts = [NSArray arrayWithArray:numbers];
}

@end
