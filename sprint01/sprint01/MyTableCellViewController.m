//
//  MyTableCellViewController.m
//  sprint01
//
//  Created by Aleksey Drachyov on 4/3/17.
//  Copyright (c) 2017 alekseydrachyov. All rights reserved.
//

#import "MyTableCellViewController.h"
#import "CustomTableCell.h"
#import "MyTableViewController.h"
@interface MyTableCellViewController ()


@end

@implementation MyTableCellViewController
@synthesize cell;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLable.text=cell.titleLabel.text;
    self.subTitleLable.text=cell.subTitleLabel.text;
    self.cellImage.image=cell.cellImage.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
