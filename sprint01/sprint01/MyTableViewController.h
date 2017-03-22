//
//  ViewController.h
//  example
//
//  Created by Aleksey Drachyov on 14.03.17.
//  Copyright (c) 2017 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *tableData;
@property (nonatomic,strong) NSDictionary *tableDictionary;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
static NSString *myId=@"MyId";



