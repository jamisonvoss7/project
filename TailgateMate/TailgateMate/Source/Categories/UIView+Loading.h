//
//  UIView+Loading.h
//  TailgateMate
//
//  Created by Jamison Voss on 8/18/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Loading)

- (void)showActivityIndicator;

- (void)showActivityIndicatorWithCurtain:(BOOL)curtain;

- (void)showActivityIndicatorWithCurtain:(BOOL)curtain
                              atPosition:(CGPoint)position;

- (void)showActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style
                           withCurtain:(BOOL)curtain;

- (void)showActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style
                           withCurtain:(BOOL)curtain
                            atPosition:(CGPoint)position;

- (void)showActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style
                                 color:(UIColor *)color
                           withCurtain:(BOOL)curtain
                            atPosition:(CGPoint)position;

- (void)hideActivityIndicator;

@end
