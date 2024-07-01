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
 * WITHOUT WARRANTIES OR CONDITIONS OF InputStyle KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import fs from '@ohos.file.fs';
import fileUri from '@ohos.file.fileuri';
import common from '@ohos.app.ability.common';
import utdDesc from '@ohos.data.uniformTypeDescriptor';
import { BusinessError } from '@ohos.base';
import { logger } from '../util/Logger';
import UDC from '@ohos.data.unifiedDataChannel';
import UTD from '@ohos.data.uniformTypeDescriptor';
import FileFs from '../fileFs/fileFs'
import { randomString } from '../util/Common';

const TAG: string = 'UDMF_Demo';

// 获取应用文件路径
let context = getContext(this) as common.UIAbilityContext;
let baseDir = context.filesDir;
let filesDir = baseDir + '/udmf_demo_test';

let class2UTD = new Map([
  ["All", "All"],
  ["Images", "general.image"],
  ["Audios", "general.audio"],
  ["Videos", "general.video"],
  ["Text", "general.text"],
  ["Archive", "general.archive"],
  ["Calendar", "general.calendar"]
]);

class FileInfo {
  filename: string;
  iconFile: string;

  constructor(fileName: string, iconFile: string) {
    this.filename = fileName;
    this.iconFile = iconFile;
  }
}

let precastFiles: string[] = [
  "test1.txt",
  "imagePng1.png",
  "imageJpg2.jpg",
  "imageTiff1.tiff",
  "imageTiff2.tiff",
  "imageMyImage1.myImage",
  "imageMyImage2.myImage",

  "myPsd.psd",
  "audioMp32.mp3",
  "audioWav1.wav",
  "audioWav2.wav",
  "myBz2.bz2",
  "myZip.zip",
  "audioMyAudio1.myAudio",
  "audioMyAudio2.myAudio",

  "myHtml.html",
  "myXml.xml",
  "myIcs.ics",
  "videoMpeg2.mpeg",
  "myVcs.vcs",
  "videoAvi2.avi",
  "myTar.tar",
  "videoMyVideo2.myVideo",
];

// 预制文件
function CreatePrecastFile(): void {
  try {
    let res = fs.accessSync(filesDir);
    if (res) {
      logger.info(TAG, `file path: ${filesDir} exists`);
    } else {
      logger.info(TAG, `file path: ${filesDir} not exists`);
      fs.mkdirSync(filesDir);
    }
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    logger.error(TAG, 'accessSync failed with error message: ' + err.message + ', error code: ' + err.code);
  }

  for (let i = 0; i < precastFiles.length; i++) {
    let fileName = filesDir + '/' + precastFiles[i];
    logger.info(TAG, `The file name: ${fileName}`);
    try {
      let res = fs.accessSync(fileName);
      if (res) {
        logger.info(TAG, `file: ${fileName} exists!.`);
      } else {
        logger.info(TAG, `file: ${fileName} not exists, will create it!.`);
        let file = fs.openSync(fileName, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        logger.info(TAG, 'file fd: ' + file.fd);

        if (fileName.includes('.txt')) {
          logger.info(TAG, 'txt file write sync ');
          fs.writeSync(file.fd, 'test content 1 test content 2');
        }
        fs.closeSync(file);
      }
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      logger.error(TAG, 'accessSync failed with error message: ' + err.message + ', error code: ' + err.code);
    }
  }
}

function saveAsFileContent(fileName: string, content: string) {
  logger.info(TAG, `The file name: ${fileName}`);
  try {
    let res = fs.accessSync(fileName);
    if (res) {
      logger.info(TAG, `file: ${fileName} exists!.`);
    } else {
      logger.info(TAG, `file: ${fileName} not exists, will create it!.`);
      let file = fs.openSync(fileName, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      logger.info(TAG, 'file fd: ' + file.fd);

      if (fileName.includes('.txt')) {
        logger.info(TAG, 'txt file write sync ');
        fs.writeSync(file.fd, content);
      }
      fs.closeSync(file);
    }
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    logger.error(TAG, 'accessSync failed with error message: ' + err.message + ', error code: ' + err.code);
  }
}

function getIconByType(fileName: string) {
  let index = fileName.lastIndexOf('.');
  let fileExtension = fileName.substring(index);
  logger.info(TAG, `getIconByType fileExtension： ${fileExtension}`);

  let utd = utdDesc.getUniformDataTypeByFilenameExtension(fileExtension); // `.txt`
  let typeObj: utdDesc.TypeDescriptor = utdDesc.getTypeDescriptor(utd);
  logger.info(TAG, `getIconByType typeObj.iconFile: ${typeObj.iconFile}`);
  if (typeObj.iconFile == '') {
    logger.info(TAG, `getIconByType typeObj.iconFile is null`);
    let iconFile: string = 'app.media.ic_select_option_collection';
    return iconFile;
  }
  return typeObj.iconFile;
}

// async function convertResourceToString(resource: Resource) {
//   return await context.resourceManager.getStringValue(resource.id)
// }

async function convertResourceToString(resource: Resource) {
  // let result: string = ''
  let value: string = await context.resourceManager.getStringValue($r('app.string.text_target_tips').id);

  //   then((value: Object) => {
  //     logger.info(TAG, 'getStringValue ok.');
  //     result = value.toString();
  //   }).catch((error: BusinessError) => {
  //   logger.error(TAG, 'Failed to getStringValue.');
  // });
  logger.info(TAG, 'getStringValue value： ' + value);
  return value;
}

@Entry
@Component
struct Index {
  // @State textContentTarget: string = '将文件/文本拖入此处'; // $r('app.string.text_target_tips')
  // string promise<string>
  @State textContentTarget: string = '';

  @StorageLink('filesDir') filesDir: string = '';

  fileFs: FileFs = new FileFs();
  @State text: string = 'All';
  @State index: number = 1;
  @State space: number = 12;
  @State arrowPosition: ArrowPosition = ArrowPosition.END;
  @State fileNames: string[] = [];
  @State selectedFilesInfos: FileInfo[] = [];
  @State textContent: string = '';
  // @State textContentTarget: string = '';
  @State backGroundColor: Color = Color.Transparent;
  controller: TextAreaController = new TextAreaController()
  controllerTarget: TextAreaController = new TextAreaController()

  getListFile(): string[] {
    let files = fs.listFileSync(filesDir);
    return files;
  }

  UpdateSelectedFiles(): void {
    this.fileNames = this.getListFile();
    for (let i = this.selectedFilesInfos.length - 1; i >= 0; i--) {
      this.selectedFilesInfos.pop();
    }
    this.selectedFilesInfos = [];
    logger.info(TAG, 'selectText: ' + this.text);
    for (let i = 0; i < this.fileNames.length; i++) {
      let fileName = this.fileNames[i];
      let index = fileName.lastIndexOf('.');
      if (index < 0) {
        logger.info(TAG, `fileNames file: ${fileName}`);
        if (this.text == 'All') {
          let fileInfo = new FileInfo(fileName, '');
          this.selectedFilesInfos.push(fileInfo);
        }
        continue;
      } else {
        let fileExtension = fileName.substring(index);
        logger.info(TAG, `fileExtension： ${fileExtension}`);
        let utd = utdDesc.getUniformDataTypeByFilenameExtension(fileExtension);
        logger.info(TAG, `fileNames file: ${fileName}, extension: ${fileExtension}, utd: ${utd}`);
        try {
          if (utd != null) {
            let typeObj: utdDesc.TypeDescriptor = utdDesc.getTypeDescriptor(utd);

            if (class2UTD.get(this.text) == 'All') {
              let fileInfo = new FileInfo(fileName, typeObj.iconFile);
              this.selectedFilesInfos.push(fileInfo);
              logger.info(TAG, `All type: ${fileInfo.filename}, utd: ${utd}, iconFile: ${fileInfo.iconFile}`);
            } else {
              let ret = typeObj.belongsTo(class2UTD.get(this.text));
              logger.info(TAG, `typeObj.belongsTo: ${fileName}, utd: ${class2UTD.get(this.text)}, ret: ${ret} iconFile: ${typeObj.iconFile}`);
              if (ret) {
                let fileInfo = new FileInfo(fileName, typeObj.iconFile);
                this.selectedFilesInfos.push(fileInfo);
              }
            }
          } else {
            if (class2UTD.get(this.text) == 'All') {
              let fileInfo = new FileInfo(fileName, '');
              this.selectedFilesInfos.push(fileInfo);
              logger.info(TAG, `utd null All type: ${fileInfo.filename}, utd: ${utd}, iconFile: ${fileInfo.iconFile}`);
            }
          }
        } catch (e) {
          let error: BusinessError = e as BusinessError;
          logger.error(TAG, `belongsTo throws an exception. code is ${error.code}, message is ${error.message}`);
        }
      }
    }
    logger.info(TAG, `all files ${JSON.stringify(this.selectedFilesInfos)}}`);
  }

  aboutToAppear() {
    logger.info(TAG, 'filesDir: ' + filesDir);
    convertResourceToString($r('app.string.text_target_tips')).then((val) => {
      this.textContentTarget = val;
    })
    CreatePrecastFile();
    this.UpdateSelectedFiles();
  }

  aboutToDisappear() {
    for (let i = this.selectedFilesInfos.length - 1; i >= 0; i--) {
      this.selectedFilesInfos.pop();
    }
  }

  getDataFromUdmfRetry(event: DragEvent, callback: (data: DragEvent) => void) {
    try {
      let data: UnifiedData = event.getData();
      if (!data) {
        return false;
      }
      let records: UDC.UnifiedRecord[] = data.getRecords();
      if (!records || records.length <= 0) {
        return false;
      }
      callback(event);
      return true;
    } catch (e) {
      console.log('getData failed, code = ' + (e as BusinessError).code + ', message = ' + (e as BusinessError).message);
      return false;
    }
  }

  getDataFromUdmf(event: DragEvent, callback: (data: DragEvent) => void) {
    if (this.getDataFromUdmfRetry(event, callback)) {
      return;
    }
    setTimeout(() => {
      this.getDataFromUdmfRetry(event, callback);
    }, 1500);
  }

  build() {
    Row() {
      Column() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
          Text($r('app.string.UDMF_demo'))
            .fontStyle(FontStyle.Normal)
            .fontSize(20)
            .fontWeight(700)
            .textAlign(TextAlign.Start)
            .id('titleText')
        }
        .width('30%')
        .height('5%')
        .margin({ left: 12 })

        // 下拉选择框
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.SpaceBetween }) {
          Select([{ value: 'All', icon: $r('app.media.ic_select_option_collection') },
            { value: 'Images', icon: $r(getIconByType('test.png')) },
            { value: 'Audios', icon: $r(getIconByType('test.mp3')) },
            { value: 'Videos', icon: $r(getIconByType('test.avi')) },
            { value: 'Text', icon: $r(getIconByType('test.txt')) },
            { value: 'Archive', icon: $r(getIconByType('test.zip')) },
            { value: 'Calendar', icon: $r(getIconByType('test.ics')) }
          ])
            .selected(this.index)
            .value(this.text)
            .id('SelectTypeList')
            .font({ size: 16, weight: 500 })
            .fontColor('#182431')
            .selectedOptionFont({ size: 16, weight: 500 })
            .optionFont({ size: 16, weight: 500 })
            .space(this.space)
            .arrowPosition(this.arrowPosition)
            .menuAlign(MenuAlignType.START, { dx: 0, dy: 0 })
            .backgroundColor($r('app.color.bottom_title_divider'))
            .width('30%')
            .height('30%')
            .onSelect((index: number, text?: string | undefined) => {
              this.index = index;
              if (text) {
                this.text = text;
                logger.info(TAG, 'Select type:' + text);
                this.UpdateSelectedFiles();
              }
            })

          // placeholder: $r('app.string.text_target_tips'),

          Text(this.textContentTarget)
            // .placeholderFont({ size: 16, weight: 500 })
            .backgroundColor($r('app.color.bottom_title_divider'))
            .width('70%')
            .height(42)
            .margin({ left: 12, right: 12 })
            .fontSize(16)
            // .maxLength(50)
            .maxLines(1)
            .fontColor('#182431')
            .id('targetText')
            .borderRadius(24)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .padding({left: 12})
            // .onChange((value: string) => {
            //   this.textContentTarget = value
            //   logger.info(TAG, `textContentTarget onChange this.textContentTarget：` + this.textContentTarget);
            // })
            // .onClick((event: ClickEvent) => {
            //   logger.info(TAG, `textContentTarget onClick this.textContentTarget：` + this.textContentTarget);
            //   this.textContentTarget = '';
            // })
            .allowDrop([UTD.UniformDataType.PLAIN_TEXT, UTD.UniformDataType.FILE])
            .onDrop((dragEvent?: DragEvent) => {
              logger.info(TAG, `textContentTarget onDrop this.textContentTarget：` + this.textContentTarget);
              this.getDataFromUdmf((dragEvent as DragEvent), (event: DragEvent) => {
                let records: Array<UDC.UnifiedRecord> = event.getData().getRecords();
                let type: string  = records[0].getType();
                if(type == UTD.UniformDataType.FILE) {
                  logger.info(TAG, 'general.file is true!');
                  let file: UDC.File = records[0] as UDC.File;
                  let name: string = randomString(6, 'UDMFDemo');

                  let details: Record<string, string> | undefined = file.details
                  if (details == undefined) {
                    return;
                  }

                  let fileTestDirPathNew: string = filesDir + "/" + name + '_' + details.name;
                  let fileTestDirPath: string = filesDir + "/" + details.name;
                  logger.info(TAG, 'fileTestDirPathNew: ' + fileTestDirPathNew);

                  let content: string = this.fileFs.getFileContent(fileTestDirPath);
                  saveAsFileContent(fileTestDirPathNew, content);
                  this.UpdateSelectedFiles();
                  this.textContentTarget = 'Save as ' + name + '_' + details.name;
                } else if (type == UTD.UniformDataType.PLAIN_TEXT) {
                  logger.info(TAG, 'general.plain-text is true!');
                  let plainText: UDC.PlainText = records[0] as UDC.PlainText;

                  let name: string = randomString(6, 'UDMFDemo') + '.txt';
                  let fileTestDirPathNew = filesDir + "/" + 'new_' + name;

                  logger.info(TAG, `textContentTarget onDrop fileTestDirPathNew：` + fileTestDirPathNew);
                  logger.info(TAG, `textContentTarget onDrop  plainText.textContent：` +  plainText.textContent);

                  saveAsFileContent(fileTestDirPathNew, plainText.textContent);
                  this.UpdateSelectedFiles();
                  this.textContentTarget = 'Content save as ' + 'new_' + name;
                    logger.info(TAG, `textContentTarget onDrop  this.textContentTarget：` +  this.textContentTarget);
                }
              })
            })

          // TextArea({
          //   text: this.textContentTarget,
          //   placeholder: $r('app.string.text_target_tips'),
          //   controller: this.controllerTarget
          // })
          //   .placeholderFont({ size: 16, weight: 500 })
          //   .backgroundColor($r('app.color.bottom_title_divider'))
          //   .width('70%')
          //   .height(42)
          //   .margin({ left: 12, right: 12 })
          //   .fontSize(16)
          //   .maxLength(50)
          //   .maxLines(1)
          //   .fontColor('#182431')
          //   .id('targetText')
          //   .onChange((value: string) => {
          //     this.textContentTarget = value
          //     logger.info(TAG, `textContentTarget onChange this.textContentTarget：` + this.textContentTarget);
          //   })
          //   .onClick((event: ClickEvent) => {
          //     logger.info(TAG, `textContentTarget onClick this.textContentTarget：` + this.textContentTarget);
          //     this.textContentTarget = '';
          //   })
          //   .allowDrop([UTD.UniformDataType.PLAIN_TEXT, UTD.UniformDataType.FILE])
          //   .onDrop((dragEvent?: DragEvent) => {
          //     logger.info(TAG, `textContentTarget onDrop this.textContentTarget：` + this.textContentTarget);
          //     this.getDataFromUdmf((dragEvent as DragEvent), (event: DragEvent) => {
          //       let records: Array<UDC.UnifiedRecord> = event.getData().getRecords();
          //       let type: string  = records[0].getType();
          //       if(type == UTD.UniformDataType.FILE) {
          //         logger.info(TAG, 'general.file is true!');
          //         let file: UDC.File = records[0] as UDC.File;
          //         let name: string = randomString(6, 'UDMFDemo');
          //
          //         let details: Record<string, string> | undefined = file.details
          //         if (details == undefined) {
          //           return;
          //         }
          //
          //         let fileTestDirPathNew: string = filesDir + "/" + name + '_' + details.name;
          //         let fileTestDirPath: string = filesDir + "/" + details.name;
          //         logger.info(TAG, 'fileTestDirPathNew: ' + fileTestDirPathNew);
          //
          //         let content: string = this.fileFs.getFileContent(fileTestDirPath);
          //         saveAsFileContent(fileTestDirPathNew, content);
          //         this.UpdateSelectedFiles();
          //         this.textContentTarget = 'Save as ' + name + '_' + details.name;
          //       } else if (type == UTD.UniformDataType.PLAIN_TEXT) {
          //         logger.info(TAG, 'general.plain-text is true!');
          //         let plainText: UDC.PlainText = records[0] as UDC.PlainText;
          //
          //         let name: string = randomString(6, 'UDMFDemo') + '.txt';
          //         let fileTestDirPathNew = filesDir + "/" + 'new_' + name;
          //
          //         logger.info(TAG, `textContentTarget onDrop fileTestDirPathNew：` + fileTestDirPathNew);
          //         logger.info(TAG, `textContentTarget onDrop  plainText.textContent：` +  plainText.textContent);
          //
          //         saveAsFileContent(fileTestDirPathNew, plainText.textContent);
          //         this.UpdateSelectedFiles();
          //         plainText.textContent = 'Content save as ' + 'new_' + name;
          //         this.textContentTarget = plainText.textContent;
          //         logger.info(TAG, `textContentTarget onDrop  this.textContentTarget：` +  this.textContentTarget);
          //       }
          //     })
          //   })
        }
        .margin({ left: 12, right: 12 })
        .height('5%')

        // 文件列表
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
          Text($r('app.string.file_list'))
            .fontStyle(FontStyle.Normal)
            .fontSize(16)
            .fontWeight(700)
            .textAlign(TextAlign.Start)
            .margin({ left: 12, top: 24, bottom: 12 })
            .height('10%')
            .copyOption(CopyOptions.InApp)
            .draggable(true)

          List({ space: 2, initialIndex: 0 }) {
            ForEach(this.selectedFilesInfos, (item: FileInfo, no: Number) => {
              ListItem() {
                Row() {
                  Column() {
                    Row() {
                      Image($r(getIconByType(item.filename)))
                        .objectFit(ImageFit.Contain)
                        .width('10%')
                        .height('60%');
                      Text(item.filename)
                        .fontSize(16)
                        .height(46)
                        .textAlign(TextAlign.Start)
                        .margin({ left: 12, right: 12 })
                        .fontWeight(500)
                        .id('textFilename_' + no)
                        .visibility(Visibility.Visible)
                        .onClick(() => {
                          logger.info(TAG, `selected file：` + item.filename + `and clicked`);
                          logger.info(TAG, `selected file：` + item.filename + `and clicked row`);
                          let fileTestDirPath = filesDir + '/' + item.filename;
                          if (item.filename.includes('.txt')) {
                            this.textContent = this.fileFs.getFileContent(fileTestDirPath);
                            if (this.textContent == '') {
                              this.textContent = item.filename + 'content is empty!'
                            }
                          }
                        })
                    }

                    Divider()
                      .vertical(false)
                      .height(2)
                      .color($r('app.color.background_shallow_grey'))
                      .opacity(0.6)
                      .margin({ left: 12, right: 12 })
                  }
                  .width('100%')
                  .height(48)
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Start)
                  .onDragStart((event) => {
                    this.textContentTarget = '';
                    let fileTestDirPath = filesDir + '/' + item.filename;
                    // if (item.filename.includes('.txt')) {
                      logger.info(TAG, 'onDragStart begin!')

                      let file = new UDC.File();
                      file.details = {
                        name: item.filename,
                        // type: 'txt',
                      };
                      file.uri = fileUri.getUriFromPath(fileTestDirPath);
                      this.backGroundColor = Color.Transparent;
                      (event as DragEvent).setData(new UDC.UnifiedData(file));
                    // } else {
                    //   logger.info(TAG, 'onDragStart error');
                    //   let data: UDC.PlainText = new UDC.PlainText();
                    //   data.abstract = 'this is abstract';
                    //   data.textContent = 'This file type not support Drag!';
                    //   (event as DragEvent).setData(new UDC.UnifiedData(data));
                    //   return;
                    // }
                  })
                }
                .width('100%')
                .height(48)
                .alignItems(VerticalAlign.Center)
              }
              .id('listItem_'+ no)
            })
          }
          .listDirection(Axis.Vertical)
          .scrollBar(BarState.Auto)
          .friction(0.6)
          .margin({ left: 12, right: 12 })
          .borderRadius(24)
          .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
          .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
            logger.info(TAG, 'onScrollIndex')
          })
          .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
            logger.info(TAG, 'onDidScroll')
          })
          .onScrollStop(()=> {
            logger.info(TAG, 'onScrollStop')
          })
          .backgroundColor(0xFFFFFF)
        }
        .height('40%')

        // 文件内容
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
          Text($r('app.string.text_content'))
            .fontStyle(FontStyle.Normal)
            .fontSize(16)
            .fontWeight(700)
            .textAlign(TextAlign.Start)
            .margin({ left: 12, top: 12, bottom: 6 })
            .height('10%')
            .copyOption(CopyOptions.InApp)
            .draggable(true)
          TextArea({
            text: this.textContent,
            controller: this.controller
          })
            .placeholderFont({ size: 16, weight: 400 })
            .backgroundColor('#FFFFFF')
            .border({ width: 1, color: Color.Gray, radius: 16 })
            .height('80%')
            .margin({ left: 12, right: 12 })
            .fontSize(16)
            .maxLines(4)
            .fontColor('#182431')
            .copyOption(CopyOptions.InApp)
            .draggable(true)
            .id('textContent')
            .onChange((value: string) => {
              this.textContent = value
            })
        }
        .margin({ top: 12 })
        .onDragStart((event) => {
          this.textContentTarget = '';
          this.backGroundColor = Color.Transparent;
          let data: UDC.PlainText = new UDC.PlainText();
          data.abstract = 'this is abstract';
          data.textContent = this.textContent;
          (event as DragEvent).setData(new UDC.UnifiedData(data));
        })
        .height('45%')
      }
      .margin({ left: 12, right: 12 })
      .alignItems(HorizontalAlign.Start)
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}

