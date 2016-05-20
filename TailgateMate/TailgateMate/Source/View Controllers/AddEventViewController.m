//
//  AddEventViewController.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AddEventViewController.h"
#import "AddEventDetailsView.h"
#import "AddEventMapView.h"
#import "AddEventSuppliesView.h"
#import "TailgatePartyServiceProvider.h"

@interface AddEventViewController () <UIScrollViewDelegate>
@property (nonatomic) AddEventDetailsView *detailView;
@property (nonatomic) AddEventMapView *mapView;
@property (nonatomic) AddEventSuppliesView *suppliesView;
@property (nonatomic) AddEventSuppliesView *neededSuppliesView;
@property (nonatomic) NSArray *defaultSupplies;
@end

@implementation AddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollview.pagingEnabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 
    CGSize size = self.scrollview.contentSize;
    size.width = self.view.frame.size.width * 4.0f;
    self.scrollview.contentSize = size;
    
    CGRect baseFrame = self.scrollview.bounds;

    self.detailView = [AddEventDetailsView instanceFromDefaultNib];
    self.detailView.frame = baseFrame;
    
    self.mapView = [AddEventMapView instanceFromDefaultNib];
    baseFrame.origin.x = self.view.frame.size.width;
    self.mapView.frame = baseFrame;
    
    self.suppliesView = [AddEventSuppliesView instanceFromDefaultNib];
    baseFrame.origin.x = self.view.frame.size.width * 2;
    self.suppliesView.frame = baseFrame;
    
    self.neededSuppliesView = [AddEventSuppliesView instanceFromDefaultNib];
    baseFrame.origin.x = self.view.frame.size.width * 3;
    self.neededSuppliesView.frame = baseFrame;
    
    [self.scrollview addSubview:self.detailView];
    [self.scrollview addSubview:self.mapView];
    [self.scrollview addSubview:self.suppliesView];
    [self.scrollview addSubview:self.neededSuppliesView];
    
    [self.suppliesView setTailgateSupplies:[self defaultSupplies]];
    [self.neededSuppliesView setTailgateSupplies:[self defaultSupplies]];
    
    self.scrollview.delegate = self;
    
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

- (void)cancel:(UIButton *)sender {
    [self.baseViewControllerDelegate dismissViewController:self];
}

- (void)addEvent:(UIButton *)sender {
    TailgateParty *party = [self buildTailgateParty];
    party.uid = [NSUUID UUID].UUIDString;
    TailgatePartyServiceProvider *service = [[TailgatePartyServiceProvider alloc] init];
    [service addTailgateParty:party
                 withComplete:^(BOOL succcess, NSError *error) {
                     if (succcess) {
                         [self.baseViewControllerDelegate dismissViewController:self];
                     }
                 }];
}

- (void)scrollRight:(UIButton *)sender {
    CGPoint point = self.scrollview.contentOffset;
    point.x = point.x + self.view.frame.size.width;
    [self.scrollview setContentOffset:point animated:YES];
}

- (void)setNavBarStringsForIndex:(NSInteger)index {
    switch (index) {
        case 0:
            self.titleLabel.text = @"Event Details";

            [self.leftButton setTitle:@"Cancel"
                             forState:UIControlStateNormal];
            [self.rightButton setTitle:@"Next"
                              forState:UIControlStateNormal];
            
            [self.leftButton addTarget:self
                                action:@selector(cancel:)
                      forControlEvents:UIControlEventTouchUpInside];
            [self.rightButton addTarget:self
                                 action:@selector(scrollRight:)
                       forControlEvents:UIControlEventTouchUpInside];

            break;
        case 1:
            self.titleLabel.text = @"Event Location";

            [self.leftButton setTitle:@"Cancel"
                             forState:UIControlStateNormal];
            [self.rightButton setTitle:@"Next"
                              forState:UIControlStateNormal];
            
            [self.leftButton addTarget:self
                                action:@selector(cancel:)
                      forControlEvents:UIControlEventTouchUpInside];
            [self.rightButton addTarget:self
                                 action:@selector(scrollRight:)
                       forControlEvents:UIControlEventTouchUpInside];
            break;
        case 2:
            self.titleLabel.text = @"Event Supplies";

            [self.leftButton setTitle:@"Cancel"
                             forState:UIControlStateNormal];
            [self.rightButton setTitle:@"Next"
                              forState:UIControlStateNormal];
            
            [self.leftButton addTarget:self
                                action:@selector(cancel:)
                      forControlEvents:UIControlEventTouchUpInside];
            [self.rightButton addTarget:self
                                 action:@selector(scrollRight:)
                       forControlEvents:UIControlEventTouchUpInside];
            break;
            
        case 3:
            self.titleLabel.text = @"Event Needs";

            [self.leftButton setTitle:@"Cancel"
                             forState:UIControlStateNormal];
            [self.rightButton setTitle:@"Add"
                              forState:UIControlStateNormal];
            
            [self.leftButton addTarget:self
                                action:@selector(cancel:)
                      forControlEvents:UIControlEventTouchUpInside];
            [self.rightButton addTarget:self
                                 action:@selector(addEvent:)
                       forControlEvents:UIControlEventTouchUpInside];

            break;
        default:
            break;
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
    
//    party.supplies = [TailgateSupply dictionaryFromArray:<#(NSArray *)#>]
    
    return party;
}

- (NSArray *)defaultSupplies {
    TailgateSupply *ice = [[TailgateSupply alloc] init];
    ice.name = @"Ice";
    ice.type = SUPPLYTYPE_MISCELLANEOUS;
    
    TailgateSupply *grill = [[TailgateSupply alloc] init];
    grill.name = @"Grill";
    grill.type = SUPPLYTYPE_APPLIANCE;
    
    TailgateSupply *soda = [[TailgateSupply alloc] init];
    soda.name = @"Soda";
    soda.type = SUPPLYTYPE_DRINK;
    
    TailgateSupply *beer = [[TailgateSupply alloc] init];
    beer.name = @"Beer";
    beer.type = SUPPLYTYPE_ALCOHOLIC_DRINK;
    
    TailgateSupply *cups = [[TailgateSupply alloc] init];
    cups.name = @"Cups";
    cups.type = SUPPLYTYPE_UTENSILE;
    
    TailgateSupply *burgers = [[TailgateSupply alloc] init];
    burgers.name = @"Burgers";
    burgers.type = SUPPLYTYPE_FOOD;
    
    TailgateSupply *brats = [[TailgateSupply alloc] init];
    brats.name = @"Brats";
    brats.type = SUPPLYTYPE_FOOD;
    
    TailgateSupply *bags = [[TailgateSupply alloc] init];
    bags.name = @"Bags";
    bags.type = SUPPLYTYPE_GAME;
    
    TailgateSupply *chips = [[TailgateSupply alloc] init];
    chips.name = @"Doritos";
    chips.type = SUPPLYTYPE_SNACK;
    
    TailgateSupply *chairs = [[TailgateSupply alloc] init];
    chairs.name = @"Chairs";
    chairs.type = SUPPLYTYPE_FURNITURE;
    
    return @[ice, grill, soda, beer, cups, burgers, brats, bags, chips, chairs];
}

@end
