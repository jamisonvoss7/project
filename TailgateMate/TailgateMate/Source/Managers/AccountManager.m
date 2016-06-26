//
//  AccountManager.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AccountManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AccountService.h"

@interface AccountManager ()
@property (nonatomic, readwrite) Account *profileAccount;
@property (nonatomic) Account *authenticatedAccount;
@end

@implementation AccountManager

- (void)loadCurrentAccuntWithComplete:(void (^)(BOOL, NSError *))handler {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults accountUID];
    
    if (uid.length == 0) {
        handler(YES, nil);
    } else {
        Account *account = [[Account alloc] init];
        account.uid = uid;
        [self loadProfileAccountWithAccount:account
                             withCompletion:handler];
    }

}

- (void)authenticateWithNewAccount:(Account *)account withCompletion:(void (^)(BOOL, NSError *))handler {
    AccountService *service = [[AccountService alloc] init];
    if (account.type == ACCOUNTTYPE_FACEBOOK) {
        [service createAccount:account
                  withComplete:^(BOOL success, NSError *error) {
                      if (success) {
                          [self loadProfileAccountWithAccount:account withCompletion:handler];
                      } else {
                          handler(NO, nil);
                      }
                  }];
    } else if (account.type == ACCOUNTTYPE_EMAIL) {
        [service createAccount:account
                  withComplete:^(BOOL success, NSError *error) {
                      if (success) {
                          [self loadProfileAccountWithAccount:account withCompletion:handler];
                      } else {
                          handler(NO, nil);
                      }
                  }];
    }
}

- (void)authenticateWithUserCredentials:(UserCredentials *)credentials withCompletion:(void (^)(BOOL, NSError *))handler {
    AccountService *service = [[AccountService alloc] init];
    [service authenticateWithUserCredentialsHelper:credentials
                                    withCompletion:^(Account *account, NSError *error) {
                                        if (account) {
                                            [self loadProfileAccountWithAccount:account withCompletion:handler];
                                        } else {
                                            handler(NO, error);
                                        }
                                    }];
}


- (void)signInWithFacebookFromViewController:(UIViewController *)vc withCompletion:(void (^)(BOOL success, NSError *error))handler {
    Firebase *ref = [AppManager sharedInstance].firebaseRef;
    
    FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
    [facebookLogin logInWithReadPermissions:@[@"email"]
                         fromViewController:vc
                                    handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                        if (error) {
                                            NSLog(@"Facebook login failed. Error: %@", error);
                                        } else if (result.isCancelled) {
                                            NSLog(@"Facebook login got cancelled.");
                                        } else {
                                            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
                                            [ref authWithOAuthProvider:@"facebook" token:accessToken
                                                   withCompletionBlock:^(NSError *error, FAuthData *authData) {
                                                       Account *account = [self createAccountFromFaceBookAuthData:authData];
                                                       [self loadProfileAccountWithAccount:account
                                                                            withCompletion:^(BOOL success, NSError *error) {
                                                                                if (success) {
                                                                                    handler(YES, nil);
                                                                                } else {
                                                                                    [self authenticateWithNewAccount:[self createAccountFromFaceBookAuthData:authData]
                                                                                                      withCompletion:handler];

                                                                                }
                                                                            }];
                                                    }];
                                        }
                                    }];
}

- (void)signOut {
    self.profileAccount = nil;
    self.authenticatedAccount = nil;
    [self saveAccountID:@""];
}

- (void)saveAccount:(Account *)account
       withComplete:(void (^)(BOOL, NSError *))handler {
    AccountService *service = [[AccountService alloc] init];

    [service saveAccount:account
            withComplete:handler];
}

- (BOOL)isAuthenticated {
    if (self.authenticatedAccount) {
        return YES;
    } else {
        return NO;
    }
}

- (void)loadProfileAccountWithAccount:(Account *)account withCompletion:(void (^)(BOOL success, NSError *error))handler {
    
    AccountService *service = [[AccountService alloc] init];
    [service loadAccountForkey:account.uid
                  withComplete:^(Account *account, NSError *error) {
                      if (account && !error) {
                          self.authenticatedAccount = account;
                          [self saveAccountID:account.uid];
                          self.profileAccount = account;
                      
                          handler(YES, nil);
                      } else {
                          self.authenticatedAccount = nil;
                          [self saveAccountID:@""];
                          self.profileAccount = nil;

                          handler(NO, error);
                      }
                  }];
}

- (Account *)createAccountFromFaceBookAuthData:(FAuthData *)data {
    Account *newAccount = [[Account alloc] init];
    
    NSDictionary *profile = [data.providerData objectForKey:@"cachedUserProfile"];
    
    
    newAccount.firstName = [profile objectForKey:@"first_name"];
    newAccount.lastName = [profile objectForKey:@"last_name"];
    newAccount.emailAddress = [profile objectForKey:@"email"];
    newAccount.uid = data.uid;
    newAccount.type = ACCOUNTTYPE_FACEBOOK;
    
    return newAccount;
}

- (void)saveAccountID:(NSString *)accountId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setAccountUID:accountId];
}

- (NSString *)loadAccountID {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults accountUID].length > 0) {
        return [defaults accountUID];
    } else {
        return @"";
    }
}

- (void)removeAccountId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setAccountUID:@""];
}
@end
