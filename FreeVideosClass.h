//
//  FreeVideos.h
//  VideoStreamer
//
//  Created by Joseph caxton-Idowu on 14/03/2012.
//  Copyright (c) 2012 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreeVideosClass :  UITableViewController  <UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray *ArrayofConfigObjects;
    NSMutableArray *ProductIDs;
    NSMutableArray *ImageObjects;
    NSMutableData *SubscriptionStatusData;
    
}

@property (nonatomic, retain) NSMutableArray *ArrayofConfigObjects;
@property (nonatomic, retain) NSMutableArray *ProductIDs;
@property (nonatomic, retain)  NSMutableArray *ImageObjects;
@property (nonatomic, retain)  NSMutableData *SubscriptionStatusData;

-(BOOL)ShouldIDownloadOrNot:(NSString*)urllPath:(NSString*)LocalFileLocation;
-(void)GetConfigFileFromServeWriteToPath:(NSString*)Path;
-(void)Alertfailedconnection;
-(void)MyParser:(NSString *)FileLocation;
-(void)ConfigureProductList:(NSString *)ProductID;
-(void)SubscriptionStatus:(NSString *)DeviceID;
@end
