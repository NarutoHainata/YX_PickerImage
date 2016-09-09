//
//  ImageCollCell.m
//  YX_PickerImage
//
//  Created by yang on 16/9/7.
//  Copyright © 2016年 poplary. All rights reserved.
//

#import "ImageCollCell.h"
@interface ImageCollCell()

@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *deleBtn;

@end
@implementation ImageCollCell

- (UIButton *)addBtn{
    
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] initWithFrame:self.bounds];
        _addBtn.layer.borderWidth = 0.5;
        _addBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}
-(UIButton *)deleBtn{
    
    if (!_deleBtn) {
        _deleBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-20, 0, 20, 20)];
        [_deleBtn setImage:[UIImage imageNamed:@"compose_photo_close"] forState:UIControlStateNormal];
        [_deleBtn addTarget:self action:@selector(deleClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleBtn;
}

- (id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.addBtn];
        [self.contentView addSubview:self.deleBtn];
    }
    return self;
}

// 重写赋值属性的setter方法（会在赋值的时候调用）
- (void)setImageShow:(UIImage *)imageShow{
    _imageShow = imageShow;
    
    [self.addBtn setImage:_imageShow forState:UIControlStateNormal];
    
//    if ([self.addBtn.currentImage isEqual:[UIImage imageNamed:@"img_add"]]) {
//        [self.deleBtn setImage:[UIImage imageNamed:@""] forState: UIControlStateNormal];
//    }
    
    
//    // 处理没有图片的cell的删除按钮
//    self.deleteImageView.hidden = (_addImage == nil);
//    // 给按钮添加图片
//    //    [self.addImageView setBackgroundImage:_addImage == nil ? [UIImage imageNamed:@"compose_pic_add"] : _addImage forState:UIControlStateNormal];
//    if (_addImage) {
//        [self.addImageView setBackgroundImage:_addImage forState:UIControlStateNormal];
//        [self.addImageView setBackgroundImage:_addImage forState:UIControlStateHighlighted];
//    }else {
//        [_addImageView setBackgroundImage:[UIImage imageNamed:@"compose_pic_add_highlighted"] forState:UIControlStateHighlighted];
//        [_addImageView setBackgroundImage:[UIImage imageNamed:@"compose_pic_add"] forState:UIControlStateNormal];
//    }
}
- (void)addClick{
    
    if ([self.delegate respondsToSelector:@selector(ImageCollCellDelegateAddImage)]) {
        [self.delegate ImageCollCellDelegateAddImage];
    }
}
- (void)deleClick{
    
    if ([self.delegate respondsToSelector:@selector(ImageCollCellDelegateDeleteImage:)]) {
        [self.delegate ImageCollCellDelegateDeleteImage:self];
    }
    
}
@end
