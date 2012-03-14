//
//  FreeVideos.m
//  VideoStreamer
//
//  Created by Joseph caxton-Idowu on 14/03/2012.
//  Copyright (c) 2012 caxtonidowu. All rights reserved.
//

#import "FreeVideosClass.h"
#import "AppDelegate.h"

@implementation FreeVideosClass




- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Free and Subscription Videos";
	
		UIBarButtonItem *Back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(Back:)];
		self.navigationItem.leftBarButtonItem = Back;
		
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *Dir = [appDelegate.applicationDocumentsDirectory stringByAppendingPathComponent:@"VideoConfig.xml"];
    [self CheckifConfigFileExistAndDelete: Dir];
    [self GetConfigFileFromServeWriteToPath:Dir];
	
        
}



-(IBAction)Back:(id)sender{
	
	[self.navigationController popViewControllerAnimated:YES];
	
}

-(void)CheckifConfigFileExistAndDelete:(NSString*)Path{
    

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error=[[NSError alloc]init];
    BOOL success=[fileManager fileExistsAtPath:Path];
    
    if(success)
	{
		[fileManager removeItemAtPath:Path error:&error];
    }
    
}
-(void)GetConfigFileFromServeWriteToPath:(NSString*)Path{
    
    NSString *queryFeed = [NSString stringWithFormat:@"http://Stage.learnerscloud.com/iosStream/VideoConfig.xml"];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	
	int	count = 1;
	
	return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    NSInteger numberOfRows = 0;
	
    return numberOfRows;
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    

	
	
    return cell;
	
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {




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
