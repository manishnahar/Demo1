//
//  DPCollectionViewDataSource.m
//  DPScrollerWithPageControl
//
//  Created by Niraj Shah on 23/04/15.
//  Copyright (c) 2015 Diaspark. All rights reserved.
//

#import "DPCollectionViewDataSource.h"
#import "DPCollectionViewCell.h"

@implementation DPCollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.dataSource1 numberOfViews];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DPCollectionViewCell *cell = (DPCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"DPCollectionViewCell" forIndexPath:indexPath];
    UIView *view = [self.dataSource1 addViewAtIndex:indexPath.item];
    [cell.contentView addSubview:view];
    //self.controller.view.translatesAutoresizingMaskIntoConstraints = NO;
   
        
//        view.translatesAutoresizingMaskIntoConstraints = NO;
//        NSLayoutConstraint *layoutConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:1.0];
//        NSLayoutConstraint *layoutConstraint1 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:1.0];
//
//        [cell.contentView addConstraint:layoutConstraint];
//        [cell.contentView addConstraint:layoutConstraint1];


  
//    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[vc]|"
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:views]];
//  [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[vc]|"
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:views]];
    return cell;
}

@end
