//
//  CMAuthorizationUtil+Alert.m
//  codemaokids_Lite
//
//  Created by 张雄文 on 2021/1/20.
//  Copyright © 2021 codemaocompany. All rights reserved.
//

#import "CMAuthorizationUtil+Alert.h"
#import "CMCurrentViewController.h"
#import "CRPCommonConfirmationAlertView.h"
#import "CRPCommonConfirmationAlertView+CRPConvenience.h"

@implementation CMAuthorizationUtil (Alert)

//展示相机没有权限的弹窗
+ (void)displayCameraAuthorizationAlert{
    [self displayAuthorizationAlert:[CRPCommonConfirmationAlertView cameraAuthorizationStyleInstance]];
}
//展示麦克风没有权限的弹窗
+ (void)displayAudioAuthorizationAlert{
    [self displayAuthorizationAlert:[CRPCommonConfirmationAlertView audioAuthorizationStyleInstance]];
}

+ (void)displayAuthorizationAlert:(CRPCommonConfirmationAlertView *)alertView {
    [alertView setConfirmButtonAction:^(CRPCommonConfirmationAlertView * _Nonnull alertView) {
        [alertView close:^{
            [CMAuthorizationUtil toApplicationSettingPage];
        }];
    }];
    [alertView setCancelButtonAction:^(CRPCommonConfirmationAlertView * _Nonnull alertView) {
        [alertView close:nil];
    }];
    [[CMCurrentViewController findCurrentShowingViewController] crp_showAlert:alertView];
}

@end
