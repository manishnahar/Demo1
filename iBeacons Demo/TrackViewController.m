//
//  TrackViewController.m
//  iBeacons Demo
//
//  Created by M Newill on 27/09/2013.
//  Copyright (c) 2013 Mobient. All rights reserved.
//

#import "TrackViewController.h"

@interface TrackViewController ()
@property (nonatomic,weak) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *linkBtn;
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
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];
}
- (IBAction)linkAction:(id)sender {
    
    NSURL *url = [NSURL URLWithString:self.linkBtn.titleLabel.text];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
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
        [self setupLocalNotifications:@"CLRegionStateInside"];

    }
    else if(state == CLRegionStateOutside)
    {
        [self setupLocalNotifications:@"CLRegionStateOutside"];

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
    
    NSMutableArray *Arr1 = [NSMutableArray array];
    NSMutableArray *Arr2 = [NSMutableArray array];
    NSMutableArray *Arr3 = [NSMutableArray array];
    NSMutableArray *Arr4 = [NSMutableArray array];
    NSMutableArray *sortedArray = [NSMutableArray array];
    
    if(beacons.count > 0) {
        
        for (CLBeacon *beacon in beacons) {
            
            if (beacon.proximity == CLProximityImmediate) {
                [Arr1 addObject:beacon];
            }
            
            
            if (beacon.proximity == CLProximityNear) {
                [Arr2 addObject:beacon];
                // Sort Arr2 based on Accurecy
                
            }
            if (beacon.proximity == CLProximityFar) {
                [Arr3 addObject:beacon];
                // Sort Arr3 based on Accurecy
                
            }
            if (beacon.proximity == CLProximityUnknown) {
                [Arr4 addObject:beacon];
                // Sort Arr4 based on Accurecy
            }
        }
        if(Arr1.count > 0) {
            Arr1 = [[self sortedGategoryItems:Arr1] mutableCopy];
            [sortedArray addObjectsFromArray:Arr1];
        }
        if(Arr2.count > 0) {
            Arr2 = [[self sortedGategoryItems:Arr2] mutableCopy];
            [sortedArray addObjectsFromArray:Arr2];
        }
        if(Arr3.count > 0) {
            Arr3 = [[self sortedGategoryItems:Arr3] mutableCopy];
            [sortedArray addObjectsFromArray:Arr3];
        }
        if(Arr4.count > 0) {
            Arr4 = [[self sortedGategoryItems:Arr4] mutableCopy];
            [sortedArray addObjectsFromArray:Arr4];
        }
        
        for (CLBeacon *beacon in beacons) {
            NSLog(@"aucuracy=== %@",[NSString stringWithFormat:@"%f", beacon.accuracy]);
        }
        for (CLBeacon *beacon in sortedArray) {
            NSLog(@"sortedArray aucuracy=== %@",[NSString stringWithFormat:@"%f", beacon.accuracy]);
        }
        
         if(sortedArray.count > 0) {
            
             CLBeacon *beacon = sortedArray[0];
             
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
            
            switch ([beacon.minor intValue]) {
                case 16143:
                    self.imgView.image = [UIImage imageNamed:@"1watch.jpg"];
                    [self.linkBtn setTitle:@"http://www.apple.com/watch/" forState:UIControlStateNormal];
                    break;
                case 62952:
                    self.imgView.image = [UIImage imageNamed:@"2iPhone6S.jpg"];
                    [self.linkBtn setTitle:@"http://www.apple.com/iphone-6s/" forState:UIControlStateNormal];

                    break;
                case 40682:
                    self.imgView.image = [UIImage imageNamed:@"3macbook.jpg"];
                    [self.linkBtn setTitle:@"http://www.apple.com/mac/" forState:UIControlStateNormal];

                    break;
                    
                default:
                    self.imgView.image = nil;
                    [self.linkBtn setTitle:@"" forState:UIControlStateNormal];

                    break;
            }
            
        }
    }
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

@end
