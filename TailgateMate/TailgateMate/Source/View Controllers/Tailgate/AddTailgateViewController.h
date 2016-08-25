//
//  AddTailgateViewController.h
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AddTailgateDetailsView.h"
#import "AddTailgateMapView.h"
#import "AddTailgateInvitesView.h"
#import "NavbarView.h"
#import "TailgatePartyServiceProvider.h"

@interface AddTailgateViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollview;

@property (nonatomic) AddTailgateDetailsView *detailView;
@property (nonatomic) AddTailgateMapView *mapView;
@property (nonatomic) AddTailgateInvitesView *invitesView;

@property (nonatomic) NavbarView *navbar;

- (void)setNavBarStringsForIndex:(NSInteger)index;
- (void)rightTapHandler:(UITapGestureRecognizer *)tap;
- (TailgateParty *)buildTailgateParty;

@end
