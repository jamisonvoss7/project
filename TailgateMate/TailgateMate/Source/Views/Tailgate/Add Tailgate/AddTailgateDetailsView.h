//
//  AddTailgateDetailsView.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/10/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTailgateDetailsView : UIView

@property (nonatomic, weak) IBOutlet UITextField *titleTextView;
@property (nonatomic, weak) IBOutlet UITextField *lotNumberTextView;
@property (nonatomic, weak) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *teamSegmentControl;
@property (nonatomic, weak) IBOutlet UISegmentedControl *availabilitySegmentControl;
@property (nonatomic, weak) IBOutlet UITextField *startDateField;
@property (nonatomic, weak) IBOutlet UITextField *endDateField;

@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;

+ (instancetype)instanceFromDefaultNib;
- (void)closeKeyboard;

@end
