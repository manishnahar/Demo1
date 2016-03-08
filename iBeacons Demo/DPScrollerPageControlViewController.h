//
//  DPScrollerPageControlViewController.h
//  DPScrollerWithPageControl
//
//  Created by Niraj Shah on 23/04/15.
//  Copyright (c) 2015 Diaspark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPCollectionViewDataSource.h"

@interface DPScrollerPageControlViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionVIew;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet DPCollectionViewDataSource *collectionDataSource;
@end
