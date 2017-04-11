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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.session =[self backgroundSession];
    self.progressView.hidden =YES;
    self.b=false;
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.tableData count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     self.prototypeCell=[[CustomTableCell alloc]init];
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    self.prototypeCell.bounds=CGRectMake(0, 0, CGRectGetWidth(self.myTableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
    [self.prototypeCell layoutIfNeeded];
    CGSize size=[self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
   
    return size.height;
}

-(void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([cell isKindOfClass:[CustomTableCell class]]){
        if(self.tableImages.count==0&&self.b==false){
             self.b=true;
            for (int i=0; i<self.tableData.count; i++) {
                self.tableDictionary =[self.tableData objectAtIndex:i];
                 NSURL *url=[NSURL URLWithString:[self.tableDictionary objectForKey:@"image_name"]];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
                    [self loadImage:url];
                    });
            }}else{
                if(self.tableImages.count!=0){
                CustomTableCell *textCell=(CustomTableCell *)cell;
                self.tableDictionary =[self.tableData objectAtIndex:indexPath.row];
                CellData *cellData=[CellData new];
                    [cellData initWithData : [self.tableDictionary objectForKey:@"title"] subTitile:[self.tableDictionary objectForKey:@"subtitle"] image:[self.tableImages objectAtIndex:indexPath.row]];
                    [textCell customCellData:cellData];
                }
            }
     
        }

    }
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
CustomTableCell *cell=(CustomTableCell *)[tableView dequeueReusableCellWithIdentifier:myId forIndexPath:indexPath];
    if(self.tableImages.count!=0){
    
    CellData *cellData=[CellData new];
    self.tableDictionary =[self.tableData objectAtIndex:indexPath.row];
    
        [cellData initWithData : [self.tableDictionary objectForKey:@"title"] subTitile:[self.tableDictionary objectForKey:@"subtitle"] image:[self.tableImages objectAtIndex:indexPath.row]];
        [cell customCellData:cellData];
    }

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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *data=[NSData dataWithContentsOfFile:[destinationURL path]];
            NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            self.tableData=[json valueForKey:@"array"];
            
            [self.myTableView reloadData];
               self.progressView.hidden=YES;         
        });
            
            
       
        
    }
    else{
        NSLog(@"Error during the copy: %@",[errorCopy localizedDescription]);
    }
}
-(void)loadImage:(NSURL *)url{
    
        
    
            NSURLSessionDownloadTask *downloadPhotoTask=[[NSURLSession sharedSession]downloadTaskWithURL:url completionHandler:^(NSURL *location,NSURLResponse *response,NSError *error){
                UIImage *downloadImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                //cellData.cellImage.image=downloadImage;
                [self.tableImages addObject:downloadImage];
                if(self.tableImages.count==self.tableData.count){
                    [self.myTableView reloadData];
                }
                
            }];
            [downloadPhotoTask resume];
    
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
        CustomTableCell *cell=(CustomTableCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
        cellView.cell=cell;
        
        
    }
}
- (IBAction)loadData:(id)sender {
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
