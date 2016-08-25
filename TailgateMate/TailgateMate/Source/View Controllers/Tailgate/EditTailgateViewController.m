//
//  EditTailgateViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/23/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "EditTailgateViewController.h"

@implementation EditTailgateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.detailView.titleTextView.text = self.party.name;
    self.detailView.lotNumberTextView.text = self.party.parkingLot.lotName;
    self.detailView.startDate = self.party.startDate;
    self.detailView.endDate = self.party.endDate;
   
    self.detailView.startDateField.text = [self.detailView.dateFormatter stringFromDate:self.party.startDate];
    self.detailView.endDateField.text = [self.detailView.dateFormatter stringFromDate:self.party.endDate];
    
    self.detailView.descriptionTextView.text = self.party.details;
    
    if (self.party.fanType == TAILGATEPARTYFANTYPE_HOME) {
        [self.detailView.teamSegmentControl setSelectedSegmentIndex:0];
    } else if (self.party.fanType == TAILGATEPARTYFANTYPE_AWAY) {
        [self.detailView.teamSegmentControl setSelectedSegmentIndex:1];
    } else{
        [self.detailView.teamSegmentControl setSelectedSegmentIndex:2];
    }
    
    if (self.party.type == TAILGATEPARTYTYPE_PRIVATE) {
        [self.detailView.availabilitySegmentControl setSelectedSegmentIndex:0];
    } else {
        [self.detailView.availabilitySegmentControl setSelectedSegmentIndex:1];
    }
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.party.parkingLot.location.lat.doubleValue
                                                      longitude:self.party.parkingLot.location.lon.doubleValue];
    
    self.mapView.initialLocationToUse = location;
    self.invitesView.invitees = [[NSMutableArray alloc] initWithArray:self.party.guests];
}

- (void)saveTailgate {
    TailgateParty *party = [self buildTailgateParty];
    
    if (party.name.length == 0) {
        [self showToast:@"Make sure to name your tailgate"];
        return;
    }
    if (party.startDate == nil) {
        [self showToast:@"Make sure to set a start time for your tailgate"];
        return;
    }
    if (party.endDate == nil) {
        [self showToast:@"Make sure to set an end time for your tailgate"];
        return;
    }
    if (!party.parkingLot.location.lat &&
        !party.parkingLot.location.lon) {
        [self showToast:@"Make sure to set a location for your tailgate"];
        return;
    }
    
    [self.view showActivityIndicatorWithCurtain:YES];
    
    party.uid = self.party.uid;
    
    TailgatePartyServiceProvider *service = [[TailgatePartyServiceProvider alloc] init];
    [service updateTailgatePartyFull:party
                        withComplete:^(BOOL succcess, NSError *error) {
                            [self.view hideActivityIndicator];
                            if (succcess) {
                                [self.baseDelegate dismissViewController:self];
                            } else {
                                [self showErrorToast:@"A problem occurred while creating your tailgate"];
                            }
                        }];
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

- (void)rightTapHandler:(UITapGestureRecognizer *)tap {
    CGFloat index = self.scrollview.contentOffset.x / self.view.frame.size.width;
    if (index == 2) {
        [self saveTailgate];
    } else {
        [super rightTapHandler:tap];
    }
}

@end
