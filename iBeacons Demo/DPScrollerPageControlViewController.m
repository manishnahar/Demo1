//
//  DPScrollerPageControlViewController.m
//  DPScrollerWithPageControl
//
//  Created by Niraj Shah on 23/04/15.
//  Copyright (c) 2015 Diaspark. All rights reserved.
//

#import "DPScrollerPageControlViewController.h"
#import "DPCollectionViewDataSource.h"

@interface DPScrollerPageControlViewController ()


@end

@implementation DPScrollerPageControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.pageControl.numberOfPages = [self.collectionVIew numberOfItemsInSection:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
@end
