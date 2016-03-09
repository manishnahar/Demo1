//
//  TrackViewController.m
//  iBeacons Demo
//
//  Created by M Newill on 27/09/2013.
//  Copyright (c) 2013 Mobient. All rights reserved.
//

#import "TrackViewController.h"
#import <CloudKit/CloudKit.h>
#import "DPCollectionViewCell.h"
#import "MBProgressHUD.h"

@interface TrackViewController ()
@property (nonatomic,weak) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *linkBtn;
@property (weak, nonatomic) IBOutlet UILabel *productId;
@property (nonatomic ,strong) CLBeacon *previousBeacon;
@property (weak, nonatomic) IBOutlet UILabel *productDescription;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong , nonatomic) NSMutableArray *imageArray;
@end

@implementation TrackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self initRegion];
    self.imageArray = [NSMutableArray array];
    
}
- (IBAction)linkAction:(id)sender {
    
    NSURL *url = [NSURL URLWithString:self.linkBtn.titleLabel.text];
    [[UIApplication sharedApplication] openURL:url];
}



- (void)initRegion {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:KUUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"Diaspark"];
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Beacon Found");
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    [self setupLocalNotifications:@"didEnterRegion"];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Left Region");
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
     [self setupLocalNotifications:@"didExitRegion"];
    self.beaconFoundLabel.text = @"No";
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    
    if(state == CLRegionStateInside)
    {
      //  [self setupLocalNotifications:@"CLRegionStateInside"];
        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];


    }
    else if(state == CLRegionStateOutside)
    {
        [self setupLocalNotifications:@"CLRegionStateOutside"];
        [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];

    }
}
+ (NSArray *)sortedGategoryItems:(NSArray *)unsortedItems {
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"categoryItemIdentifier" ascending:YES comparator:^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
        
    }];
    
    return  [unsortedItems sortedArrayUsingDescriptors:@[sortDescriptor]];
    
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
        CLBeacon *beacon = beacons[0];
        if (!self.previousBeacon) {
        
            self.previousBeacon = beacon;
        }
        else if ([self.previousBeacon.minor intValue] == [beacon.minor intValue]) {
                
                return;
        }
            self.previousBeacon = beacon;
            self.beaconFoundLabel.text = @"Yes";
            self.proximityUUIDLabel.text = beacon.proximityUUID.UUIDString;
            self.majorLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
            self.minorLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];
            self.accuracyLabel.text = [NSString stringWithFormat:@"%f", beacon.accuracy];
            if (beacon.proximity == CLProximityUnknown) {
                self.distanceLabel.text = @"Unknown Proximity";
            } else if (beacon.proximity == CLProximityImmediate) {
                self.distanceLabel.text = @"Immediate";
            } else if (beacon.proximity == CLProximityNear) {
                self.distanceLabel.text = @"Near";
            } else if (beacon.proximity == CLProximityFar) {
                self.distanceLabel.text = @"Far";
            }
            self.rssiLabel.text = [NSString stringWithFormat:@"%li", (long)beacon.rssi];
            
             
             if (beacon.proximity == CLProximityNear || beacon.proximity == CLProximityImmediate) {
                 
                 NSFileManager *fileManager = [NSFileManager defaultManager];
                 NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                  switch ([beacon.minor intValue])
                 {
                     case 16143:{
                        
                         NSString *dirPath = [docPath stringByAppendingPathComponent:@"Beacon2"];
                         BOOL isDir;
                         if (![fileManager fileExistsAtPath:dirPath isDirectory:&isDir]) {
                             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                             CKDatabase *database = [[CKContainer defaultContainer] publicCloudDatabase];
                             CKRecordID *recordId = [[CKRecordID alloc] initWithRecordName: @"Beacon2"];
                             [database fetchRecordWithID:recordId completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                                 
                                 if (error) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                         [self showAlertWithTitle:@"Fail" message:error.localizedDescription delegate:nil];
                                         
                                     });
                                 }
                                 else{
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         
                                         //   [self showAlertWithTitle:[NSString stringWithFormat:@"%@", results[0].recordID] message:@"Record is successfully fetched" delegate:nil];
                                         [self.imageArray removeAllObjects];
                                         //CKRecord *record = results[0];
                                         for (int i=0; i <6; i++ ) {
                                             
                                             CKAsset *asset = [record objectForKey:[NSString stringWithFormat:@"Image%d",i]];
                                             if (asset) {
                                                 
                                                 NSString *dirPath = [docPath stringByAppendingPathComponent:@"Beacon2"];
                                                 BOOL isDir1;
                                                 if (![fileManager fileExistsAtPath:dirPath isDirectory:&isDir1]) {
                                                     
                                                     [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:nil];
                                                 }
                                                 NSString *imagePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Image%d",i+1]];
                                                 [fileManager copyItemAtPath:asset.fileURL.path toPath:imagePath error:nil];
                                                 
                                                 [self.imageArray addObject:imagePath];
                                             }
                                         }
                                         
                                         
                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                         self.productId.text   =  [record objectForKey:@"ProductID"];
                                         self.productDescription.text = [record objectForKey:@"Description"];
                                         [self.collectionView reloadData];
                                         
                                         
                                     });
                                 }
                             }];
                         }
                         else{
                              [self.imageArray removeAllObjects];
                             NSArray *images = [fileManager contentsOfDirectoryAtPath:dirPath error:nil];
                             for (NSString *image in images) {
                                 
                                 [self.imageArray addObject:[dirPath stringByAppendingPathComponent:image]];
                             }
                             [self.collectionView reloadData];
                         }
                     }
                     //self.imgView.image = [UIImage imageNamed:@"1watch.jpg"];
                     //  [self.linkBtn setTitle:@"http://www.apple.com/watch/" forState:UIControlStateNormal];
                     break;
                     case 62952:{
                         
                         NSString *dirPath = [docPath stringByAppendingPathComponent:@"Beacon3"];
                         BOOL isDir;
                         if (![fileManager fileExistsAtPath:dirPath isDirectory:&isDir]) {
                             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                             CKDatabase *database = [[CKContainer defaultContainer] publicCloudDatabase];
                             CKRecordID *recordId = [[CKRecordID alloc] initWithRecordName: @"Beacon3"];
                             [database fetchRecordWithID:recordId completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                                 
                                 if (error) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                         [self showAlertWithTitle:@"Fail" message:error.localizedDescription delegate:nil];
                                         
                                     });
                                 }
                                 else{
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         
                                         //   [self showAlertWithTitle:[NSString stringWithFormat:@"%@", results[0].recordID] message:@"Record is successfully fetched" delegate:nil];
                                         [self.imageArray removeAllObjects];
                                         //CKRecord *record = results[0];
                                         for (int i=0; i <6; i++ ) {
                                             
                                             CKAsset *asset = [record objectForKey:[NSString stringWithFormat:@"Image%d",i]];
                                             if (asset) {
                                                 
                                                 NSString *dirPath = [docPath stringByAppendingPathComponent:@"Beacon3"];
                                                 BOOL isDir1;
                                                 if (![fileManager fileExistsAtPath:dirPath isDirectory:&isDir1]) {
                                                     
                                                     [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:nil];
                                                 }
                                                 NSString *imagePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Image%d",i+1]];
                                                 [fileManager copyItemAtPath:asset.fileURL.path toPath:imagePath error:nil];
                                                 
                                                 [self.imageArray addObject:imagePath];
                                             }
                                         }
                                         
                                         
                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                         self.productId.text   =  [record objectForKey:@"ProductID"];
                                         self.productDescription.text = [record objectForKey:@"Description"];
                                         [self.collectionView reloadData];
                                         
                                         
                                     });
                                 }
                             }];
                         }
                         else{
                              [self.imageArray removeAllObjects];
                             NSArray *images = [fileManager contentsOfDirectoryAtPath:dirPath error:nil];
                             for (NSString *image in images) {
                                 
                                 [self.imageArray addObject:[dirPath stringByAppendingPathComponent:image]];
                             }
                             [self.collectionView reloadData];
                         }
                     }
                     
                     break;
                     case 40682:{
                         NSString *dirPath = [docPath stringByAppendingPathComponent:@"Beacon1"];
                         BOOL isDir;
                         if (![fileManager fileExistsAtPath:dirPath isDirectory:&isDir]) {
                             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                             CKDatabase *database = [[CKContainer defaultContainer] publicCloudDatabase];
                             CKRecordID *recordId = [[CKRecordID alloc] initWithRecordName: @"Beacon1"];
                             [database fetchRecordWithID:recordId completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                                 
                                 if (error) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                         [self showAlertWithTitle:@"Fail" message:error.localizedDescription delegate:nil];
                                         
                                     });
                                 }
                                 else{
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         
                                         //   [self showAlertWithTitle:[NSString stringWithFormat:@"%@", results[0].recordID] message:@"Record is successfully fetched" delegate:nil];
                                         [self.imageArray removeAllObjects];
                                         //CKRecord *record = results[0];
                                         for (int i=0; i <6; i++ ) {
                                             
                                             CKAsset *asset = [record objectForKey:[NSString stringWithFormat:@"Image%d",i]];
                                             if (asset) {
                                                 
                                                 NSString *dirPath = [docPath stringByAppendingPathComponent:@"Beacon1"];
                                                 BOOL isDir1;
                                                 if (![fileManager fileExistsAtPath:dirPath isDirectory:&isDir1]) {
                                                     
                                                     [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:nil];
                                                 }
                                                 NSString *imagePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Image%d",i+1]];
                                                 [fileManager copyItemAtPath:asset.fileURL.path toPath:imagePath error:nil];
                                                 
                                                 [self.imageArray addObject:imagePath];
                                             }
                                         }
                                         
                                         
                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                         self.productId.text   =  [record objectForKey:@"ProductID"];
                                         self.productDescription.text = [record objectForKey:@"Description"];
                                         [self.collectionView reloadData];
                                         
                                         
                                     });
                                 }
                             }];
                         }
                         else{
                             [self.imageArray removeAllObjects];
                             NSArray *images = [fileManager contentsOfDirectoryAtPath:dirPath error:nil];
                             for (NSString *image in images) {
                                 
                                 [self.imageArray addObject:[dirPath stringByAppendingPathComponent:image]];
                             }
                             [self.collectionView reloadData];
                         }
                     }
                     break;
                     
                 default:
                     self.imgView.image = nil;
                     [self.linkBtn setTitle:@"" forState:UIControlStateNormal];
                     
                     break;
                 }
             }
}

-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (NSArray *)sortedGategoryItems:(NSArray *)unsortedItems {
    
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"accuracy" ascending:YES comparator:^(id obj1, id obj2) {
            
            if ([obj1 doubleValue] > [obj2 doubleValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 doubleValue] < [obj2 doubleValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
            
        }];
        
        return  [unsortedItems sortedArrayUsingDescriptors:@[sortDescriptor]];
        
    }

    
- (void)setupNotifications {
    
    //Do checking here.
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSDate *now = [NSDate date];
    NSLog(@"now time: %@", now);
    localNotification.fireDate = now;
    localNotification.alertBody = @"CLProximityImmediate";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1; // increment
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    
}

- (void)setupLocalNotifications:(NSString *)msg {
    
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)
    {
        //Do checking here.
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        NSDate *now = [NSDate date];
        NSLog(@"now time: %@", now);
        localNotification.fireDate = now;
        localNotification.alertBody = msg;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = 1; // increment
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    else {
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
//        [alert show];
        
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  [self.imageArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DPCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DPCollectionViewCell" forIndexPath:indexPath];
    if (self.imageArray.count > 0) {
      
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:self.imageArray[indexPath.row]];
        collectionViewCell.imageview.image = image;
    }
    
    return collectionViewCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

@end
