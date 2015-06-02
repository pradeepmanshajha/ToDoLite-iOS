//
//  AppDelegate.m
//  ToDoLite
//
//  Created by Pasin Suriyentrakorn on 10/11/14.
//  Copyright (c) 2014 Pasin Suriyentrakorn. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "DetailViewController.h"
#import "LoginViewController.h"
#import "Profile.h"
#import "NSString+Additions.h"

// Sync Gateway
#define kSyncGatewayUrl @"http://demo.mobile.couchbase.com/todolite"
#define kSyncGatewayWebSocketSupport NO

// Guest DB Name
#define kGuestDBName @"guest"

// For Application Migration
#define kMigrationVersion @"MigrationVersion"

@interface AppDelegate () <UISplitViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic) CBLReplication *push;
@property (nonatomic) CBLReplication *pull;
@property (nonatomic) NSError *lastSyncError;
@property (nonatomic) FBSDKLoginManager *facebookLoginManager;
@property (nonatomic) UIAlertView *facebookLoginAlertView;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [CBLManager enableLogging:@"Sync"];

    
    
    return YES;
}

- (void)createDatabase {
    _database = [[CBLManager sharedInstance] databaseNamed:@"todoapp" error:nil];
}

#pragma mark - Message

- (void)showMessage:(NSString *)text withTitle:(NSString *)title {
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

#pragma mark - Database

- (void)setCurrentDatabase:(CBLDatabase *)database {
    [self willChangeValueForKey:@"database"];
    _database = database;
    [self didChangeValueForKey:@"database"];
}

- (NSString *)databaseNameForName:(NSString *)name {
    return [NSString stringWithFormat:@"db%@", [[name MD5] lowercaseString]];
}


// Clear the SyncGateway session cookie when logging out
// In the future the replication object may handle that: https://github.com/couchbase/couchbase-lite-ios/issues/543
- (void)removeSessionCookie {
    NSHTTPCookieStorage *cookieJar = NSHTTPCookieStorage.sharedHTTPCookieStorage;
    for (NSHTTPCookie *aCookie in cookieJar.cookies) {
        if ([aCookie.name  isEqual: @"SyncGatewaySession"]) {
            [cookieJar deleteCookie:aCookie];
        }
    }
}

@end
