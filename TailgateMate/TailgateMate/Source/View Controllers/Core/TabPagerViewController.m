//
//  GUITabPagerViewController.m
//  GUITabPagerViewController
//
//  Created by Guilherme Araújo on 26/02/15.
//  Copyright (c) 2015 Guilherme Araújo. All rights reserved.
//

#import "TabPagerViewController.h"
#import "TabScrollView.h"

@interface TabPagerViewController () <TabScrollDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) TabScrollView *header;
@property (assign, nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (strong, nonatomic) NSMutableArray *tabTitles;
@property (strong, nonatomic) UIColor *headerColor;
@property (strong, nonatomic) UIColor *tabBackgroundColor;
@property (assign, nonatomic) CGFloat headerHeight;

@end

@implementation TabPagerViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setEdgesForExtendedLayout:UIRectEdgeNone];
  
  [self setPageViewController:[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil]];
  
  for (UIView *view in [[[self pageViewController] view] subviews]) {
    if ([view isKindOfClass:[UIScrollView class]]) {
      [(UIScrollView *)view setCanCancelContentTouches:YES];
      [(UIScrollView *)view setDelaysContentTouches:NO];
    }
  }

  [[self pageViewController] setDataSource:self];
  [[self pageViewController] setDelegate:self];

  [self addChildViewController:self.pageViewController];
  [self.view addSubview:self.pageViewController.view];
  [self.pageViewController didMoveToParentViewController:self];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [self reloadTabs];
}


#pragma mark - Page View Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
  NSUInteger pageIndex = [[self viewControllers] indexOfObject:viewController];
  return pageIndex > 0 ? [self viewControllers][pageIndex - 1]: nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
  NSUInteger pageIndex = [[self viewControllers] indexOfObject:viewController];
  return pageIndex < [[self viewControllers] count] - 1 ? [self viewControllers][pageIndex + 1]: nil;
}

#pragma mark - Page View Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
  NSInteger index = [[self viewControllers] indexOfObject:pendingViewControllers[0]];
  [[self header] animateToTabAtIndex:index];
  
  if ([[self delegate] respondsToSelector:@selector(tabPager:willTransitionToTabAtIndex:)]) {
    [[self delegate] tabPager:self willTransitionToTabAtIndex:index];
  }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
  [self setSelectedIndex:[[self viewControllers] indexOfObject:[[self pageViewController] viewControllers][0]]];
  [[self header] animateToTabAtIndex:[self selectedIndex]];
  
  if ([[self delegate] respondsToSelector:@selector(tabPager:didTransitionToTabAtIndex:)]) {
    [[self delegate] tabPager:self didTransitionToTabAtIndex:[self selectedIndex]];
  }
}

#pragma mark - Tab Scroll View Delegate

- (void)tabScrollView:(TabScrollView *)tabScrollView didSelectTabAtIndex:(NSInteger)index {
  if (index != [self selectedIndex]) {
    if ([[self delegate] respondsToSelector:@selector(tabPager:willTransitionToTabAtIndex:)]) {
      [[self delegate] tabPager:self willTransitionToTabAtIndex:index];
    }
    
    [[self pageViewController]  setViewControllers:@[[self viewControllers][index]]
                                         direction:(index > [self selectedIndex]) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse
                                          animated:YES
                                        completion:^(BOOL finished) {
                                          [self setSelectedIndex:index];
                                          
                                          if ([[self delegate] respondsToSelector:@selector(tabPager:didTransitionToTabAtIndex:)]) {
                                            [[self delegate] tabPager:self didTransitionToTabAtIndex:[self selectedIndex]];
                                          }
                                        }];
  }
}

- (void)reloadData {
  [self setViewControllers:[NSMutableArray array]];
  [self setTabTitles:[NSMutableArray array]];
  
  for (int i = 0; i < [[self dataSource] numberOfViewControllers]; i++) {
    UIViewController *viewController;
    
    if ((viewController = [[self dataSource] viewControllerForIndex:i]) != nil) {
      [[self viewControllers] addObject:viewController];
    }
    
    if ([[self dataSource] respondsToSelector:@selector(titleForTabAtIndex:)]) {
      NSString *title;
      if ((title = [[self dataSource] titleForTabAtIndex:i]) != nil) {
        [[self tabTitles] addObject:title];
      }
    }
  }
  
  [self reloadTabs];
  
  CGRect frame = [[self view] frame];
  frame.origin.y = [self headerHeight];
  frame.size.height -= [self headerHeight];
  
  [[[self pageViewController] view] setFrame:frame];
  
  [self.pageViewController setViewControllers:@[[self viewControllers][0]]
                                    direction:UIPageViewControllerNavigationDirectionReverse
                                     animated:NO
                                   completion:nil];
  [self setSelectedIndex:0];
}

- (void)reloadTabs {
    NSInteger number = [[self dataSource] numberOfViewControllers];

    if ([[self dataSource] numberOfViewControllers] == 0) {
        return;
    }
  
    if ([[self dataSource] respondsToSelector:@selector(tabHeight)]) {
        [self setHeaderHeight:[[self dataSource] tabHeight]];
    } else {
        [self setHeaderHeight:44.0f];
    }
  
    if ([[self dataSource] respondsToSelector:@selector(tabColor)]) {
        [self setHeaderColor:[[self dataSource] tabColor]];
    } else {
        [self setHeaderColor:[UIColor orangeColor]];
    }
  
    if ([[self dataSource] respondsToSelector:@selector(tabBackgroundColor)]) {
        [self setTabBackgroundColor:[[self dataSource] tabBackgroundColor]];
    } else {
        [self setTabBackgroundColor:[UIColor colorWithWhite:0.95f alpha:1.0f]];
    }
  
    NSMutableArray *tabViews = [NSMutableArray array];
  
    if ([[self dataSource] respondsToSelector:@selector(viewForTabAtIndex:)]) {
        for (int i = 0; i < [[self viewControllers] count]; i++) {
            [tabViews addObject:[[self dataSource] viewForTabAtIndex:i]];
        }
    } else {
        NSInteger index = 0;
        CGFloat tabWidth = 85;
        
        for (NSString *title in [self tabTitles]) {
            UILabel *label = [UILabel new];
            [label setText:title];
            [label setTextAlignment:NSTextAlignmentCenter];
      //      [label setFont:self.textFont];
      //      [label setTextColor:self.textColor];
            [label setNumberOfLines:2];
            [label setLineBreakMode:NSLineBreakByWordWrapping];
            [label sizeToFit];
            
            CGRect frame = [label frame];
            tabWidth = MAX(frame.size.width + 10, self.view.frame.size.width / number - (10 * (number + 2)/number));
            
            frame.size.width = tabWidth;
            [label setFrame:frame];
            [tabViews addObject:label];
            index++;
        }
    }
  
    if ([self header]) {
        [[self header] removeFromSuperview];
    }
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    frame.size.height = [self headerHeight];
    [self setHeader:[[TabScrollView alloc] initWithFrame:frame tabViews:tabViews tabBarHeight:[self headerHeight] tabColor:[self headerColor] backgroundColor:[self tabBackgroundColor] selectedTabIndex:self.selectedIndex]];
    [[self header] setTabScrollDelegate:self];
  
    [[self view] addSubview:[self header]];
}

#pragma mark - Public Methods

- (void)selectTabbarIndex:(NSInteger)index {
  [self selectTabbarIndex:index animation:NO];
}

- (void)selectTabbarIndex:(NSInteger)index animation:(BOOL)animation {
  [self.pageViewController setViewControllers:@[[self viewControllers][index]]
                                    direction:UIPageViewControllerNavigationDirectionReverse
                                     animated:animation
                                   completion:nil];
  [[self header] animateToTabAtIndex:index animated:animation];
  [self setSelectedIndex:index];
}

@end
