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
    UIButton *FreeVideos;
	UIButton *MyVideos;
    UIButton *RentaVideo;
    UIImage *Image;
    UIImageView *ImageView;
   
}

@property (nonatomic, retain) UIView *FirstView;
@property (nonatomic, retain) UIButton *FreeVideos;
@property (nonatomic, retain) UIButton *MyVideos;
@property (nonatomic, retain)  UIButton *RentaVideo;
@property (nonatomic, retain)  UIImage *Image;
@property (nonatomic, retain)   UIImageView *ImageView;


-(IBAction)ViewFreeVideos:(id)sender;
- (void)AddProgress;
@end
