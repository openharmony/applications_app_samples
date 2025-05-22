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

import imageEffect from 'libentry.so';
import image from '@ohos.multimedia.image';
import { ImageUtils } from '../utils/ImageUtils';
import { fileUri } from '@kit.CoreFileKit';
import fs from '@ohos.file.fs';
import { camera } from '@kit.CameraKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';

const VALUE_MIN_MINUS = -100;
const VALUE_MIN = 1;
const VALUE_MAX = 100;

@Entry
@Component
struct ImageEditPage {
  settingBtn: Resource = $r('app.media.ic_public_settings');
  @Provide displayPixelMap: image.PixelMap | undefined = undefined;
  @Provide displayPixelMapUri: image.PixelMap | undefined = undefined;
  @State brightnessSetValue: number = 100;
  @State brightnessSelect: boolean = false;
  @State contrastSetValue: number = 0;
  @State contrastSelect: boolean = false;
  @State cropSetValue: number = 100;
  @State cropSelect: boolean = false;
  @State customBrightnessSetValue: number = 0;
  @State customBrightnessSelect: boolean = false;
  @State customCropSetValue: number = 50;
  @State customCropSelect: boolean = false;
  @State filterOptions: Array<Array<string | number>> = [];
  @State filterInfo: string = '';
  mXComponentController: XComponentController = new XComponentController();
  @State mSurfaceId: string = '';
  @State inputType: 'PixelmapNative' | 'NativeBuffer' | 'URI' | 'NativeWindow' = 'PixelmapNative';
  @State index: number = 0;
  cameraMgr: camera.CameraManager | undefined = undefined;
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({
      cancel: this.onCancel,
      confirm: this.onAccept,
      filterOptions: $filterOptions,
      brightnessSetValue: $brightnessSetValue,
      brightnessSelect: $brightnessSelect,
      contrastSetValue: $contrastSetValue,
      contrastSelect: $contrastSelect,
      cropSetValue: $cropSetValue,
      cropSelect: $cropSelect,
      customBrightnessSetValue: $customBrightnessSetValue,
      customBrightnessSelect: $customBrightnessSelect,
      customCropSetValue: $customCropSetValue,
      customCropSelect: $customCropSelect,
      filterInfo: $filterInfo,
      inputType: $inputType,
      index: $index,
    }),
    cancel: this.existApp,
    autoCancel: true,
  });
  private tag: string = '[Sample_ImageEdit]';

  aboutToAppear(): void {
    console.info(`${this.tag} aboutToAppear called`);
    ImageUtils.getInstance().getPixelMap($r('app.media.ic_1080x1920')).then(pixelMap => {
      this.displayPixelMap = pixelMap;
    })
    ImageUtils.getInstance().getPixelMap($r('app.media.ic_700x700')).then(pixelMap => {
      this.displayPixelMapUri = pixelMap;
    })
    console.info(`${this.tag} aboutToAppear done`);
  }

  aboutToDisappear(): void {
    console.info(`${this.tag} aboutToDisappear called`);
    console.info(`${this.tag} aboutToDisappear done`);
  }

  build() {
    Column() {
      Row() {
        Row() {
          Text($r('app.string.image_edit'))
            .fontColor(Color.White)
            .fontSize('app.float.title_font_size')
            .margin({ left: $r('app.float.home_page_title_margin') })
        }

        Blank()

        Row() {
          Button() {
            Image(this.settingBtn)
              .width($r('app.float.title_image_width'))
              .height($r('app.float.title_image_height'))
              .id('btn_setting')
          }
          .height('100%')
          .type(ButtonType.Normal)
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            if (this.dialogController != undefined) {
              console.info(`${this.tag} to open setting dialog`);
              this.dialogController.open();
            }
          })
        }
      }
      .width('100%')
      .height($r('app.float.home_page_title_height'))
      .margin({
        top: $r('app.float.home_page_title_margin'),
        left: $r('app.float.home_page_title_margin'),
        right: $r('app.float.home_page_title_margin')
      })

      Column() {
        if (this.inputType == 'PixelmapNative') {
          Image(this.displayPixelMap)
            .objectFit(ImageFit.None)
        }
        if (this.inputType == 'NativeBuffer') {
          Column() {
            Text($r('app.string.native_buffer_description'))
              .fontSize($r('app.float.title_size'))
          }
          .backgroundColor(Color.White)
        }
        if (this.inputType == 'URI') {
          Image(this.displayPixelMapUri)
            .objectFit(ImageFit.None)
        }
        if (this.inputType == 'NativeWindow') {
          // [Start image_effect_add_xcomponent]
          XComponent({
            id: 'xcomponentId',
            type: XComponentType.SURFACE,
            controller: this.mXComponentController,
            libraryname: 'entry'
          })
            .onLoad(async () => {
              // 获取XComponent的SurfaceId。
              this.mSurfaceId = this.mXComponentController.getXComponentSurfaceId();
              // 调用native接口获取输入SurfaceId。
              this.mSurfaceId = imageEffect.getSurfaceId(this.mSurfaceId);
              // 调用相机接口启动预览，将获取到的输入SurfaceId传递给相机框架
              this.startPreview(this.mSurfaceId);
            })
            .width('100%')
            .height('100%')
          // [End image_effect_add_xcomponent]
        }
      }
      .clip(true)
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('85%')

      Row() {
        Button('Reset')
          .id('btn_reset')
          .onClick(() => {
            this.pixelInit();
          })
          .width($r('app.float.button_width'))

        Button('Apply')
          .id('btn_apply')
          .onClick(() => {
            this.doApply();
          })
          .width($r('app.float.button_width'))
      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .width('100%')
      .height('6%')
      .margin({ top: $r('app.float.home_page_title_margin') })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Grey)
  }

  onCancel() {
    console.info(`Callback when the cancel button is clicked`);
  }

  onAccept() {
    console.info(`Callback when the confirm button is clicked`);
  }

  existApp() {
    console.info(`click the callback in the blank area`);
  }

  private async startPreview(surfaceId: string) {
    let cameraManager = camera.getCameraManager(getContext(this));
    let cameras = this.getSupportedCameras(cameraManager);
    let modes = this.getSupportedSceneModes(cameraManager, cameras[0]);
    let cameraOutputCapability = cameraManager.getSupportedOutputCapability(cameras[0], modes[0]);
    let previewOutput = this.getPreviewOutput(cameraManager, cameraOutputCapability, surfaceId);
    if (previewOutput != undefined) {
      await this.startPreviewOutput(cameraManager, previewOutput);
    }
  }

  private getSupportedCameras(cameraManager: camera.CameraManager): camera.CameraDevice[] {
    let cameras: camera.CameraDevice[] = [];
    try {
      cameras = cameraManager.getSupportedCameras();
    } catch (error) {
      let err = error as BusinessError;
      console.error(`The getSupportedCameras call failed. error code: ${err.code}`);
    }
    return cameras;
  }

  private getSupportedSceneModes(cameraManager: camera.CameraManager,
    camera: camera.CameraDevice): camera.SceneMode[] {
    let modes: camera.SceneMode[] = [];
    try {
      modes = cameraManager.getSupportedSceneModes(camera);
    } catch (error) {
      let err = error as BusinessError;
      console.error(`The getSupportedSceneModes call failed. error code: ${err.code}`);
    }
    return modes;
  }

  private getPreviewOutput(cameraManager: camera.CameraManager, cameraOutputCapability: camera.CameraOutputCapability,
    surfaceId: string): camera.PreviewOutput | undefined {
    let previewProfilesArray: camera.Profile[] = cameraOutputCapability.previewProfiles;
    let previewOutput: camera.PreviewOutput | undefined = undefined;
    try {
      previewOutput = cameraManager.createPreviewOutput(previewProfilesArray[0], surfaceId);
    } catch (error) {
      let err = error as BusinessError;
      console.error('Failed to create the PreviewOutput instance. error code: ' + err.code);
    }
    return previewOutput;
  }

  private async startPreviewOutput(cameraManager: camera.CameraManager,
    previewOutput: camera.PreviewOutput): Promise<void> {
    let cameraArray: camera.CameraDevice[] = [];
    cameraArray = cameraManager.getSupportedCameras();
    if (cameraArray.length == 0) {
      console.error('no camera.');
      return;
    }
    // 获取支持的模式类型
    let sceneModes: camera.SceneMode[] = cameraManager.getSupportedSceneModes(cameraArray[0]);
    let isSupportPhotoMode: boolean = sceneModes.indexOf(camera.SceneMode.NORMAL_PHOTO) >= 0;
    if (!isSupportPhotoMode) {
      console.error('photo mode not support');
      return;
    }
    let cameraInput: camera.CameraInput | undefined = undefined;
    cameraInput = cameraManager.createCameraInput(cameraArray[0]);
    if (cameraInput === undefined) {
      console.error('cameraInput is undefined');
      return;
    }
    // 打开相机
    await cameraInput.open();
    let session: camera.PhotoSession =
      cameraManager.createSession(camera.SceneMode.NORMAL_PHOTO) as camera.PhotoSession;
    session.beginConfig();
    session.addInput(cameraInput);
    session.addOutput(previewOutput);
    await session.commitConfig();
    await session.start();
  }

  private async doSavePixel(): Promise<void> {
    let pixelMap: image.PixelMap | undefined = undefined;
    if (this.inputType == 'PixelmapNative') {
      pixelMap = await ImageUtils.getInstance().getPixelMap($r('app.media.ic_1080x1920'));
    } else {
      pixelMap = await ImageUtils.getInstance().getPixelMap($r('app.media.ic_700x700'));
    }
    const imagePackerApi = image.createImagePacker();
    const packOption: image.PackingOption = {
      format: 'image/jpeg',
      quality: 100
    };
    let filePath = '';
    if (this.inputType == 'PixelmapNative') {
      filePath = getContext().filesDir + '/ic_1080x1920.jpg';
    } else {
      filePath = getContext().filesDir + '/ic_700x700.jpg';
    }
    console.info(`savePixel to ${filePath}`);
    let uri = fileUri.getUriFromPath(filePath);
    let imageData = await imagePackerApi.packing(pixelMap, packOption);
    let file = fs.openSync(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    let writeLen = fs.writeSync(file.fd, imageData);
    fs.closeSync(file);
    console.info(`write data to file succeed and size is ${writeLen}`);
  }

  private confirmInfo() {
    this.filterOptions = [];
    if (this.brightnessSelect && this.inputType != 'URI') {
      let brightnessArray: (string | number)[] = [];
      brightnessArray.push('Brightness', this.brightnessSetValue);
      this.filterOptions.push(brightnessArray);
    }
    if (this.contrastSelect && this.inputType != 'URI') {
      let contrastArray: (string | number)[] = [];
      contrastArray.push('Contrast', this.contrastSetValue);
      this.filterOptions.push(contrastArray);
    }
    if (this.cropSelect && this.inputType != 'NativeBuffer' && this.inputType != 'NativeWindow') {
      let cropArray: (string | number)[] = [];
      cropArray.push('Crop', this.cropSetValue);
      this.filterOptions.push(cropArray);
    }
    if (this.customBrightnessSelect) {
      let customBrightnessArray: (string | number)[] = [];
      customBrightnessArray.push('CustomBrightness', this.customBrightnessSetValue);
      this.filterOptions.push(customBrightnessArray);
    }
    if (this.customCropSelect && this.inputType != 'NativeWindow') {
      let customCropArray: (string | number)[] = [];
      customCropArray.push('CustomCrop', this.customCropSetValue);
      this.filterOptions.push(customCropArray);
    }
  }

  private async doApply(): Promise<void> {
    this.confirmInfo();
    if (this.filterOptions.toString() != '') {
      let filePath: string = '';
      let result: boolean = true;
      switch (this.inputType) {
        case 'PixelmapNative':
          await this.doSavePixel();
          filePath = getContext().filesDir + '/ic_1080x1920.jpg';
          result = imageEffect.PixelMapFilterStart(filePath, [...this.filterOptions]);
          this.displayPixelMap = await ImageUtils.getInstance().getPixelMapByFilePath(filePath);
          promptAction.showToast({ message: `apply PixelMapNative ${result == true ? 'succeed' : 'fail'}!` });
          break;
        case 'NativeBuffer':
          result = imageEffect.NativeBufferFilterStart([...this.filterOptions]);
          promptAction.showToast({ message: `apply NativeBuffer ${result == true ? 'succeed' : 'fail'}!` });
          break;
        case 'URI':
          await this.doSavePixel();
          filePath = getContext().filesDir + '/ic_700x700.jpg';
          result = imageEffect.URIFilterStart(filePath, [...this.filterOptions]);
          this.displayPixelMapUri = await ImageUtils.getInstance().getPixelMapByFilePath(filePath);
          promptAction.showToast({ message: `apply URI ${result == true ? 'succeed' : 'fail'}!` });
          break;
        case 'NativeWindow':
          result = imageEffect.SurfaceFilterStart([...this.filterOptions]);
          promptAction.showToast({ message: `apply NativeWindow ${result == true ? 'succeed' : 'fail'}!` });
          break;
      }
    }
  }

  private async pixelInit(): Promise<void> {
    if (this.inputType == 'NativeWindow') {
      imageEffect.SurfaceFilterStop();
      this.mSurfaceId = imageEffect.getSurfaceId(this.mSurfaceId);
      this.startPreview(this.mSurfaceId);
      console.info(`initCamera succeed`);
    }
    this.displayPixelMap?.release();
    this.displayPixelMap = await ImageUtils.getInstance().getPixelMap($r('app.media.ic_1080x1920'));
    this.displayPixelMapUri?.release();
    this.displayPixelMapUri = await ImageUtils.getInstance().getPixelMap($r('app.media.ic_700x700'));
  }
}

@CustomDialog
struct CustomDialogExample {
  @Link brightnessSetValue: number;
  @Link brightnessSelect: boolean;
  @Link contrastSetValue: number;
  @Link contrastSelect: boolean;
  @Link cropSetValue: number;
  @Link cropSelect: boolean;
  @Link customBrightnessSetValue: number;
  @Link customBrightnessSelect: boolean;
  @Link customCropSetValue: number;
  @Link customCropSelect: boolean;
  @Link filterOptions: Array<Array<string | number>>;
  @Link filterInfo: string;
  @Link inputType: string;
  @Link index: number;
  inputList: SelectOption[] = [{ value: 'PixelmapNative' }, { value: 'NativeBuffer' },
    { value: 'URI' }, { value: 'NativeWindow' }];
  controller: CustomDialogController;
  @State formatList: String[] = ['Format:rgba_8888', 'Format:nv21', 'Format:nv12'];
  @State handlePopup: boolean = false;
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  @Builder
  filterInfoMenu() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Center }) {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
        Text(this.filterInfo).fontSize($r('app.float.filter_info_size'))
      }
    }
    .width('60%').height('15%')
    .opacity($r('app.float.filter_info_opacity'))
    .id('filter_info_menu')
  }

  build() {
    Column() {
      Select(this.inputList)
        .value($r('app.string.select_description'))
        .selected(this.index)
        .onSelect((index: number) => {
          this.index = index;
          this.inputType = this.inputList[index].value.toString();
        })
        .id('select_input')
      Divider().height($r('app.float.divider_height')).color(0xCCCCCC)

      Column() {
        Column() {
          Text('Filter')
            .width('100%')
            .fontSize($r('app.float.dialog_title_size'))
            .margin({ bottom: $r('app.float.bottom_size') })

          Row() {
            Column() {
              if (this.inputType != 'URI') {
                Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                  Checkbox({ name: 'brightnessCheckbox', group: 'filterCheckboxGroup' })
                    .selectedColor(0x39a2db)
                    .select(this.brightnessSelect)
                    .onChange((value: boolean) => {
                      this.brightnessSelect = value;
                    })
                    .width($r('app.float.check_box_width'))
                    .height($r('app.float.check_box_height'))
                    .id('checkbox_brightness')
                  Text('Brightness').fontSize($r('app.float.filter_text_size')).width('18%')
                  Slider({
                    value: this.brightnessSetValue,
                    min: VALUE_MIN_MINUS,
                    max: VALUE_MAX,
                    style: SliderStyle.OutSet
                  })
                    .showTips(true, this.brightnessSetValue.toFixed())
                    .onChange((value: number, mode: SliderChangeMode) => {
                      this.brightnessSetValue = value;
                      console.info('value:' + value + 'mode:' + mode.toString());
                    })
                    .width('60%')
                    .id('slider_brightness')
                  // toFixed()将滑动条返回值处理为整数精度
                  Column() {
                    Text(this.brightnessSetValue.toFixed()).fontSize($r('app.float.filter_number_size'))
                  }.width('8%')

                  Column() {
                    Image($r('app.media.ic_public_search'))
                      .width('5%')
                      .height('3.7%')
                  }.bindMenu(this.filterInfoMenu, {
                    onAppear: () => {
                      this.doLookFilterInfo('Brightness');
                    },
                    onDisappear: () => {
                      this.filterInfo = '';
                    }
                  })
                  .margin({ left: $r('app.float.margin_left') })
                  .id('btn_search_brightness')
                }
              }

              if (this.inputType != 'URI') {
                Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                  Checkbox({ name: 'contrastCheckbox', group: 'filterCheckboxGroup' })
                    .selectedColor(0x39a2db)
                    .select(this.contrastSelect)
                    .onChange((value: boolean) => {
                      this.contrastSelect = value;
                    })
                    .width($r('app.float.check_box_width'))
                    .height($r('app.float.check_box_height'))
                    .id('checkbox_contrast')
                  Text('Contrast').fontSize($r('app.float.filter_text_size')).width('18%')
                  Slider({
                    value: this.contrastSetValue,
                    min: VALUE_MIN_MINUS,
                    max: VALUE_MAX,
                    style: SliderStyle.OutSet
                  })
                    .showTips(true, this.contrastSetValue.toFixed())
                    .onChange((value: number, mode: SliderChangeMode) => {
                      this.contrastSetValue = value;
                      console.info('value:' + value + 'mode:' + mode.toString());
                    })
                    .width('60%')
                    .id('slider_contrast')
                  // toFixed()将滑动条返回值处理为整数精度
                  Column() {
                    Text(this.contrastSetValue.toFixed()).fontSize($r('app.float.filter_number_size'))
                  }.width('8%')

                  Column() {
                    Image($r('app.media.ic_public_search'))
                      .width('5%')
                      .height('3.7%')
                  }.bindMenu(this.filterInfoMenu, {
                    onAppear: () => {
                      this.doLookFilterInfo('Contrast');
                    },
                    onDisappear: () => {
                      this.filterInfo = '';
                    }
                  })
                  .margin({ left: $r('app.float.margin_left') })
                  .id('btn_search_contrast')
                }
              }

              if (this.inputType != 'NativeBuffer' && this.inputType != 'NativeWindow') {
                Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                  Checkbox({ name: 'cropCheckbox', group: 'filterCheckboxGroup' })
                    .selectedColor(0x39a2db)
                    .select(this.cropSelect)
                    .onChange((value: boolean) => {
                      this.cropSelect = value;
                    })
                    .width($r('app.float.check_box_width'))
                    .height($r('app.float.check_box_height'))
                    .id('checkbox_crop')
                  Text('Crop').fontSize($r('app.float.filter_text_size')).width('18%')
                  Slider({
                    value: this.cropSetValue,
                    min: VALUE_MIN,
                    max: VALUE_MAX,
                    style: SliderStyle.OutSet
                  })
                    .showTips(true, this.cropSetValue.toFixed())
                    .onChange((value: number, mode: SliderChangeMode) => {
                      this.cropSetValue = value;
                      console.info('value:' + value + 'mode:' + mode.toString());
                    })
                    .width('60%')
                    .id('slider_crop')
                  // toFixed()将滑动条返回值处理为整数精度
                  Column() {
                    Text(this.cropSetValue.toFixed()).fontSize($r('app.float.filter_number_size'))
                  }.width('8%')

                  Column() {
                    Image($r('app.media.ic_public_search'))
                      .width('5%')
                      .height('3.7%')
                  }.bindMenu(this.filterInfoMenu, {
                    onAppear: () => {
                      this.doLookFilterInfo('Crop');
                    },
                    onDisappear: () => {
                      this.filterInfo = '';
                    }
                  })
                  .margin({ left: $r('app.float.margin_left') })
                  .id('btn_search_crop')
                }
              }

              Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                Checkbox({ name: 'customBrightnessCheckbox', group: 'filterCheckboxGroup' })
                  .selectedColor(0x39a2db)
                  .select(this.customBrightnessSelect)
                  .onChange((value: boolean) => {
                    this.customBrightnessSelect = value;
                  })
                  .width($r('app.float.check_box_width'))
                  .height($r('app.float.check_box_height'))
                  .id('checkbox_custom_brightness')
                Text('CustomBrightness').fontSize($r('app.float.filter_text_size')).width('18%')
                Slider({
                  value: this.customBrightnessSetValue,
                  min: VALUE_MIN_MINUS,
                  max: VALUE_MAX,
                  style: SliderStyle.OutSet
                })
                  .showTips(true, this.customBrightnessSetValue.toFixed())
                  .onChange((value: number, mode: SliderChangeMode) => {
                    this.customBrightnessSetValue = value;
                    console.info('value:' + value + 'mode:' + mode.toString());
                  })
                  .width('60%')
                  .id('slider_custom_brightness')
                // toFixed()将滑动条返回值处理为整数精度
                Column() {
                  Text(this.customBrightnessSetValue.toFixed()).fontSize($r('app.float.filter_number_size'))
                }.width('8%')

                Column() {
                  Image($r('app.media.ic_public_search'))
                    .width('5%')
                    .height('3.7%')
                }.bindMenu(this.filterInfoMenu, {
                  onAppear: () => {
                    this.doLookFilterInfo('CustomBrightness');
                  },
                  onDisappear: () => {
                    this.filterInfo = '';
                  }
                })
                .margin({ left: $r('app.float.margin_left') })
                .id('btn_search_custom_brightness')
              }

              if (this.inputType != 'NativeWindow') {
                Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                  Checkbox({ name: 'customCropCheckbox', group: 'filterCheckboxGroup' })
                    .selectedColor(0x39a2db)
                    .select(this.customCropSelect)
                    .onChange((value: boolean) => {
                      this.customCropSelect = value;
                    })
                    .width($r('app.float.check_box_width'))
                    .height($r('app.float.check_box_height'))
                    .id('checkbox_custom_crop')
                  Text('CustomCrop').fontSize($r('app.float.filter_text_size')).width('18%')
                  Slider({
                    value: this.customCropSetValue,
                    min: VALUE_MIN,
                    max: VALUE_MAX,
                    style: SliderStyle.OutSet
                  })
                    .showTips(true, this.customCropSetValue.toFixed())
                    .onChange((value: number, mode: SliderChangeMode) => {
                      this.customCropSetValue = value;
                      console.info('value:' + value + 'mode:' + mode.toString());
                    })
                    .width('60%')
                    .id('slider_custom_crop')
                  // toFixed()将滑动条返回值处理为整数精度
                  Column() {
                    Text(this.customCropSetValue.toFixed()).fontSize($r('app.float.filter_number_size'))
                  }.width('8%')

                  Column() {
                    Image($r('app.media.ic_public_search'))
                      .width('5%')
                      .height('3.7%')
                  }.bindMenu(this.filterInfoMenu, {
                    onAppear: () => {
                      this.doLookFilterInfo('CustomCrop');
                    },
                    onDisappear: () => {
                      this.filterInfo = '';
                    }
                  })
                  .margin({ left: $r('app.float.margin_left') })
                  .id('btn_search_custom_crop')
                }
              }
            }
            .width('100%')
          }
        }
      }.margin({ bottom: $r('app.float.bottom_size') })

      Column() {
        Divider().height($r('app.float.divider_height')).color(0xCCCCCC);
        Column() {
          Text($r('app.string.look_up'))
            .width('100%')
            .fontSize($r('app.float.dialog_title_size'))
            .margin({ bottom: $r('app.float.bottom_size') })
          Row() {
            Column() {
              Text($r('app.string.btn_search'))
                .width('15%')
                .fontSize($r('app.float.search_size'))
                .margin({ left: '35%' })
            }

            Column() {
              Image($r('app.media.ic_public_arrow_right'))
                .fillColor(Color.Black)
                .width('10%')
                .height('4%')
            }
          }
          .id('btn_search')
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .bindMenu(this.lookupCategoryMenuBuilder)
        }
      }.margin({ bottom: $r('app.float.bottom_size') })

      Divider().height($r('app.float.divider_height')).color(0xCCCCCC)

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button($r('app.string.btn_cancel'))
          .onClick(() => {
            this.controller.close();
            this.cancel();
          }).backgroundColor(0xffffff)
          .fontColor(Color.Black)
          .id('btn_dialog_cancel')
        Button($r('app.string.btn_confirm'))
          .onClick(() => {
            this.controller.close();
            this.confirm();
          }).backgroundColor(0xffffff)
          .fontColor(Color.Red)
          .id('btn_dialog_confirm')
      }
    }.margin($r('app.float.margin'))
  }

  @Builder
  lookupCategoryMenuBuilder() {
    Menu() {
      MenuItem({
        content: 'Format',
        builder: (): void => this.formatMenuBuilder()
      });
    }.id('menu_category')
  }

  @Builder
  formatMenuBuilder() {
    Menu() {
      ForEach(this.formatList, (item: string) => {
        LookupFilterMenuItem({ item: item })
          .id('menu_format')
      });
    }
  }

  private async doLookFilterInfo(name: String): Promise<void> {
    this.filterInfo = imageEffect.lookupFilterInfo(name);
  }
}

@Component
struct LookupFilterMenuItem {
  @State item: string = '';
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogDetails({
      item: $item
    }),
    offset: { dx: $r('app.float.offset_x'), dy: $r('app.float.offset_y') },
    autoCancel: true,
  });

  build() {
    MenuItem({ content: this.item })
      .onClick(() => {
        if (this.dialogController != null) {
          this.dialogController.open();
        }
      })
  }
}

@CustomDialog
struct CustomDialogDetails {
  @Link item: string
  controller?: CustomDialogController

  build() {
    Column() {
      Text('Filters:\n' + imageEffect.lookupFilters(this.item))
        .fontSize($r('app.float.filter_info_size'))
    }
  }
}
