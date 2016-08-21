//
//  AddTailgateViewController.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AddTailgateViewController.h"
#import "AddTailgateDetailsView.h"
#import "AddTailgateMapView.h"
//#import "AddTailgateSuppliesView.h"
#import "AddTailgateInvitesView.h"

#import "TailgatePartyServiceProvider.h"
#import "NavbarView.h"

@interface AddTailgateViewController () <UIScrollViewDelegate>
@property (nonatomic) AddTailgateDetailsView *detailView;
@property (nonatomic) AddTailgateMapView *mapView;
//@property (nonatomic) AddTailgateSuppliesView *suppliesView;
//@property (nonatomic) AddTailgateSuppliesView *neededSuppliesView;
@property (nonatomic) AddTailgateInvitesView *invitesView;
@property (nonatomic) NSArray *defaultSupplies;
@property (nonatomic) NavbarView *navbar;
@end

@implementation AddTailgateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollview.pagingEnabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 
    CGSize size = self.scrollview.contentSize;
    size.width = self.view.frame.size.width * 3.0f;
    self.scrollview.contentSize = size;
    
    CGRect baseFrame = self.scrollview.bounds;

    self.detailView = [AddTailgateDetailsView instanceFromDefaultNib];
    self.detailView.frame = baseFrame;
    
    self.mapView = [AddTailgateMapView instanceFromDefaultNib];
    baseFrame.origin.x = self.view.frame.size.width;
    self.mapView.frame = baseFrame;
    
//    self.suppliesView = [AddTailgateSuppliesView instanceFromDefaultNib];
//    baseFrame.origin.x = self.view.frame.size.width * 2;
//    self.suppliesView.frame = baseFrame;
//    
//    self.neededSuppliesView = [AddTailgateSuppliesView instanceFromDefaultNib];
//    baseFrame.origin.x = self.view.frame.size.width * 3;
//    self.neededSuppliesView.frame = baseFrame;
    
    self.invitesView = [AddTailgateInvitesView instanceWithDefaultNib];
    baseFrame.origin.x = self.view.frame.size.width * 2;
    self.invitesView.frame = baseFrame;
    
    [self.scrollview addSubview:self.detailView];
    [self.scrollview addSubview:self.mapView];
//    [self.scrollview addSubview:self.suppliesView];
//    [self.scrollview addSubview:self.neededSuppliesView];
    [self.scrollview addSubview:self.invitesView];
    
//    [self.suppliesView setTailgateSupplies:[self defaultSupplies]];
//    [self.neededSuppliesView setTailgateSupplies:[self defaultSupplies]];
    
    self.scrollview.delegate = self;

    self.navbar = [NavbarView instanceFromDefaultNib];
    CGRect frame = self.navbar.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.navbar.frame = frame;
    
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTapHandler:)];
    leftTap.numberOfTapsRequired = 1;
    [self.navbar.leftButton addGestureRecognizer:leftTap];
    
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTapHandler:)];
    rightTap.numberOfTapsRequired = 1;
    [self.navbar.rightButton addGestureRecognizer:rightTap];
    
    [self.view addSubview:self.navbar];
    
    [self setNavBarStringsForIndex:0];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat index = scrollView.contentOffset.x / self.view.frame.size.width;
    [self setNavBarStringsForIndex:index];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    CGFloat index = scrollView.contentOffset.x / self.view.frame.size.width;
    [self setNavBarStringsForIndex:index];
}

- (void)cancel {
    [self.baseDelegate dismissViewController:self];
}

- (void)addTailgate {
    TailgateParty *party = [self buildTailgateParty];
    party.uid = [NSUUID UUID].UUIDString;
    TailgatePartyServiceProvider *service = [[TailgatePartyServiceProvider alloc] init];
    [service addTailgateParty:party
                 withComplete:^(BOOL succcess, NSError *error) {
                     if (succcess) {
                         [self.baseDelegate dismissViewController:self];
                     }
                 }];
}

- (void)scrollRight {
    CGPoint point = self.scrollview.contentOffset;
    point.x = point.x + self.view.frame.size.width;
    [self.scrollview setContentOffset:point animated:YES];
}

- (void)scrollLeft {
    CGPoint point = self.scrollview.contentOffset;
    point.x = point.x - self.view.frame.size.width;
    [self.scrollview setContentOffset:point animated:YES];
}

- (void)setNavBarStringsForIndex:(NSInteger)index {
    if (index == 0) {
        self.navbar.leftButton.text = @"Cancle";
        self.navbar.rightButton.text = @"Next";
        self.navbar.titleLabel.text = @"Tailgate Details";
    } else if (index == 1) {
        [self.detailView closeKeyboard];
        self.navbar.leftButton.text = @"Back";
        self.navbar.rightButton.text = @"Next";
        self.navbar.titleLabel.text = @"Tailgate Location";
    } else {
        self.navbar.leftButton.text = @"Back";
        self.navbar.rightButton.text = @"Add";
        self.navbar.titleLabel.text = @"Invite Friends";
    }
}

- (TailgateParty *)buildTailgateParty {
    TailgateParty *party = [[TailgateParty alloc] init];
    
    party.name = self.detailView.titleTextView.text;
    party.details = self.detailView.descriptionTextView.text;

    party.parkingLot = [[ParkingLot alloc] init];
    party.parkingLot.lotName = [NSString stringWithFormat:@"%@", self.detailView.lotNumberTextView.text];
    Location *location = [[Location alloc] init];
    location.lat = [NSNumber numberWithDouble:self.mapView.mapview.centerCoordinate.latitude];
    location.lon = [NSNumber numberWithDouble:self.mapView.mapview.centerCoordinate.longitude];
    party.parkingLot.location = location;
    
//    party.supplies = self.suppliesView.selectedSupplies;
//    party.needs = self.neededSuppliesView.selectedSupplies;
    party.guests = self.invitesView.invitees;
    
    party.hostUserName = [AppManager sharedInstance].accountManager.profileAccount.userName;
    
    TimelineItem *firstItem = [[TimelineItem alloc] init];
    firstItem.userDisplayName = [AppManager sharedInstance].accountManager.profileAccount.displayName;
    firstItem.type = TIMELINEITEMTYPE_CREATION;
    firstItem.message = [NSString stringWithFormat:@"%@ created this tailgate!", [AppManager sharedInstance].accountManager.profileAccount.displayName];
    
    firstItem.tiemStamp = [NSDate date];
    
    party.timeline = [NSArray arrayWithObject:firstItem];
    
    party.startDate = self.detailView.startDate;
    party.endDate = self.detailView.endDate;
    switch (self.detailView.teamSegmentControl.selectedSegmentIndex) {
        case 0:
            party.fanType = TAILGATEPARTYFANTYPE_HOME;
            break;
        case 1:
            party.fanType = TAILGATEPARTYFANTYPE_AWAY;
            break;
            
        default:
            party.fanType = TAILGATEPARTYFANTYPE_BOTH;
            break;
    }

    party.type = self.detailView.availabilitySegmentControl.selectedSegmentIndex == 0 ? TAILGATEPARTYTYPE_PRIVATE : TAILGATEPARTYTYPE_PUBLIC;
    
    return party;
}

- (void)leftTapHandler:(UITapGestureRecognizer *)tap {
    CGFloat index = self.scrollview.contentOffset.x / self.view.frame.size.width;
    if (index == 0) {
        [self cancel];
    } else {
        [self scrollLeft];
    }
}

- (void)rightTapHandler:(UITapGestureRecognizer *)tap {
    CGFloat index = self.scrollview.contentOffset.x / self.view.frame.size.width;
    if (index == 2) {
        [self addTailgate];
    } else {
        [self scrollRight];
    }
}


@end