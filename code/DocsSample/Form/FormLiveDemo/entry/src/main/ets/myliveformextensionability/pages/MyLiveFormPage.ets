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
import LiveFormExtensionContext from 'application/LiveFormExtensionContext';
import { Constants } from '../../common/Constants';

const ANIMATION_RECT_SIZE: number = 100;
const END_SCALE: number = 1.5;
const END_TRANSLATE: number = -300;

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
  private liveFormContext: LiveFormExtensionContext | undefined = undefined;

  aboutToAppear(): void {
    this.uiContext = this.getUIContext();
    if (!this.uiContext) {
      console.error('no uiContext');
      return;
    }
    this.initParams();
  }

  private initParams(): void {
    this.storageForMyLiveFormPage = this.uiContext?.getSharedLocalStorage();
    this.formId = this.storageForMyLiveFormPage?.get<string>('formId');
    this.formRect = this.storageForMyLiveFormPage?.get<formInfo.Rect>('formRect');
    this.formBorderRadius = this.storageForMyLiveFormPage?.get<number>('borderRadius');
    this.liveFormContext = this.storageForMyLiveFormPage?.get<LiveFormExtensionContext>('context');
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
          console.info('startAbilityByLiveForm succeed');
        })
        .catch((err: BusinessError) => {
          console.error(`startAbilityByLiveForm failed, code is ${err?.code}, message is ${err?.message}`);
        });
    } catch (e) {
      console.error(`startAbilityByLiveForm failed, code is ${e?.code}, message is ${e?.message}`);
    }
  }

  build() {
    Stack({alignContent: Alignment.TopStart}) {
      // 背景组件，和普通卡片等大
      Column()
        .width(this.formRect? this.formRect.width : 0)
        .height(this.formRect? this.formRect.height : 0)
        .offset({
          x: this.formRect? this.formRect.left : 0,
          y: this.formRect? this.formRect.top : 0,
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
      console.info('startAbilityByLiveForm click to start ability');
      if (!this.liveFormContext) {
        console.info('startAbilityByLiveForm liveFormContext is empty');
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

    Button($r('app.string.button_cancel'))
      .backgroundColor(Color.Grey)
      .onClick(() => {
        if (!this.formId) {
          console.info('startAbilityByLiveForm formId is empty, cancel overflow failed');
          return;
        }
        console.info('startAbilityByLiveForm cancel overflow animation');
        formProvider.cancelOverflow(this.formId);
      })
  }
}
// [End liveform_MyLiveFormPage]