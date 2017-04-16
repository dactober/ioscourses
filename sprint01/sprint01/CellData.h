//
//  CellData.h
//  sprint01
//
//  Created by Aleksey Drachyov on 4/14/17.
//  Copyright (c) 2017 alekseydrachyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CellDataModel.h"

@interface CellData : NSObject
//-(id)initWithData :(NSString *)title subTitile:(NSString *)subTitle image:(UIImage *)image;
+(CellData *)sharedStore;
-(CellDataModel*)createCell;
-(NSArray *)cells;
-(void)save:(NSError *)error;
@end
