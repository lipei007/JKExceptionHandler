//
//  JKExceptionHandler.h
//  JKExceptionHandler
//
//  Created by Jack on 16/9/7.
//  Copyright © 2016年 mini1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKExceptionHandler : NSObject
{
    BOOL dismissed;
}
@end


void HandleException(NSException *exception);
void SignalHandler(int signal);


void InstallUncaughtExceptionHandler(void);
