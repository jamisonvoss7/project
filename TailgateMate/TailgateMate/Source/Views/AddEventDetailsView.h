//
//  AddEventDetailsView.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/10/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddEventDetailsView : UIView

@property (nonatomic, weak) IBOutlet UITextField *titleTextView;
@property (nonatomic, weak) IBOutlet UITextField *lotNumberTextView;
@property (nonatomic, weak) IBOutlet UITextView *descriptionTextView;

+ (instancetype)instanceFromDefaultNib;

@end
