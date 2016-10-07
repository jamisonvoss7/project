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
@property (nonatomic) FBSDKLoginManager *facebookLogin;
@end

@implementation AccountManager

- (id)init {
    self = [super init];
    if (self) {
        _facebookLogin = [[FBSDKLoginManager alloc] init];
    }
    return self;
}

- (void)loadCurrentAccountWithComplete:(void (^)(BOOL, NSError *))handler {
    FIRUser *user = [[FIRAuth auth] currentUser];
    
    if (!user) {
        handler(NO, nil);
    } else {
        [self loadProfileAccountWithAccountForId:user.uid
                                  withCompletion:handler];
    }
}

- (void)loadCurrentAccountFromFirUser:(void (^)(BOOL, NSError *))handler {
    FIRUser *user = [[FIRAuth auth] currentUser];
    if (user) {
        [user getTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
            if (token && !error) {
                [self loadCurrentAccountWithComplete:handler];
            } else {
                [self signOut];
                handler(NO, error);
            }
        }];
    } else {
        handler(NO, nil);
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
    [self.facebookLogin logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
                         fromViewController:vc
                                    handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                        if (error) {
                                            handler(NO, error);
                                        } else if (result.isCancelled) {
                                            handler(NO, nil);
                                        } else {
                                            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
                                            FIRAuthCredential *credential = [FIRFacebookAuthProvider credentialWithAccessToken:accessToken];
                                          
                                            [[FIRAuth auth] signInWithCredential:credential
                                                                      completion:^(FIRUser *user, NSError *error) {
                                                                          [self loadProfileAccountWithAccountForId:user.uid
                                                                                               withCompletion:^(BOOL success, NSError *error) {
                                                                                                   if (success) {
                                                                                                       handler(YES, nil);
                                                                                                   } else {
                                                                                                       [self authenticateWithNewAccount:[self createAccountFromFaceBookAuthData:user]
                                                                                                                     andUserCredentials:nil
                                                                                                                         withCompletion:handler];
                                                                                                   }
                                                                                               }];
                                                    }];
                                        }
                                    }];
}

- (void)signOut {
    if (self.profileAccount.type == ACCOUNTTYPE_FACEBOOK) {
        [self.facebookLogin logOut];
    }
    
    [[FIRAuth auth] signOut:nil];
    
    self.profileAccount = nil;
    self.authenticatedAccount = nil;
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
                          self.profileAccount = account;
                      
                          handler(YES, nil);
                      } else {
                          self.profileAccount = nil;
                          self.authenticatedAccount = nil;

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
    newAccount.uid = data.uid;
    newAccount.type = ACCOUNTTYPE_FACEBOOK;
    
    return newAccount;
}

//- (void)saveAccountID:(NSString *)accountId {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setAccountUID:accountId];
//}
//
//- (NSString *)loadAccountID {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults accountUID].length > 0) {
//        return [defaults accountUID];
//    } else {
//        return @"";
//    }
//}

- (void)removeAccountId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setAccountUID:@""];
}


@end
