//
//  AppDelegate.h
//  VideoStreamer
//
//  Created by Joseph caxton-Idowu on 13/03/2012.
//  Copyright (c) 2012 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject <UIApplicationDelegate>{
    
    NSThread *SecondThread;
    UIWindow *window;
    UITabBarController *tabBarController;
    NSString *SelectProductID;
    UITableViewController *buyScreen;
    NSString *DomainName;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSThread *SecondThread;
@property (nonatomic, retain) NSString *SelectProductID;
@property (nonatomic, retain) UITableViewController *buyScreen;
@property (nonatomic, retain) NSString *DomainName;


- (NSString *)applicationDocumentsDirectory;
-(BOOL)isDeviceConnectedToInternet;
- (BOOL)downloadFileIfUpdated:(NSString*)urlString:(NSString*)LocalFileLocation;
- (NSString *)GetUUID;

@end
