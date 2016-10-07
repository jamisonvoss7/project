//
//  TailgatePartyViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/11/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TailgatePartyViewController.h"
#import "TailgatePartyInfoViewController.h"
#import "TailgatePartyTimeLineViewController.h"
#import "EditTailgateViewController.h"
#import "TailgatePartyServiceProvider.h"
#import "ContactsViewControler.h"

@interface TailgatePartyViewController () <TabPagerDataSource, TabPagerDelegate>
@property (nonatomic) TailgateParty *tailgateParty;
@property (nonatomic) TailgatePartyInfoViewController *infoViewController;
@property (nonatomic) TailgatePartyTimeLineViewController *timelineViewController;
@property (nonatomic) ContactsViewControler *contactsViewController;
@end

@implementation TailgatePartyViewController

- (id)initWIthTailgateParty:(TailgateParty *)tailgateParty {
    self = [super init];
    if (self) {
        _tailgateParty = tailgateParty;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(goBack)];
    self.title = self.tailgateParty.name;
    
    if (![self.tailgateParty.hostUserName isEqualToString:[AppManager sharedInstance].accountManager.profileAccount.userName]) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(editParty)];
    }

    self.infoViewController = [[TailgatePartyInfoViewController alloc] initWithTailgate:self.tailgateParty];
    self.timelineViewController = [[TailgatePartyTimeLineViewController alloc] initWithTailgateParty:self.tailgateParty];
   
    if (self.tailgateParty.guests.count > 0) {
        self.contactsViewController = [[ContactsViewControler alloc] initWithContactList:self.tailgateParty.guests isSubpage:YES];
    }
    
    [self reloadData];
}

- (NSInteger)numberOfViewControllers {
    if (self.tailgateParty.guests.count > 0) {
        return 3;
    } else {
        return 2;
    }
}

- (UIViewController *)viewControllerForIndex:(NSInteger)index {
    if (index == 0) {
        return self.infoViewController;
    } else if (index == 1) {
        return self.timelineViewController;
    } else {
        return self.contactsViewController;
    }
}

- (UIColor *)tabBackgroundColor {
    return [UIColor whiteColor];
}

- (UIColor *)tabColor {
    return [UIColor blackColor];
}

- (NSString *)titleForTabAtIndex:(NSInteger)index {
    if (index == 0) {
        return @"Info";
    } else if (index == 1) {
        return @"Timeline";
    } else {
        return @"Guests";
    }
}

- (void)goBack {
    [self.baseDelegate dismissViewController:self];
}

- (void)editParty {
    EditTailgateViewController *vc = [[EditTailgateViewController alloc] init];
    vc.party = self.tailgateParty;

    [self presentViewController:vc animated:YES completion:nil];
}


@end
