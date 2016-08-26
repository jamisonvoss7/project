//
//  ProfileViewController.m
//  TailgateMate
//
//  Created by Jamison Voss on 4/3/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileView.h"
#import "ProfileEditView.h"
#import "NavbarView.h"
#import "ContactsViewControler.h"
#import "PhoneVerificationView.h"
#import "AccountService.h"
#import "AddContactsView.h"
#import "ImageServiceProvider.h"

@interface ProfileViewController () <UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic) ProfileView *profileView;
@property (nonatomic) ProfileEditView *editView;
@property (nonatomic) UIBarButtonItem *barButton;
@property (nonatomic) NavbarView *navbarView;
@property (nonatomic, assign) BOOL isEditiing;
@property (nonatomic) NSMutableArray *pages;
@property (nonatomic, assign) NSInteger pageCursor;
@property (nonatomic) PhoneVerificationView *phoneVerificcationView;
@property (nonatomic) AddContactsView *addContactsView;
@property (nonatomic) UIAlertController *passwordInput;
@end

@implementation ProfileViewController

- (id)init {
    self = [super initWithNibName:@"ProfileViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navbarView = [NavbarView instanceFromDefaultNib];
    self.navbarView.titleLabel.text = @"Profile";
    self.navbarView.leftButton.text = @"Close";
    self.navbarView.rightButton.text = @"Edit";
    
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(leftButtonAction:)];
    closeTap.numberOfTapsRequired = 1;
    [self.navbarView.leftButton addGestureRecognizer:closeTap];
    
    UITapGestureRecognizer *editTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(rightButtonAction:)];
    editTap.numberOfTapsRequired = 1;
    [self.navbarView.rightButton addGestureRecognizer:editTap];
    
    [self.view addSubview:self.navbarView];
    
    CGSize size = self.containerView.contentSize;
    size.width = self.view.frame.size.width;
    self.containerView.contentSize = size;
    
    self.containerView.scrollEnabled = NO;
    
    self.isEditiing = NO;
    
    self.profileView = [ProfileView instanceFromDefaultNib];
    self.editView = [ProfileEditView instanceFromDefaultNib];
    self.phoneVerificcationView = [PhoneVerificationView instanceWithDefaultNib];
    self.addContactsView = [AddContactsView instanceWithDefaultNib];
    
    CGRect frame = self.editView.frame;
    frame.origin.x = self.view.frame.size.width;
    self.editView.frame = frame;
    
    frame = self.phoneVerificcationView.frame;
    frame.origin.x = self.view.frame.size.width * 3.0f;
    self.phoneVerificcationView.frame = frame;
    
    frame = self.addContactsView.frame;
    frame.origin.x = self.view.frame.size.width * 3.0f;
    self.addContactsView.frame = frame;
    
    [self.containerView addSubview:self.profileView];
    [self.containerView addSubview:self.editView];
    [self.containerView addSubview:self.phoneVerificcationView];
    [self.containerView addSubview:self.addContactsView];
    
    self.editView.profileDelegate = self;
    self.phoneVerificcationView.profileDelegate = self;
    
    self.signoutButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [self.signoutButton addTarget:self
                           action:@selector(signOutHandler:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [self.profileView.addContactsButton addTarget:self
                                           action:@selector(showAddContacts:)
                                 forControlEvents:UIControlEventTouchUpInside];
    
    [self.profileView.contactsButton addTarget:self
                                        action:@selector(showContacts:)
                              forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapHandler:)];
    imageTap.numberOfTapsRequired = 1;
    [self.profileView.imageClickReceiver addGestureRecognizer:imageTap];
}

- (void)rightButtonAction:(UITapGestureRecognizer *)sender {
    if (self.isEditiing) {
//        [self save];
    } else {
        [self startEditing];
    }
}

- (void)leftButtonAction:(UITapGestureRecognizer *)sender {
    if (self.isEditiing) {
        [self.editView closeKeyboards];
        [self doneEditing];
    } else {
        [self.baseDelegate dismissViewController:self];
    }
}

- (void)startEditing {
    CGPoint point = self.containerView.contentOffset;
    point.x = self.view.frame.size.width;
    [self.containerView setContentOffset:point animated:YES];
    
    self.navbarView.leftButton.text = @"Back";
    self.navbarView.rightButton.text = @"";
    self.navbarView.titleLabel.text = @"Edit Profile";
    
    self.isEditiing = YES;
}

- (void)updateName:(NSString *)name {
    self.editView.userInteractionEnabled = NO;
    [self.editView showActivityIndicatorWithCurtain:YES];
   
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    
    Account *profileAccount = [AppManager sharedInstance].accountManager.profileAccount;
    profileAccount.displayName = self.editView.nameField.text;
    
    [manager saveAccount:profileAccount
            withComplete:^(BOOL success, NSError *error) {
                [self.editView hideActivityIndicator];
                self.editView.userInteractionEnabled = YES;

                [self.profileView reload];
                [self.editView reload];

                if (!success) {
                    [self showToast:@"An error occurred"];
                }
            }];
}

- (void)updateEmail:(NSString *)email {
    self.editView.userInteractionEnabled = NO;
    [self.editView showActivityIndicatorWithCurtain:YES];
    
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    
    [manager updateEmail:self.editView.emailField.text
            withComplete:^(BOOL success, NSError *error) {
                if (success) {
                    Account *profileAccount = manager.profileAccount;
                    profileAccount.emailAddress = self.editView.emailField.text;
                
                    [manager saveAccount:profileAccount
                            withComplete:^(BOOL success, NSError *error) {
                                [self.editView hideActivityIndicator];
                                self.editView.userInteractionEnabled = YES;
                              
                                [self.profileView reload];
                                [self.editView reload];

                                if (!success) {
                                    [self showToast:@"An error occurred"];
                                }
                        }];
                } else if (error.code == 17014) {
                    self.editView.userInteractionEnabled = YES;
                    [self.editView hideActivityIndicator];
                    [self showPassowordAlertForEmail:email];
                } else {
                    [self.profileView reload];
                    [self.editView reload];

                    self.editView.userInteractionEnabled = YES;

                    [self.editView hideActivityIndicator];
                    [self showToast:@"An error occurred"];
                }
            }];
}

- (void)updateUserName:(NSString *)username {
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    AccountService *service = [[AccountService alloc] init];
    
    [service checkUserNameAvailability:self.editView.userNameField.text
                          withComplete:^(BOOL available, NSError *error) {
                              if (available) {
                                  Account *profileAccount = manager.profileAccount;
                                  profileAccount.userName = self.editView.userNameField.text;
                              
                                  [manager saveAccount:profileAccount
                                          withComplete:^(BOOL success, NSError *error) {
                                              [self.editView hideActivityIndicator];
                                              self.editView.userInteractionEnabled = YES;

                                              [self.profileView reload];
                                              [self.editView reload];

                                              if (!success) {
                                                  [self showToast:@"An error occurred"];
                                              }
                                          }];
                              } else {
                                  self.editView.userInteractionEnabled = YES;
                                  [self.editView hideActivityIndicator];
                            
                                  [self.profileView reload];
                                  [self.editView reload];

                                  [self showErrorToast:@"This username is taken"];
                              }
                          }];
}

- (void)updatePhoneNumber:(NSString *)phoneNumber {
    [self scrollRight];
    self.phoneVerificcationView.phoneNumber = phoneNumber;
}

- (void)finishUpdatingPhone {
    [self scrollLeft];
}

- (void)doneEditing {
    CGPoint point = self.containerView.contentOffset;
    point.x = 0;
    [self.containerView setContentOffset:point animated:YES];
    
    self.navbarView.titleLabel.text = @"Profile";
    self.navbarView.leftButton.text = @"Close";
    self.navbarView.rightButton.text = @"Edit";

    self.isEditiing = NO;
}

- (void)signOutHandler:(UIButton *)sender {
    AccountManager *manager = [AppManager sharedInstance].accountManager;
    [manager signOut];
    [self.baseDelegate dismissViewController:self];
}


- (void)showAddContacts:(UIButton *)sender {
    CGPoint point = self.containerView.contentOffset;
    point.x = 3 * self.view.frame.size.width;
    [self.containerView setContentOffset:point];
    
    [self.addContactsView becomesVisible]
    
    self.navbarView.leftButton.text = @"Back";
    self.navbarView.rightButton.text = @"";
    self.navbarView.titleLabel.text = @"Add Contacts";

    self.isEditiing = YES;
}

- (void)showContacts:(UIButton *)sender {
    ContactsViewControler *vc = [[ContactsViewControler alloc] init];
    [self.baseDelegate presentViewController:vc];
}

- (void)scrollRight {
    CGPoint point = self.containerView.contentOffset;
    point.x = point.x + self.view.frame.size.width;
    [self.containerView setContentOffset:point animated:YES];
}

- (void)scrollLeft {
    CGPoint point = self.containerView.contentOffset;
    point.x = point.x - self.view.frame.size.width;
    [self.containerView setContentOffset:point animated:YES];
}

- (void)showPassowordAlertForEmail:(NSString *)email {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please confirm your password" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *field = [alert.textFields firstObject];
        
        AccountManager *manager = [AppManager sharedInstance].accountManager;

        UserCredentials *user = [[UserCredentials alloc] init];
        user.userName = manager.profileAccount.emailAddress;
        user.password = field.text;
        
        [manager authenticateWithUserCredentials:user
                                  withCompletion:^(BOOL authenticated, NSError *error) {
                                      [self updateEmail:email];
                                  }];
    }];
    [alert addAction:action];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imageTapHandler:(UITapGestureRecognizer *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take a Photo"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                [self presentPhotoTakerController];
                                                            }];
    
    UIAlertAction *pickPhotoAction = [UIAlertAction actionWithTitle:@"Pick a Photo"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                [self presentPhotoSelecterController];
                                                            }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:takePhotoAction];
    [alert addAction:pickPhotoAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

- (void)presentPhotoTakerController {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.allowsEditing = NO;
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)presentPhotoSelecterController {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.allowsEditing = NO;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        if ([info objectForKey:UIImagePickerControllerOriginalImage]) {
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            [self.profileView showActivityIndicatorWithCurtain:YES];

            AccountManager *manager = [AppManager sharedInstance].accountManager;

            NSString *uid = [NSUUID UUID].UUIDString;
            NSString *path = [NSString stringWithFormat:@"%@/%@", manager.profileAccount.uid, uid];
            

            ImageServiceProvider *service = [[ImageServiceProvider alloc] init];
            [service saveImage:image
                        atPath:path
                withCompletion:^(BOOL success, NSError *error) {
                    if (success) {
                        Account *account = manager.profileAccount;
                        account.photoId = uid;
                        
                        [manager saveAccount:account
                                withComplete:^(BOOL success, NSError *error) {
                                    [self.profileView hideActivityIndicator];
                                  
                                    self.profileView.profileImageView.image = image;

                                    if (!success) {
                                        [self showToast:@"An error occurred"];
                                    }
                                }];
                    } else {
                        [self showToast:@"An error occurred"];
                    }
                }];
        }
    }];
}


@end
