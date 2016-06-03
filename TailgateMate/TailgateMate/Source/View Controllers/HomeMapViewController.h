//
//  ViewController.h
//
//  Copyright © 2015 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapbox/Mapbox.h>

#import "BaseViewControllerDelegate.h"

@interface HomeMapViewController : UIViewController <MGLMapViewDelegate>

@property (nonatomic, weak) id<BaseViewControllerDelegate> baseViewControllerDelegate;

@property (nonatomic, weak) IBOutlet MGLMapView *mapView;

@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UIButton *searchButton;
@property (nonatomic, weak) IBOutlet UIButton *addButton;
@property (nonatomic, weak) IBOutlet UIButton *filterButton;

@end

