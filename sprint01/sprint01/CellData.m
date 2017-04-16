//
//  CellData.m
//  sprint01
//
//  Created by Aleksey Drachyov on 4/14/17.
//  Copyright (c) 2017 alekseydrachyov. All rights reserved.
//

#import "CellData.h"
@interface CellData()
@property(nonatomic,retain) NSManagedObjectModel *model;
@property(nonatomic,strong) NSManagedObjectContext *context;
@end
@implementation CellData

-(id)init{
    if(self=[super init]){
        //[self initManagedObjectModel];
        //[self initManagedObjectContext];
    }
    return self;
}
-(CellDataModel *)createCell{
    return [NSEntityDescription insertNewObjectForEntityForName:@"CellDataModel" inManagedObjectContext:self.context];
}
+(CellData *)sharedStore{
    static CellData *cellData;
    if(cellData == nil){
        cellData=[[CellData alloc]init];
    }
    return cellData;
}
-(NSArray *)cells{
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"CellDataModel"];
    NSSortDescriptor *sortDescriptor =[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSError *error;
    NSArray *cells=[self.context executeFetchRequest:fetchRequest error:&error];
    if(error!=nil){
        [NSException raise:@"Exception on retrieving artists" format:@"Error: %@",error.localizedDescription];
    }
    return cells;
}
-(void)save:(NSError *)error{
    [self.context save:&error];
}


@end
