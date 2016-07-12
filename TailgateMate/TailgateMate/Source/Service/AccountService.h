//
//  AccountService.h
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "FireBaseServiceProvider.h"

@interface AccountService : FireBaseServiceProvider

- (void)loadAccountForkey:(NSString *)uid
             withComplete:(void (^)(Account *account, NSError *error))handler;

- (void)authenticateWithNewUserCredentials:(UserCredentials *)credentials
                            withCompletion:(void (^)(NSString *uid, NSError *error))handler;

- (void)authenticateWithUserCredentials:(UserCredentials *)credentials
                         withCompletion:(void (^)(NSString *uid, NSError *error))handler;

- (void)createAccount:(Account *)account
         withComplete:(void (^)(BOOL success, NSError *error))handler;

- (void)saveAccount:(Account *)account
       withComplete:(void (^)(BOOL success, NSError *error))handler;


@end
