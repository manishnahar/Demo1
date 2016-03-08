//
//  DPScrollerPageControlView.m
//  DPScrollerWithPageControl
//
//  Created by Niraj Shah on 24/04/15.
//  Copyright (c) 2015 Diaspark. All rights reserved.
//

#import "DPScrollerPageControlView.h"
#import "DPCollectionViewCell.h"

IB_DESIGNABLE
@interface DPScrollerPageControlView ()

@property (nonatomic ,strong)  UIPageControl *pageControl;
@property (nonatomic ,strong)  IBInspectable  UIColor *pageControlTintColor;
@property (nonatomic ,strong)  IBInspectable  UIColor *currentPageControlTintColor;


@end

@implementation DPScrollerPageControlView

-(void)awakeFromNib{
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
     layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
   self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.pageIndicatorTintColor = self.pageControlTintColor ;
    self.pageControl.currentPageIndicatorTintColor = self.currentPageControlTintColor;
    self.pageControl.numberOfPages = 1;
    [self addSubview:self.pageControl];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    [self addSubview:collectionView];

    self.translatesAutoresizingMaskIntoConstraints = NO;
     collectionView.translatesAutoresizingMaskIntoConstraints = NO;
     self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [collectionView registerClass:[DPCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    NSDictionary *viewBindings = @{@"currentView" : self, @"collectionView" : collectionView ,  @"PageControl" : self.pageControl};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:viewBindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]-[PageControl]|" options:0 metrics:nil views:viewBindings]];
    NSLayoutConstraint *contraint1 = [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.pageControl attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:1.0];
    [self addConstraint:contraint1];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger pageCount = [self.viewDataSource numberOfViews:self];
    if (pageCount == 0) {
        pageCount = pageCount + 1;
    }
    self.pageControl.numberOfPages = pageCount;

   return pageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    BOOL hasSubView = false;
    for (UIView *subview in [cell.contentView subviews]) {
        
        hasSubView = YES;
        if (subview.tag != indexPath.item) {
            [subview removeFromSuperview];
            hasSubView = NO;
        }
    }
    if (!hasSubView) {
        
        UIView *view = [self.viewDataSource pageUIView:self addViewAtIndex:indexPath.item];
        view.tag = indexPath.item;
        [cell.contentView addSubview:view];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.bounds.size.width, self.frame.size.height - self.pageControl.frame.size.height - 10);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    self.pageControl.currentPage = scrollView.contentOffset.x/self.frame.size.width;
}

@end
