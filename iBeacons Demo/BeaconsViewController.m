//
//  BeaconsViewController.m
//  iBeacons Demo
//
//  Created by Niraj Shah on 01/03/16.
//  Copyright © 2016 Mobient. All rights reserved.
//

#import "BeaconsViewController.h"
#import "BeaconsInformation.h"
#import "AddBeaconsDetailViewController.h"

@interface BeaconsViewController ()
@property (nonatomic, weak) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *beaconsArray;
@end

@implementation BeaconsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.beaconsArray = [NSMutableArray array];

     BeaconsInformation *beaconInformation = [[BeaconsInformation alloc] init];
    beaconInformation.beaconUUID = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    beaconInformation.major = @"56173";
    beaconInformation.minor = @"40682";
    beaconInformation.beaconName = @"Beacon1";
    beaconInformation.beaconImage = @"Beacon1.png";
    [self.beaconsArray addObject:beaconInformation];
    
    BeaconsInformation *beaconInformation1 = [[BeaconsInformation alloc] init];
    beaconInformation1.beaconUUID = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    beaconInformation1.major = @"17267";
    beaconInformation1.minor = @"16143";
    beaconInformation1.beaconName = @"Beacon2";
    beaconInformation1.beaconImage = @"Beacon2.png";
    [self.beaconsArray addObject:beaconInformation1];
    
    BeaconsInformation *beaconInformation2 = [[BeaconsInformation alloc] init];
    beaconInformation2.beaconUUID = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    beaconInformation2.major = @"40965";
    beaconInformation2.minor = @"62952";
    beaconInformation2.beaconName = @"Beacon3";
    beaconInformation2.beaconImage = @"Beacon3.png";
    [self.beaconsArray addObject:beaconInformation2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeaconsCell" forIndexPath:indexPath];
    BeaconsInformation *beaconInfo = self.beaconsArray[indexPath.row];
    cell.textLabel.text = beaconInfo.beaconName;
    cell.imageView.image = [UIImage imageNamed:beaconInfo.beaconImage];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"ProductDetail" sender:indexPath];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    AddBeaconsDetailViewController *detailViewController = [segue destinationViewController];
    NSIndexPath *indexPath = (NSIndexPath*)sender;
    detailViewController.beaconInfo = self.beaconsArray[indexPath.row];
}


@end
