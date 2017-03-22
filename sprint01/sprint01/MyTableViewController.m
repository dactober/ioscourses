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
@property (weak, nonatomic) IBOutlet UIButton *loadData;
- (IBAction)loadData:(id)sender;
@property (strong,nonatomic) NSMutableDictionary *dictionaryOfCells;
@property(nonatomic,strong) CustomTableCell *prototypeCell;
@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.tableData count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     self.prototypeCell=[self.myTableView dequeueReusableCellWithIdentifier:myId];
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    self.prototypeCell.bounds=CGRectMake(0, 0, CGRectGetWidth(self.myTableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
    [self.prototypeCell layoutIfNeeded];
    CGSize size=[self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
   
    return size.height+1;
}

-(void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([cell isKindOfClass:[CustomTableCell class]]){
        CustomTableCell *textCell=(CustomTableCell *)cell;
        self.tableDictionary =[self.tableData objectAtIndex:indexPath.row];
        [textCell customCellData:self.tableDictionary];

    }
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CustomTableCell *cell=(CustomTableCell *)[tableView dequeueReusableCellWithIdentifier:myId forIndexPath:indexPath];
    
    self.tableDictionary =[self.tableData objectAtIndex:indexPath.row];
    [cell customCellData:self.tableDictionary];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}




- (IBAction)loadData:(id)sender {
    
   
        self.tableData=[NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TableList" ofType:@"plist"]];
    [self.myTableView reloadData];
    
    
    
}
@end
