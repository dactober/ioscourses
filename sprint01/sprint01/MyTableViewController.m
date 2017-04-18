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
#import "CellDataModel.h"

@interface MyTableViewController ()
@property(nonatomic,retain) NSManagedObjectModel *model;
@property(nonatomic,strong) NSManagedObjectContext *context;
@property(nonatomic,strong)NSMutableDictionary *cachedImages;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *loadData;
- (IBAction)loadData:(id)sender;
@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSURLSessionDownloadTask *downloadTask;
@property(nonatomic,strong) CustomTableCell *prototypeCell;
@property (nonatomic,strong)NSMutableArray *cells;
@property (nonatomic)NSUInteger number;
@property(nonatomic,strong)NSFileManager *fileManager;
@property(nonatomic,strong)NSString *tempFolderPath;
@end

@implementation MyTableViewController
@synthesize fetchedResultsController=_fetchedResultsController;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fileManager=[NSFileManager defaultManager];
    NSArray *URLs=[self.fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory=[URLs objectAtIndex:0];
    
    self.tempFolderPath=[documentsDirectory.path stringByAppendingPathComponent:@"Temp"];
    if(![self.fileManager fileExistsAtPath:self.tempFolderPath]){
        NSError *error=nil;
        if(![self.fileManager createDirectoryAtPath:self.tempFolderPath withIntermediateDirectories:YES attributes:nil error:&error]){
            NSLog(@"Error:%@",error.localizedDescription);
        }
    }
   // [self.fileManager removeItemAtPath:self.tempFolderPath error:nil];
    NSError *error;
    _cachedImages=[NSMutableDictionary dictionary];
   // [[NSFileManager defaultManager]removeItemAtPath:[self storeURL].path error:&error];
    [self managedObjectModel];
    [self setupManagedObjectContext];
    //[self deleteAllObjects:@"CellDataModel"];
    
    if(![[self fetchedResultsController]performFetch:&error]){
        NSLog(@"Unresolved error %@,%@",error,[error userInfo]);
        exit(-1);
    }
    self.session =[self backgroundSession];
    self.progressView.hidden =YES;
   
    // Do any additional setup after loading the view, typically from a nib.
}
//-(void)deleteAllObjects:(NSString *)entityDescription{
//    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
//    NSEntityDescription *entity=[NSEntityDescription entityForName:entityDescription inManagedObjectContext:self.context];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    NSArray *items=[self.context executeFetchRequest:fetchRequest error:&error];
//    for(NSManagedObject *managedObject in items){
//        [self.context deleteObject:managedObject];
//    }
//}
-(void)viewDidUnload{
    [super viewDidUnload];
    self.fetchedResultsController=nil;
}
-(NSFetchedResultsController *)fetchedResultsController{
    if(_fetchedResultsController!=nil){
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CellDataModel" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort=[[NSSortDescriptor alloc]initWithKey:@"title" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];
    NSFetchedResultsController *theFethResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController=theFethResultsController;
    _fetchedResultsController.delegate=self;
    return _fetchedResultsController;
}
-(NSURL*)storeURL{
    NSURL *url=[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    return [url URLByAppendingPathComponent:@"store.sqlite"];
}

-(void)managedObjectModel{
    NSURL *momdURL=[[NSBundle mainBundle]URLForResource:@"Model" withExtension:@"momd"];
    self.model=[[NSManagedObjectModel alloc]initWithContentsOfURL:momdURL];
}
-(void)setupManagedObjectContext{
    self.context=[[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.context.persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.model];
    NSError* error;
    [self.context.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:nil error:&error];
    if(error){
        NSLog(@"error %@",error);
        
    }
    self.context.undoManager=[[NSUndoManager alloc]init];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //return 1;
    return [[[self fetchedResultsController]sections]count];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex{
    
    id sectionInfo=[[_fetchedResultsController sections]objectAtIndex:sectionIndex];
    self.number =[sectionInfo numberOfObjects];
    return self.number;
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     self.prototypeCell=[self.myTableView dequeueReusableCellWithIdentifier:myId];
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    self.prototypeCell.bounds=CGRectMake(0, 0, CGRectGetWidth(self.myTableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
    [self.prototypeCell layoutIfNeeded];
    CGSize size=[self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
   
    return size.height+2;
}

-(void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([cell isKindOfClass:[CustomTableCell class]]){

                CustomTableCell *textCell=(CustomTableCell *)cell;
        CellDataModel *cellDataModel=[_fetchedResultsController objectAtIndexPath:indexPath];
            [textCell customCellData:cellDataModel];
        
        
    }
        }
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableCell *cell=(CustomTableCell *)[tableView dequeueReusableCellWithIdentifier:myId forIndexPath:indexPath];
    CellDataModel *cellDataModel=[_fetchedResultsController objectAtIndexPath:indexPath];
    
    void(^callback)(UIImage*)=^(UIImage *downloadedImage){
        dispatch_async(dispatch_get_main_queue(), ^{
            
        cell.cellImage.image=downloadedImage;
        });
    };
    
    self.tableDictionary =[self.tableData objectAtIndex:indexPath.row];
    NSURL *url=[NSURL URLWithString:cellDataModel.image];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self loadImage:url callback:callback];
    });
    
    [cell customCellData:cellDataModel];
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
        dispatch_async(dispatch_get_main_queue(),^{
    
            for(NSInteger i=self.number;i<self.tableData.count;i++){
            self.tableDictionary=[self.tableData objectAtIndex:i];
            CellDataModel *newCell=[NSEntityDescription insertNewObjectForEntityForName:@"CellDataModel" inManagedObjectContext:self.context];
            [self createCellData:self.tableDictionary newCell:newCell];
        }
            NSError *mocSaveError=nil;
            if(![self.context save:&mocSaveError]){
                NSLog(@"Save did not complete successfully. Error: %@",[mocSaveError localizedDescription]);
            }
                self.progressView.hidden=YES;
                [self.myTableView reloadData];
            
            
        });
        
    }
    else{
        NSLog(@"Error during the copy: %@",[errorCopy localizedDescription]);
    }
}
-(void)loadImage:(NSURL *)url callback:(void(^)(UIImage*))callback{
            NSURLSessionDownloadTask *downloadPhotoTask=[[NSURLSession sharedSession]downloadTaskWithURL:url completionHandler:^(NSURL *location,NSURLResponse *response,NSError *error){
                //NSString *tempDirectory=NSTemporaryDirectory();
                NSURL *originalURL=[response URL];
                NSString *fileName=[originalURL lastPathComponent];
                NSError *errorCopy;
                //[fileManager removeItemAtURL:destinationURL error:NULL];
                if(![self.fileManager fileExistsAtPath:self.tempFolderPath]){
                    NSError *error=nil;
                    if(![self.fileManager createDirectoryAtPath:self.tempFolderPath withIntermediateDirectories:YES attributes:nil error:&error]){
                        NSLog(@"Error:%@",error.localizedDescription);
                    }
                }
                if([self.fileManager fileExistsAtPath:[self.tempFolderPath stringByAppendingString:[originalURL lastPathComponent]]]){
                    [self.fileManager removeItemAtPath:[self.tempFolderPath stringByAppendingString:[originalURL lastPathComponent]] error:nil];
                }
                [self.fileManager copyItemAtPath:location.path toPath:[self.tempFolderPath  stringByAppendingPathComponent:[originalURL lastPathComponent]] error:&errorCopy];
                
                    NSURL *destinationURL=[NSURL fileURLWithPath:[self.tempFolderPath stringByAppendingPathComponent:fileName]];
                  //  destinationURL=[NSURL fileURLWithPath:[tempDirectory lastPathComponent]];
                _cachedImages[url]=destinationURL;
                UIImage *image=[[UIImage alloc]initWithContentsOfFile:[_cachedImages[url] path]];
                callback(image);
               
                
                
            }];
            [downloadPhotoTask resume];
    
}
-(CellDataModel *)createCellData:(NSDictionary*)dictionary newCell:(CellDataModel *)newCell{
    
    newCell.title=[dictionary objectForKey:@"title"];
    newCell.subtitle=[dictionary objectForKey:@"subtitle"];
    newCell.image=[dictionary objectForKey:@"image_name"];
    
    
    return newCell;
}
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.myTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.myTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.myTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.myTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.myTableView endUpdates];
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
        CellDataModel *cell=[_fetchedResultsController objectAtIndexPath:indexPath];
        cellView.cellData=cell;
        cellView.imagePath=_cachedImages[[NSURL URLWithString:cell.image]] ;
        
        
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
    self.cellArray=[NSMutableArray new];
    NSURLRequest *request= [NSURLRequest requestWithURL:downloadURL];
    self.downloadTask=[self.session downloadTaskWithRequest:request];
    [self.downloadTask resume];
    self.progressView.hidden=NO;
}
@end
