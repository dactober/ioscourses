//
//  CustomTableCell.m
//  example
//
//  Created by Aleksey Drachyov on 16.03.17.
//  Copyright (c) 2017 Aleksey Drachyov. All rights reserved.
//
#import "CustomTableCell.h"

@implementation CustomTableCell



-(void)customCellData:(CellData *)cellData{
   
    self.titleLabel.text=cellData.titleLabel;
    self.subTitleLabel.text=cellData.subTitleLabel;
    self.cellImage.image=cellData.cellImage;
               
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.subTitleLabel.preferredMaxLayoutWidth=CGRectGetWidth(self.subTitleLabel.frame);
}

@end
