    //
//  VideoPlayer.m
//  EvaluatorForIPad
//
//  Created by Joseph caxton-Idowu on 21/02/2011.
//  Copyright 2011 caxtonidowu. All rights reserved.
//

#import "VideoPlayer.h"


@implementation VideoPlayer

@synthesize VideoFileName,ServerLocation;

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
    
	
	ServerLocation = [NSString stringWithFormat:@"http://Stage.learnerscloud.com/iosStream/"];
	
}

-(void)viewWillAppear:(BOOL)animated{
	
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BlackBackGround.png"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
	
	
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


- (void)viewWillDisappear:(BOOL)animated {
	
	[moviePlayerController stop];
	
	
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