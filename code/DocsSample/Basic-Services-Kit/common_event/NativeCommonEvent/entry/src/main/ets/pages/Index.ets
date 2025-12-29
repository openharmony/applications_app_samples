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

import commonEventManager from 'libentry.so';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0xD001000;

@Entry
@Component
struct Index {
  @State message: string = 'Common Event Management';

  // Subscribe to event - Test createSubscribeInfo, createSubscriber, subscribe APIs
  subscribeEvent(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'TEST: Calling NAPI - createSubscribeInfo');
    this.message = 'Testing subscribe APIs...';

    try {
      // Test createSubscribeInfo API
      const createInfoResult = commonEventManager.createSubscribeInfo();
      if (createInfoResult) {
        // Test createSubscriber API
        const createSubscriberResult = commonEventManager.createSubscriber();

        if (createSubscriberResult) {
          // Test subscribe API
          const subscribeResult = commonEventManager.subscribe();

          if (subscribeResult) {
            this.message = 'Subscribe API test success';
            AppStorage.setOrCreate<boolean>('result', true);
          } else {
            this.message = 'Subscribe API test failed';
          }
        } else {
          this.message = 'createSubscriber API test failed';
        }
      } else {
        this.message = 'createSubscribeInfo API test failed';
      }
    } catch (error) {
      this.message = 'Subscribe API test exception';
    }
  }

  // Abort common event - Test abortCommonEvent API
  abortCommonEvent(): void {
    try {
      const result = commonEventManager.abortCommonEvent();
      AppStorage.setOrCreate<boolean>('result', result);
      this.message = result ? 'abortCommonEvent API test success' : 'abortCommonEvent API test failed';
    } catch (error) {
      this.message = 'abortCommonEvent API test exception';
    }
  }

  // Clear abort status - Test clearAbortCommonEvent API
  clearAbortCommonEvent(): void {
    try {
      const result = commonEventManager.clearAbortCommonEvent();
      AppStorage.setOrCreate<boolean>('result', result);
      this.message = result ? 'clearAbortCommonEvent API test success' : 'clearAbortCommonEvent API test failed';
    } catch (error) {
      this.message = 'clearAbortCommonEvent API test exception';
    }
  }

  // Modify event content - Test publishWithInfo API
  modifyCommonEventContent(): void {
    try {
      const result = commonEventManager.publishWithInfo();
      AppStorage.setOrCreate<boolean>('result', result);
      this.message = result ? 'publishWithInfo API test success' : 'publishWithInfo API test failed';
    } catch (error) {
      this.message = 'publishWithInfo API test exception';
    }
  }

  // Unsubscribe - Test unsubscribe, destroySubscriber, destroySubscribeInfo APIs
  unsubscribeEvent(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'TEST: Calling NAPI - unsubscribe');
    try {
      const unsubscribeResult = commonEventManager.unsubscribe();

      if (unsubscribeResult) {
        // Test destroySubscriber API
        commonEventManager.destroySubscriber();

        // Test destroySubscribeInfo API
        commonEventManager.destroySubscribeInfo();
        this.message = 'Unsubscribe APIs test success';
        AppStorage.setOrCreate<boolean>('result', true);
      } else {
        this.message = 'unsubscribe API test failed';
      }
    } catch (error) {
      hilog.error(DOMAIN, 'testTag', '%{public}s', 'TEST ERROR: Exception during unsubscribe API testing:', error);
    }
  }

  // Publish event - Test publish API
  publishEvent(): void {
    try {
      const result = commonEventManager.publish();
      AppStorage.setOrCreate<boolean>('result', result);
      this.message = result ? 'publish API test success' : 'publish API test failed';
    } catch (error) {
      this.message = 'publish API test exception';
    }
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 30 })
          .textAlign(TextAlign.Center)

        Button($r('app.string.subscribe'))
          .width('80%')
          .height(45)
          .margin({ bottom: 15 })
          .onClick(() => this.subscribeEvent())

        Button($r('app.string.abort'))
          .width('80%')
          .height(45)
          .margin({ bottom: 15 })
          .onClick(() => this.abortCommonEvent())

        Button($r('app.string.cancel'))
          .width('80%')
          .height(45)
          .margin({ bottom: 15 })
          .onClick(() => this.clearAbortCommonEvent())

        Button($r('app.string.modify'))
          .width('80%')
          .height(45)
          .margin({ bottom: 15 })
          .onClick(() => this.modifyCommonEventContent())

        Button($r('app.string.unsubscribe'))
          .width('80%')
          .height(45)
          .margin({ bottom: 15 })
          .onClick(() => this.unsubscribeEvent())

        Button($r('app.string.publish'))
          .width('80%')
          .height(45)
          .onClick(() => this.publishEvent())
      }
      .width('100%')
      .padding({ top: 50 })
    }.height('100%').margin({ top: 20, bottom: 20 })
  }
}