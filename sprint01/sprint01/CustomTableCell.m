//
//  CustomTableCell.m
//  example
//
//  Created by Aleksey Drachyov on 16.03.17.
//  Copyright (c) 2017 Aleksey Drachyov. All rights reserved.
//
#import "CustomTableCell.h"
@implementation CustomTableCell
@synthesize titleLabel;
@synthesize subTitleLabel;
@synthesize cellImage;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        titleLabel=[[UILabel alloc]init];
        
        subTitleLabel=[[UILabel alloc]init];
        
        cellImage=[[UIImageView alloc]init];
        
    }
    return self;
}
-(void)customCellData:(NSDictionary *)dict{
    cellImage.image=[UIImage imageNamed:[dict objectForKey:@"image_name"]];
    titleLabel.text=[dict objectForKey:@"title"];
    subTitleLabel.text=[dict objectForKey:@"subtitle"];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.subTitleLabel.preferredMaxLayoutWidth=CGRectGetWidth(self.subTitleLabel.frame);
}

@end
