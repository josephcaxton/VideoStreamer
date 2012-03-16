//
//  Start.m
//  VideoStreamer
//
//  Created by Joseph caxton-Idowu on 13/03/2012.
//  Copyright (c) 2012 caxtonidowu. All rights reserved.
//

#import "Start.h"
#import "FreeVideosClass.h"

@implementation Start

@synthesize FirstView,FreeVideos,MyVideos,RentaVideo,FreeVideosView,MyVideosView,FreeVideosViewframe,MyVideosViewframe;

#define SCREEN_WIDTH 768
#define SCREEN_HEIGHT 950

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"www.LearnersCloud.com";
    CGRect FirstViewframe = CGRectMake(0 ,0, SCREEN_WIDTH, SCREEN_HEIGHT);
	self.FirstView = [[UIView alloc] initWithFrame:FirstViewframe];
    
    UIColor *patternColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Cinema_port.png"]];

    [FirstView setBackgroundColor:patternColor];

    [self.view addSubview:FirstView];
    
    FreeVideosViewframe = CGRectMake(555 ,200, 200, 44);
    FreeVideosView = [[UIView alloc] initWithFrame:FreeVideosViewframe];
    FreeVideos = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [FreeVideos setTitle:@"View free videos!" forState:UIControlStateNormal];
    UIImage *FreeVideosbuttonImage = [UIImage imageNamed:@"YellowBackground.png"];
    [FreeVideos setBackgroundImage:FreeVideosbuttonImage forState:UIControlStateNormal];
    FreeVideos.frame = FreeVideosViewframe;

    [FreeVideos addTarget:self action:@selector(ViewFreeVideos:) forControlEvents:UIControlEventTouchUpInside];
    
    [FirstView addSubview:FreeVideos];
    
    
    MyVideosViewframe = CGRectMake(555 ,300, 200, 44);
    MyVideosView = [[UIView alloc] initWithFrame: MyVideosViewframe];
    MyVideos = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [MyVideos setTitle:@"My videos!" forState:UIControlStateNormal];
    [MyVideos setTitleColor:[UIColor redColor] forState: UIControlStateNormal];
    UIImage *MyVideosbuttonImage = [UIImage imageNamed:@"blueBackground.png"];
    [MyVideos setBackgroundImage:MyVideosbuttonImage forState:UIControlStateNormal];
    MyVideos.frame = MyVideosViewframe;
    
    [MyVideos addTarget:self action:@selector(Practice:) forControlEvents:UIControlEventTouchUpInside];
    
    [FirstView addSubview:MyVideos];

   
    
    
    
}

-(IBAction)ViewFreeVideos:(id)sender{
    
    FreeVideosClass *Free_View = [[FreeVideosClass alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:Free_View animated:YES];
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
	
	
}



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
    
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait  || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
       FirstView.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT);
       
        
    }
    else
    {
        FirstView.frame = CGRectMake(0, 0, SCREEN_HEIGHT + 80, SCREEN_WIDTH);
        
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    


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
