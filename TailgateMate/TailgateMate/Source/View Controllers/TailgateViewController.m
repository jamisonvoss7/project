//
//  TailgateViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 5/4/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "TailgateViewController.h"
#import "TailgateSupplySlider.h"
#import "NavbarView.h"

@interface TailgateViewController ()
@property (nonatomic) TailgateParty *tailgateParty;
@property (nonatomic) TailgateSupplySlider *havesSlider;
@property (nonatomic) TailgateSupplySlider *needsSlider;
@property (nonatomic) NavbarView *navbar;
@end

@implementation TailgateViewController

- (id)initWithTailgate:(TailgateParty *)tailgateParty {
    self = [super initWithNibName:@"TailgateViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _tailgateParty = tailgateParty;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navbar = [NavbarView instanceFromDefaultNib];
    CGRect frame = self.navbar.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.navbar.frame = frame;
    
    [self.view addSubview:self.navbar];
    
    self.navbar.rightButton.text = @"Close";
    self.navbar.leftButton.hidden = YES;
    self.navbar.titleLabel.text = self.tailgateParty.name;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    tap.numberOfTapsRequired = 1;
    [self.navbar.rightButton addGestureRecognizer:tap];
    
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

- (void)goBack {
    [self.baseViewControllerDelegate dismissViewController:self];
}


@end
