//
//  ImageCollCell.h
//  YX_PickerImage
//
//  Created by yang on 16/9/7.
//  Copyright © 2016年 poplary. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageCollCell;
@protocol ImageCollCellDelegate <NSObject>

- (void)ImageCollCellDelegateAddImage;

- (void)ImageCollCellDelegateDeleteImage:(ImageCollCell *)cell;

@end

@interface ImageCollCell : UICollectionViewCell

@property (nonatomic, weak)id<ImageCollCellDelegate>delegate;
@property (nonatomic, strong) UIImage *imageShow;

@end
