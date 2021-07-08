//
//  CMAuthorizationUtil.m
//  codemaokids_Lite
//
//  Created by ygy on 2020/11/2.
//  Copyright © 2020 codemaocompany. All rights reserved.
//

#import "CMAuthorizationUtil.h"
#import <EventKit/EventKit.h>
@import Photos;

@implementation CMAuthorizationUtil

+ (void)requestAlbumAuthorization:(void(^)(BOOL))callback {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (!callback) {
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {}];
        }
        return;
    }
    
    if (status == PHAuthorizationStatusAuthorized) {
        callback(YES);
        return;
    }
    
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        callback(NO);
        return ;
    }
    
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(status == PHAuthorizationStatusAuthorized);
            });
        }];
        return;
    }
    
    callback(NO);
    
}

+ (void)requestCameraAuthorization:(void (^)(BOOL))callback {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (!callback) {
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {}];
        }
        return;
    }
    
    if (status == AVAuthorizationStatusAuthorized) {
        callback(YES);
        return;
    }
    
    if ((status == AVAuthorizationStatusRestricted || status ==AVAuthorizationStatusDenied)) {
        callback(NO);
        return;
    }
    
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(granted);
            });
        }];
        return;
    }
    
    callback(NO);
}

+ (void)requestMicrophoneAuthorization:(void (^)(BOOL))callback {

    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (!callback) {
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {}];
        }
        return;
    }
    
    if (status == AVAuthorizationStatusAuthorized) {
        callback(YES);
        return;
    }
    
    if ((status == AVAuthorizationStatusRestricted || status ==AVAuthorizationStatusDenied)) {
        callback(NO);
        return;
    }
    
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(granted);
            });
        }];
        return;
    }
    
    callback(NO);
}

+ (void)requestCalendarAuthorization:(void (^)(BOOL))callback {
    EKEventStore *eventStore = [EKEventStore new];
    
    if (!callback) {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) { }];
    }
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(granted);
        });
    }];
}

+ (void)toApplicationSettingPage {
    NSURL *settingPageURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [UIApplication.sharedApplication openURL:settingPageURL options:@{} completionHandler:nil];
}

/// 请求相机权限和麦克风权限
/// @param callback 结果回调
+ (void)requestCameraAndMicrophoneAuthorization:(void(^)(BOOL cameraAuthorization,BOOL audioAuthorization))callback{
    
    CMSignal *cameraSignal = [[self requestCameraAuthorizationSignal] map:^id _Nullable(id  _Nullable value) {
        if (![value boolValue]) {
            // 未授权 没有相机权限
            if (callback) {
                callback(NO,NO);
            }
        }
        return value;
    }];
    
    CMSignal *audioSignal = [[self requestMicrophoneAuthorizationSignal] map:^id _Nullable(id  _Nullable value) {
        if (![value boolValue]) {
            // 未授权 没有麦克风权限
            if (callback) {
                callback(YES,NO);
            }
        }
        return value;
    }];
    
    CMSignal *signal = [cameraSignal flattenMap:^CMSignal * _Nonnull(id  _Nullable value) {
        if ([value boolValue]) {
            return audioSignal;
        } else {
            return [CMSignal just:@(NO)];
        }
    }];
    
    [signal subscribeValue:^(id  _Nullable value) {
        if ([value boolValue]) {
            // 完成所有授权
            if (callback) {
                callback(YES,YES);
            }
        }
    }];
}

+(CMSignal*)requestCameraAuthorizationSignal{
    
    return [CMSignal signalWithAction:^CMSignalDisposer * _Nonnull(id<CMSubscriber>  _Nonnull subscriber) {
        [CMAuthorizationUtil requestCameraAuthorization:^(BOOL granted) {
            [subscriber sendValue:@(granted)];
        }];
        return [CMSignalDisposer disposerWithAction:nil];
    }];
}

+(CMSignal*)requestMicrophoneAuthorizationSignal{
    
    return [CMSignal signalWithAction:^CMSignalDisposer * _Nonnull(id<CMSubscriber>  _Nonnull subscriber) {
        [CMAuthorizationUtil requestMicrophoneAuthorization:^(BOOL granted) {
            [subscriber sendValue:@(granted)];
        }];
        return [CMSignalDisposer disposerWithAction:nil];
    }];
}

@end
