//
//  EventViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 5/4/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController ()
@property (nonatomic) TailgateParty *event;
@end

@implementation EventViewController

- (id)initWithEvent:(TailgateParty *)event {
    self = [super initWithNibName:@"EventViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _event = event;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navbar.rightButton setTitle:@"Close" forState:UIControlStateNormal];
    self.navbar.leftButton.hidden = YES;
    self.navbar.titleLabel.text = self.event.name;
    
}




@end
