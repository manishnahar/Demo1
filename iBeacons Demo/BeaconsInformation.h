//
//  BeaconsInformation.h
//  iBeacons Demo
//
//  Created by Niraj Shah on 01/03/16.
//  Copyright © 2016 Mobient. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeaconsInformation : NSObject
@property (nonatomic , strong) NSString *beaconUUID;
@property (nonatomic , strong) NSString *major;
@property (nonatomic , strong) NSString *minor;
@property (nonatomic, strong) NSString *beaconName;
@property (nonatomic , strong) NSString *beaconImage;
@end
