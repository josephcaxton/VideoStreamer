//
//  AppDelegate.m
//  VideoStreamer
//
//  Created by Joseph caxton-Idowu on 13/03/2012.
//  Copyright (c) 2012 caxtonidowu. All rights reserved.
//

#import "AppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

//#import "FirstViewController.h"

//#import "SecondViewController.h"

@implementation AppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize SecondThread;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Remove useless tabbarItems ..
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:tabBarController.viewControllers];
    [viewControllers removeObjectAtIndex:1];
    [viewControllers removeObjectAtIndex:2];
    [viewControllers removeObjectAtIndex:2];
    [viewControllers removeObjectAtIndex:2];
    [tabBarController setViewControllers:viewControllers];
    
    SecondThread = nil;


    [window addSubview: tabBarController.view];
	[window makeKeyAndVisible];
    return YES;
}

- (NSString *)applicationDocumentsDirectory {
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(BOOL)isDeviceConnectedToInternet{
    
    static BOOL checkNetwork = YES;
	BOOL _isDataSourceAvailable;
    if (checkNetwork) { // Since checking the reachability of a host can be expensive, cache the result and perform the reachability check once.
         checkNetwork = NO; //don't cache
		
        Boolean success;    
        const char *host_name = "http://www.google.com"; // my data source host name
		
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
        SCNetworkReachabilityFlags flags;
        success = SCNetworkReachabilityGetFlags(reachability, &flags);
        _isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
        CFRelease(reachability);
    }
    return _isDataSourceAvailable;
}

//Return True is file does not exist in device -- so download from server;
// Return True if the file exist but version is defferent--- So we need to download the file;
// Return false if the file is same version --- so don't download;
- (BOOL)downloadFileIfUpdated:(NSString*)urlString:(NSString*)LocalFileLocation {  
    
    //DLog(@"Downloading HTTP header from: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];  
    
    NSString *cachedPath = LocalFileLocation;
    NSFileManager *fileManager = [NSFileManager defaultManager];  
    
    //BOOL downloadFromServer = NO; 
    NSString *lastModifiedString = nil;  
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];  
    [request setHTTPMethod:@"HEAD"];  
    NSHTTPURLResponse *response;  
   // Get Date from server first 
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];  
    if ([response respondsToSelector:@selector(allHeaderFields)]) {  
        lastModifiedString = [[response allHeaderFields] objectForKey:@"Last-Modified"];  
    }
    
    NSDate *lastModifiedServer = nil;  
    @try {  
        NSDateFormatter *df = [[NSDateFormatter alloc] init];  
        df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";  
        df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];  
        df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];  
        lastModifiedServer = [df dateFromString:lastModifiedString];
    
        
    }  
    @catch (NSException * e) {  
        NSLog(@"Error parsing last modified date: %@ - %@", lastModifiedString, [e description]);  
    }  
   // NSLog(@"lastModifiedServer: %@", lastModifiedServer);
    
    // Get Date on Local device
    NSDate *lastModifiedLocal = nil;  
    if ([fileManager fileExistsAtPath:cachedPath]) {  
        NSError *error = nil;  
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:cachedPath error:&error];  
        if (error) {  
            NSLog(@"Error reading file attributes for: %@ - %@", cachedPath, [error localizedDescription]);  
        }  
        lastModifiedLocal = [fileAttributes fileModificationDate];  
       // NSLog(@"lastModifiedLocal : %@", lastModifiedLocal);  
    }
    
    // Download file from server if we don't have a local file  
    if (!lastModifiedLocal) {  
        return YES;  
    }
    
    if ([lastModifiedLocal laterDate:lastModifiedServer] == lastModifiedServer) {  
        return YES;  
    }
    
    return NO;
    
}  


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
