//
//  CustomTableCell.h
//  example
//
//  Created by Aleksey Drachyov on 16.03.17.
//  Copyright (c) 2017 Aleksey Drachyov. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface CustomTableCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UIImageView *cellImage;
-(void)customCellData:(NSDictionary*)dict;

@end