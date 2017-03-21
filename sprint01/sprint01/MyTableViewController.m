//
//  ViewController.m
//  example
//
//  Created by Aleksey Drachyov on 14.03.17.
//  Copyright (c) 2017 Aleksey Drachyov. All rights reserved.
//
//@class CustomTableCell;
#import "MyTableViewController.h"
#import "CustomTableCell.h"

@interface MyTableViewController ()

@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableData=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TableList" ofType:@"plist"]];
    UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen]bounds] style:UITableViewStylePlain];
    self.mainTableView = tableView;
    
    
    [self.mainTableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    self.mainTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.mainTableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;

    self.mainTableView.delegate=self;
    self.mainTableView.dataSource=self;
    [self.mainTableView reloadData];
    [self.mainTableView registerClass:[CustomTableCell class] forCellReuseIdentifier:myId];
    [self.view addSubview:self.mainTableView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.tableData count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
   return @"Food";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CustomTableCell *cell=(CustomTableCell *)[self.mainTableView dequeueReusableCellWithIdentifier:myId forIndexPath:indexPath];
   self.tableDictionary =[self.tableData objectAtIndex:indexPath.row];
    [cell customCellData:self.tableDictionary];
    
    return cell;
}




@end
