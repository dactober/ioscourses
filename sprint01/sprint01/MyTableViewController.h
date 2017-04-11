//
//  ViewController.h
//  example
//
//  Created by Aleksey Drachyov on 14.03.17.
//  Copyright (c) 2017 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData/CoreData.h"
@interface MyTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDownloadDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic,strong) NSMutableArray *tableData;
@property (nonatomic,strong) NSDictionary *tableDictionary;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,strong) NSMutableArray *tableImages;
@end
static NSString *myId=@"MyId";



