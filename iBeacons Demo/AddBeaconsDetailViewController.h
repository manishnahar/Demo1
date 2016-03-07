//
//  AddBeaconsDetailViewController.h
//  iBeacons Demo
//
//  Created by Niraj Shah on 01/03/16.
//  Copyright © 2016 Mobient. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "BeaconsInformation.h"

@interface AddBeaconsDetailViewController : UIViewController< UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong)  BeaconsInformation *beaconInfo ;
@end
