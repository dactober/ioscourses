//
//  CellData.m
//  sprint01
//
//  Created by Aleksey Drachyov on 4/10/17.
//  Copyright (c) 2017 alekseydrachyov. All rights reserved.
//

#import "CellData.h"

@implementation CellData
-(void)initWithData :(UILabel *)title subTitile:(UILabel *)subTitle image:(UIImage *)image{
    self.titleLabel=title;
    self.subTitleLabel=subTitle;
    self.cellImage=[[UIImageView alloc]initWithImage:image ];
}


@end