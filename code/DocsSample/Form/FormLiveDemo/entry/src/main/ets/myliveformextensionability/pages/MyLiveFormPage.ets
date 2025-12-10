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
// [Start liveform_MyLiveFormPage]
// entry/src/main/ets/myliveformextensionability/pages/MyLiveFormPage.ets
import { formInfo, formProvider } from '@kit.FormKit';
import { BusinessError } from '@kit.BasicServicesKit';
// 在API version 22以前通过 import LiveFormExtensionContext from 'application/LiveFormExtensionContext'; 导入LiveFormExtensionContext
// IDE标红，但不影响编译运行，LiveFormExtensionContext直接使用
// 在API version 22及以后使用 import { common } from '@kit.AbilityKit'; 导入，通过common.LiveFormExtensionContext方式使用
import { common } from '@kit.AbilityKit';
// Constants实现参考“互动卡片动效工具函数实现”小节
import { Constants } from '../../common/Constants';
import { hilog } from '@kit.PerformanceAnalysisKit';

const ANIMATION_RECT_SIZE: number = 100;
const END_SCALE: number = 1.5;
const END_TRANSLATE: number = -300;
const DOMAIN = 0x0000;

@Entry
@Component
struct MyLiveFormPage {
  @State columnScale: number = 1.0;
  @State columnTranslate: number = 0.0;
  private uiContext: UIContext | undefined = undefined;
  private storageForMyLiveFormPage: LocalStorage | undefined = undefined;
  private formId: string | undefined = undefined;
  private formRect: formInfo.Rect | undefined = undefined;
  private formBorderRadius: number | undefined = undefined;
  // 在API version 22以前通过 import LiveFormExtensionContext from 'application/LiveFormExtensionContext'; 导入LiveFormExtensionContext
  // IDE标红，但不影响编译运行，LiveFormExtensionContext直接使用
  // 在API version 22及以后使用 import { common } from '@kit.AbilityKit'; 导入，通过common.LiveFormExtensionContext方式使用
  private liveFormContext: common.LiveFormExtensionContext | undefined = undefined;

  aboutToAppear(): void {
    this.uiContext = this.getUIContext();
    if (!this.uiContext) {
      hilog.error(DOMAIN, 'testTag', 'no uiContext');
      return;
    }
    this.initParams();
  }

  private initParams(): void {
    this.storageForMyLiveFormPage = this.uiContext?.getSharedLocalStorage();
    this.formId = this.storageForMyLiveFormPage?.get<string>('formId');
    this.formRect = this.storageForMyLiveFormPage?.get<formInfo.Rect>('formRect');
    this.formBorderRadius = this.storageForMyLiveFormPage?.get<number>('borderRadius');
    // 在API version 22以前通过 import LiveFormExtensionContext from 'application/LiveFormExtensionContext'; 导入LiveFormExtensionContext
    // IDE标红，但不影响编译运行，LiveFormExtensionContext直接使用
    // 在API version 22及以后使用 import { common } from '@kit.AbilityKit'; 导入，通过common.LiveFormExtensionContext方式使用
    this.liveFormContext = this.storageForMyLiveFormPage?.get<common.LiveFormExtensionContext>('context');
  }

  // 执行动效
  private runAnimation(): void {
    this.uiContext?.animateTo({
      duration: Constants.OVERFLOW_DURATION,
      curve: Curve.Ease
    }, () => {
      this.columnScale = END_SCALE;
      this.columnTranslate = END_TRANSLATE;
    });
  }

  private startAbilityByLiveForm(): void {
    try {
      // 请开发者替换为实际的want信息
      this.liveFormContext?.startAbilityByLiveForm({
        bundleName: 'com.samples.formlivedemo',
        abilityName: 'EntryAbility',
      })
        .then(() => {
          hilog.info(DOMAIN, 'testTag', 'startAbilityByLiveForm succeed');
        })
        .catch((err: BusinessError) => {
          hilog.error(DOMAIN, 'testTag',
            `startAbilityByLiveForm failed, code is ${err?.code}, message is ${err?.message}`);
        });
    } catch (e) {
      hilog.error(DOMAIN, 'testTag', `startAbilityByLiveForm failed, code is ${e?.code}, message is ${e?.message}`);
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 背景组件和普通卡片一样大
      Column()
        .width(this.formRect ? this.formRect.width : 0)
        .height(this.formRect ? this.formRect.height : 0)
        .offset({
          x: this.formRect ? this.formRect.left : 0,
          y: this.formRect ? this.formRect.top : 0,
        })
        .borderRadius(this.formBorderRadius ? this.formBorderRadius : 0)
        .backgroundColor('#2875F5')
      Stack() {
        this.buildContent();
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .onClick(() => {
      hilog.info(DOMAIN, 'testTag', 'MyLiveFormPage click to start ability');
      if (!this.liveFormContext) {
        hilog.info(DOMAIN, 'testTag', 'MyLiveFormPage liveFormContext is empty');
        return;
      }
      this.startAbilityByLiveForm();
    })
  }

  @Builder
  buildContent() {
    Stack()
      .width(ANIMATION_RECT_SIZE)
      .height(ANIMATION_RECT_SIZE)
      .backgroundColor(Color.White)
      .scale({
        x: this.columnScale,
        y: this.columnScale,
      })
      .translate({
        y: this.columnTranslate
      })
      .onAppear(() => {
        // 在页面出现时执行动效
        this.runAnimation();
      })
    // $r('app.string.button_cancel')需要在相应的资源文件string.json中定义
    Button($r('app.string.button_cancel'))
      .backgroundColor(Color.Grey)
      .onClick(() => {
        if (!this.formId) {
          hilog.info(DOMAIN, 'testTag', 'MyLiveFormPage formId is empty, cancel overflow failed');
          return;
        }
        hilog.info(DOMAIN, 'testTag', 'MyLiveFormPage cancel overflow animation');
        formProvider.cancelOverflow(this.formId);
      })
  }
}
// [End liveform_MyLiveFormPage]