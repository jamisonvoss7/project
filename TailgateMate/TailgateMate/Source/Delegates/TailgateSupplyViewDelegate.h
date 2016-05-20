//
//  TailgateSupplyViewDelegate.h
//  TailgateMate
//
//  Created by Jamison Voss on 4/15/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TailgateSupplyViewDelegate <NSObject>

- (void)selectedTailgateSupply:(TailgateSupply *)supply;
- (void)removedTailgateSupply:(TailgateSupply *)supply;

@end
