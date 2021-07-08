//
//  CMAuthorizationUtil+Alert.h
//  codemaokids_Lite
//
//  Created by 张雄文 on 2021/1/20.
//  Copyright © 2021 codemaocompany. All rights reserved.
//

#import "CMAuthorizationUtil.h"


NS_ASSUME_NONNULL_BEGIN

@interface CMAuthorizationUtil (Alert)

//展示相机没有权限的弹窗
+ (void)displayCameraAuthorizationAlert;
//展示麦克风没有权限的弹窗
+ (void)displayAudioAuthorizationAlert;

@end

NS_ASSUME_NONNULL_END
