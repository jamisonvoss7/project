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

@property (nonatomic, weak) IBOutlet UIView *upperLeftView;
@property (nonatomic, weak) IBOutlet UIView *upperRightView;
@property (nonatomic, weak) IBOutlet UIView *lowerLeftView;
@property (nonatomic, weak) IBOutlet UIView *lowerRightView;

@end

