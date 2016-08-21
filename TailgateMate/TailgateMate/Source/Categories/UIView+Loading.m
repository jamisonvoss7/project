//
//  UIView+Loading.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/18/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "UIView+Loading.h"
#import <objc/runtime.h>

static char kUIViewPropertyIndicatorViewKey;
static char kUIViewPropertyCurtainViewKey;
static char kUIViewPropertyIndicatorContainerViewKey;

// --------------------------------------------------------------------------------
#pragma mark -
#pragma mark ActivityIndicator Category
// --------------------------------------------------------------------------------

@implementation UIView (Loading)

// --------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Properties
// --------------------------------------------------------------------------------

- (void)setActivityIndicatorView:(UIActivityIndicatorView *)indicatorView {
    objc_setAssociatedObject(self
                             , &kUIViewPropertyIndicatorViewKey
                             , indicatorView
                             , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)activityIndicatorView {
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &kUIViewPropertyIndicatorViewKey);
}

- (void)setActivityCurtainView:(UIView *)curtainView {
    objc_setAssociatedObject(self
                             , &kUIViewPropertyCurtainViewKey
                             , curtainView
                             , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)activityCurtainView {
    return (UIView *)objc_getAssociatedObject(self, &kUIViewPropertyCurtainViewKey);
}

- (void)setActivityIndicatorContainerView:(UIView *)containerView {
    objc_setAssociatedObject(self
                             , &kUIViewPropertyIndicatorContainerViewKey
                             , containerView
                             , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)activityIndicatorContainerView {
    return (UIView *)objc_getAssociatedObject(self, &kUIViewPropertyIndicatorContainerViewKey);
}

// --------------------------------------------------------------------------------
#pragma mark -
#pragma mark Instance Methods
// --------------------------------------------------------------------------------

- (void)showActivityIndicator {
    [self showActivityIndicatorWithCurtain:NO];
}

- (void)showActivityIndicatorWithCurtain:(BOOL)curtain {
    [self showActivityIndicatorWithCurtain:curtain
                                atPosition:CGPointMake(MAXFLOAT, MAXFLOAT)];
}

- (void)showActivityIndicatorWithCurtain:(BOOL)curtain
                              atPosition:(CGPoint)position {
    [self showActivityIndicatorWithStyle:UIActivityIndicatorViewStyleWhite
                             withCurtain:curtain
                              atPosition:position];
}

- (void)showActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style
                           withCurtain:(BOOL)curtain {
    [self showActivityIndicatorWithStyle:style
                             withCurtain:curtain
                              atPosition:CGPointMake(MAXFLOAT, MAXFLOAT)];
}

- (void)showActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style
                           withCurtain:(BOOL)curtain
                            atPosition:(CGPoint)position {
    [self showActivityIndicatorWithStyle:style
                                   color:nil
                             withCurtain:curtain
                              atPosition:position];
}

- (void)showActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style
                                 color:(UIColor *)color
                           withCurtain:(BOOL)curtain
                            atPosition:(CGPoint)position {
    
    if ([self activityIndicatorView]) {
        return;
    }
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    if (color) {
        activityView.color = color;
    }
    
    // The container circle view
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(0.0
                                                                  , 0.0
                                                                  , CGRectGetWidth(activityView.bounds) + 15
                                                                  , CGRectGetHeight(activityView.bounds) + 15)];
    
    circleView.layer.cornerRadius = CGRectGetHeight(circleView.bounds) / 2;
    circleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    activityView.center = circleView.center;
    [circleView addSubview:activityView];
    
    CGPoint (^activityIndicatorCenter)(UIView*) = ^CGPoint (UIView *containerView) {
        if (position.x < MAXFLOAT && position.y < MAXFLOAT) {
            return position;
        }
        CGRect bounds = containerView.bounds;
        return CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    };
    
    // The curtain view that covers up this whole view
    if (curtain) {
        UIView* curtainView = [[UIView alloc] initWithFrame: self.bounds];
        curtainView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        
        circleView.center = activityIndicatorCenter(curtainView);
        [curtainView addSubview:circleView];
        [self addSubview:curtainView];
        
        [self setActivityCurtainView:curtainView];
    } else {
        circleView.center = activityIndicatorCenter(self);
        [self addSubview:circleView];
    }
    [activityView startAnimating];
    
    [self setActivityIndicatorView:activityView];
    [self setActivityIndicatorContainerView:circleView];
}

- (void)hideActivityIndicator {
    __weak typeof(self) this = self;
    
    [UIView animateWithDuration:0.3
                     animations: ^{
                         UIView *containerView = [this activityIndicatorContainerView];
                         containerView.alpha = 0.0;
                         UIView *curtainView = [this activityCurtainView];
                         curtainView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         UIActivityIndicatorView *indicatorView = [this activityIndicatorView];
                         [indicatorView stopAnimating];
                         
                         UIView *containerView = [this activityIndicatorContainerView];
                         [containerView removeFromSuperview];
                         
                         UIView *curtainView = [this activityCurtainView];
                         [curtainView removeFromSuperview];
                         
                         [this setActivityIndicatorView:nil];
                         [this setActivityCurtainView:nil];
                         [this setActivityIndicatorContainerView:nil];
                     }];
}

@end

