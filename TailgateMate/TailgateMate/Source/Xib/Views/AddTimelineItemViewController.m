//
//  AddTimeLineItemView.m
//  TailgateMate
//
//  Created by Jamison Voss on 8/15/16.
//  Copyright © 2016 Jamison Voss. All rights reserved.
//

#import "AddTimelineItemViewController.h"
#import "ImageServiceProvider.h"
#import "TimelineServiceProvider.h"

@interface AddTimelineItemViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic) UIImage *selectedImage;
@property (nonatomic) TailgateParty *tailgateParty;
@end

@implementation AddTimelineItemViewController

- (instancetype) initWithTailgateParty:(TailgateParty *)party {
    self = [super initWithNibName:@"AddTimelineItemViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        _tailgateParty = party;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapHandler:)];
    tap.numberOfTapsRequired = 1;
    [self.imageClickReceiver addGestureRecognizer:tap];
    
    [self.postButton addTarget:self action:@selector(onPost:) forControlEvents:UIControlEventTouchUpInside];
    
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
            self.selectedImage = image;
            self.imageView.image = image;
        }
    }];
}

- (void)onPost:(UIButton *)sender {
    TimelineItem *newItem = [[TimelineItem alloc] init];
    newItem.message = self.textView.text;
    newItem.type = self.selectedImage ? TIMELINEITEMTYPE_IMAGE : TIMELINEITEMTYPE_MESSAGE;
    newItem.userDisplayName = [AppManager sharedInstance].accountManager.profileAccount.displayName;
    newItem.tiemStamp = [NSDate date];
    
    TimelineServiceProvider *timelineService = [[TimelineServiceProvider alloc] init];

    if (self.selectedImage) {
        NSString *uid = [NSUUID UUID].UUIDString;
        newItem.photoId = uid;
        [timelineService saveImage:self.selectedImage
                           atId:uid
               forPartyTimeline:self.tailgateParty.uid
                 withCompletion:^(BOOL success, NSError *error) {
                     if (success) {
                         [timelineService addTimelineItem:newItem
                                          toTailgateParty:self.tailgateParty
                                             withComplete:^(BOOL success, NSError *error) {
                                                 if (success) {
                                                     [self.baseDelegate dismissViewController:self];
                                                 }
                                             }];
                     }
                 }];
    } else {
        [timelineService addTimelineItem:newItem
                         toTailgateParty:self.tailgateParty
                            withComplete:^(BOOL success, NSError *error) {
                                if (success) {
                                    [self.baseDelegate dismissViewController:self];
                                }
                            }];
    }
    
}
@end
