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

@synthesize VideoFileName,ServerLocation,credential,protectionSpace,domain,ImageViewer1,moviePlayerViewController;

#define SCREEN_WIDTH 768
#define SCREEN_HEIGHT 950


- (void)movieFinishedCallback:(NSNotification*) notification  {  
	
	MPMoviePlayerController *player = [notification object];  
	[[NSNotificationCenter defaultCenter] removeObserver:self  
													name:MPMoviePlayerPlaybackDidFinishNotification  
												  object:player];  
	[player stop];
	[moviePlayerViewController.view removeFromSuperview];  
	
	
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
   

	moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:fileURL];
	 
	[[NSNotificationCenter defaultCenter] addObserver:self  
											 selector:@selector(movieFinishedCallback:)  
												 name:MPMoviePlayerPlaybackDidFinishNotification  
											   object:[moviePlayerViewController moviePlayer]];
    
    [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
    

}



- (void)viewWillDisappear:(BOOL)animated {
	
	[moviePlayerViewController.moviePlayer stop];
	
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return  (interfaceOrientation != UIInterfaceOrientationPortrait );
	
	
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
	
	if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		
		[[moviePlayerViewController view] setFrame:CGRectMake(30 ,150, 700, 600)];
		
	}
	
	else {
		
		[[moviePlayerViewController view] setFrame:CGRectMake(180 ,20, 700, 600)];
		
		
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
