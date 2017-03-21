//
//  ViewController.h
//  example
//
//  Created by Aleksey Drachyov on 14.03.17.
//  Copyright (c) 2017 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) NSArray *tableData;
@property (nonatomic,strong) NSDictionary *tableDictionary;

@end
static NSString *myId=@"MyId";



