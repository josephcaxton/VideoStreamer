//
//  Start.m
//  VideoStreamer
//
//  Created by Joseph caxton-Idowu on 13/03/2012.
//  Copyright (c) 2012 caxtonidowu. All rights reserved.
//

#import "Start.h"
#import "FreeVideosClass.h"
#import "AppDelegate.h"

@implementation Start

@synthesize FirstView,FreeVideos,BtnTransfermysubscription,RentaVideo,Image,ImageView,UsernameText,PasswordText,textField,ReponseFromServer,PassageFlag;

#define SCREEN_WIDTH  768    
#define SCREEN_HEIGHT 950



- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.navigationItem.title = @"www.LearnersCloud.com";
    CGRect FirstViewframe = CGRectMake(0 ,0, SCREEN_WIDTH, SCREEN_HEIGHT);
	self.FirstView = [[UIView alloc] initWithFrame:FirstViewframe];
    
    
    Image = [UIImage imageNamed:@"MathsBackground.png"];
    ImageView = [[UIImageView alloc] initWithImage:Image];
   // ImageView.frame = CGRectMake(0 ,0, 540, 950);
    ImageView.frame = CGRectMake(60 ,200, 640, 480);

    
   // UIColor *patternColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Cinema_port.png"]];

    [FirstView addSubview:ImageView];

    [self.view addSubview:FirstView];
    
   
    FreeVideos = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [FreeVideos setTitle:@"Start here to view free and subscription videos!" forState:UIControlStateNormal];
    FreeVideos.frame = CGRectMake(85 ,100, 600, 44);
   // UIImage *FreeVideosbuttonImage = [UIImage imageNamed:@"YellowBackground.png"];
   // [FreeVideos setBackgroundImage:FreeVideosbuttonImage forState:UIControlStateNormal];
    

    [FreeVideos addTarget:self action:@selector(ViewFreeVideos:) forControlEvents:UIControlEventTouchUpInside];
    
    [FirstView addSubview:FreeVideos];
    
    
    
    BtnTransfermysubscription = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [BtnTransfermysubscription setTitle:@"Transfer my subscription to this device" forState:UIControlStateNormal];
    [BtnTransfermysubscription setTitleColor:[UIColor redColor] forState: UIControlStateNormal];
    BtnTransfermysubscription.frame = CGRectMake(400 ,700, 300, 44);
   // UIImage *BtnTransfermysubscriptionbuttonImage = [UIImage imageNamed:@"blueBackground.png"];
    //[BtnTransfermysubscription setBackgroundImage:BtnTransfermysubscriptionbuttonImage forState:UIControlStateNormal];
    
    [BtnTransfermysubscription addTarget:self action:@selector(TransferSubscription:) forControlEvents:UIControlEventTouchUpInside];
    
    [FirstView addSubview:BtnTransfermysubscription];

   
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

-(IBAction)ViewFreeVideos:(id)sender{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.SecondThread = [[NSThread alloc]initWithTarget:self selector:@selector(AddProgress) object:nil];
    [appDelegate.SecondThread start];

   
    FreeVideosClass *Free_View = [[FreeVideosClass alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:Free_View animated:YES];
    
    
}

-(IBAction)TransferSubscription:(id)sender{
    
    NSString *myTitle = [[NSString alloc] initWithString:@"Enter your details"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:myTitle message:@"\n \n \n \n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    
    UsernameText = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 60.0, 260.0, 30.0)];
    UsernameText.placeholder = @"EmailAddress";
    UsernameText.tag = 1717;
    [UsernameText setBackgroundColor:[UIColor whiteColor]];
    UsernameText.enablesReturnKeyAutomatically = YES;
    [UsernameText setReturnKeyType:UIReturnKeyDone];
    [UsernameText setDelegate:self];
    [alertView addSubview:UsernameText];
    
    // Adds a password Field
   PasswordText = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 95.0, 260.0, 30.0)];
    PasswordText.placeholder = @"Password";
    PasswordText.tag = 1818;
    [PasswordText setSecureTextEntry:YES];
    PasswordText.enablesReturnKeyAutomatically = YES;
    [PasswordText setBackgroundColor:[UIColor whiteColor]];
    [PasswordText setReturnKeyType:UIReturnKeyDone];
    [PasswordText setDelegate:self];   
    [alertView addSubview:PasswordText];
    
    alertView.tag = 1313;
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1 && actionSheet.tag == 1313){
            NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
            BOOL notAValidEmail = ![emailTest evaluateWithObject:UsernameText.text];
            
            if (notAValidEmail || [UsernameText.text length] == 0) {
                // Your email is not valid or you have not entered an emailaddress
               NSString *AlertTitle = [[NSString alloc] initWithString:@"Your email is not valid or you have not entered an email address. Try again?"];
               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:AlertTitle message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                alertView.tag = 1212;
                [alertView show];
            }
            else if([PasswordText.text length] == 0 ){
                // "password missing
                NSString *AlertTitle = [[NSString alloc] initWithString:@"You did not enter a password. Try again?"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:AlertTitle message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                alertView.tag = 1212;
                [alertView show];

            }
            else
            {
                // To database with email address,password and UIID;
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                NSString *MyDeviceId = [prefs stringForKey:@"LCUIID"];
                [self SubscriptionTransferServer:MyDeviceId];
                
            }
            
            
        
    }
    else if(buttonIndex == 1 && actionSheet.tag == 1212){
        
        
        [self TransferSubscription:self];
        
    }
    
}



- (BOOL)textFieldShouldEndEditing:(UITextView *)textView{
    
    if(textView.tag == 1717){
        if(UsernameText.text.length > 0 ){
            
            [UsernameText resignFirstResponder];
            
            return true;
        }
        else
        {
            return false;
            
            [UsernameText resignFirstResponder];
        }
        
    }
    
    else if(textView.tag == 1818){
            
        if(PasswordText.text.length > 0 ){
            
            [PasswordText resignFirstResponder];
            
            return true;
            }
        else
            {
                [PasswordText resignFirstResponder];
                return false;
                
            }
    }
    else
    {
        return false;
    }
}



-(void)SubscriptionTransferServer:(NSString *)DeviceID{
    
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *domain = appDelegate.DomainName;
    
    
    NSString *queryString = [NSString stringWithFormat:@"%@/Services/iOS/VideoSubscription.asmx/UpdateDeviceID",domain];
    NSURL *url = [NSURL URLWithString:queryString];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    NSString *FullString = [NSString stringWithFormat:@"DeviceID=%@&email=%@&password=%@&",DeviceID,UsernameText.text,PasswordText.text];
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
    
    /* Response from server:
     
    
     0 = Successfully updated
     -1 = Error
     -2 = Error
     -3 = Error
     -4 = User does not exist*/
    
    if(!ReponseFromServer){
        ReponseFromServer = [[NSMutableData alloc]init ];
    }
    
    
    [ReponseFromServer appendData:someData];
    
    
    
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSString *returnedString = [[NSString alloc] initWithData:ReponseFromServer encoding:NSASCIIStringEncoding];
    //NSLog(@"%@",returnedString);
    NSString *Clean1 = [returnedString stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    NSString *Clean2 =[Clean1 stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    NSString *Clean3 =[Clean2 stringByReplacingOccurrencesOfString:@"&lt;/" withString:@"/>"];
    //NSLog(@"%@",Clean3);
    NSData *xmlData = [Clean3 dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    [parser setDelegate:self];
    [parser parse];

}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    
    }


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    NSString *CleanString = [string stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([CleanString isEqualToString:@""]){
        
        //Do nothing
       
        return;
        
    }
    
        int Returnid = [string intValue];
        
        //NSLog(@"%i",Returnid);
    
        if (Returnid == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Successful" message:@"Update successful" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.tag = 4444;
        [alertView show];
    }
        else if (Returnid < 0){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Not successful" message:@"You don't have any running subscription" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alertView.tag = 4444;
            [alertView show];
            
    }



       
    
}




- (void)AddProgress{
	
	
	UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[activityIndicator stopAnimating];
    [activityIndicator hidesWhenStopped];
	UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	[self navigationItem].rightBarButtonItem = barButton;
	
	[(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView startAnimating];
	
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
	
	
}



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
    
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait  || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        FreeVideos.frame = CGRectMake(85 ,100, 600, 44);
        BtnTransfermysubscription.frame = CGRectMake(400 ,700, 300, 44);
        ImageView.frame = CGRectMake(60 ,200, 640, 480);
        FirstView.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT);
       
        
    }
    else
    {
        FreeVideos.frame = CGRectMake(220 ,15, 600, 44);
        BtnTransfermysubscription.frame = CGRectMake(540 ,600, 300, 44);
        ImageView.frame = CGRectMake(200 ,90, 640, 480);
        FirstView.frame = CGRectMake(0, 0, SCREEN_HEIGHT + 80 , SCREEN_WIDTH);
        
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView stopAnimating];
    [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:1];

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
