    //
//  VideoPlayer.m
//  EvaluatorForIPad
//
//  Created by Joseph caxton-Idowu on 21/02/2011.
//  Copyright 2011 caxtonidowu. All rights reserved.
//

#import "VideoPlayer.h"
#import "AppDelegate.h"

@implementation VideoPlayer

@synthesize VideoFileName,ServerLocation,credential,protectionSpace,domain;

#define SCREEN_WIDTH 768
#define SCREEN_HEIGHT 950


- (void)moviePlaybackComplete:(NSNotification *)notification  {  
	
	moviePlayerController = [notification object];  
	[[NSNotificationCenter defaultCenter] removeObserver:self  
													name:MPMoviePlayerPlaybackDidFinishNotification  
												  object:moviePlayerController];  
	
	[moviePlayerController.view removeFromSuperview];  
	
	
	[self.navigationController popViewControllerAnimated:YES];
	
	
}  


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    domain = appDelegate.DomainName;
    ServerLocation = [NSString stringWithFormat:@"%@/iosStream/",domain];
	

	
}

-(void)viewWillAppear:(BOOL)animated{
	
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BlackBackGround.png"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
	
    //Authentication Details here
    
   NSURLCredential *credential1 = [[NSURLCredential alloc] 
                                   initWithUser:@"theta"
                                   password:@"letmein2"
                                   persistence: NSURLCredentialPersistenceForSession];
    self.credential = credential1;
    
    NSString *DomainLocation = [domain stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    
   NSURLProtectionSpace *protectionSpace1 = [[NSURLProtectionSpace alloc]
                                             initWithHost: DomainLocation 
                                             port:80
                                             protocol:@"http"
                                             realm: DomainLocation   
                                             authenticationMethod:NSURLAuthenticationMethodDefault];
    self.protectionSpace = protectionSpace1;
    
    
    [[NSURLCredentialStorage sharedCredentialStorage] setDefaultCredential:credential
                                                        forProtectionSpace:protectionSpace]; 

    
	
    NSString *ServerpathAndVideoFileName = [ServerLocation stringByAppendingString:VideoFileName];
    
    // We can implement diffeerent Bandwidth size here..... TODO
    
    NSString *Finalpath = [ServerpathAndVideoFileName stringByAppendingString:@"/all.m3u8"];
    
    //NSLog(@"this is my final path ... %@", Finalpath);
	
	NSURL    *fileURL    =   [NSURL URLWithString:Finalpath]; 
   // NSURL *fileURL = [NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];

	
	moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self  
											 selector:@selector(moviePlaybackComplete:)  
												 name:MPMoviePlayerPlaybackDidFinishNotification  
											   object:moviePlayerController]; 
	
	//moviePlayerController.controlStyle = MPMovieControlModeDefault;
	[self.view addSubview:moviePlayerController.view];
	
	[self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:1];
	//moviePlayerController.fullscreen = YES;
	//moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
	//[self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:1];
	[moviePlayerController play];  
	
	
}

//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
//    
//    if ([challenge previousFailureCount] == 0) {
//        
//        NSURLCredential *credential = [[NSURLCredential alloc] 
//                                       initWithUser:@"theta"
//                                       password:@"letmein2"
//                                       persistence: NSURLCredentialPersistenceForSession];
//        
//        [[challenge sender] useCredential:credential
//         
//               forAuthenticationChallenge:challenge];
//        
//    } else {
//        
//        [[challenge sender] cancelAuthenticationChallenge:challenge];
//        
//        // inform the user that the user name and password
//        
//        // in the preferences are incorrect
//        
//        
//        
//    }
//    
//}

//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
//    
//    NSString *method = protectionSpace.authenticationMethod;
//    NSLog(@"%@",method );
//    
//    return true;
//}


- (void)viewWillDisappear:(BOOL)animated {
	
	//[moviePlayerController stop];
	
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return  (interfaceOrientation != UIInterfaceOrientationPortrait );
	
	
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
	
	if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		
		[[moviePlayerController view] setFrame:CGRectMake(30 ,150, 700, 600)];
		
	}
	
	else {
		
		[[moviePlayerController view] setFrame:CGRectMake(180 ,20, 700, 600)];
		
		
	}
	
	
	
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





@end
