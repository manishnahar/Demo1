//
//  ConfigViewController.m
//  iBeacons Demo
//
//  Created by M Newill on 27/09/2013.
//  Copyright (c) 2013 Mobient. All rights reserved.
//

#import "ConfigViewController.h"

@interface ConfigViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *majerTxtField;
@property (weak, nonatomic) IBOutlet UITextField *minorTxtField;

@end

@implementation ConfigViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initBeacon];
    [self setLabels];
}

- (void)initBeacon {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:KUUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                major:[self.majerTxtField.text intValue]
                                                                minor:[self.minorTxtField.text intValue]
                                                           identifier:@"Diaspark"];
}

- (void)setLabels {
    self.uuidLabel.text = self.beaconRegion.proximityUUID.UUIDString;
    self.identityLabel.text = self.beaconRegion.identifier;
}

- (IBAction)transmitBeacon:(UIButton *)sender {
    
    [self initBeacon];
  
    self.beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                                     queue:nil
                                                                                   options:nil];
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Powered On");
        [self.peripheralManager startAdvertising:self.beaconPeripheralData];
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        NSLog(@"Powered Off");
        [self.peripheralManager stopAdvertising];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
