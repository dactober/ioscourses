//
//  CellData.h
//  sprint01
//
//  Created by Aleksey Drachyov on 4/10/17.
//  Copyright (c) 2017 alekseydrachyov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellData : NSObject
@property (nonatomic,strong) NSString *titleLabel;
@property (nonatomic,strong) NSString *subTitleLabel;
@property (nonatomic,strong)  UIImage *cellImage;
-(void)initWithData :(NSString *)title subTitile:(NSString *)subTitle image:(UIImage *)image;
@end
