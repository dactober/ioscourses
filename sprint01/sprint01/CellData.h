//
//  CellData.h
//  sprint01
//
//  Created by Aleksey Drachyov on 4/10/17.
//  Copyright (c) 2017 alekseydrachyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellData : NSObject
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong)  UIImageView *cellImage;
-(void)initWithData :(UILabel *)title subTitile:(UILabel *)subTitle image:(UIImage *)image;
@end
