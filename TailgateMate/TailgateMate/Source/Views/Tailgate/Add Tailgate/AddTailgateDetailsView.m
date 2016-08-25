//
//  AddTailgateDetailsView.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/10/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AddTailgateDetailsView.h"
#import "DatePickerView.h"

NSInteger const AddTailgateDetailSecondInADay = 86400;
NSString * const AddTailgateDetailDateFormat = @"M/d h:mm a";

@interface AddTailgateDetailsView () <UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic) DatePickerView *datePickerView;
@property (nonatomic, assign) BOOL editingStartDate;
@property (nonatomic, assign) BOOL editingEndDate;
@end

@implementation AddTailgateDetailsView
+ (instancetype)instanceFromDefaultNib {
    UINib *nib = [UINib nibWithNibName:@"AddTailgateDetailsView"
                                bundle:[NSBundle mainBundle]];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = AddTailgateDetailDateFormat;
    
    self.titleTextView.delegate = self;
    self.lotNumberTextView.delegate = self;
    self.endDateField.delegate = self;
    self.startDateField.delegate = self;
    self.descriptionTextView.delegate = self;
    
    self.datePickerView = [DatePickerView instanceWithDefaultNib];
    CGRect frame = self.frame;
    frame.origin.y = frame.size.height;
    self.datePickerView.frame = frame;
    
    self.datePickerView.greyView.alpha = 0;
    
    [self addSubview:self.datePickerView];
    
    UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(closeKeyboard)];
    backgroundTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:backgroundTap];
    
    [self.datePickerView.cancelButton setTarget:self];
    [self.datePickerView.cancelButton setAction:@selector(cancelDatePicking:)];
    
    [self.datePickerView.saveButton setTarget:self];
    [self.datePickerView.saveButton setAction:@selector(saveDatePicking:)];
}

- (void)closeKeyboard {
    [self.titleTextView resignFirstResponder];
    [self.lotNumberTextView resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.startDateField) {
        [self editStartDate];
        return NO;
    } else if (textField == self.endDateField) {
        [self editEndDate];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == self.descriptionTextView) {
        [self animateViewUpForTextBox];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == self.descriptionTextView) {
        [self animateViewDownForTextBox];
    }
}

- (void)editStartDate {
    self.editingStartDate = YES;

    self.datePickerView.datePicker.minimumDate = [NSDate date];
    
    [self showDatePicker];
}

- (void)editEndDate {
    self.editingEndDate = YES;
    
    if (self.startDate) {
        self.datePickerView.datePicker.minimumDate = self.startDate;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self.startDate];
        
        NSInteger hours = [components hour];
        NSInteger minutes = [components minute];
        NSInteger seconds = [components second];
        
        NSTimeInterval diff = AddTailgateDetailSecondInADay - (hours * 3600 + minutes * 60 + seconds);
        NSDate *futureMidnight = [NSDate dateWithTimeInterval:diff sinceDate:self.startDate];
        self.datePickerView.datePicker.maximumDate = futureMidnight;
    } else {
        self.datePickerView.datePicker.minimumDate = [NSDate date];
    }
    
    [self showDatePicker];
}

- (void)saveDatePicking:(UIBarButtonItem *)sender {
    if (self.editingStartDate) {
        self.startDate = self.datePickerView.datePicker.date;
        self.startDateField.text = [self.dateFormatter stringFromDate:self.datePickerView.datePicker.date];
    } else if (self.editingEndDate) {
        self.endDate = self.datePickerView.datePicker.date;
        self.endDateField.text = [self.dateFormatter stringFromDate:self.datePickerView.datePicker.date];
    }
    self.editingEndDate = NO;
    self.editingStartDate = NO;
    
    [self hideDatePicker];
}

- (void)cancelDatePicking:(UIBarButtonItem *)sender {
    [self hideDatePicker];
    
    self.editingEndDate = NO;
    self.editingStartDate = NO;
}

- (void)showDatePicker {
    [self closeKeyboard];
    
    [UIView animateWithDuration:.35
                     animations:^{
                         CGRect frame = self.datePickerView.frame;
                         frame.origin.y = 0;
                         self.datePickerView.frame = frame;
                         
                         self.datePickerView.greyView.alpha = .3;
                     }];
}

- (void)hideDatePicker {
    [UIView animateWithDuration:.35
                     animations:^{
                         CGRect frame = self.datePickerView.frame;
                         frame.origin.y = self.frame.size.height;
                         self.datePickerView.frame = frame;
                         
                         self.datePickerView.greyView.alpha = 0;
                     }];
}

- (void)animateViewUpForTextBox {
    [UIView animateWithDuration:.25 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = frame.origin.y - 200;
        self.frame = frame;
    }];
}

- (void)animateViewDownForTextBox {
    [UIView animateWithDuration:.25 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = frame.origin.y + 200;
        self.frame = frame;
    }];
}
@end
