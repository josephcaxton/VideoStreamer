//
//  PopUpTableviewViewController.m
//  VideoStreamer
//
//  Created by Joseph caxton-Idowu on 15/06/2012.
//  Copyright (c) 2012 caxtonidowu. All rights reserved.
//

#import "PopUpTableviewViewController.h"

@interface PopUpTableviewViewController ()

@end

@implementation PopUpTableviewViewController

@synthesize m_popover,facebook,logoutFacebook;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //listofItems = [[NSMutableArray alloc] init];
	
	// Add items to the array this is hardcoded for now .. may need to be migrated to the database
    //[listofItems addObject:@"Email to a friend"];
    //[listofItems addObject:@"Terms and Conditions"];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    
self.clearsSelectionOnViewWillAppear = NO;
self.contentSizeForViewInPopover = CGSizeMake(108,400);

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section == 0){
        
        return 1;
    }
    else
    {
        

    return 3;
    
    }



}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {

    if(indexPath.row == 0 && indexPath.section == 0){
        
        return 60;
    }
    else
        
    {
        return 50;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0 ){
        
       // UIImage* mailImage = [UIImage imageNamed:@"mail.png"];
       //cell.imageView.image = mailImage;
      
      cell.textLabel.text = @"Like what you see here? Share this app with a friend and we give you two more videos free!";
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [ UIColor blackColor ];
        cell.textLabel.backgroundColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = UITextAlignmentCenter;


    }
    else  if (indexPath.section == 1 && indexPath.row == 0){
        
        UIImage* mailImage = [UIImage imageNamed:@"mail.png"];
        cell.imageView.image = mailImage;
        cell.textLabel.text = @"Email to a friend";
        
        
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        UIImage* mailImage = [UIImage imageNamed:@"facebook.png"];
        cell.imageView.image = mailImage;
        cell.textLabel.text = @"Facebook";
        
        // Show logout facebook
       
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        
        UIImage* logoutImage = [UIImage imageNamed:@"logoutfacebook.png"];
        logoutFacebook = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        logoutFacebook.frame = CGRectMake(320, 10, 72, 22);
        [logoutFacebook setBackgroundImage:logoutImage forState:UIControlStateNormal];
        //[logoutFacebook setTitle:@"Log Out" forState:UIControlStateNormal];
            [logoutFacebook addTarget:self action:@selector(logoutButtonClicked:)forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:logoutFacebook];  
            
            
        }
	
    }
    
    else if (indexPath.section == 1 && indexPath.row == 2) {
        
        UIImage* TwitterImage = [UIImage imageNamed:@"twitter.png"];
        cell.imageView.image = TwitterImage;
        cell.textLabel.text = @"Twitter";
    
    }
	
	return cell;

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_popover dismissPopoverAnimated:YES];
    [m_popover.delegate popoverControllerDidDismissPopover:self.m_popover];
    
    if(indexPath.section == 1 && indexPath.row ==0){
        
        [self ShareThisAppViaMail:self];
        


    }
    else if (indexPath.section == 1 && indexPath.row == 1){
        
        [self ConnectToFaceBook];
        
    }
    
    else if (indexPath.section == 1 && indexPath.row == 2){
        
        [self Twit];
    }
     
}


-(IBAction)ShareThisAppViaMail:(id)sender{
	
	if ([MFMailComposeViewController canSendMail]) {
        
        
        //NSArray *SendTo = [NSArray arrayWithObjects:@"support@LearnersCloud.com",nil];
        
        MFMailComposeViewController *SendMailcontroller = [[MFMailComposeViewController alloc]init];
        SendMailcontroller.mailComposeDelegate = self;
        //[SendMailcontroller setToRecipients:SendTo];
        [SendMailcontroller setSubject:@"Get LearnersCloud app on your iPhone, iPad Tourch, or iPad"];
        
        [SendMailcontroller setMessageBody:[NSString stringWithFormat:@"Checkout the free LearnersCloud video app. Its loaded with quality revision videos from <a href=http://itunes.apple.com/us/app/maths-videos/id522347113?ls=1&mt=8>here at the app store</a> or do a search for LearnersCloud in the app store to view a list of all LearnersCloud apps. LearnersCloud is a top 20 winner of the BETT show award 2012. "] isHTML:YES];
        [self presentModalViewController:SendMailcontroller animated:YES];
        
		
	}
	
	else {
		UIAlertView *Alert = [[UIAlertView alloc] initWithTitle: @"Cannot send mail" 
                                                        message: @"Device is unable to send email in its current state. Configure email" delegate: self 
                                              cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		
		
		
		[Alert show];
		
		
	}
    
	
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
   
    if(MFMailComposeResultSent){
	
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
         // Give user one free video.
            if(![prefs objectForKey:@"AddOneFree"]){
        
                [prefs setObject:@"1" forKey:@"AddOneFree"];
                [prefs synchronize];
    
                }
        
    }
	
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
	
	
	
	
}

-(void)ConnectToFaceBook {
    
    facebook = [[Facebook alloc] initWithAppId:@"319408714808003" andDelegate:self];
    
    //Save a pointer to this object for return from facebook
     AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
     appDelegate.m_facebook = facebook;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    
    }
    
    
    if (![facebook isSessionValid]) {
        [facebook authorize:nil];
    }
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Hey!!!. I'm watching amazing maths videos on this great new app, it really helped me and i hope it helps you too. You should try it out. Download it now for your iPad, iPhone and iPod Touch",  @"message",
                                   nil];
    
    [facebook dialog:@"apprequests"
           andParams:params
         andDelegate:self];
    
}


- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    
    [defaults synchronize];
    
}

- (void)fbDidNotLogin:(BOOL)cancelled{
    
    
    
}


- (void) logoutButtonClicked:(id)sender {
    
    facebook = [[Facebook alloc] initWithAppId:@"319408714808003" andDelegate:self];
    //Save a pointer to this object for return from facebook
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.m_facebook = facebook;
    
    [facebook logout];
    
    // Remove saved authorization information if it exists
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"]) {
            [defaults removeObjectForKey:@"FBAccessTokenKey"];
            [defaults removeObjectForKey:@"FBExpirationDateKey"];
            [defaults synchronize];
        }
        
    // Dismiss the popover 
    [m_popover dismissPopoverAnimated:YES];
    [m_popover.delegate popoverControllerDidDismissPopover:self.m_popover];


}

- (void) fbDidLogout {
    

}


- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt{
    
}

- (void)fbSessionInvalidated{
    

}

- (void)dialogDidComplete:(FBDialog *)dialog {
   
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // Give user one free video.
    if(![prefs objectForKey:@"AddOneFree"]){
        
        
        [prefs setObject:@"1" forKey:@"AddOneFree"];
        [prefs synchronize];
        
    }

    
}

- (void) dialogDidNotComplete:(FBDialog *)dialog{
    
    
}

- (void)dialogCompleteWithUrl:(NSURL *)url{
    
    
}

-(void)Twit {
    
    if ([TWTweetComposeViewController canSendTweet])
    {
        NSString *UrlString = @"http://itunes.apple.com/us/app/maths-videos/id522347113?ls=1&mt=8";
        
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:@"Checkout LearnersCloud video app. Quality maths revision videos. :)"];
        [tweetSheet addURL:[NSURL URLWithString:UrlString]];
        [tweetSheet addImage:[UIImage imageNamed:@"Icon"]];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result) { 
            switch (result) {
                case TWTweetComposeViewControllerResultCancelled:                    
                    break;
                    
                case TWTweetComposeViewControllerResultDone:
                    
                    
                    // Give user one free video.
                    if(![prefs objectForKey:@"AddOneFree"]){
                        
                        [prefs setObject:@"1" forKey:@"AddOneFree"];
                        [prefs synchronize];
                        
                    }

                    
                    break;
                    
                default:
                    break;
            }
            [self dismissModalViewControllerAnimated:YES];
        };

        
        
        
	    [self presentModalViewController:tweetSheet animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"Sorry"                                                             
                                  message:@"You can't send a tweet right now, make sure  your device has an internet connection and you have at least one Twitter account setup"                                                          
                                  delegate:self                                              
                                  cancelButtonTitle:@"OK"                                                   
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}



@end
