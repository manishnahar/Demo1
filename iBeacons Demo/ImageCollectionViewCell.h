//
//  ImageCollectionViewCell.h
//  iBeacons Demo
//
//  Created by Niraj Shah on 04/03/16.
//  Copyright © 2016 Mobient. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionViewCell : UICollectionViewCell
 @property  (nonatomic , strong) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) BOOL isImageVisible;
@end
