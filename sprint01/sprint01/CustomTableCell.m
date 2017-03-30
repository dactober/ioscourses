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
    self.titleLabel.hidden=YES;
    self.subTitleLabel.hidden=YES;
    self.cellImage.hidden=YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
    [self loadImage:dict];
    });
    
}
-(void)loadImage:(NSDictionary *)dict
{
    NSURL *url=[NSURL URLWithString:[dict objectForKey:@"image_name"]];
    
        NSURLSessionDownloadTask *downloadPhotoTask=[[NSURLSession sharedSession]downloadTaskWithURL:url completionHandler:^(NSURL *location,NSURLResponse *response,NSError *error){
        UIImage *downloadImage =[UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            dispatch_async(dispatch_get_main_queue(),^{//sync or async?
                self.cellImage.image=downloadImage;
                self.titleLabel.text=[dict objectForKey:@"title"];
                self.subTitleLabel.text=[dict objectForKey:@"subtitle"];
                
            });
            self.titleLabel.hidden=NO;
            self.subTitleLabel.hidden=NO;
            self.cellImage.hidden=NO;
            
        }];
        [downloadPhotoTask resume];
    
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.subTitleLabel.preferredMaxLayoutWidth=CGRectGetWidth(self.subTitleLabel.frame);
}

@end
