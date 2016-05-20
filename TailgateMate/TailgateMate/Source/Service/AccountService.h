//
//  AccountService.h
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FireBaseServiceProvider.h"

@interface AccountService : FireBaseServiceProvider

- (void)loadAllAccounts;
- (void)loadAccountForkey:(NSString *)uid withComplete:(void (^)(Account *account, NSError *error))handler;
- (void)authenticateWithUserCredentialsHelper:(UserCredentials *)credentials withCompletion:(void (^)(Account *account, NSError *error))handler;
- (void)createAccount:(Account *)account withComplete:(void (^)(BOOL success, NSError *error))handler;
- (void)saveAccount:(Account *)account withComplete:(void (^)(BOOL success, NSError *error))handler;

@end
