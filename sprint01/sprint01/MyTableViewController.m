//
//  ViewController.m
//  example
//
//  Created by Aleksey Drachyov on 14.03.17.
//  Copyright (c) 2017 Aleksey Drachyov. All rights reserved.
//
#import "MyTableViewController.h"
#import "CustomTableCell.h"

@interface MyTableViewController ()

@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableData=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TableList" ofType:@"plist"]];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.tableData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CustomTableCell *cell=(CustomTableCell *)[tableView dequeueReusableCellWithIdentifier:myId forIndexPath:indexPath];
   self.tableDictionary =[self.tableData objectAtIndex:indexPath.row];
    [cell customCellData:self.tableDictionary];
    
    return cell;
}




@end
