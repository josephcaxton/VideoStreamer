//
//  FreeVideos.m
//  VideoStreamer
//
//  Created by Joseph caxton-Idowu on 14/03/2012.
//  Copyright (c) 2012 caxtonidowu. All rights reserved.
//

#import "FreeVideosClass.h"
#import "AppDelegate.h"
#import "ConfigObject.h"
#import "VideoPlayer.h"
#import "Buy.h"


@implementation FreeVideosClass


@synthesize ArrayofConfigObjects,ProductIDs,ImageObjects,SubscriptionStatusData;



- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Free and Subscription Videos";
	 AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // Put all the images into an array
    
    ImageObjects = [[NSMutableArray alloc] init];
    int i;
    NSString *loadString;
    
    for(i = 0; i < 113; i++) {
        loadString = [NSString stringWithFormat:@"img%d", i + 1]; 
        [ImageObjects addObject:[UIImage imageNamed:loadString]];
        
    }
	
    
    //Check SubscriptionStatus
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *MyDeviceId = [prefs stringForKey:@"LCUIID"];
    
    [self SubscriptionStatus: MyDeviceId];
	// Copy or Update the VideoConfig File;
   
    NSString *domain = appDelegate.DomainName;
    NSString *queryFeed = [NSString stringWithFormat:@"%@/iosStream/VideoConfig.xml",domain]; 
    NSString *Dir = [appDelegate.applicationDocumentsDirectory stringByAppendingPathComponent:@"VideoConfig.xml"];
    
         
   
   // if(appDelegate.isDeviceConnectedToInternet){
    
   BOOL DownloadIt =  [self ShouldIDownloadOrNot:queryFeed :Dir];
   
    if(DownloadIt == YES){
        
           NSFileManager *fileManager = [NSFileManager defaultManager];
           NSError *error=[[NSError alloc]init];
            
            BOOL success=[fileManager fileExistsAtPath:Dir];
           
            if(success)
        	{
        		[fileManager removeItemAtPath:Dir error:&error];
            }

    
        [self GetConfigFileFromServeWriteToPath:Dir];
        
    }
    
    
    
    ArrayofConfigObjects = [[NSMutableArray alloc] init];
    
    [self MyParser:Dir];
        
   // }
    //else
   // {
    
   //     [self Alertfailedconnection];
    
   // }
	
    [appDelegate.SecondThread cancel];
        
}





-(BOOL)ShouldIDownloadOrNot:(NSString*)urllPath:(NSString*)LocalFileLocation{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
   BOOL ReturnVal =  [appDelegate downloadFileIfUpdated:urllPath:LocalFileLocation];
    
    return ReturnVal;
   
    
    
    
}
-(void)GetConfigFileFromServeWriteToPath:(NSString*)Path{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *domain = appDelegate.DomainName;
    NSString *queryFeed = [NSString stringWithFormat:@"%@/iosStream/VideoConfig.xml", domain];
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:queryFeed]];
    NSURLResponse *resp = nil; 
    NSError *err = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest: theRequest returningResponse: &resp error: &err];
    
    if (response) {
        
        NSError* error;
        
        [response writeToFile:Path options:NSDataWritingAtomic error:&error];
        
        if(error != nil)
            NSLog(@"write error %@", error);
    }
    

    
    
}

-(void)Alertfailedconnection{
    
    NSString *message = [[NSString alloc] initWithFormat:@"Your device is not connected to the internet. You need access to the internet to stream our videos "];
    
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Important Notice"
                                                   message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
   

    
}

-(void)MyParser:(NSString *)FileLocation{
	
	NSError* error;
	
	NSString* fileContents = [NSString stringWithContentsOfFile:FileLocation encoding:NSWindowsCP1252StringEncoding error:&error];
	
	
	NSArray* pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"±"]];
	
	for(int idx = 0; idx < pointStrings.count - 1; idx++)
	{
		// break the string down even further to the columns
		NSString* currentPointString = [pointStrings objectAtIndex:idx];
		NSArray* arr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|"]];
		
		NSString *Title = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:1]];
		NSString *Description = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:3]];
		NSString *Free = [[NSString alloc] initWithFormat:@"%@", [arr objectAtIndex:5]];
		NSString *Subject = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:7]];
		NSString *M3u8 = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:9]];
		NSString *ThumbNail = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:11]];
        NSString *ProductID = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:13]];
		
         //if ([Show isEqualToString: @"1"]){
        
        ConfigObject *obj = [[ConfigObject alloc] init];
        obj.VideoTitle = Title;
        obj.VideoDescription = Description;
        if ([Free isEqualToString: @"1"]){
            obj.Free = YES;
        }
        else
        {
            obj.Free = NO; 
        }
        obj.Subject = Subject;
        obj.M3u8 = M3u8;
        obj.Thumbnail = ThumbNail;
        obj.ProductID = ProductID;
        [ArrayofConfigObjects addObject:obj];
        
        
       // NSLog(@"Title in my array is: %@",obj.VideoTitle);
				
		

	}
}

-(void)SubscriptionStatus:(NSString *)DeviceID{
    
    NSString *Filter =[NSString stringWithString:@"1"];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *domain = appDelegate.DomainName;
    
    
    NSString *queryString = [NSString stringWithFormat:@"%@/Services/iOS/VideoSubscription.asmx/ViewSubscriptionStatus",domain];
    NSURL *url = [NSURL URLWithString:queryString];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    NSString *FullString = [NSString stringWithFormat:@"DeviceID=%@&filter=%@&",DeviceID,Filter];
     NSData* data=[FullString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    [req addValue:contentType forHTTPHeaderField:@"Content-Length"];
    unsigned long long postLength = data.length;
    NSString *contentLength = [NSString stringWithFormat:@"%llu",postLength];
    [req addValue:contentLength forHTTPHeaderField:@"Content-Length"];
    
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:data];
    
    NSURLConnection *conn;
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (!conn) {
        NSLog(@"error while starting the connection");
    } 

    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)someData {
    
    /*ViewSubscriptionStatus returns from server:
     
     A Jason object with 
     1, DateTo
     2, EmailAddress
     3,ProductIdentifier */
    
    //NSError *myError = nil;
   // NSDictionary *res = [NSJSONSerialization JSONObjectWithData:someData options:NSJSONReadingMutableLeaves error:&myError];

   // if (![res isKindOfClass:[NSDictionary class]]) {
    //    NSLog(@"not a dict");
   // }
    if(!SubscriptionStatusData){
        SubscriptionStatusData = [[NSMutableData alloc]init ];
    }
    
    [SubscriptionStatusData appendData:someData];
     NSString *returnedString = [[NSString alloc] initWithData:someData encoding:NSUTF8StringEncoding];
     NSLog(@"%@",returnedString);
    


}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{

    NSString *returnedString = [[NSString alloc] initWithData:SubscriptionStatusData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",returnedString);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	
	int	count = 1;
	
	return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    NSInteger numberOfRows =[ArrayofConfigObjects count];
	
    return numberOfRows;
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    ConfigObject *obj = [ArrayofConfigObjects objectAtIndex:indexPath.row];
    //Change how image is loaded
    //NSString *PicLocation = [[NSString alloc] initWithFormat:@"%@",[obj Thumbnail]];
    //UIImage* theImage = [UIImage imageNamed:PicLocation];
    UIImage* theImage =[ImageObjects objectAtIndex:indexPath.row];
    cell.imageView.image = theImage;
    
    cell.textLabel.text = [obj VideoTitle];
    
    if ([obj Free] == YES){
       
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         NSString* descriptiontxt = [obj VideoDescription];
         NSString* FullDesciption = [descriptiontxt stringByAppendingString:@" - Free view"];
        cell.detailTextLabel.text =FullDesciption;
        
        
    }
    else
    {
         cell.accessoryType =  UITableViewCellAccessoryNone;
          NSString* descriptiontxt = [obj VideoDescription];
          NSString* FullDesciption = [descriptiontxt stringByAppendingString:@" - Buy"];
        cell.detailTextLabel.text = FullDesciption;
    }
   
    
    
	
	
    return cell;
	
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ConfigObject *obj = [ArrayofConfigObjects objectAtIndex:indexPath.row];
    
    if ([obj Free] == YES) {
        
    VideoPlayer *VP1 = [[VideoPlayer alloc] initWithNibName:nil bundle:nil];
    VP1.VideoFileName =[NSString stringWithString:[obj M3u8]];
    [self.navigationController pushViewController:VP1 animated:YES];
    }
    else{
        // To store for buying
        //NSLog(@"my product id is %@",[obj ProductID]);
               
        [self ConfigureProductList:[obj ProductID]];
        
        Buy *buyer = [[Buy alloc ]initWithNibName:nil bundle:nil];
        buyer.ProductsToIstore = ProductIDs;
        [self.navigationController pushViewController:buyer animated:YES];
        
        
        
    }
         


}

-(void)ConfigureProductList:(NSString *)ProductID{
    
    ProductIDs = [[NSMutableArray alloc] init];
    
    NSString* Sevendays = [ProductID stringByAppendingString:@"7days"];
    [ProductIDs addObject:Sevendays];
    
   // NSLog(@"my product id for 7 days is %@",Sevendays);
    
    NSString* OneMonth = [ProductID stringByAppendingString:@"1month"];
    [ProductIDs addObject:OneMonth];
    
   /* NSString* TwoMonths = [ProductID stringByAppendingString:@"2months"];
    [ProductIDs addObject:TwoMonths];
    
    NSString* ThreeMonths = [ProductID stringByAppendingString:@"3months"];
    [ProductIDs addObject:ThreeMonths];
    
    NSString* SixMonths = [ProductID stringByAppendingString:@"6months"];
    [ProductIDs addObject:SixMonths];
    
    NSString* OneYear = [ProductID stringByAppendingString:@"1year"];
    [ProductIDs addObject:OneYear]; */

    
    
    
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}




- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
