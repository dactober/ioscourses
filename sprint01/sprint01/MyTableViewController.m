//
//  ViewController.m
//  example
//
//  Created by Aleksey Drachyov on 14.03.17.
//  Copyright (c) 2017 Aleksey Drachyov. All rights reserved.
//
#import "AppDelegate.h"
#import "MyTableViewController.h"
#import "CustomTableCell.h"
#import "MyTableCellViewController.h"
#import "CellData.h"

@interface MyTableViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *loadData;
- (IBAction)loadData:(id)sender;
@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSURLSessionDownloadTask *downloadTask;
@property(nonatomic,strong) CustomTableCell *prototypeCell;
@property(nonatomic) Boolean b;
@end

@implementation MyTableViewController
@synthesize fetchedResultsController=_fetchedResultsController;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.session =[self backgroundSession];
    self.progressView.hidden =YES;

    NSError *error;
    if(![[self fetchedResultsController]performFetch:&error]){
        NSLog(@"Unresolver error %@, %@",error,[error userInfo]);
        exit(-1);
    }
    // Do any additional setup after loading the view, typically from a nib.
}
-(NSFetchedResultsController *)fetchedResultsController{
    if(_fetchedResultsController!=nil){
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Food" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort=[[NSSortDescriptor alloc]initWithKey:@"details.time" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];
    NSFetchedResultsController *theFetchedResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    self.fetchedResultsController=theFetchedResultsController;
    _fetchedResultsController.delegate=self;
    return _fetchedResultsController;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id sectionInfo=[[_fetchedResultsController sections]objectAtIndex:section];
    return [sectionInfo numberOfObjects];
    //return [self.tableData count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     self.prototypeCell=[self.myTableView dequeueReusableCellWithIdentifier:myId];
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    self.prototypeCell.bounds=CGRectMake(0, 0, CGRectGetWidth(self.myTableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
    [self.prototypeCell layoutIfNeeded];
    CGSize size=[self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
   
    return size.height;
}

-(void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([cell isKindOfClass:[CustomTableCell class]]){

                CustomTableCell *textCell=(CustomTableCell *)cell;
                self.tableDictionary =[self.tableData objectAtIndex:indexPath.row];
                    [textCell customCellData:[self.tableImages objectAtIndex:indexPath.row]];
    }
        }
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
CustomTableCell *cell=(CustomTableCell *)[tableView dequeueReusableCellWithIdentifier:myId forIndexPath:indexPath];
           self.tableDictionary =[self.tableData objectAtIndex:indexPath.row];
        [cell customCellData:[self.tableImages objectAtIndex:indexPath.row]];
   

    return cell;
}
-(NSURLSession *)backgroundSession
{
    static NSURLSession *session=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        NSURLSessionConfiguration *configuration=[NSURLSessionConfiguration backgroundSessionConfiguration:@"com.alekseydrachyov.sprint02"];
        session=[NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    });
    return session;
}
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    if(downloadTask.taskIdentifier==self.downloadTask.taskIdentifier){
        double progress=(double)totalBytesWritten/(double)totalBytesExpectedToWrite;
        NSLog(@"DownloadTask:%@ progress: %lf",downloadTask,progress);
        dispatch_async(dispatch_get_main_queue(),^{
            self.progressView.progress=progress;
        });
    }
}
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)downloadURL{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSArray *URLs=[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory=[URLs objectAtIndex:0];
    NSURL *originalURL=[[downloadTask originalRequest]URL];
    NSURL *destinationURL=[documentsDirectory URLByAppendingPathComponent:[originalURL lastPathComponent]];
    NSError *errorCopy;
    
    [fileManager removeItemAtURL:destinationURL error:NULL];
    BOOL success=[fileManager copyItemAtURL:downloadURL toURL:destinationURL error:&errorCopy];
    if(success){
        
        
            NSData *data=[NSData dataWithContentsOfFile:[destinationURL path]];
            NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.tableData=[json valueForKey:@"array"];
        
            for (int i=0; i<self.tableData.count; i++) {
                self.tableDictionary =[self.tableData objectAtIndex:i];
                NSURL *url=[NSURL URLWithString:[self.tableDictionary objectForKey:@"image_name"]];
                    [self loadImage:url index:i];
               }
        
    }
    else{
        NSLog(@"Error during the copy: %@",[errorCopy localizedDescription]);
    }
}
-(void)loadImage:(NSURL *)url index:(int)index{
            NSURLSessionDownloadTask *downloadPhotoTask=[[NSURLSession sharedSession]downloadTaskWithURL:url completionHandler:^(NSURL *location,NSURLResponse *response,NSError *error){
                UIImage *downloadImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                [self createCellData:index image:downloadImage];
                if(self.tableImages.count==self.tableData.count){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.progressView.hidden=YES;
                    [self.myTableView reloadData];
                        });
                }
                
            }];
            [downloadPhotoTask resume];
    
}
-(void)createCellData:(int)index image:(UIImage *)downloadImage{
    CellData *cellData=[CellData new];
    self.tableDictionary =[self.tableData objectAtIndex:index];
    [cellData initWithData:[self.tableDictionary objectForKey:@"title"] subTitile:[self.tableDictionary objectForKey:@"subtitle"] image:downloadImage ];
    [self.tableImages addObject:cellData];
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if(error==nil){
        NSLog(@"Task: %@ completed successfully",task);
        
    }
    else{
        NSLog(@"Task %@ completed with error: %@",task,[error localizedDescription]);
    }
    
    self.downloadTask=nil;
   
    
}
-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if(appDelegate.backgroundSessionCompletionHandler){
        void(^completionHandler)()=appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler=nil;
        completionHandler();
    }
    NSLog(@"All tasks are finished");
}
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"CellViewController"]){
        
        NSIndexPath *indexPath =[self.myTableView indexPathForSelectedRow];
        MyTableCellViewController *cellView=(MyTableCellViewController *)segue.destinationViewController;
       
        cellView.cellData=[self.tableImages objectAtIndex:indexPath.row];
        
        
    }
}
- (IBAction)loadData:(id)sender {
    
    [self download];
}

-(void)download{
    if(self.downloadTask)
    {
        return;
    }
    NSURL *downloadURL=[NSURL URLWithString:@"https://api.backendless.com/4B1822F6-55B7-B39A-FF0C-655867D71F00/v1/files/document.json"];
    self.tableImages=[NSMutableArray new];
    NSURLRequest *request= [NSURLRequest requestWithURL:downloadURL];
    self.downloadTask=[self.session downloadTaskWithRequest:request];
    [self.downloadTask resume];
    self.progressView.hidden=NO;
}
@end
