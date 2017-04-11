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
    ////self.titleLabel.hidden=YES;
    //self.subTitleLabel.hidden=YES;
    self.titleLabel=cellData.titleLabel;
    self.subTitleLabel=cellData.subTitleLabel;
    self.cellImage=cellData.cellImage;
                //self.titleLabel.hidden=NO;
                //self.subTitleLabel.hidden=NO;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.subTitleLabel.preferredMaxLayoutWidth=CGRectGetWidth(self.subTitleLabel.frame);
}

@end
