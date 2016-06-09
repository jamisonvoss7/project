//
//  EventViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 5/4/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "EventViewController.h"
#import "TailgateSupplySlider.h"
#import "Navbar.h"

@interface EventViewController ()
@property (nonatomic) TailgateParty *tailgateParty;
@property (nonatomic) TailgateSupplySlider *havesSlider;
@property (nonatomic) TailgateSupplySlider *needsSlider;
@property (nonatomic) Navbar *navbar;
@end

@implementation EventViewController

- (id)initWithEvent:(TailgateParty *)tailgateParty {
    self = [super initWithNibName:@"EventViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _tailgateParty = tailgateParty;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navbar = [Navbar instanceFromDefaultNib];
    CGRect frame = self.navbar.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.navbar.frame = frame;
    
    [self.view addSubview:self.navbar];
    
    [self.navbar.rightButton setTitle:@"Close" forState:UIControlStateNormal];
    self.navbar.leftButton.hidden = YES;
    self.navbar.titleLabel.text = self.tailgateParty.name;
    
    [self.navbar.rightButton addTarget:self
                                action:@selector(close:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    
    self.titleLabel.text = self.tailgateParty.name;
    self.lotNumberLabel.text = self.tailgateParty.parkingLot.lotName;
    
    self.havesSlider = [TailgateSupplySlider instanceWitDefaultNib];
    self.needsSlider = [TailgateSupplySlider instanceWitDefaultNib];
 
    self.havesSlider.bounds = self.havesContainer.bounds;
    [self.havesContainer addSubview:self.havesSlider];
    
    self.needsSlider.bounds = self.needsContainer.bounds;
    [self.needsContainer addSubview:self.needsSlider];
    
    [self.havesSlider setSupplies:self.tailgateParty.supplies];
    [self.needsSlider setSupplies:self.tailgateParty.needs];
}

- (void)close:(UIButton *)sender {
    [self.baseViewControllerDelegate dismissViewController:self];
}


@end
