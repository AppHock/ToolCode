//
//  CMAuthorizationUtil.h
//  codemaokids_Lite
//
//  Created by ygy on 2020/11/2.
//  Copyright © 2020 codemaocompany. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMAuthorizationUtil : NSObject

/// 请求相册权限
/// @param callback 结果回调
+ (void)requestAlbumAuthorization:(void(^)(BOOL granted))callback;

/// 请求相机权限
/// @param callback 结果回调
+ (void)requestCameraAuthorization:(void(^)(BOOL granted))callback;

/// 请求麦克风权限
/// @param callback 结果回调
+ (void)requestMicrophoneAuthorization:(void(^)(BOOL granted))callback;

/// 请求日历权限
/// @param callback 结果回调
+ (void)requestCalendarAuthorization:(void(^)(BOOL granted))callback;

/// 跳转设置页面
+ (void)toApplicationSettingPage;

/// 请求相机权限和麦克风权限
/// @param callback 结果回调
+ (void)requestCameraAndMicrophoneAuthorization:(void(^)(BOOL cameraAuthorization,BOOL audioAuthorization))callback;

@end

NS_ASSUME_NONNULL_END
