//
//  MyTableCellViewController.h
//  sprint01
//
//  Created by Aleksey Drachyov on 4/3/17.
//  Copyright (c) 2017 alekseydrachyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDataModel.h"

@interface MyTableCellViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLable;
@property(strong,nonatomic)CellDataModel *cellData;

@end
