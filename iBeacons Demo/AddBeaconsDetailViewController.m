//
//  AddBeaconsDetailViewController.m
//  iBeacons Demo
//
//  Created by Niraj Shah on 01/03/16.
//  Copyright © 2016 Mobient. All rights reserved.
//

#import "AddBeaconsDetailViewController.h"
#import <CloudKit/CloudKit.h>
#import "ImageCollectionViewCell.h"

@interface AddBeaconsDetailViewController ()
@property (nonatomic , strong) UIImage *productImage;
@property (weak, nonatomic) IBOutlet UITextField *productIdTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@end

@implementation AddBeaconsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openCamera{
    
    if([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]){
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusAuthorized){
            
            [self takePhoto];
        }
        else if(authStatus == AVAuthorizationStatusNotDetermined){
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted){
                
                if(granted){
                    
                    [self takePhoto];
                }
                else{
                    
                    [self dismissViewControllerAnimated:NO completion:nil];
                    [self showAlertWithTitle:@"" message:@"This app does not have access to your camera.\nYou can enable access in Privacy Settings." delegate:nil];
                }
            }];
        }
        else {
            
            [self dismissViewControllerAnimated:NO completion:nil];
            [self showAlertWithTitle:@"" message:@"This app does not have access to your camera.\nYou can enable access in Privacy Settings." delegate:nil];
        }
    }
    else{
        
        [self takePhoto];
    }
}

-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)takePhoto{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [pickerController setAllowsEditing:YES];
        [self presentViewController:pickerController animated:YES completion:nil];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//@Method             :pickPhoto
//@Abstract            :This method calls to display the action sheet with photos option i.e Take Photo or Choose Photo.
//@Param status	  :NA
//@Returntype		  :void
//@Author               :Niraj Shah
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)pickPhoto:(id)sender{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Select One" preferredStyle:UIAlertControllerStyleActionSheet];
   
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self takePhoto];
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Choose Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [pickerController setAllowsEditing:YES];
        pickerController.delegate = self;
        [self presentViewController:pickerController animated:YES completion:nil];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:NO completion:nil];

    }];
    
    [alertController addAction:action];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//@Method			:imagePickerController:didFinishPickingMediaWithInfo
//@Abstract			:This method calls after picking the image either by taking a photo from camera or choose an existing photo from photo library.
//@Param status		:UIImagePickerController,NSDictionary
//@Returntype		:void
//@Author			:Niraj Shah
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage;
    
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)== kCFCompareEqualTo) {
        
        editedImage = (UIImage *) info[UIImagePickerControllerEditedImage];
        
        originalImage = (UIImage *) info[UIImagePickerControllerOriginalImage];
        if (editedImage) {
            
            self.productImage = editedImage;
            
            
        } else {
            
            self.productImage = originalImage ;
            
        }
        ImageCollectionViewCell * cell = (ImageCollectionViewCell*)[self.collectionview cellForItemAtIndexPath:[[self.collectionview indexPathsForSelectedItems] objectAtIndex:0]];
        cell.imageview.image = self.productImage;

        self.imageView.image = self.productImage;
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//@Method			:imagePickerControllerDidCancel
//@Abstract			:This delegate method calls when Cancel button is tap on ImagePicker controller
//@Param status		:UIImagePickerController
//@Returntype		:void
//@Author			:Niraj Shah
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
}
- (IBAction)saveProductToCloud:(id)sender {
    
    
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        
        if (accountStatus == CKAccountStatusNoAccount) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign in to iCloud"
                                        
                                                                           message:@"Sign in to your iCloud account to write records. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap Create a new Apple ID."
                                        
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok"
                              
                                                      style:UIAlertActionStyleCancel
                              
                                                    handler:nil]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
        else {
            
            CKDatabase *database = [[CKContainer defaultContainer] publicCloudDatabase];
            CKRecordID *recordId = [[CKRecordID alloc] initWithRecordName: self.beaconInfo.beaconName];
            CKRecord *record =[[CKRecord alloc] initWithRecordType:@"Product" recordID:recordId];
            record[@"UUID" ] = self.beaconInfo.beaconUUID;
            
            record[@"Major"] = self.beaconInfo.major;
            
            record[@"Minor"] = self.beaconInfo.minor;
            
            record[@"ProductID"] = self.productIdTextField.text;
            
            record[@"Description"] = self.descriptionView.text;
            if (self.productImage) {
                
                NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                NSString *imagePath = [docPath stringByAppendingPathComponent:self.beaconInfo.beaconName];
                NSData *imageData = UIImagePNGRepresentation(self.productImage);
                [imageData writeToFile:imagePath atomically:YES];
                NSURL *imageURL = [NSURL fileURLWithPath:imagePath];
                CKAsset *productImage = [[CKAsset alloc] initWithFileURL:imageURL];
                record[@"ProductImage"] = productImage;
            }
            
            [database fetchRecordWithID:recordId completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                
                if (error) {
                    
                    [database saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                        
                        if (error) {
                            
                        }
                        else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [self showAlertWithTitle:@"Success" message:@"Record is successfully saved" delegate:nil];
                                
                            });
                        }

                    }];
                }
                else {
                    if (self.productImage) {
                        
                        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                        NSString *imagePath = [docPath stringByAppendingPathComponent:self.beaconInfo.beaconName];
                        NSData *imageData = UIImagePNGRepresentation(self.productImage);
                        [imageData writeToFile:imagePath atomically:YES];
                        NSURL *imageURL = [NSURL fileURLWithPath:imagePath];
                        CKAsset *productImage = [[CKAsset alloc] initWithFileURL:imageURL];
                        record[@"ProductImage"] = productImage;
                        record[@"ProductID"] = self.productIdTextField.text;
                        record[@"Description"] = self.descriptionView.text;
                    }
                [database saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {

                    if (error) {
                        
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self showAlertWithTitle:@"Success" message:@"Record is successfully saved" delegate:nil];
                            
                        });
                    }
                }];
                }
               
            }];
        }
        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    collectionViewCell.imageview.image = [UIImage imageNamed:@"imageplace"];
    return collectionViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self pickPhoto:nil];
}



/*
#pragma mark - Navigation
 [database saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
 if (error) {
 dispatch_async(dispatch_get_main_queue(), ^{
 [self showAlertWithTitle:@"Fail" message:error.localizedDescription delegate:nil];
 if (error.code == 14 ) {
 
 [database fetchRecordWithID:recordId completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
 
 if (self.productImage) {
 
 NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
 NSString *imagePath = [docPath stringByAppendingPathComponent:self.beaconInfo.beaconName];
 NSData *imageData = UIImagePNGRepresentation(self.productImage);
 [imageData writeToFile:imagePath atomically:YES];
 NSURL *imageURL = [NSURL fileURLWithPath:imagePath];
 CKAsset *productImage = [[CKAsset alloc] initWithFileURL:imageURL];
 record[@"ProductImage"] = productImage;
 }
 [database saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
 }];
 }];
 }
 });
 }
 else{
 dispatch_async(dispatch_get_main_queue(), ^{
 
 [self showAlertWithTitle:@"Success" message:@"Record is successfully saved" delegate:nil];
 
 });
 }
 }]
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
