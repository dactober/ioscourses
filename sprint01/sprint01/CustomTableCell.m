//
//  CustomTableCell.m
//  example
//
//  Created by Aleksey Drachyov on 16.03.17.
//  Copyright (c) 2017 Aleksey Drachyov. All rights reserved.
//
#import "CustomTableCell.h"
#import "CellDataModel.h"
@implementation CustomTableCell



-(void)customCellData:(CellDataModel *)cellData {//object:(id)object{
   
    //CellDataModel* model=object;
    self.titleLabel.text=cellData.title;
    self.subTitleLabel.text=cellData.subtitle;
    self.cellImage.image=[[UIImage alloc]initWithContentsOfFile:cellData.image];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.subTitleLabel.preferredMaxLayoutWidth=CGRectGetWidth(self.subTitleLabel.frame);
}

@end
