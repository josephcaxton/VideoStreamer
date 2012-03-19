//
//  Start.h
//  VideoStreamer
//
//  Created by Joseph caxton-Idowu on 13/03/2012.
//  Copyright (c) 2012 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Start : UIViewController{
    
    UIView *FirstView;
    UIView *FreeVideosView;
    UIButton *FreeVideos;
    UIView *MyVideosView;
	UIButton *MyVideos;
    UIButton *RentaVideo;
	CGRect FreeVideosViewframe;
    CGRect MyVideosViewframe;
   
}

@property (nonatomic, retain) UIView *FirstView;
@property (nonatomic, retain) UIView *FreeVideosView;
@property (nonatomic, retain) UIButton *FreeVideos;
@property (nonatomic, retain) UIView *MyVideosView;
@property (nonatomic, retain) UIButton *MyVideos;
@property (nonatomic, retain)  UIButton *RentaVideo;
@property (nonatomic, assign)  CGRect FreeVideosViewframe;
@property (nonatomic, assign)  CGRect MyVideosViewframe;


-(IBAction)ViewFreeVideos:(id)sender;
- (void)AddProgress;
@end
