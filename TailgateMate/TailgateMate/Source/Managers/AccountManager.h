//
//  AccountManager.h
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface AccountManager : NSObject

@property (nonatomic, readonly) Account *profileAccount;
@property (nonatomic, readonly, assign) BOOL isAuthenticated;

- (void)loadCurrentAccountWithComplete:(void (^)(BOOL success, NSError *error))handler;

- (void)loadCurrentAccountFromFirUser:(void (^)(BOOL success, NSError *error))handler;

- (void)authenticateWithNewAccount:(Account *)account
                andUserCredentials:(UserCredentials *)credentials
                    withCompletion:(void(^)(BOOL authenticated, NSError *error))handler;

- (void)authenticateWithUserCredentials:(UserCredentials *)credentials
                         withCompletion:(void (^)(BOOL authenticated, NSError *error))handler;

- (void)saveAccount:(Account *)account withComplete:(void (^)(BOOL success, NSError *error))handler;

- (void)addUserName:(NSString *)userName
       withComplete:(void (^)(BOOL success, NSError *error))handler;

- (void)updateEmail:(NSString *)email
       withComplete:(void (^)(BOOL success, NSError *error))handler;

- (void)signInWithFacebookFromViewController:(UIViewController *)vc
                              withCompletion:(void (^)(BOOL success, NSError *error))handler;

- (void)signOut;

@end
