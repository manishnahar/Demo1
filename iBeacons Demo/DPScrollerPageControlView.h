//
//  DPScrollerPageControlView.h
//  DPScrollerWithPageControl
//
//  Created by Niraj Shah on 24/04/15.
//  Copyright (c) 2015 Diaspark. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollerPageViewDataSource <NSObject>

-(NSInteger) numberOfViews:(UIView*) pageView ;
- (UIView*)pageUIView:(UIView*)pageView addViewAtIndex :(NSInteger) index;

@end


@interface DPScrollerPageControlView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic , weak) id <ScrollerPageViewDataSource> viewDataSource;
@end
