/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import router from '@ohos.router';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import picker from '@ohos.file.picker';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import image from '@ohos.multimedia.image';
import Logger from '../utils/Logger';
import CommonConstants from '../common/constants/CommonConstants';
import { BusinessError } from '@ohos.base';
import { LooperUtil } from '../utils/LooperUtil';

const TAG = 'testTag_Notes: ';
let context = getContext(this) as common.UIAbilityContext; //获取设备A&B UIAbilityContext信息
let disPath: string = context.distributedFilesDir;
//获取分布式目录的文件路径
let filePath: string = disPath + '/picture.jpg';

@Entry
@Component
struct Notes {
  @State text: string = '';
  @State img: string = 'app.media.pic_image';
  @StorageLink('isContinuation') isContinuation: boolean = false;
  @StorageLink('isSelectImg') isSelectImg: boolean = false;
  @StorageLink('inputText') inputText: string = '';
  @StorageLink('inputTextArea') inputTextArea: string = '';
  @StorageLink('imgStr') imgStr: string = 'app.media.pic_image';
  @StorageLink('ability_isON') stoLink_ability_isON: boolean = true;
  controller: TextAreaController = new TextAreaController();
  @State num: number = 0;
  @State image1: PixelMap | null = null; // 图一展示照片(选择或流转)
  @State image2: Object = new Object; // 图二展示照片(选择或流转)
  @StorageLink('imgIsVisible1') imgIsVisible1: boolean = true;
  @StorageLink('imgIsVisible2') imgIsVisible2: boolean = true;
  @State showSubMenus: boolean = false;
  @State jpgStr: string = '';
  @State uris: Array<string> = []; // 用于接受 PhotoViewPicker选择图片1的返回的uri(分布式文件方式)
  @State uris2: Array<string> = []; // 用于接受 PhotoViewPicker选择图片2的返回的uri(分布式文件方式)
  @State fileName: string = '';
  @State readLenAtSink: number = 0;
  private imgArray: Resource[] = [
  $r('app.media.pic_image'),
  $r('app.media.img_08'),
  $r('app.media.img_07')
  ]

  // 从图库中选择图片
  async choosePictureFile() {
    try {
      let photoSelectOptions = new picker.PhotoSelectOptions();
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 1;
      let photoPicker = new picker.PhotoViewPicker();
      photoPicker.select(photoSelectOptions).then((photoSelectResult) => {
        if (!photoSelectResult) {
          Logger.error(TAG, 'photoSelectResult = null');
          return;
        }
        this.uris = photoSelectResult.photoUris;

        if (this.writeSrcToDistributedFile(this.uris)) {
          Logger.info(TAG, 'copy file success');
          // 成功写入图片后将标志设为true
          AppStorage.set('isSelectImg', true);
          this.isSelectImg = true;
          Logger.info(TAG, "AppStorage.get<boolean>('isSelectImg') :" + AppStorage.get<boolean>('isSelectImg'));
        } else {
          Logger.error(TAG, 'copy file failed');
        }

        // 获取图库中清晰图片PixelMap
        // 1.通过uri打开文件得到fd
        let file = fs.openSync(this.uris[0], fs.OpenMode.READ_ONLY);
        Logger.info(TAG, 'file.fd:' + file.fd);
        // 2.通过imageSourceApi来创建pixelMap并直接显示
        let imageSourceApi = image.createImageSource(file.fd);
        if (imageSourceApi) {
          imageSourceApi.createPixelMap().then((pixelMap) => {
            this.image1 = pixelMap;
            this.imgIsVisible1 = false;
          });
        } else {
          Logger.info(TAG, 'imageSourceApi is undefined');
        }
      })
    } catch (error) {
      Logger.error(TAG, 'photoPicker failed with error: ' + JSON.stringify(error));
    }
  }

  writeSrcToDistributedFile(uris: string[]): boolean {
    if (!uris.length) {
      Logger.error(TAG, 'uri length is empty');
      return false;
    }
    Logger.info(TAG, 'uri length = ' + uris.length);
    // 选中后先删除之前的文件
    try {
      let res = fs.accessSync(filePath);
      if (res) {
        fs.unlink(filePath);
        Logger.info(TAG, ' delete file successfully');
      } else {
        Logger.info(TAG, 'delete file failed');
      }
      // 重新写文件
      let srcFile = fs.openSync(uris[0], fs.OpenMode.READ_ONLY);
      let dstFile = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      Logger.info(TAG, 'open srcFile dstFile success!');
      const bufSize = 4096;
      let readSize = 0;
      let buf = new ArrayBuffer(bufSize);
      let readLen = fs.readSync(srcFile.fd as number, buf, { offset: readSize });
      while (readLen > 0) {
        readSize += readLen;
        fs.writeSync(dstFile.fd as number, buf, { length: readLen });
        readLen = fs.readSync(srcFile.fd as number, buf, { offset: readSize });
      }
      Logger.info(TAG, 'copy file success size： ' + readSize);
      fs.close(srcFile);
      fs.close(dstFile);
      return true;
    } catch (error) {
      Logger.error(TAG, 'open file fail with err: ' + JSON.stringify(error));
      return false;
    }
  }

  readFromDistributedFile(): void {
    Logger.info(TAG, 'readFromDistributedFile: filePath: ' + filePath);
    try {
      Logger.info(TAG, 'readFromDistributedFile try to read');
      // 查看并打开分布式目录下的文件
      if (fs.accessSync(filePath)) {
        Logger.info(TAG, filePath + ' exists');
      } else {
        Logger.error(TAG, filePath + 'not exists');
        return;
      }
      // 通过imageSourceApi来创建pixelMap 并负责流转后展示
      let imageSourceApi = image.createImageSource(filePath);
      imageSourceApi.createPixelMap().then((pixelMap) => {
        this.image1 = pixelMap;
        this.imgIsVisible1 = false;
      });
      Logger.info(TAG, 'readFromDistributedFile is ready');
    } catch (error) {
      Logger.error(TAG, 'readFromDistributedFile failed with error :' + JSON.stringify(error));
    }
  }

  choosePictureFileForImage2(): void {
    try {
      let photoSelectOptions = new picker.PhotoSelectOptions();
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 1;
      let photoPicker = new picker.PhotoViewPicker();
      photoPicker.select(photoSelectOptions).then((photoSelectResult) => {
        if (!photoSelectResult) {
          Logger.error(TAG, 'choosePicture2 photoSelectResult = null');
          return;
        }
        this.uris2 = photoSelectResult.photoUris;

        if (this.writeDistributedAsset()) {
          Logger.info(TAG, "choosePicture2 success");
        } else {
          Logger.error(TAG, 'choosePicture2 failed');
        }

        // 获取图库中清晰图片PixelMap
        // 1.通过uri打开文件得到fd
        let file = fs.openSync(this.uris2[0], fs.OpenMode.READ_ONLY);
        // 2.通过imageSourceApi来创建pixelMap并直接显示
        let imageSourceApi = image.createImageSource(file.fd);
        if (imageSourceApi) {
          imageSourceApi.createPixelMap().then((pixelMap) => {
            this.image2 = pixelMap;
            this.imgIsVisible2 = false;
          });
          AppStorage.setOrCreate<string>('image2Path', CommonConstants.DISTRIBUTED_ASSET_SAVE_PATH);
        } else {
          Logger.info(TAG, 'choosePicture2 imageSourceApi is undefined');
        }
      })
    } catch (error) {
      Logger.error(TAG, 'choosePicture2 photoPicker failed with error: ' + JSON.stringify(error));
    }
  }

  writeDistributedAsset(): boolean {
    Logger.info(TAG, 'writeDistributedAsset in');
    // 删除目录
    try {
      fs.rmdirSync(CommonConstants.DISTRIBUTED_ASSET_DIR);
      Logger.info(TAG, 'remove dir successful');
    } catch (error) {
      Logger.info(TAG, `remove dir failed, cause: ${JSON.stringify(error)}`);
    }
    try {
      fs.mkdirSync(CommonConstants.DISTRIBUTED_ASSET_DIR, true);
      let srcFile = fs.openSync(this.uris2[0], fs.OpenMode.READ_ONLY);
      let dstFile = fs.openSync(CommonConstants.DISTRIBUTED_ASSET_SAVE_PATH, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      Logger.info(TAG, 'writeDistributedAsset open srcFile dstFile success!');
      const bufSize = 4096;
      let readSize = 0;
      let buf = new ArrayBuffer(bufSize);
      let readLen = fs.readSync(srcFile.fd as number, buf, { offset: readSize });
      while (readLen > 0) {
        readSize += readLen;
        fs.writeSync(dstFile.fd as number, buf, { length: readLen });
        readLen = fs.readSync(srcFile.fd as number, buf, { offset: readSize });
      }
      Logger.info(TAG, 'copy file success size： ' + readSize);
      fs.close(srcFile);
      fs.close(dstFile);
      return true;
    } catch (error) {
      Logger.error(TAG, `writeDistributedAsset error, cause: ${JSON.stringify(error)}`);
    }
    return false;
  }

  readDistributedAsset(): void {
    Logger.info(TAG, 'readDistributedAsset in');
    try {
      let image2Path = AppStorage.get<string>('image2Path');
      if (image2Path == undefined || image2Path == '') {
        Logger.info(TAG, `image2Path error, cause: $JSON.stringify(image2Path)`);
        return;
      }
      if (fs.accessSync(image2Path)) {
        Logger.info(TAG, 'open distributed asset successfully');
      } else {
        Logger.error(TAG, 'distributed asset does not exists');
        return;
      }
      let imageSource = image.createImageSource(image2Path);
      imageSource.createPixelMap().then((pixelMap) => {
        Logger.info(TAG, 'createPixelMap successfully')
        this.image2 = pixelMap;
        this.imgIsVisible2 = false;
      })
      Logger.info(TAG, 'readDistributedAsset successfully');
    } catch (error) {
      Logger.error(TAG, `readDistributedAsset error, cause: ${JSON.stringify(error)}`);
    }
  }

  aboutToAppear() {
    Logger.info(TAG, 'aboutToAppear in');
    LooperUtil.on(CommonConstants.EVENT_DATA_RESTORE, () => {
      this.readDistributedAsset();
    });
    if (this.isContinuation) {
      if (this.isSelectImg) {
        this.readFromDistributedFile();
      }
    }
  }

  aboutToDisappear(): void {
    Logger.info(TAG, 'aboutToDisappear in');
    LooperUtil.off(CommonConstants.EVENT_DATA_RESTORE);
    AppStorage.set<string>('image2Path', '');
    this.isSelectImg = false;
    this.imgIsVisible1 = true;
    this.imgIsVisible2 = true;
  }

  build() {
    Row() {
      Column() {
        Column() {

          // 顶部导航
          Flex({ direction: FlexDirection.Row }) {
            Row() {
              Image($r('app.media.ic_back'))
                .width(24)
                .height(24)
                .margin({ right: 16 })
                .id('back_arrow_notes')

            }
            .width(30)
            .height(30)
            .onClick(() => {
              router.back()
            })

            Text(CommonConstants.NOTES_TITLE)
              .fontSize(20)
              .fontWeight(500)
              .margin({ top: 5, left: 16 })

          }
          .margin({ top: 36, left: 24, bottom: 14 })
          .width(360)

          Column() {

            TextInput({ text: this.inputText,
              placeholder: CommonConstants.PLEASE_INPUT_NOTE_TITLE
            })
              .fontWeight(500)
              .fontSize(30)
              .textAlign(TextAlign.JUSTIFY)
              .align(Alignment.Center)
              .height(51)
              .onChange((value: string) => {
                this.inputText = value;
                AppStorage.set('inputText', value);
                Logger.info(TAG, 'this.inputText: ' + this.inputText);
              })
              .type(InputType.Normal)
              .backgroundColor(Color.Transparent)
              .margin({ left: -14 })
              .restoreId(2)
              .id('textInput')


            Text(CommonConstants.NOTES_TIME)
              .fontWeight(400)
              .fontSize(14)
              .textAlign(TextAlign.JUSTIFY)
              .fontColor('#182431')
              .lineHeight(19)

            TextArea({
              text: this.inputTextArea,
              placeholder: CommonConstants.PLEASE_INPUT_NOTE_CONTENT,
              controller: this.controller
            })
              .placeholderFont({ size: 16, weight: 400 })
              .placeholderColor('#182431')
              .width('100%')
              .height(126)
              .margin({ top: 16 })
              .fontSize(16)
              .fontColor('#182431')
              .backgroundColor('#FFFFFF')
              .onChange((value: string) => {
                this.inputTextArea = value;
                AppStorage.set('inputTextArea', value);
              })
              .restoreId(3)
              .id('textArea')


            // 分布式文件: 迁移图片1
            Row() {
              // 初始占位小图
              Image(this.imgArray[0])
                .width(48)
                .height(48)
                .margin({ left: 144 })
                .visibility(this.imgIsVisible1 ? Visibility.Visible : Visibility.None)
              //大图
              Image(this.image1)
                .width('100%')
                .height('100%')
                .borderRadius(24)
                .syncLoad(true)
                .onComplete((msg) => {
                  Logger.info(TAG, 'load image success 01');
                })// 图片获取失败打印结果
                .onError(() => {
                  Logger.info(TAG, 'load image fail 01');
                })
                .visibility(this.imgIsVisible1 ? Visibility.None : Visibility.Visible)
            }
            .width('100%')
            .height(154)
            .backgroundColor('#FFFFFF')
            .borderRadius(24)
            .margin({ top: 12 })

            Text($r('app.string.PICTURE_ONE'))
              .fontSize(12)
              .fontColor('#182431')
              .height(16)
              .fontWeight(500)
              .margin({ top: 8, left: 152 })
            // 分布式对象携带附件: 迁移图片2
            Row() {
              // 初始站位小图
              Image(this.imgArray[0])
                .width(48)
                .height(48)
                .margin({ left: 144 })
                .visibility(this.imgIsVisible2 ? Visibility.Visible : Visibility.None)
              // 大图
              Image(this.image2 as PixelMap)
                .width('100%')
                .height('100%')
                .borderRadius(24)
                .syncLoad(true)
                .onComplete((msg) => {
                  Logger.info(TAG, 'load image success 03');
                })// 图片获取失败打印结果
                .onError(() => {
                  Logger.info(TAG, 'load image fail 03')
                })
                .visibility(this.imgIsVisible2 ? Visibility.None : Visibility.Visible)
            }
            .width('100%')
            .height(154)
            .backgroundColor('#FFFFFF')
            .borderRadius(24)
            .margin({ top: 12 })

            Text($r('app.string.PICTURE_TWO'))
              .fontSize(12)
              .fontColor('#182431')
              .height(16)
              .fontWeight(500)
              .margin({ top: 8, left: 152, bottom: 32 })

            Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
              Button($r('app.string.pick_photo_one'), { type: ButtonType.Capsule, stateEffect: true })
                .backgroundColor('rgba(24,36,49,0.05)')
                .width(150)
                .height(40)
                .fontColor('#007DFF')
                .margin({ right: 12 })
                .onClick(() => {
                  this.choosePictureFile();
                })
                .id('button_select_picture_One')


              Button($r('app.string.pick_photo_two'), { type: ButtonType.Capsule, stateEffect: true })
                .backgroundColor('rgba(24,36,49,0.05)')
                .width(150)
                .height(40)
                .fontColor('#007DFF')
                .onClick(() => {
                  this.choosePictureFileForImage2();
                })
                .id('button_select_picture_two')

            }
          }
          .width(336)
          .alignItems(HorizontalAlign.Start)
        }
        .width(360)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .alignItems(VerticalAlign.Top)
    .backgroundColor('#f1f3f5')
  }
}