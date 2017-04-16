//
//  CellDataModel.h
//  sprint01
//
//  Created by Aleksey Drachyov on 4/13/17.
//  Copyright (c) 2017 alekseydrachyov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CellDataModel : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;

//+(instancetype)insertCellWithObjects:(NSString*)title subTitle:(NSString*)subTitle image:(NSString*)image
//                              parent:(CellDataModel*)parent inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
//-(NSFetchedResultsController*)childrenFecthedResultsController;
@end
