//
//  AddContactsViewController.h
//  TailgateMate
//
//  Created by Jamison Voss on 9/13/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "BaseViewController.h"

@protocol AddContactsViewControllerDelegate <NSObject>
- (void)presentAViewController:(UIViewController *)viewController;
@end

@interface AddContactsViewController : BaseViewController <AddContactsViewControllerDelegate>

@end
