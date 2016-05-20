//
//  AuthenticationDelegate.h
//  TailgateMate
//
//  Created by Jamison Voss on 3/23/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AuthenticationDelegate <NSObject>

- (void)didAuthenticate;
- (void)failedToAuthenticate;

@end
