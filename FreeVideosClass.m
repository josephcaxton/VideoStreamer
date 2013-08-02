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
#import "TransparentToolBar.h"
#import "Start.h"



@implementation FreeVideosClass


@synthesize ArrayofConfigObjects,filteredArrayofConfigObjects,ProductIDs,ImageObjects,ProductsSubscibedTo,FullSubscription,popover,mySearchBar,buttons,SubscribeButton,ShareButton,LoginImage,LogoutImage,LoginLogoutbtn,LoginViaLearnersCloud,FreeSamples,FreeSamples_Copy;




- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
	UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbtn setBackgroundImage:[UIImage imageNamed:@"back_arrow40.png"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    backbtn.frame=CGRectMake(0.0, 0.0, 64.0, 40.0);
    UIBarButtonItem *GoBack = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = GoBack;
    
    self.tableView.backgroundView = nil;
    NSString *BackImagePath = [[NSBundle mainBundle] pathForResource:@"Background" ofType:@"png"];
	UIImage *BackImage = [[UIImage alloc] initWithContentsOfFile:BackImagePath];
    self.view.backgroundColor = [UIColor colorWithPatternImage:BackImage];
    
    NSString *LoginImagePath = [[NSBundle mainBundle] pathForResource:@"login" ofType:@"png"];
    LoginImage = [[UIImage alloc] initWithContentsOfFile:LoginImagePath];
    
    
    
    NSString *LogoutImagePath = [[NSBundle mainBundle] pathForResource:@"logout" ofType:@"png"];
    LogoutImage = [[UIImage alloc] initWithContentsOfFile:LogoutImagePath];
    
    // Listen to notification
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(RefreshTable:) name:@"ToFreeVideoClass" object:nil];
	 
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
      //NSLog(@"Subscibed products= %@", appDelegate.SubscibedProducts);
    
    // create a toolbar where we can place some buttons, I have subclassed this to remove the default background
    TransparentToolBar* toolbar = [[TransparentToolBar alloc]
                          initWithFrame:CGRectMake(0, 0, 210, 45)];
  
   
    
   
    
    
    // create an array for the buttons
     buttons = [[NSMutableArray alloc] initWithCapacity:2];
    

    if(appDelegate.UserEmail == nil){
        
        
        LoginLogoutbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [LoginLogoutbtn setBackgroundImage:LoginImage forState:UIControlStateNormal];
        [LoginLogoutbtn addTarget:self action:@selector(LoginUser:) forControlEvents:UIControlEventTouchUpInside];
        LoginLogoutbtn.frame=CGRectMake(0.0, 0.0, 60.0, 40.0);
       
        LoginViaLearnersCloud = [[UIBarButtonItem alloc] initWithCustomView:LoginLogoutbtn];
        LoginViaLearnersCloud.tag  = 1;
        [buttons addObject:LoginViaLearnersCloud];

        
    }else
    {
        LoginLogoutbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [LoginLogoutbtn setBackgroundImage:LogoutImage forState:UIControlStateNormal];
        [LoginLogoutbtn addTarget:self action:@selector(LogoutUser:) forControlEvents:UIControlEventTouchUpInside];
        LoginLogoutbtn.frame=CGRectMake(0.0, 0.0, 71.0, 40.0);
        LoginViaLearnersCloud = [[UIBarButtonItem alloc] initWithCustomView:LoginLogoutbtn];
        LoginViaLearnersCloud.tag  = 2;
        [buttons addObject:LoginViaLearnersCloud];
        
    }
    
    /*create Report Problem Button
    UIBarButtonItem *SendSupportMail = [[UIBarButtonItem alloc] initWithTitle:@"Report Problem" style: UIBarButtonItemStyleBordered target:self action:@selector(ReportProblem:)];
    
    //self.navigationItem.rightBarButtonItem = SendSupportMail;
    
    [buttons addObject:SendSupportMail]; */
    
    // create a spacer between the buttons
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil
                               action:nil];
    [buttons addObject:spacer];
    
    // Create Share or Subscibe image button 
     UIImage *SubscribeImage = [UIImage imageNamed:@"subscribe.png"];
     UIButton *Subscribe = [UIButton buttonWithType:UIButtonTypeCustom];
    [Subscribe setBackgroundImage:SubscribeImage forState:UIControlStateNormal];
     Subscribe.tag = 1;
    Subscribe.frame = CGRectMake( 0.0, 0.0, 89, 43 );
    [Subscribe addTarget:self action:@selector(GoSubScribe:)forControlEvents:UIControlEventTouchUpInside];
    SubscribeButton = [[UIBarButtonItem alloc] initWithCustomView:Subscribe];
    
    // Share Button
     UIImage *ShareImage = [UIImage imageNamed:@"share_hit40.png"];
    UIButton *Sharebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [Sharebtn setBackgroundImage:ShareImage forState:UIControlStateNormal];
    Sharebtn.frame = CGRectMake( 0.0, 0.0, 69, 43 );
    [Sharebtn addTarget:self action:@selector(share:)forControlEvents:UIControlEventTouchUpInside];
    ShareButton = [[UIBarButtonItem alloc] initWithCustomView:Sharebtn];
         
    if(appDelegate.AccessAll == TRUE){
        
        [buttons addObject:ShareButton];
    }
    else{
    
        [buttons addObject:SubscribeButton];
    
    }
    
    // put the buttons in the toolbar
    [toolbar setItems:buttons animated:NO];
    
    // place the toolbar into the navigation bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithCustomView:toolbar];
    // Get Subscibed products from delegate
    /*if([appDelegate.SubscibedProducts count] > 0){
        
        ProductsSubscibedTo = [[NSMutableArray alloc] initWithArray:appDelegate.SubscibedProducts]; 
        
    }*/
    
    // If User is fully subscibed by logging in or by identifying via DeviceID
    FullSubscription = appDelegate.AccessAll;
    
    // Put all the images into an array
    
    ImageObjects = [[NSMutableArray alloc] init];
    int i;
    NSString *loadString;
    
    for(i = 0; i < 260; i++) {
        loadString = [NSString stringWithFormat:@"img%d", i + 1]; 
        [ImageObjects addObject:[UIImage imageNamed:loadString]];
        
    }
	
    
    
	// Copy or Update the VideoConfig File;
   
    NSString *domain = appDelegate.DomainName;
    NSString *queryFeed = [NSString stringWithFormat:@"%@/iosStreamv2/maths/MathsConfig.xml",domain];
    NSString *Dir = [appDelegate.applicationDocumentsDirectory stringByAppendingPathComponent:@"MathsConfig.xml"];
    
    
   
    if(appDelegate.isDeviceConnectedToInternet){
    
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
   filteredArrayofConfigObjects = [[NSMutableArray alloc] init];
    FreeSamples = [[NSMutableArray alloc] init];
   FreeSamples_Copy = [[NSMutableArray alloc] init];
        
    }
    else
    {
    
        [self Alertfailedconnection];
    
    }
	
    [appDelegate.SecondThread cancel];
    
    mySearchBar = [[UISearchBar alloc] init];
    mySearchBar.placeholder = @"Type a search term";
    mySearchBar.tintColor = [UIColor blackColor];
    mySearchBar.delegate = self;
    [mySearchBar sizeToFit];
    [mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [mySearchBar sizeToFit];
    self.tableView.tableHeaderView = mySearchBar;
        
}
- (void)viewWillAppear:(BOOL)animated {

    // Check if search bar is on
    if(mySearchBar.text.length > 0){
        
        [self searchBarCancelButtonClicked:mySearchBar];
        
    }

   AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //[self AdjustProductSubscribedTo];
    
    // Get Subscibed Status from delegate or Don't check if user is successfully logged in
    if(appDelegate.AccessAll == TRUE){
        
       // NSLog(@"%@",appDelegate.AccessAll);
    }
    else{
    
       // NSLog(@"%@",appDelegate.AccessAll);
        
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *DeviceID = [prefs stringForKey:@"LCUIID"];
    
    [appDelegate SubscriptionStatus: DeviceID];
    
    FullSubscription = appDelegate.AccessAll;
    
    }
    
    [ArrayofConfigObjects removeAllObjects];
    [filteredArrayofConfigObjects removeAllObjects];
    [FreeSamples removeAllObjects];
        
    NSString *Dir = [appDelegate.applicationDocumentsDirectory stringByAppendingPathComponent:@"MathsConfig.xml"]; 
   [self MyParser:Dir];
   //[self.tableView reloadData];
    
    
}

/*-(void)AdjustProductSubscribedTo{

   AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if([appDelegate.TempSubscibedProducts count] > 0){
        
        if([ProductsSubscibedTo count] > 0){
            
            [ProductsSubscibedTo removeAllObjects];
            for(int i = 0; i < [appDelegate.TempSubscibedProducts count]; i++){
                
                [ProductsSubscibedTo addObject:[appDelegate.TempSubscibedProducts objectAtIndex:i]]; 
            }
        }
        else{
            
            
            ProductsSubscibedTo = [[NSMutableArray alloc] initWithArray:appDelegate.TempSubscibedProducts]; 
            
        }
        
        
    }

    
}*/


-(void)RefreshTable:(NSNotification *)note{
    
    
   [self performSelectorOnMainThread:@selector(RefeshTable) withObject:nil waitUntilDone:NO];
}

-(void)RefeshTable{
    
    /*UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	[self navigationItem].rightBarButtonItem = barButton;
    [(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView startAnimating];*/
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //NSLog(@"%@", appDelegate.TempSubscibedProducts);
   
    NSString *Dir = [appDelegate.applicationDocumentsDirectory stringByAppendingPathComponent:@"MathsConfig.xml"];
    //[self AdjustProductSubscribedTo];
     FullSubscription = appDelegate.AccessAll;
     //NSLog(@"%@", appDelegate.TempSubscibedProducts);
     //NSLog(@"%@",  ProductsSubscibedTo);
    [ArrayofConfigObjects removeAllObjects];
    [filteredArrayofConfigObjects removeAllObjects];
    [FreeSamples removeAllObjects];
    
    [self MyParser:Dir];
    [self.tableView reloadData];
    
    //[activityIndicator stopAnimating];
    //[activityIndicator hidesWhenStopped];
    
}


-(BOOL)ShouldIDownloadOrNot:(NSString*) urllPath :(NSString*)LocalFileLocation{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BOOL ReturnVal =  [appDelegate downloadfileifUpdated:urllPath location:LocalFileLocation];
    
    return ReturnVal;
    
    
    
    
}
-(void)GetConfigFileFromServeWriteToPath:(NSString*)Path{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *domain = appDelegate.DomainName;
    NSString *queryFeed = [NSString stringWithFormat:@"%@/iosStreamv2/maths/MathsConfig.xml", domain];
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
		NSString *Sociallyfree = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:11]];
        //Reconfigure for apple approval
        //NSString *ProductID = [[NSString alloc] initWithFormat:@"%@",[arr objectAtIndex:13]];
		
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
        obj.M3u8 = [M3u8 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([Sociallyfree isEqualToString: @"1"]){
           
            obj.SociallyFree = YES;
        }
        else
        {
            obj.SociallyFree = NO; 
        }

        obj.ProductID = @"Maths";
        //NSLog(@"Product is: %@",obj.ProductID);
        /*for (int i = 0; i < ProductsSubscibedTo.count; i++) {
            
            if ([obj.ProductID isEqualToString:[ProductsSubscibedTo objectAtIndex:i]]) {
                
                //NSLog(@"Product is: %@",obj.ProductID);
                obj.Subcribed = YES;
            }
        }*/
        
        [ArrayofConfigObjects addObject:obj];
        
        if ([Free isEqualToString: @"1"]){
            
            
            [FreeSamples addObject:obj];
            
        }
        
       // NSLog(@"Title in my array is: %@",obj.VideoTitle);
				
		

	}
    FreeSamples_Copy = [FreeSamples mutableCopy];
    filteredArrayofConfigObjects = [ArrayofConfigObjects mutableCopy];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	
	int	count = 2;
	
	return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows;
    
    if(section == 0){
       
        numberOfRows = [FreeSamples count];
       
    }
    else if (section == 1)
    {
   
    numberOfRows =[filteredArrayofConfigObjects count];
    
    }
	
    return numberOfRows;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectZero];
    aView.backgroundColor = [UIColor clearColor];
    
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.origin.x + 50.0, 10, tableView.frame.size.width -12.0, 21)];
    sectionHeader.textAlignment = UITextAlignmentLeft;
    sectionHeader.backgroundColor = [UIColor clearColor];
    sectionHeader.font = [UIFont boldSystemFontOfSize:20];
    sectionHeader.textColor = [UIColor whiteColor];
     if(section == 0){
         if([FreeSamples count] > 0){
             sectionHeader.text =@"Free Samples";
         }
         else{
             sectionHeader.text =@"";
         }
     }
     else if(section == 1){
         if([filteredArrayofConfigObjects count] > 0 && FullSubscription == FALSE ){
             sectionHeader.text = @"GCSE Maths – Start today from only £1.49";
         }
         else if ([filteredArrayofConfigObjects count] > 0 && FullSubscription == TRUE ){
             sectionHeader.text = @"My Courses – GCSE Maths";
         }
         else{
             sectionHeader.text =@"";
         }
     }
    
    [aView addSubview:sectionHeader];
    return aView;
    
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0 ){
       
        ConfigObject *obj = [FreeSamples objectAtIndex:indexPath.row];
        UIImage* theImage =[ImageObjects objectAtIndex:arc4random() % 259];
        cell.imageView.image = theImage;
        
        cell.textLabel.text = [obj VideoTitle];
        
        NSString* descriptiontxt = [obj VideoDescription];
        
        
        cell.detailTextLabel.text =descriptiontxt;
        cell.detailTextLabel.textColor = [UIColor blueColor];
        UIImage *FreeImage = [UIImage imageNamed:@"free.png"];
        UIButton *btnFree = [UIButton buttonWithType:UIButtonTypeCustom];
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown)
        {
            btnFree.frame = CGRectMake(650, 5, 72, 35);
        }
        else{
            
            btnFree.frame = CGRectMake(900, 5, 72, 35);
        }
        
        [btnFree setBackgroundImage:FreeImage forState:UIControlStateNormal];
        btnFree.tag = indexPath.row;
        [btnFree addTarget:self action:@selector(ViewFreeSectionOne:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btnFree];

        
    }
    
    else if(indexPath.section == 1){
    ConfigObject *obj = [filteredArrayofConfigObjects objectAtIndex:indexPath.row];
       
    // Here i am picking up image randomly in which case i don't have to add any more images to bundle
     UIImage* theImage =[ImageObjects objectAtIndex:arc4random() % 259];
    cell.imageView.image = theImage;
    
    cell.textLabel.text = [obj VideoTitle];
    
       // Is user Subscribed?
    if(FullSubscription == TRUE){
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString* descriptiontxt = [obj VideoDescription];
        NSString* FullDesciption = [descriptiontxt stringByAppendingString:@""];
        cell.detailTextLabel.text =FullDesciption;
        cell.detailTextLabel.textColor = [UIColor blueColor];
        
    }
    // Sorry mate you have to buy
    else
    {
        
        
          NSString* descriptiontxt = [obj VideoDescription];
         cell.detailTextLabel.text = descriptiontxt;
         cell.detailTextLabel.textColor = [UIColor redColor];
        
    

    }
   
    }
    
	
	
    return cell;
	
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
         ConfigObject *obj = [FreeSamples objectAtIndex:indexPath.row];
        VideoPlayer *VP1 = [[VideoPlayer alloc] initWithNibName:nil bundle:nil];
        VP1.FreeView = self;
        VP1.VideoFileName =[NSString stringWithString:[obj M3u8]];
        
        [self.navigationController pushViewController:VP1 animated:YES];
        
    }
    else
    {

    ConfigObject *obj = [filteredArrayofConfigObjects objectAtIndex:indexPath.row];
    
    if (FullSubscription == TRUE) {
        
    VideoPlayer *VP1 = [[VideoPlayer alloc] initWithNibName:nil bundle:nil];
    VP1.FreeView = self;
    VP1.VideoFileName =[NSString stringWithString:[obj M3u8]];
        
    [self.navigationController pushViewController:VP1 animated:YES];
    }
    else if ([obj SociallyFree] == YES){
        // Have you shared if so view video
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        if([[prefs objectForKey:@"AddOneFree"] isEqualToString:@"1"]){
            
            VideoPlayer *VP1 = [[VideoPlayer alloc] initWithNibName:nil bundle:nil];
            VP1.FreeView = self;
            VP1.VideoFileName =[NSString stringWithString:[obj M3u8]];
            [self.navigationController pushViewController:VP1 animated:YES];
            
        }
        
        else {
            
            UIAlertView *alertView = [[UIAlertView alloc] 
                                      initWithTitle:@"Sorry"                                                             
                                      message:@"You can only view this video for free if you share"                                                          
                                      delegate:self                                              
                                      cancelButtonTitle:@"OK"                                                   
                                      otherButtonTitles:nil];
            [alertView show];
            
            return;
        
        }
        
    }
    
    else{
        // To store for buying
        //NSLog(@"my product id is %@",[obj ProductID]);
               
        [self ConfigureProductList:[obj ProductID]];
        
        Buy *buyer = [[Buy alloc ]initWithNibName:nil bundle:nil];
        buyer.ProductsToIstore = ProductIDs;
        //NSLog(@"%@",ProductIDs);
        [self.navigationController pushViewController:buyer animated:YES];
        
        
        
    }
}
    


}

-(IBAction)ViewFree:(UIButton*)sender{
    
    int tag = sender.tag;
    
    ConfigObject *obj = [filteredArrayofConfigObjects objectAtIndex:tag];
    VideoPlayer *VP1 = [[VideoPlayer alloc] initWithNibName:nil bundle:nil];
    VP1.FreeView = self;
    VP1.VideoFileName =[NSString stringWithString:[obj M3u8]];
    
    [self.navigationController pushViewController:VP1 animated:YES];

    
    
    
    
    
}

-(IBAction)ViewFreeSectionOne:(UIButton*)sender{
    
    int tag = sender.tag;
    
    ConfigObject *obj = [FreeSamples objectAtIndex:tag];
    VideoPlayer *VP1 = [[VideoPlayer alloc] initWithNibName:nil bundle:nil];
    VP1.FreeView = self;
    VP1.VideoFileName =[NSString stringWithString:[obj M3u8]];
    
    [self.navigationController pushViewController:VP1 animated:YES];
    
}

-(IBAction)GoSubScribe:(UIButton*)sender{
    
    int tag = sender.tag;
    
    ConfigObject *obj = [filteredArrayofConfigObjects objectAtIndex:tag];
    
    [self ConfigureProductList:[obj ProductID]];
    
    Buy *buyer = [[Buy alloc ]initWithNibName:nil bundle:nil];
    buyer.ProductsToIstore = ProductIDs;
    //NSLog(@"%@",ProductIDs);
    [self.navigationController pushViewController:buyer animated:YES];
    
    
    
}


-(void)ConfigureProductList:(NSString *)ProductID{
    
    ProductIDs = [[NSMutableArray alloc] init];
    
    NSString* OneWeek = [ProductID stringByAppendingString:@"1week"];
    [ProductIDs addObject:OneWeek];
    
    NSString* OneMonth = [ProductID stringByAppendingString:@"1month"];
    [ProductIDs addObject:OneMonth];
    
    NSString* ThreeMonths = [ProductID stringByAppendingString:@"3months"];
    [ProductIDs addObject:ThreeMonths];
    
    NSString* SixMonths = [ProductID stringByAppendingString:@"6months"];
    [ProductIDs addObject:SixMonths];
    
    NSString* NineMonths = [ProductID stringByAppendingString:@"9months"];
    [ProductIDs addObject:NineMonths];
    
    NSString* TwelveMonths = [ProductID stringByAppendingString:@"12months"];
    [ProductIDs addObject:TwelveMonths]; 

    
    
    
    
    
}
// For ios 6
-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
    
}
//ios 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}



- (IBAction)share:(id)sender{
    UIButton *button = (UIButton*)sender;
    //UIView *button = [Barbutton valueForKey:@"view"];
    
    PopUpTableviewViewController *tableViewController = [[PopUpTableviewViewController alloc] initWithStyle:UITableViewStylePlain];
    
    
   popover = [[UIPopoverController alloc] initWithContentViewController:tableViewController];
   tableViewController.m_popover = popover;
  [popover setPopoverContentSize:CGSizeMake(420, 380) animated:YES];

   [popover presentPopoverFromRect:CGRectMake(button.frame.size.width / 2, button.frame.size.height / 1, 1, 1) inView:button permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
   
}



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
    
    if(popover){
        
        [popover dismissPopoverAnimated:YES];
        [popover.delegate popoverControllerDidDismissPopover:self.popover];
        
    }
    [self.tableView reloadData];
    
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1 ){
        
        [self reviewPressed];
        
    }
    else  {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *ReviewID = [prefs stringForKey:@"Review"];
        NSInteger Counter = [ReviewID integerValue];
        NSInteger CounterPlus = Counter + 1;
        NSString *ID = [NSString stringWithFormat:@"%d",CounterPlus];
        [prefs setObject:ID  forKey:@"Review"];
        [prefs synchronize];
        
    }
    
            
}

        

    

- (void)reviewPressed {
    
    //Set user has reviewed.
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *ID = @"1";
    [prefs setObject:ID forKey:@"IHaveLeftReview"];
    
    [prefs synchronize];
    
    // Report to  analytics
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"User Sent to Review Math Videos iPad at app store"
                                         action:@"User Sent to Review Math Videos iPad at app store"
                                          label:@"User Sent to Review Math Videos iPad at app store"
                                          value:1
                                      withError:&error]) {
        NSLog(@"error in trackEvent");
    }
    
    
    NSString *str = @"https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=522347113&type=Purple+Software"; 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    mySearchBar.showsCancelButton = YES;
    mySearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    //empty previous search results
    [filteredArrayofConfigObjects removeAllObjects];
    [FreeSamples removeAllObjects];
    [self.tableView reloadData];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    mySearchBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    //empty previous search results
    [filteredArrayofConfigObjects removeAllObjects];
    [FreeSamples removeAllObjects];
     NSString *searchString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([searchString isEqualToString:@""] || searchString==nil){
        //show original dataset records
        filteredArrayofConfigObjects = [ArrayofConfigObjects mutableCopy];
        FreeSamples = [FreeSamples_Copy mutableCopy];
        [self.tableView reloadData];
    }
    
    else {
        
        for(ConfigObject *obj in ArrayofConfigObjects){
            
            NSRange foundInTitle = [[obj.VideoTitle lowercaseString] rangeOfString:[searchString lowercaseString]];
            
            if(foundInTitle.location != NSNotFound){
                
                [filteredArrayofConfigObjects addObject:obj];
                
            }else {
                
                NSRange foundInDescrption = [[obj.VideoDescription lowercaseString] rangeOfString:[searchString lowercaseString]];
                
                if(foundInDescrption.location != NSNotFound){
                    
                     [filteredArrayofConfigObjects addObject:obj];
                }
            }
        }
       
         [self.tableView reloadData];
    
        }

    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [filteredArrayofConfigObjects removeAllObjects];
    filteredArrayofConfigObjects = [ArrayofConfigObjects mutableCopy];
    [FreeSamples removeAllObjects];
    FreeSamples = [FreeSamples_Copy mutableCopy];
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)goBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)LogoutUser:(id)sender{
   
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.FlagToLoginOrLogout = [NSNumber numberWithInt:2];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(IBAction)LoginUser:(id)sender{
    
  AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.FlagToLoginOrLogout = [NSNumber numberWithInt:1];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
