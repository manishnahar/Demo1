//
//  DPCollectionViewDataSource.h
//  DPScrollerWithPageControl
//
//  Created by Niraj Shah on 23/04/15.
//  Copyright (c) 2015 Diaspark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ViewDataSource <NSObject>
- (NSInteger)numberOfViews;
- (UIView *)addViewAtIndex:(NSInteger)index;
@end

@interface DPCollectionViewDataSource : NSObject
@property (nonatomic ,  weak) id <ViewDataSource> dataSource1;
@property (nonatomic ,  weak) id  hello;
@end
