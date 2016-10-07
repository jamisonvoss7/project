//
//  AddContactsViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 6/23/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AddContactsView.h"
#import <Contacts/Contacts.h>
#import "NavbarView.h"
#import "AccountService.h"
#import "AddContactTableViewCell.h"
#import "AddContactTableHeaderView.h"
#import <MessageUI/MessageUI.h>
#import "CNContact+Additions.H"

NSString * const kAppLink = @"https://itunes.apple.com/us/app/pregame!/id1143855430?mt=8";

@interface AddContactsView () <MFMessageComposeViewControllerDelegate>
@property (nonatomic) NavbarView *navbarView;
@property (nonatomic) NSArray *availableContacts;
@property (nonatomic) NSArray *addableContacts;
@property (nonatomic) NSArray *invitableContacts;
@property (nonatomic) NSMutableDictionary *accountsDict;
@property (nonatomic) NSArray *currentContacts;
@property (nonatomic, copy) void (^dismissHandler)();
@end

@implementation AddContactsView

+ (instancetype)instanceWithDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"AddContactsView"
                                bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)dismissHandler:(void (^)(void))handler {
    if (handler) {
        self.dismissHandler = handler;
    }
}

- (void)becomesVisible {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navbarView = [NavbarView instanceFromDefaultNib];
    self.navbarView.titleLabel.text = @"Add Contacts";
    self.navbarView.leftButton.text = @"Done";
    self.navbarView.rightButton.text = @"Add all";
    
    CGRect frame = self.navbarView.frame;
    frame.size.width = self.frame.size.width;
    self.navbarView.frame = frame;
    
    UITapGestureRecognizer *addAllTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(addAllAvailableContacts:)];
    addAllTap.numberOfTapsRequired = 1;
    [self.navbarView.rightButton addGestureRecognizer:addAllTap];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(closeView:)];
    tap.numberOfTapsRequired = 1;
    [self.navbarView.leftButton addGestureRecognizer:tap];
    
    [self addSubview:self.navbarView];
    
    frame = self.tableView.frame;
    frame.size.height = frame.size.height - self.navbarView.frame.size.height;
    frame.origin.y = self.navbarView.frame.size.height;
    self.tableView.frame = frame;

    self.availableContacts = [[NSArray alloc] init];
    self.addableContacts = [[NSArray alloc] init];
    self.invitableContacts = [[NSArray alloc] init];
    self.accountsDict = [[NSMutableDictionary alloc] init];
  
    [self setupCurrentContacts];
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can use contacts" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self.flowDelegate presentAViewController:alert];
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
        }
    }];
}

- (void)setFlowDelegate:(id<AccountFlowDelegate>)flowDelegate {
    _flowDelegate = flowDelegate;
}

- (void)bootStrapData {
    [self showActivityIndicatorWithCurtain:YES];
    
    Batch *batch = [Batch create];
    
    NSMutableArray *addableContacts = [[NSMutableArray alloc] initWithCapacity:self.availableContacts.count];
    NSMutableArray *invitableContacts = [[NSMutableArray alloc] initWithCapacity:self.availableContacts.count];
    NSMutableDictionary *accounts = [[NSMutableDictionary alloc] initWithCapacity:self.availableContacts.count];
    
    AccountService *service = [[AccountService alloc] init];
    
    for (CNContact *contact in self.availableContacts) {
        if (![self.currentContacts containsObject:[contact phoneNumberString]] &&
            [contact phoneNumberString].length > 0 &&
            ![[contact phoneNumberString] isEqualToString:[AppManager sharedInstance].accountManager.profileAccount.phoneNumber]) {
       
            [batch addBatchBlock:^(Batch *batch) {
                [service loadAccountFromPhoneNumber:[contact phoneNumberString]
                                       withComplete:^(Account *account, NSError *error) {
                                           if (account) {
                                               [addableContacts addObject:contact];
                                               [accounts setObject:account forKey:contact];
                                           } else {
                                               [invitableContacts addObject:contact];
                                           }
                                           [batch complete:error];
                                       }];
            }];
        }
    }
        
    [batch executeWithComplete:^(NSError *error) {
        self.addableContacts = [addableContacts sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            CNContact *contact1 = (CNContact *)obj1;
            CNContact *contact2 = (CNContact *)obj2;
            
            NSString *firstName1 = contact1.givenName.length > 0 ? contact1.givenName : contact1.middleName;
            NSString *firstName2 = contact2.givenName.length > 0 ? contact2.givenName : contact2.middleName;
          
            if (firstName1.length == 0 && contact1.organizationName.length > 0) {
                firstName1 = contact1.organizationName;
            }
         
            if (firstName2.length == 0 && contact2.organizationName.length > 0) {
                firstName2 = contact2.organizationName;
            }
            
            if ([firstName1 isEqualToString:firstName2]) {
                return [contact1.familyName compare:contact2.familyName];
            } else {
                return [firstName1 compare:firstName2];
            }
        }];
       
        self.invitableContacts = [invitableContacts sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            CNContact *contact1 = (CNContact *)obj1;
            CNContact *contact2 = (CNContact *)obj2;
            
            NSString *firstName1 = contact1.givenName.length > 0 ? contact1.givenName : contact1.middleName;
            NSString *firstName2 = contact2.givenName.length > 0 ? contact2.givenName : contact2.middleName;
            
            if (firstName1.length == 0 && contact1.organizationName.length > 0) {
                firstName1 = contact1.organizationName;
            }
            
            if (firstName2.length == 0 && contact2.organizationName.length > 0) {
                firstName2 = contact2.organizationName;
            }
            
            if ([firstName1 isEqualToString:firstName2]) {
                return [contact1.familyName compare:contact2.familyName];
            } else {
                return [firstName1 compare:firstName2];
            }
        }];;
        
        self.accountsDict = accounts;
        
        [self hideActivityIndicator];
        
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
            view.textLabel.text = @"Invite";
        }
    } else {
        view.textLabel.text = @"Invite";
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
    cell.actionLabel.text = @"Invite";
     
    if (self.addableContacts.count > 0) {
        if (indexPath.section == 0) {
            contact = [self.addableContacts objectAtIndex:indexPath.row];
            if ([self.currentContacts containsObject:[contact phoneNumberString]]) {
                cell.actionLabel.text = @"Added";
            } else {
                cell.actionLabel.text = @"Add";
            }
        } else {
            contact = [self.invitableContacts objectAtIndex:indexPath.row];
        }
    } else {
        contact = [self.invitableContacts objectAtIndex:indexPath.row];
    }
  
    NSString *firstName1 = contact.givenName.length > 0 ? contact.givenName : contact.middleName;
    
    if (firstName1.length == 0 && contact.organizationName.length > 0) {
        firstName1 = contact.organizationName;
    }
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName1, contact.familyName];

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
    if (self.dismissHandler) {
        self.dismissHandler();
    }
    [self.flowDelegate showNextFlowStep:FlowStepDone withObject:nil];
}

- (void)addContactAtIndexPath:(NSIndexPath *)indexPath andTableCell:(AddContactTableViewCell *)cell {
    Account *account = [AppManager sharedInstance].accountManager.profileAccount;
    NSMutableArray *contacts = [NSMutableArray arrayWithArray:account.contacts];
   
    CNContact *cnContact = [self.addableContacts objectAtIndex:indexPath.row];
    if ([self.currentContacts containsObject:[cnContact phoneNumberString]]) {
        return;
    }
    
    Account *accountToAdd = [self.accountsDict objectForKey:cnContact];
    
    Contact *newContact = [[Contact alloc] init];
    newContact.displayName = accountToAdd.displayName;
    newContact.emailAddress = accountToAdd.emailAddress;
    newContact.phoneNumber = accountToAdd.phoneNumber;
    newContact.userName = accountToAdd.userName;
    newContact.imageId = accountToAdd.photoId;
    newContact.imageURL = accountToAdd.photoUrl;
    
    [contacts addObject:newContact];
    account.contacts = contacts;
    
    AccountService *service = [[AccountService alloc] init];
    [service saveAccount:account
            withComplete:^(BOOL success, NSError *error) {
                if (success) {
                    NSMutableArray *update = [[NSMutableArray alloc] initWithArray:self.currentContacts];
                    [update addObject:newContact.phoneNumber];
                    self.currentContacts = [NSArray arrayWithArray:update];
                    cell.actionLabel.text = @"Added";
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
        if (self.flowDelegate) {
            [self.flowDelegate presentAViewController:alert];
        } else {
            [self.addContactsVCDelegate presentAViewController:alert];
        }
        return;
    }
    
    Account *profile = [AppManager sharedInstance].accountManager.profileAccount;
    
    NSArray *recipents = @[[contactToInvite phoneNumberString]];
    NSString *message = [NSString stringWithFormat:@"%@ wants to you join Pregame! %@ ", profile.displayName, kAppLink];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    if (self.flowDelegate) {
        [self.flowDelegate presentAViewController:messageController];
    } else {
        [self.addContactsVCDelegate presentAViewController:messageController];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    switch (result) {
        case MessageComposeResultCancelled:
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
            
        case MessageComposeResultFailed: {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:@"Failed to send SMS!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self.flowDelegate presentAViewController:alert];
            break;
        }
            
        case MessageComposeResultSent:
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
            
        default:
            break;
    }
}

- (void)setupCurrentContacts {
    NSArray *contacts = [AppManager sharedInstance].accountManager.profileAccount.contacts;
    NSMutableArray *numbers = [[NSMutableArray alloc] init];
    
    for (Contact *contact in contacts) {
        if (contact.phoneNumber.length > 0) {
            [numbers addObject:contact.phoneNumber];
        }
    }
    
    self.currentContacts = [NSArray arrayWithArray:numbers];
}

- (void)addAllAvailableContacts:(UITapGestureRecognizer *)sender {
    if (self.addableContacts.count <= 0) {
        return;
    }
    
    Account *account = [AppManager sharedInstance].accountManager.profileAccount;
    NSMutableArray *newContacts = [[NSMutableArray alloc] init];

    for (CNContact *cnContact in self.addableContacts) {
        if ([self.currentContacts containsObject:[cnContact phoneNumberString]]) {
            break;
        }
    
        Account *accountToAdd = [self.accountsDict objectForKey:cnContact];
    
        Contact *newContact = [[Contact alloc] init];
        newContact.displayName = accountToAdd.displayName;
        newContact.emailAddress = accountToAdd.emailAddress;
        newContact.phoneNumber = accountToAdd.phoneNumber;
        newContact.userName = accountToAdd.userName;
        newContact.imageId = accountToAdd.photoId;
        newContact.imageURL = accountToAdd.photoUrl;
    
        [newContacts addObject:newContact];
    }
   
    if (newContacts.count > 0) {
        NSMutableArray *contacts = [NSMutableArray arrayWithArray:account.contacts];
        [contacts addObjectsFromArray:newContacts];
        account.contacts = contacts;
        
        [self showActivityIndicatorWithCurtain:YES];
        
        AccountService *service = [[AccountService alloc] init];
        [service saveAccount:account
                withComplete:^(BOOL success, NSError *error) {
                    [self hideActivityIndicator];
                    if (success) {
                        NSMutableArray *update = [[NSMutableArray alloc] initWithArray:self.currentContacts];
                        for (Contact *contact in newContacts) {
                            [update addObject:contact.phoneNumber];
                        }
                        self.currentContacts = [NSArray arrayWithArray:update];
                        [self.tableView reloadData];
                    }
                }];
    }
}
@end
