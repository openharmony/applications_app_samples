/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import imageEffect from 'libentry.so'
import image from '@ohos.multimedia.image';
import { ImageUtils } from '../utils/ImageUtils';
import { fileUri } from '@kit.CoreFileKit';
import fs from '@ohos.file.fs';

@Entry
@Component
struct ImageEditPage {
  private tag: string = '[Sample_ImageEdit]';
  settingBtn: Resource = $r('app.media.ic_public_settings');
  @Provide pixelMap: image.PixelMap | undefined = undefined;
  @Provide displayPixelMap: image.PixelMap | undefined = undefined;
  @State brightnessSetValue: number = 100;
  @State brightnessSelect: boolean = true;
  @State contrastSetValue: number = 0;
  @State contrastSelect: boolean = false;
  @State cropSetValue: number = 100;
  @State cropSelect: boolean = false;
  @State customSetValue: number = 0;
  @State customSelect: boolean = false;
  @State filterOptions: Array<Array<string | number>> = [];
  @State filterInfo: string = "";

  aboutToAppear(): void {
    console.info(`${this.tag} aboutToAppear called`);
    ImageUtils.getInstance().getPixelMap($r('app.media.ic_1080x1920')).then(pixelMap => {
      this.pixelMap = pixelMap;
    })
    ImageUtils.getInstance().getPixelMap($r('app.media.ic_1080x1920')).then(pixelMap => {
      this.displayPixelMap = pixelMap;
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

        Row({ space: 0 }) {
          Button() {
            Image(this.settingBtn)
              .width($r('app.float.title_image_width'))
              .height($r('app.float.title_image_height'))
              .id('btn_setting')
          }
          .height('100%')
          .type(ButtonType.Normal)
          .aspectRatio(1)
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
      .margin({ top: $r('app.float.home_page_title_margin') })

      Column() {
        Image(this.displayPixelMap)
          .objectFit(ImageFit.None)
      }
      .clip(true)
      .width('100%')
      .height('85%')

      Column() {
        Row() {
          Button("Reset").id("btn_reset").onClick(() => {
            this.pixelInit();
          }).width(100).margin({ left: 3, right: 3, top: 3, bottom: 6 })

          Button("Apply").id("btn_apply").onClick(() => {
            this.doApply();
          }).width(100).margin({ left: 3, right: 3, top: 3, bottom: 6 })
        }
        .justifyContent(FlexAlign.Center)
      }
      .align(Alignment.End)
      .width('100%')
      .height('6%')
      .margin({ top: $r('app.float.home_page_title_margin') })
      .backgroundColor(Color.Black)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }

  private async doSavePixel(): Promise<void> {
    let pixelMap = await ImageUtils.getInstance().getPixelMap($r('app.media.ic_1080x1920'));
    const imagePackerApi = image.createImagePacker();
    const packOption: image.PackingOption = {
      format: 'image/jpeg',
      quality: 100
    };
    let filePath = getContext().filesDir + "/test.jpg";
    let uri = fileUri.getUriFromPath(filePath);
    let imageData = await imagePackerApi.packing(pixelMap, packOption);
    let file = fs.openSync(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    let writeLen = fs.writeSync(file.fd, imageData);
    fs.closeSync(file);
    console.info(`write data to file succeed and size is ${writeLen}`);
  }

  private confirmInfo() {
    this.filterOptions = [];
    if (this.brightnessSelect) {
      let brightnessArray: (string | number)[] = [];
      brightnessArray.push("Brightness", this.brightnessSetValue);
      this.filterOptions.push(brightnessArray);
    }
    if (this.contrastSelect) {
      let contrastArray: (string | number)[] = [];
      contrastArray.push("Contrast", this.contrastSetValue);
      this.filterOptions.push(contrastArray);
    }
    if (this.cropSelect) {
      let cropArray: (string | number)[] = [];
      cropArray.push("Crop", this.cropSetValue);
      this.filterOptions.push(cropArray);
    }
    if (this.customSelect) {
      let customArray: (string | number)[] = [];
      customArray.push("CustomBrightness", this.customSetValue);
      this.filterOptions.push(customArray);
    }
  }

  private async doApply(): Promise<void> {
    this.confirmInfo();
    if (this.brightnessSelect || this.contrastSelect || this.cropSelect || this.customSelect) {
      await this.doSavePixel();
      let filePath = getContext().filesDir + "/test.jpg";
      imageEffect.apply(filePath, [...this.filterOptions]);
      this.displayPixelMap = await ImageUtils.getInstance().getPixelMapByFilePath(filePath);
    }
  }

  private async pixelInit(): Promise<void> {
    this.displayPixelMap?.release();
    this.displayPixelMap = await ImageUtils.getInstance().getPixelMap($r('app.media.ic_1080x1920'))
  }

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
      customSetValue: $customSetValue,
      customSelect: $customSelect,
      filterInfo: $filterInfo,
    }),
    cancel: this.existApp,
    autoCancel: true,
  })

  onCancel() {
    console.info(`Callback when the cancel button is clicked`);
  }

  onAccept() {
    console.info(`Callback when the confirm button is clicked`);
  }

  existApp() {
    console.info(`click the callback in the blank area`);
  }
}

@CustomDialog
struct CustomDialogExample {
  @Link brightnessSetValue: number
  @Link brightnessSelect: boolean
  @Link contrastSetValue: number
  @Link contrastSelect: boolean
  @Link cropSetValue: number
  @Link cropSelect: boolean
  @Link customSetValue: number
  @Link customSelect: boolean
  @Link filterOptions: Array<Array<string | number>>
  @Link filterInfo: string;
  controller: CustomDialogController;
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }
  @State formatList: Array<String> = ["Format:default", "Format:rgba_8888", "Format:nv21", "Format:nv12"]
  @State handlePopup: boolean = false

  @Builder
  FilterInfoMenu() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Center }) {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
        Text(this.filterInfo).fontSize(16)
      }
    }
    .width('60%').height('15%')
    .opacity(0.8)
    .id("filter_info_menu")
  }

  private async doLookFilterInfo(name: String): Promise<void> {
    this.filterInfo = imageEffect.lookupFilterInfo(name);
  }

  build() {
    Column() {
      Column() {
        Divider().height(2).color(0xcccccc)
        Column() {
          Text('Filter')
            .width('100%')
            .fontSize(18)
            .margin({ bottom: 10 })

          Row() {
            Column() {
              Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                Checkbox({ name: 'brightnessCheckbox', group: 'filterCheckboxGroup' })
                  .selectedColor(0x39a2db)
                  .select(this.brightnessSelect)
                  .onChange((value: boolean) => {
                    this.brightnessSelect = value;
                  })
                  .width(10)
                  .height(14)
                  .id("checkbox_brightness")
                Text('Brightness').fontSize(10).width('18%')
                Slider({
                  value: this.brightnessSetValue,
                  min: -100,
                  max: 100,
                  style: SliderStyle.OutSet
                })
                  .showTips(true, this.brightnessSetValue.toFixed())
                  .onChange((value: number, mode: SliderChangeMode) => {
                    this.brightnessSetValue = value
                    console.info('value:' + value + 'mode:' + mode.toString())
                  })
                  .width('60%')
                  .id("slider_brightness")
                // toFixed(0)将滑动条返回值处理为整数精度
                Column() {
                  Text(this.brightnessSetValue.toFixed(0)).fontSize(12)
                }.width('8%')

                Column() {
                  Image($r('app.media.ic_public_search'))
                    .width('5%')
                    .height('3.7%')
                }.bindMenu(this.FilterInfoMenu, {
                  onAppear: () => {
                    this.doLookFilterInfo("Brightness");
                  },
                  onDisappear: () => {
                    this.filterInfo = "";
                  }
                })
                .margin({ left: 2 })
                .id("btn_search_brightness")
              }

              Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                Checkbox({ name: 'contrastCheckbox', group: 'filterCheckboxGroup' })
                  .selectedColor(0x39a2db)
                  .select(this.contrastSelect)
                  .onChange((value: boolean) => {
                    this.contrastSelect = value;
                  })
                  .width(10)
                  .height(14)
                  .id("checkbox_contrast")
                Text('Contrast').fontSize(10).width('18%')
                Slider({
                  value: this.contrastSetValue,
                  min: -100,
                  max: 100,
                  style: SliderStyle.OutSet
                })
                  .showTips(true, this.contrastSetValue.toFixed())
                  .onChange((value: number, mode: SliderChangeMode) => {
                    this.contrastSetValue = value
                    console.info('value:' + value + 'mode:' + mode.toString())
                  })
                  .width('60%')
                  .id("slider_contrast")
                // toFixed(0)将滑动条返回值处理为整数精度
                Column() {
                  Text(this.contrastSetValue.toFixed(0)).fontSize(12)
                }.width('8%')

                Column() {
                  Image($r('app.media.ic_public_search'))
                    .width('5%')
                    .height('3.7%')
                }.bindMenu(this.FilterInfoMenu, {
                  onAppear: () => {
                    this.doLookFilterInfo("Contrast");
                  },
                  onDisappear: () => {
                    this.filterInfo = "";
                  }
                })
                .margin({ left: 2 })
                .id("btn_search_contrast")
              }

              Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                Checkbox({ name: 'cropCheckbox', group: 'filterCheckboxGroup' })
                  .selectedColor(0x39a2db)
                  .select(this.cropSelect)
                  .onChange((value: boolean) => {
                    this.cropSelect = value;
                  })
                  .width(10)
                  .height(14)
                  .id("checkbox_crop")
                Text('Crop').fontSize(10).width('18%')
                Slider({
                  value: this.cropSetValue,
                  min: 1,
                  max: 100,
                  style: SliderStyle.OutSet
                })
                  .showTips(true, this.cropSetValue.toFixed())
                  .onChange((value: number, mode: SliderChangeMode) => {
                    this.cropSetValue = value
                    console.info('value:' + value + 'mode:' + mode.toString())
                  })
                  .width('60%')
                  .id("slider_crop")
                // toFixed(0)将滑动条返回值处理为整数精度
                Column() {
                  Text(this.cropSetValue.toFixed(0)).fontSize(12)
                }.width('8%')

                Column() {
                  Image($r('app.media.ic_public_search'))
                    .width('5%')
                    .height('3.7%')
                }.bindMenu(this.FilterInfoMenu, {
                  onAppear: () => {
                    this.doLookFilterInfo("Crop");
                  },
                  onDisappear: () => {
                    this.filterInfo = "";
                  }
                })
                .margin({ left: 2 })
                .id("btn_search_crop")
              }

              Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                Checkbox({ name: 'customCheckbox', group: 'filterCheckboxGroup' })
                  .selectedColor(0x39a2db)
                  .select(this.customSelect)
                  .onChange((value: boolean) => {
                    this.customSelect = value;
                  })
                  .width(10)
                  .height(14)
                  .id("checkbox_custom")
                Text('Custom').fontSize(10).width('18%')
                Slider({
                  value: this.customSetValue,
                  min: -100,
                  max: 100,
                  style: SliderStyle.OutSet
                })
                  .showTips(true, this.customSetValue.toFixed())
                  .onChange((value: number, mode: SliderChangeMode) => {
                    this.customSetValue = value
                    console.info('value:' + value + 'mode:' + mode.toString())
                  })
                  .width('60%')
                  .id("slider_custom")
                // toFixed(0)将滑动条返回值处理为整数精度
                Column() {
                  Text(this.customSetValue.toFixed(0)).fontSize(12)
                }.width('8%')

                Column() {
                  Image($r('app.media.ic_public_search'))
                    .width('5%')
                    .height('3.7%')
                }.bindMenu(this.FilterInfoMenu, {
                  onAppear: () => {
                    this.doLookFilterInfo("CustomBrightness");
                  },
                  onDisappear: () => {
                    this.filterInfo = "";
                  }
                })
                .margin({ left: 2 })
                .id("btn_search_custom")
              }
            }
            .width('100%')
          }
        }
      }.margin({ bottom: 10 })

      Column() {
        Divider().height(2).color(0xCCCCCC);
        Column() {
          Text($r('app.string.look_up'))
            .width('100%')
            .fontSize(18)
            .margin({ bottom: 10 })
          Row() {
            Column() {
              Text($r('app.string.btn_search'))
                .width('15%')
                .fontSize(20)
                .margin({ left: '35%' })
            }

            Column() {
              Image($r('app.media.ic_public_arrow_right'))
                .fillColor(Color.Black)
                .width('10%')
                .height('4%')
            }
          }
          .id("btn_search")
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .bindMenu(this.LookupCategoryMenuBuilder)
        }
      }.margin({ bottom: 10 })

      Divider().height(2).color(0xCCCCCC)

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button($r('app.string.btn_cancel'))
          .onClick(() => {
            this.controller.close()
            this.cancel();
          }).backgroundColor(0xffffff)
          .fontColor(Color.Black)
          .id("btn_dialog_cancel")
        Button($r('app.string.btn_confirm'))
          .onClick(() => {

            this.controller.close()
            this.confirm()
          }).backgroundColor(0xffffff)
          .fontColor(Color.Red)
          .id("btn_dialog_confirm")
      }
    }.margin(24)
  }

  @Builder
  LookupCategoryMenuBuilder() {
    Menu() {
      MenuItem({ content: "Format" }).bindMenu(this.FormatMenuBuilder())
    }.id("menu_category")
  }

  @Builder
  FormatMenuBuilder() {
    Menu() {
      ForEach(this.formatList, (item: string, index) => {
        LookupFilterMenuItem({ item: item })
          .id("menu_format")
      })
    }
  }
}

@Component
struct LookupFilterMenuItem {
  @State item: string = "";
  @State handlePopup: boolean = false

  build() {
    MenuItem({ content: this.item })
      .bindPopup(this.handlePopup, {
        message: 'Filters:\n' + imageEffect.lookupFilters(this.item),
        messageOptions: {
          font: {
            size: '14vp',
            style: FontStyle.Italic
          },
        },
        placementOnTop: false,
        onStateChange: (e) => {
          console.log(e.isVisible.toString())
          if (!e.isVisible) {
            this.handlePopup = false
          }
        }
      })
      .onClick(() => {
        this.handlePopup = !this.handlePopup
      })
  }
}
