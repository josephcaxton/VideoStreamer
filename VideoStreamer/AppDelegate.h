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
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSThread *SecondThread;

- (NSString *)applicationDocumentsDirectory;


@end
