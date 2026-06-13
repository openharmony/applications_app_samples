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

import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { formInfo } from '@kit.FormKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { image } from '@kit.ImageKit';
import { Constants } from '../common/Constants';
import { subjectSegmentation } from '@kit.CoreVisionKit';
import { Want } from '@kit.AbilityKit';

const DOMAIN = 0x0000;
const TAG  = 'testTag';
const scaleMax = 1.2;
const subjectMaxCount = '2';

@Entry
@Component
struct Page {
  @State columnScale: number = 1.0;
  @State columnTranslate: number = 0.0;
  @State chooseImage: Resource = $r('app.media.img');
  @State segmentedImage: PixelMap | undefined = undefined;
  @State imageScale: number = 1.0;

  private uiContext: UIContext | undefined = undefined;
  private storageForMyLiveFormPage: LocalStorage | undefined = undefined;
  private formId: string | undefined = undefined;
  private formRect: formInfo.Rect | undefined = undefined;
  private formBorderRadius: number | undefined = undefined;
  private liveFormContext: common.LiveFormExtensionContext | undefined = undefined;
  private isInit: boolean = false;

  aboutToAppear(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'aboutToAppear');
    this.uiContext = this.getUIContext();
    if (!this.uiContext) {
      return;
    }
    this.initParams();
    subjectSegmentation.init().then((isInit) => {
      this.isInit = isInit;
      hilog.info(DOMAIN, TAG, 'Subject segmentation initialization result:%{public}d', isInit);
    })
  }

  aboutToDisappear(): void {
    subjectSegmentation.release().then(()=>{
      hilog.info(DOMAIN, TAG, '%{public}s', 'Subject segmentation released successfully');
    })
  }

  private initParams(): void {
    this.storageForMyLiveFormPage = this.uiContext?.getSharedLocalStorage();
    this.formId = this.storageForMyLiveFormPage?.get<string>('formId');
    this.formRect = this.storageForMyLiveFormPage?.get<formInfo.Rect>('formRect');
    this.formBorderRadius = this.storageForMyLiveFormPage?.get<number>('borderRadius');
    this.liveFormContext = this.storageForMyLiveFormPage?.get<common.LiveFormExtensionContext>('context');
  }

  private startAbilityByLiveForm(): void {
    try {
      let want: Want = {
        bundleName: 'com.example.shakeliveformdemo',
        abilityName: 'EntryAbility',
        deviceId: 'testDeviceId',
        uri: 'test/uri',
        type: 'test/type',
        flags: 0x00000001,
        action: 'test/action',
        parameters: {
          'testNum': 2,
          'testStr': 'test/str'
        },
        entities: ['test/entity1', 'test/entity2'],
        moduleName: 'entry',
      };
      this.liveFormContext?.startAbilityByLiveForm(want)
        .then(() => {
          hilog.info(DOMAIN, TAG, '%{public}s', 'startAbilityByLiveForm succeed');
        })
        .catch((err: BusinessError) => {
          hilog.error(DOMAIN, TAG, 'startAbilityByLiveForm error: %{public}s', JSON.stringify(err));
        });
    } catch (e) {
      hilog.error(DOMAIN, TAG, 'startAbilityByLiveForm failed: %{public}s', JSON.stringify(e));
    }
  }

  async loadImage(resource: Resource): Promise<image.PixelMap | undefined> {
    let context = this.getUIContext().getHostContext() as common.UIAbilityContext; // 获取resourceManager资源管理
    const resourceManager = context.resourceManager; // 获取图片数据
    let fileData: Uint8Array;
    try {
      fileData = await resourceManager.getMediaContent(resource.id); // 返回对应的媒体文件内容。
    } catch (e) {
      return undefined;
    }
    let buffer: ArrayBuffer = fileData.buffer.slice(0);
    const imageSource: image.ImageSource = image.createImageSource(buffer);
    const pixelMap: image.PixelMap = await imageSource.createPixelMap();
    imageSource.release();
    return pixelMap;
  }

  async doImageSegmentation() {
    if (!this.chooseImage) {
      return;
    }
    let img: image.PixelMap | undefined = await this.loadImage(this.chooseImage);
    if (!img) {
      return;
    }
    let visionInfo: subjectSegmentation.VisionInfo = {
      pixelMap: img,
    };
    let config: subjectSegmentation.SegmentationConfig = {
      maxCount: parseInt(subjectMaxCount),
      enableSubjectDetails: true,
      enableSubjectForegroundImage: true
    };
    try {
      let data: subjectSegmentation.SegmentationResult = await subjectSegmentation.doSegmentation(visionInfo, config);
      if (data.fullSubject && data.fullSubject.foregroundImage) {
        this.segmentedImage = data.fullSubject.foregroundImage;
      }
    } catch (e) {
      hilog.error(DOMAIN, TAG, 'Image segmentation failed: %{public}s', JSON.stringify(e));
      this.segmentedImage = undefined;
    }
  }

  // 执行动效
  private runAnimation(): void {
    this.uiContext?.animateTo({
      duration: Constants.OVERFLOW_DURATION,
      curve: Curve.Ease
    }, () => {
      this.imageScale = scaleMax;
    });
  }

  @Builder
  buildContent(img: Resource | PixelMap | undefined, isRadius: boolean) {
    Column() {
      Image(img)
        .width('100%')
        .height('100%')
        .scale({ x: this.imageScale, y: this.imageScale, centerX: '50%', centerY: '100%' })
    }
    .width(this.formRect ? this.formRect.width : 0)
    .height(this.formRect ? this.formRect.height : 0)
    .offset({
      x: this.formRect ? this.formRect.left : 0,
      y: this.formRect ? this.formRect.top : 0,
    })
    .borderRadius(isRadius ? (this.formBorderRadius ? this.formBorderRadius : 0) : 0)
    .clip(isRadius ? true : undefined)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {
        Image(this.chooseImage)
          .width('100%')
          .height('100%')
          .scale({ x: this.imageScale, y: this.imageScale, centerX: '50%', centerY: '100%' })
      }
      .width(this.formRect ? this.formRect.width : 0)
      .height(this.formRect ? this.formRect.height : 0)
      .offset({
        x: this.formRect ? this.formRect.left : 0,
        y: this.formRect ? this.formRect.top : 0,
      })
      .borderRadius(this.formBorderRadius ? this.formBorderRadius : 0)
      .clip(true)

      Column() {
        Image(this.segmentedImage)
          .width('100%')
          .height('100%')
          .scale({ x: this.imageScale, y: this.imageScale, centerX: '50%', centerY: '100%' })
      }
      .width(this.formRect ? this.formRect.width : 0)
      .height(this.formRect ? this.formRect.height : 0)
      .offset({
        x: this.formRect ? this.formRect.left : 0,
        y: this.formRect ? this.formRect.top : 0,
      })
    }
    .width('100%')
    .height('100%')
    .onAppear(async () => {
      await this.doImageSegmentation();
      if (!this.segmentedImage) {
        return;
      }
      this.runAnimation();
    })
    .onClick(() => {
      if (!this.liveFormContext) {
        return;
      }
      this.startAbilityByLiveForm();
    })
  }
}