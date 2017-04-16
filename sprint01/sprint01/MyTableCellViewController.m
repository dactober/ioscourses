//
//  MyTableCellViewController.m
//  sprint01
//
//  Created by Aleksey Drachyov on 4/3/17.
//  Copyright (c) 2017 alekseydrachyov. All rights reserved.
//

#import "MyTableCellViewController.h"
@interface MyTableCellViewController ()



@end

@implementation MyTableCellViewController

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
    self.titleLable.text=self.cellData.title;
    self.subTitleLable.text=self.cellData.subtitle;
    self.cellImage.image=[[UIImage alloc]initWithContentsOfFile:self.cellData.image];
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
