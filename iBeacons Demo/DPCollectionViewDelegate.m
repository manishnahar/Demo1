//
//  DPCollectionViewDelegate.m
//  DPScrollerWithPageControl
//
//  Created by Niraj Shah on 23/04/15.
//  Copyright (c) 2015 Diaspark. All rights reserved.
//

#import "DPCollectionViewDelegate.h"
#import <UIKit/UIKit.h>

@implementation DPCollectionViewDelegate



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
