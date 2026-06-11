/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
// [Start window_animation_start_ability]
import { Want, StartOptions, common } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  private context = AppStorage.get('context') as common.UIAbilityContext;

  openAbility():void {
    let want: Want = {
      deviceId: '',
      bundleName: 'com.example.startabilitywithfadeinout',
      abilityName: 'FadeInOutAbility',
      moduleName: 'entry'
    };
    let options: StartOptions = {
      // 传入启动动效参数
      windowCreateParams: {
        animationParams : { type: window.AnimationType.FADE_IN_OUT },
      }
    }
    try {
      this.context.startAbility(want, options, (err: BusinessError) => {
        if (err.code) {
          // 处理业务逻辑错误
          console.error(`startAbility failed, code is ${err.code}, message is ${err.message}`);
          return;
        }
        // 执行正常业务
        console.info('startAbility succeed');
      });
    } catch (err) {
      // 处理入参错误异常
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      console.error(`startAbility failed, code is ${code}, message is ${message}`);
    }
  }
  build() {
    RelativeContainer() {
      Column() {
        Button('startAbility').onClick(() => this.openAbility())
      }
      .height('100%')
      .width('100%')
      .justifyContent(FlexAlign.Center);
    }
    .height('100%')
    .width('100%')
  }
}
// [End window_animation_start_ability]
