//
//  AccountManager.m
//
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AccountManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AccountService.h"
@import FirebaseAuth;

@interface AccountManager ()
@property (nonatomic, readwrite) Account *profileAccount;
@property (nonatomic) Account *authenticatedAccount;
@end

@implementation AccountManager

- (void)loadCurrentAccuntWithComplete:(void (^)(BOOL, NSError *))handler {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults accountUID];
    
    if (uid.length == 0) {
        handler(NO, nil);
    } else {
        [self loadProfileAccountWithAccountForId:uid
                                  withCompletion:handler];
    }

}

- (void)authenticateWithNewAccount:(Account *)account
                andUserCredentials:(UserCredentials *)credentials
                    withCompletion:(void (^)(BOOL, NSError *))handler {
   
    AccountService *service = [[AccountService alloc] init];
    if (account.type == ACCOUNTTYPE_FACEBOOK) {
        [service createAccount:account
                  withComplete:^(BOOL success, NSError *error) {
                      if (success) {
                          [self loadProfileAccountWithAccountForId:account.uid
                                               withCompletion:handler];
                      } else {
                          handler(NO, nil);
                      }
                  }];
    } else if (account.type == ACCOUNTTYPE_EMAIL) {
        [service authenticateWithNewUserCredentials:credentials
                                     withCompletion:^(NSString *uid, NSError *error) {
                                            if (uid.length > 0) {
                                                account.uid = uid;
                                                [service createAccount:account
                                                          withComplete:^(BOOL success, NSError *error) {
                                                              if (success) {
                                                                  [self loadProfileAccountWithAccountForId:uid
                                                                                       withCompletion:handler];
                                                              } else {
                                                                  handler(NO, nil);
                                                              }
                                                          }];
                                            } else {
                                                handler(NO, error);
                                            }
                                        }];
    }
}

- (void)authenticateWithUserCredentials:(UserCredentials *)credentials withCompletion:(void (^)(BOOL, NSError *))handler {
    AccountService *service = [[AccountService alloc] init];
    [service authenticateWithUserCredentials:credentials
                              withCompletion:^(NSString *uid, NSError *error) {
                                  if (uid.length) {
                                      [self loadProfileAccountWithAccountForId:uid withCompletion:handler];
                                  } else {
                                      handler(NO, error);
                                  }
                              }];
}


- (void)signInWithFacebookFromViewController:(UIViewController *)vc withCompletion:(void (^)(BOOL success, NSError *error))handler {
    FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
    [facebookLogin logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
                         fromViewController:vc
                                    handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                        if (error) {

                                        } else if (result.isCancelled) {

                                        } else {
                                            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
                                            FIRAuthCredential *credential = [FIRFacebookAuthProvider credentialWithAccessToken:accessToken];
                                          
                                            [[FIRAuth auth] signInWithCredential:credential
                                                                      completion:^(FIRUser *user, NSError *error) {
                                                                          Account *account = [self createAccountFromFaceBookAuthData:user];
                                                                          [self loadProfileAccountWithAccountForId:account.uid
                                                                                               withCompletion:^(BOOL success, NSError *error) {
                                                                                                   if (success) {
                                                                                                       handler(YES, nil);
                                                                                                   } else {
                                                                                                       [self authenticateWithNewAccount:[self createAccountFromFaceBookAuthData:user] andUserCredentials:nil
                                                                                                                         withCompletion:handler];

                                                                                                   }
                                                                                               }];
                                                    }];
                                        }
                                    }];
}

- (void)signOut {
    if (self.profileAccount.type == ACCOUNTTYPE_FACEBOOK) {
        FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
        [facebookLogin logOut];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:@"hasSkipped"];
    
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

- (void)addUserName:(NSString *)userName
       withComplete:(void (^)(BOOL, NSError *))handler {
    
}

- (BOOL)isAuthenticated {
    if (self.authenticatedAccount) {
        return YES;
    } else {
        return NO;
    }
}

- (void)updateEmail:(NSString *)email withComplete:(void (^)(BOOL, NSError *))handler {
    AccountService *service = [[AccountService alloc] init];
    [service updateEmail:email withComplete:^(BOOL success, NSError *error) {
        if (success) {
            Account *account = self.profileAccount;
            account.emailAddress = email;
            [service saveAccount:account
                    withComplete:^(BOOL success, NSError *error) {
                        [self loadProfileAccountWithAccountForId:account.uid
                                                  withCompletion:handler];
                    }];
        } else {
            handler(NO, error);
        }
    }];
}

- (void)loadProfileAccountWithAccountForId:(NSString *)uid withCompletion:(void (^)(BOOL success, NSError *error))handler {
    AccountService *service = [[AccountService alloc] init];
    [service loadAccountForkey:uid
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

- (Account *)createAccountFromFaceBookAuthData:(FIRUser *)data {
    Account *newAccount = [[Account alloc] init];
    
    id<FIRUserInfo> profile = [data.providerData firstObject];
    
    newAccount.displayName = [profile displayName];
    newAccount.emailAddress = [profile email];
    newAccount.photoUrl = [[profile photoURL] absoluteString];
    newAccount.uid = [profile uid];
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
