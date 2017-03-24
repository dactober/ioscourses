//
//  CustomTableCell.m
//  example
//
//  Created by Aleksey Drachyov on 16.03.17.
//  Copyright (c) 2017 Aleksey Drachyov. All rights reserved.
//
#import "CustomTableCell.h"
@implementation CustomTableCell



-(void)customCellData:(NSDictionary *)dict{
    self.cellImage.image=[UIImage imageNamed:[dict objectForKey:@"image_name"]];
    self.titleLabel.text=[dict objectForKey:@"title"];
    self.subTitleLabel.text=[dict objectForKey:@"subtitle"];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.subTitleLabel.preferredMaxLayoutWidth=CGRectGetWidth(self.subTitleLabel.frame);
}

@end
