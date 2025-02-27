/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { fileAccess } from '@kit.CoreFileKit';
import Logger from '../../common/Logger';

// context 是EntryAbility 传过来的context
let context = getContext(this) as common.UIAbilityContext;

@Entry
@Component
struct Index {
  @State result: string = ''; // 用于显示回调信息
  // 创建连接系统内所有文件管理服务端的helper对象
  @State fileAccessHelperAllServer: fileAccess.FileAccessHelper = fileAccess.createFileAccessHelper(context);

  build() {
    Column({ space: 10 }) {
      Button($r('app.string.registerToMonitorButton'))
        .width('80%') // 按钮宽度占屏幕宽度80%
        .height('10%') // 按钮高度占屏幕高度10%
        .fontSize($r('app.float.size_25')) // 按钮字体大小为25
        .borderRadius($r('app.float.size_25')) // 按钮圆角半径为25
        .backgroundColor($r('app.color.whiteColor')) // 按钮背景颜色为白色
        .shadow({
          radius: $r('app.float.size_10'), // 阴影半径为10
          color: $r('app.color.grayColor'), // 阴影颜色为灰色
          offsetX: $r('app.float.size_15'), // 阴影水平偏移量为15
          offsetY: $r('app.float.size_15') // 阴影垂直偏移量为15
        })
        .fontColor($r('app.color.blackColor')) // 按钮字体颜色为黑色
        .onClick(() => {
          this.registerObserver();
        })

      Button($r('app.string.cancelMonitorButton'))
        .width('80%') // 按钮宽度占屏幕宽度80%
        .height('10%') // 按钮高度占屏幕高度10%
        .fontSize($r('app.float.size_25')) // 按钮字体大小为25
        .borderRadius($r('app.float.size_25')) // 按钮圆角半径为25
        .backgroundColor($r('app.color.whiteColor')) // 按钮背景颜色为白色
        .shadow({
          radius: $r('app.float.size_10'), // 阴影半径为10
          color: $r('app.color.grayColor'), // 阴影颜色为灰色
          offsetX: $r('app.float.size_15'), // 阴影水平偏移量为15
          offsetY: $r('app.float.size_15') // 阴影垂直偏移量为15
        })
        .fontColor($r('app.color.blackColor')) // 按钮字体颜色为黑色
        .onClick(() => {
          this.unregisterObserver();
        })

      Text(this.result)
        .fontSize($r('app.float.size_50')) // 文本字体大小为50
        .fontWeight(FontWeight.Bold) // 文本字体加粗
        .margin({ top: $r('app.float.size_20') }) // 文本上边距为20
    }
    .width('100%') // 外层列布局宽度占满屏幕
    .height('100%') // 外层列布局高度占满屏幕
    .alignItems(HorizontalAlign.Center) // 水平居中对齐
    .justifyContent(FlexAlign.Center) // 垂直居中对齐
    .backgroundColor($r('app.color.lightGrayColor')) // 背景颜色为浅灰色
  }

  // 在组件初始化时创建 fileAccessHelperAllServer 对象
  onInit() {
    this.createFileAccessHelper();
  }

  createFileAccessHelper(): void {
    try {
      this.fileAccessHelperAllServer = fileAccess.createFileAccessHelper(context);
      if (!this.fileAccessHelperAllServer) {
        Logger.error('createFileAccessHelper interface returns an undefined object');
      }
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error('createFileAccessHelper failed, errCode:' + error.code + ', errMessage:' + error.message);
    }
  }

  // 提供监听回调方法
  callBackDir1 = (notifyMessageDir: fileAccess.NotifyMessage) => {
    if (notifyMessageDir != undefined) {
      Logger.info('NotifyType: ' + notifyMessageDir.type + 'NotifyUri:' + notifyMessageDir.uris[0]);
      this.result = 'Monitoring succeeded'; // 更新 result 状态
    } else {
      Logger.error('notifyMessageDir is undefined');
    }
  }

  // 注册监听设备
  registerObserver() {
    try {
      // 使用 this.callbackDir1
      this.fileAccessHelperAllServer.registerObserver(fileAccess.DEVICES_URI, true, this.callBackDir1);
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error('registerObserver failed, errCode:' + error.code + ', errMessage:' + error.message);
    }
  }

  // 取消设备监听
  unregisterObserver() {
    try {
      this.fileAccessHelperAllServer.unregisterObserver(fileAccess.DEVICES_URI,
        this.callBackDir1); // 使用 this.callbackDir1
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error('unregisterObserver failed, errCode:' + error.code + ', errMessage:' + error.message);
    }
  }
}