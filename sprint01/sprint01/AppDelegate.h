//
//  AppDelegate.h
//  example
//
//  Created by Aleksey Drachyov on 14.03.17.
//  Copyright (c) 2017 Aleksey Drachyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTableViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (copy)void(^backgroundSessionCompletionHandler)();
@property (retain,nonatomic) UINavigationController *navigationController;


@end

