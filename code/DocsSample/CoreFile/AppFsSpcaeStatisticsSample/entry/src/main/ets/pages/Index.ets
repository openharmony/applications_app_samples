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

// [Start import_interface_storage]
import { statfs } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { storageStatistics } from '@kit.CoreFileKit';
// [End import_interface_storage]

@Entry
@Component
struct Index {
  @State text: string = '';
  @State documentResult: string = '';
  @State result: string = '';

  build() {
    Column({ space: $r('app.float.size_10') }) {
      Row({ space: $r('app.float.size_10') }) {
        // getFreeSize按钮
        Button($r('app.string.getFreeSizeButton'))
          .width('50%') // 按钮宽度占屏幕宽度50%
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
            this.getFreeSize();
          })
      }
      // getCurrentBundleStats按钮
      Button($r('app.string.getCurrentBundleStatsButton'))
        .width('80%') // 按钮宽度占屏幕宽度30%
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
          this.getCurrentBundleStats();
        })
      // getTotalSize按钮
      Button($r('app.string.getTotalSizeButton'))
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
          this.getTotalSize();
        })
      // getTotalSizeSync按钮
      Button($r('app.string.getTotalSizeSyncButton'))
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
          this.getTotalSizeSync();
        })
      // getTotalSizeSync按钮
      Button($r('app.string.storageGetFreeSizeButton'))
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
          this.storageGetFreeSize();
        })
      // getTotalSizeSync按钮
      Button($r('app.string.getFreeSizeSyncButton'))
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
          this.getFreeSizeSync();
        })
      // 显示调用接口后的结果。
      Text(this.result)
        .fontSize($r('app.float.size_25')) // 文本字体大小为50
        .fontWeight(FontWeight.Bold) // 文本字体加粗
        .margin({ top: $r('app.float.size_20') }) // 文本上边距为20
    }
    .width('100%') // 外层列布局宽度占满屏幕
    .height('100%') // 外层列布局高度占满屏幕
    .alignItems(HorizontalAlign.Center) // 水平居中对齐
    .justifyContent(FlexAlign.Center) // 垂直居中对齐
    .backgroundColor($r('app.color.lightGrayColor')) // 背景颜色为浅灰色
  }

  //获取当前应用的存储空间大小。
  getCurrentBundleStats() {
    try {
      // [Start storageStatistics_getCurrentBundleStats]
      storageStatistics.getCurrentBundleStats((err: BusinessError, bundleStats: storageStatistics.BundleStats) => {
        if (err) {
          console.error(`Invoke getCurrentBundleStats failed, code is ${err.code}, message is ${err.message}`);
        } else {
          console.info(`Invoke getCurrentBundleStats succeeded, appsize is ${bundleStats.appSize}`);
        }
      });
      // [End storageStatistics_getCurrentBundleStats]
    }catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`DocumentViewPicker failed with err, code is: ${err.code}, message is: ${err.message}`);
    }
    this.result = 'getCurrentBundleStats success';
  }

  //获取文件系统数据分区剩余空间大小。
  storageGetFreeSize() {
    try {
      // [Start storageStatistics_statfs_getFreeSize]
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      let path = context.filesDir;
      statfs.getFreeSize(path, (err: BusinessError, number: number) => {
        if (err) {
          console.error(`Invoke getFreeSize failed, code is ${err.code}, message is ${err.message}`);
        } else {
          console.info(`Invoke getFreeSize succeeded, size is ${number}`);
        }
      });
      // [End storageStatistics_statfs_getFreeSize]
    }catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`DocumentViewPicker failed with err, code is: ${err.code}, message is: ${err.message}`);
    }
    this.result = 'getFreeSize success';
  }
  //异步获取内置存储的总空间大小。
  getTotalSize() {
    try {
      // [Start storageStatistics_getTotalSize]
      storageStatistics.getTotalSize().then((number: number) => {
        console.info(`getTotalSize successfully, number is ${number}`);
      }).catch((err: BusinessError) => {
        console.error(`getTotalSize failed with error, code is ${err.code}, message is ${err.message}`);
      });
      // [End storageStatistics_getTotalSize]
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`DocumentViewPicker failed with err, code is: ${err.code}, message is: ${err.message}`);
    }
    this.result = 'getTotalSize success';
  }

  getTotalSizeSync() {
    // [Start storageStatistics_getTotalSizeSync]
    try {
      let number = storageStatistics.getTotalSizeSync();
      console.info(`getTotalSizeSync successfully, number is ${number}`);
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      console.error(`getTotalSizeSync failed with error, code is ${error.code}, message is ${error.message}`);
    }
    // [End storageStatistics_getTotalSizeSync]
    this.result = 'getTotalSizeSync success';
  }

  getFreeSize() {
    try {
      // [Start storageStatistics_getFreeSize]
      storageStatistics.getFreeSize().then((number: number) => {
        console.info(`getFreeSize successfully, number is ${number}`);
      }).catch((err: BusinessError) => {
        console.error(`getFreeSize failed with error, code is ${err.code}, message is ${err.message}`);
      });
      // [End storageStatistics_getFreeSize]
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`DocumentViewPicker failed with err, code is: ${err.code}, message is: ${err.message}`);
    }
    this.result = 'storageGetFreeSize success';
  }

  getFreeSizeSync() {
    // [Start storageStatistics_getFreeSizeSync]
      try {
        let number = storageStatistics.getFreeSizeSync();
        console.info(`getFreeSizeSync successfully, number is ${number}`);
      } catch (err) {
        let error: BusinessError = err as BusinessError;
        console.error(`getFreeSizeSync failed with error, code is ${error.code}, message is ${error.message}`);
      }
    // [End storageStatistics_getFreeSizeSync]
    this.result = 'getFreeSizeSync success';
  }
}