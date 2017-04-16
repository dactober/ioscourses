//
//  CustomTableCell.h
//  example
//
//  Created by Aleksey Drachyov on 16.03.17.
//  Copyright (c) 2017 Aleksey Drachyov. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CellDataModel.h"
@interface CustomTableCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UILabel *subTitleLabel;
@property (nonatomic,strong) IBOutlet UIImageView *cellImage;
-(void)customCellData:(CellDataModel *)cellData ;

@end