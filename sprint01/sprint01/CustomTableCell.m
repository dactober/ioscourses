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
        titleLabel.font=[UIFont systemFontOfSize:16];
        subTitleLabel=[[UILabel alloc]init];
        subTitleLabel.font=[UIFont systemFontOfSize:10];
        cellImage=[[UIImageView alloc]init];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.cellImage];
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
    CGRect contentRect=self.contentView.bounds;
    CGFloat boundsX=contentRect.origin.x;
    CGRect frame;
    frame=CGRectMake(boundsX+10, 0, 50, 50);
    cellImage.frame=frame;
    frame=CGRectMake(boundsX+70, 5, 200, 25);
    titleLabel.frame=frame;
    frame=CGRectMake(boundsX+70, 30, 100, 15);
    subTitleLabel.frame=frame;
}
-(void)dealloc{
    [titleLabel release];
    [subTitleLabel release];
    [cellImage release];
    [super dealloc];
}
@end
