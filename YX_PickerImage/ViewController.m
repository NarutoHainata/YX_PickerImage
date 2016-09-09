//
//  ViewController.m
//  YX_PickerImage
//
//  Created by yang on 16/9/7.
//  Copyright © 2016年 poplary. All rights reserved.
//

#import "ViewController.h"
#import <QBImagePickerController/QBImagePickerController.h>
#import "ImageCollCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,QBImagePickerControllerDelegate,ImageCollCellDelegate>

//显示图片的collection
@property (nonatomic, strong) UICollectionView *imageColl;
//弹出选择的界面
@property (nonatomic, strong) UIAlertController *imageAlertCon;
//创建数组存储选择的image
@property (nonatomic, strong) NSMutableArray *saveImage;
//图片选择器
@property (nonatomic, strong) QBImagePickerController *qbPickerController;
@end

@implementation ViewController

-(UICollectionView *)imageColl{
    
    if (!_imageColl) {
        CGRect rect = CGRectMake(0, 100, self.view.frame.size.width, 200);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _imageColl = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
        _imageColl.delegate = self;
        _imageColl.dataSource = self;
        _imageColl.backgroundColor = [UIColor whiteColor];
        
        [_imageColl registerClass:[ImageCollCell class] forCellWithReuseIdentifier:@"cellid"];
        
    }
    return _imageColl;
}
#pragma mark collectionView 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.saveImage.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == self.saveImage.count-1) {
        [cell.contentView.subviews objectAtIndex:1].hidden = YES;
    }else{
        [cell.contentView.subviews objectAtIndex:1].hidden = NO;
    }
    cell.imageShow = [self.saveImage objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80, 80);
}
//自定义cell之后不响应
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //[self presentViewController:self.imageAlertCon animated:YES completion:nil];
}
#pragma mark 存储图片的数组
- (NSMutableArray *)saveImage{
    
    if (!_saveImage) {
        _saveImage = [[NSMutableArray alloc] init];
        [_saveImage addObject:[UIImage imageNamed:@"img_add"]];
    }
    return _saveImage;
}
#pragma mark 弹出选择视图
- (UIAlertController *)imageAlertCon{
    
    if (!_imageAlertCon) {
        _imageAlertCon = [UIAlertController alertControllerWithTitle:@"选择方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *taPicAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pickerImageFormPhone];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [_imageAlertCon addAction:taPicAction];
        [_imageAlertCon addAction:photoAction];
        [_imageAlertCon addAction:cancel];
    }
    return _imageAlertCon;
}
#pragma mark 图片选择器
-(QBImagePickerController *)qbPickerController{
    
    if (!_qbPickerController) {
        _qbPickerController = [[QBImagePickerController alloc] init];
        _qbPickerController.delegate = self;
        _qbPickerController.allowsMultipleSelection = YES;
        _qbPickerController.maximumNumberOfSelection = 6;
        _qbPickerController.showsNumberOfSelectedAssets = YES;

    }
    return _qbPickerController;
}

#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.imageColl];
}
#pragma mark 选择器弹出
- (void)pickerImageFormPhone{
    
    [self presentViewController:self.qbPickerController animated:YES completion:NULL];
}
#pragma mark 选择器代理
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    NSLog(@"Selected assets:");
    NSLog(@"%@", assets);
    [self.saveImage removeAllObjects];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
        for (ALAsset * asset in assets) {
            
            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
            CGImageRef imgRef = [assetRep fullResolutionImage];   //获取高清图片
            UIImage *img = [UIImage imageWithCGImage:imgRef
                                               scale:assetRep.scale
                                         orientation:(UIImageOrientation)assetRep.orientation];
            CGImageRef ref = [asset thumbnail];    //获取缩略图
            UIImage *thumbnailImg = [[UIImage alloc]initWithCGImage:ref];
            [self.saveImage addObject:thumbnailImg];
        }
        [self.saveImage addObject:[UIImage imageNamed:@"img_add"]];
        [self.imageColl reloadData];
    }];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Canceled.");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark imagecell代理
- (void)ImageCollCellDelegateAddImage{

    [self presentViewController:self.imageAlertCon animated:YES completion:nil];
}
- (void)ImageCollCellDelegateDeleteImage:(ImageCollCell *)cell{
    
    NSIndexPath *deleIndexPath = [self.imageColl indexPathForCell:cell];
    [self.saveImage removeObjectAtIndex:deleIndexPath.row];
    [self.imageColl reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
