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
import common from '@ohos.app.ability.common';
import utdDesc from '@ohos.data.uniformTypeDescriptor';
import { BusinessError } from '@ohos.base';
import { logger } from '../util/Logger';
import UDC from '@ohos.data.unifiedDataChannel';
import UTD from '@ohos.data.uniformTypeDescriptor';
import FileFs from '../fileFs/fileFs'
import { randomString } from '../util/Common';
import { Event } from '@ohos.worker';

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
    logger.error(TAG, "accessSync failed with error message: " + err.message + ", error code: " + err.code);
  }

  for (let i = 0; i < precastFiles.length; i++) {
    let fileName = filesDir + "/" + precastFiles[i];
    logger.info(TAG, `The file name: ${fileName}`);
    try {
      let res = fs.accessSync(fileName);
      if (res) {
        logger.info(TAG, `file: ${fileName} exists!.`);
      } else {
        logger.info(TAG, `file: ${fileName} not exists, will create it!.`);
        let file = fs.openSync(fileName, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        logger.info(TAG, "file fd: " + file.fd);

        if (fileName.includes('.txt')) {
          logger.info(TAG, "txt file write sync ");
          fs.writeSync(file.fd, 'test content 1 test content 2');
        }
        fs.closeSync(file);
      }
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      logger.error(TAG, "accessSync failed with error message: " + err.message + ", error code: " + err.code);
    }
  }
}

// function  readFileContent(filename: string) {
//   let fileName = filesDir + "/" + filename;
//   logger.info(TAG, `The file name: ${fileName}`);
//   try {
//     // let res = fs.accessSync(fileName);
//     // if (res) {
//     //   logger.info(TAG, `file: ${fileName} exists!.`);
//     // } else {
//     //   logger.info(TAG, `file: ${fileName} not exists, will create it!.`);
//
//       if (fileName.includes('.txt')) {
//         let file = fs.openSync(fileName, fs.OpenMode.READ_WRITE);
//         logger.info(TAG, "file fd: " + file.fd);
//         logger.info(TAG, "txt file write sync ");
//         const BUFFER_SIZE = 4096; // 读写文件缓冲区大小
//         let buf = new ArrayBuffer(BUFFER_SIZE);
//         fs.readSync(file.fd, buf);
//         let resultPut: string = FileFs.bufferToString(buf);
//         logger.info(TAG, 'modifyFileToWatcher getFileContent read resultPut = ' + resultPut);
//         fs.closeSync(file);
//       }
//
//     // }
//   } catch (error) {
//     let err: BusinessError = error as BusinessError;
//     logger.error(TAG, "accessSync failed with error message: " + err.message + ", error code: " + err.code);
//   }
// }

function  saveAsFileContent(fileName: string, content: string) {
  logger.info(TAG, `The file name: ${fileName}`);
  try {
    let res = fs.accessSync(fileName);
    if (res) {
      logger.info(TAG, `file: ${fileName} exists!.`);
    } else {
      logger.info(TAG, `file: ${fileName} not exists, will create it!.`);
      let file = fs.openSync(fileName, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      logger.info(TAG, "file fd: " + file.fd);

      if (fileName.includes('.txt')) {
        logger.info(TAG, "txt file write sync ");
        fs.writeSync(file.fd, content);
      }
      fs.closeSync(file);
    }
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    logger.error(TAG, "accessSync failed with error message: " + err.message + ", error code: " + err.code);
  }
}
function getIconByType(fileName: string) {
  // let typeObj = utdDesc.getTypeDescriptor(type); //'general.plain-text'
  let index = fileName.lastIndexOf('.');
  let fileExtension = fileName.substring(index);
  logger.info(TAG, `getIconByType fileExtension： ${fileExtension}`);

  let utd = utdDesc.getUniformDataTypeByFilenameExtension(fileExtension); // `.txt`
  let typeObj: utdDesc.TypeDescriptor = utdDesc.getTypeDescriptor(utd);
  logger.info(TAG, `getIconByType typeObj.iconFile: ${typeObj.iconFile}`);
  if (typeObj.iconFile == '') {
    logger.info(TAG, `getIconByType typeObj.iconFile is null`);
    // let iconFile:string = getIconByType('test.xls');
    let iconFile:string = 'app.media.ic_select_option_collection';
    return iconFile;
  }
  return typeObj.iconFile;
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  fileFs: FileFs = new FileFs();
  @State text: string = "Images";
  @State index: number = 1;
  @State space: number = 12;
  @State arrowPosition: ArrowPosition = ArrowPosition.END;
  @State fileNames: string[] = [];
  @State selectedFilesInfos: FileInfo[] = [];

  @State textContent: string  = '';
  @State textContentTarget: string  = '';
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
    logger.info(TAG, "selectText: " + this.text)
    for (let i = 0; i < this.fileNames.length; i++) {
      let fileName = this.fileNames[i];
      let index = fileName.lastIndexOf('.');
      if (index < 0) {
        logger.info(TAG, `fileNames file: ${fileName}`);
        if (this.text == "All") {
          let fileInfo = new FileInfo(fileName, "");
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

            if (class2UTD.get(this.text) == "All") {
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
            if (class2UTD.get(this.text) == "All") {
              let fileInfo = new FileInfo(fileName, "");
              this.selectedFilesInfos.push(fileInfo);
              logger.info(TAG, `utd null All type: ${fileInfo.filename}, utd: ${utd}, iconFile: ${fileInfo.iconFile}`);
            }
          }
        }
        catch (e) {
          let error: BusinessError = e as BusinessError;
          logger.error(TAG, `belongsTo throws an exception. code is ${error.code}, message is ${error.message}`);
        }
      }
    }
    logger.info(TAG, `all files ${JSON.stringify(this.selectedFilesInfos)}}`);
  }

  aboutToAppear() {
    logger.info(TAG, 'filesDir: ' + filesDir);
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
      let records: Array<UDC.UnifiedRecord> = data.getRecords();
      if (!records || records.length <= 0) {
        return false;
      }
      callback(event);
      return true;
    } catch (e) {
      console.log("getData failed, code = " + (e as BusinessError).code + ", message = " + (e as BusinessError).message);
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
        // Column() {
          // Row() {
            Text($r('app.string.UDMF_demo'))
              .fontStyle(FontStyle.Normal)
              .fontSize(20)
              .fontWeight(700)
              .textAlign(TextAlign.Start)
              .id('titleText')
          // }
          // .width('100%')
          // .height(56)
          // .alignItems(VerticalAlign.Center)
        }
        // .width(280)
        // .height(56)
        // .alignItems(HorizontalAlign.Start)
        .backgroundColor(Color.Yellow)
        .width('30%')
        .height('5%')

        // 下拉选择框
        // Column() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
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
            .backgroundColor($r('app.color.background_shallow_grey'))
            .width('100%')
            .height('100%')
            .onSelect((index: number, text?: string | undefined) => {
              this.index = index;
              if (text) {
                this.text = text;
                logger.info(TAG, 'Select type:' + text);
                this.UpdateSelectedFiles();
              }
            })
        }
        // .margin({ left: 12, right: 12 })
        // .height(48)
        // .width(160)
        .margin(0)
        .height('5%')
        .width('40%')
        // .alignItems(HorizontalAlign.Start)
        // .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.Brown)

        // 拖拽文本内容
        // Column() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
          // Row() {
          Text($r('app.string.text_target_content'))
            .fontStyle(FontStyle.Normal)
            .fontSize(16)
            .textAlign(TextAlign.Start)
            .margin({top:12, bottom:12})
            .height('10%')
            .copyOption(CopyOptions.InApp)
            .draggable(true)
          TextArea({
            text: this.textContentTarget,
            controller: this.controllerTarget
          })
            .placeholderFont({ size: 16, weight: 400 })
            .backgroundColor('#FFFFFF')
            .border({ width: 1, color: Color.Gray, radius: 16 })
            .width('100%') //336
            .height('90%') // 56
            .margin(5)
            .fontSize(16)
            .maxLength(50)
            .maxLines(4)
            .fontColor('#182431')
            .id('pasteText')
            .onChange((value: string) => {
              this.textContentTarget = value
              logger.info(TAG, `textContentTarget onChange this.textContentTarget：` + this.textContentTarget);
            })
            .onClick((event: ClickEvent) => {
              logger.info(TAG, `textContentTarget onClick this.textContentTarget：` + this.textContentTarget);
              this.textContentTarget = '';
            })
            .allowDrop([UTD.UniformDataType.PLAIN_TEXT])
            .onDrop((dragEvent?: DragEvent) => {
              this.textContentTarget = '';
              // this.controllerTarget.caretPosition()
              // logger.info(`textContentTarget onDrop this.textContentTarget  ${this.textContentTarget}`)
              logger.info(TAG, `textContentTarget onDrop this.textContentTarget：` + this.textContentTarget);
              this.getDataFromUdmf((dragEvent as DragEvent), (event: DragEvent) => {
                let records: Array<UDC.UnifiedRecord> = event.getData().getRecords();
                let plainText: UDC.PlainText = records[0] as UDC.PlainText;
                this.textContentTarget = plainText.textContent;
              })
            })

          // }
          // .width('100%')
          // .height(56)
          // .alignItems(VerticalAlign.Center)
        }
        // .width(280)
        .width('100%')
        .height('20%')
        .margin(10)
        .visibility(Visibility.Visible)
        // .alignItems(HorizontalAlign.Start)
        .backgroundColor(Color.Red)

        // 文件列表
        // Column() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
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
                        .id("textFilename_" + no)
                        .visibility(Visibility.Visible)
                        .onClick(() => {
                          logger.info(TAG, `selected file：` + item.filename + `and clicked`);
                          // let file = fs.openSync(this.path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
                          // let context = getContext(this);
                          // let filepath = filesDir + "/" + item.filename;;
                          // logger.info(TAG, "context this "+ context);
                          // this.fileFs.implicitStartAbility(context, filepath);

                          logger.info(TAG, `selected file：` + item.filename + `and clicked row`);
                          let fileTestDirPath = filesDir + "/" + item.filename;
                          if (item.filename.includes('.txt')) {
                            this.textContent = this.fileFs.getFileContent(fileTestDirPath);
                            if (this.textContent == '') {
                              this.textContent = item.filename + 'content is empty!'
                            }
                          }
                        })
                    }
                    // .onClick(() => {
                    //   logger.info(TAG, `selected file：` + item.filename + `and clicked row`);
                    //     let fileTestDirPath = filesDir + "/" + item.filename;
                    //     if (item.filename.includes('.txt')) {
                    //       this.textContent = this.fileFs.getFileContent(fileTestDirPath);
                    //     }
                    // })

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
                  let content: string = ''
                    // let fileTestDirPath =
                    let fileTestDirPath = filesDir + "/" + item.filename;
                    if (item.filename.includes('.txt')) {
                      content = this.fileFs.getFileContent(fileTestDirPath);
                    }

                    let fileTestDirPathNew = filesDir + "/" + 'new_' + item.filename;
                    saveAsFileContent(fileTestDirPathNew, content);

                    this.backGroundColor = Color.Transparent;
                    let data: UDC.PlainText = new UDC.PlainText();
                    data.abstract = 'this is abstract';
                    data.textContent = 'Content save as ' + 'new_' + item.filename;
                    (event as DragEvent).setData(new UDC.UnifiedData(data));
                  })
                }
                .width('100%')
                .height(48)
                .alignItems(VerticalAlign.Center)
              }
              .id("listItem_" + no)
            })
          }
          .listDirection(Axis.Vertical) // 排列方向
          .scrollBar(BarState.Auto)
          .friction(0.6)
          .margin({ left: 12, right: 12 })
          .borderRadius(24)
          .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
          .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
            logger.info(TAG, 'first: ' + firstIndex);
            logger.info(TAG, 'last: ' + lastIndex);
            logger.info(TAG, 'center: ' + centerIndex);
          })
          .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
            logger.info(TAG, `onScroll scrollState = ScrollState` + scrollState + `, scrollOffset = ` + scrollOffset);
          })
          .backgroundColor(0xFFFFFF)
        }
        .width('100%')
        // .height(680)
        .height('30%')
        // .alignItems(HorizontalAlign.Start)
        // .justifyContent(FlexAlign.Start)
        .backgroundColor(Color.Orange)

        // 文件内容
        // Column() {
          // Row() {
          Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
            Text($r('app.string.text_content'))
              .fontStyle(FontStyle.Normal)
              .fontSize(16)
              .textAlign(TextAlign.Start)
              .margin({top:12, bottom:12})
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
              .width('100%') //336
              .height('80%') // 56
              .margin(5)
              .fontSize(16)
              .maxLength(50)
              .maxLines(4)
              .fontColor('#182431')
              .copyOption(CopyOptions.InApp)
              .draggable(true)
              .id('pasteText')
              .onChange((value: string) => {
                this.textContent = value
              })

          // }
          // .width('100%')
          // .height(56)
          // .alignItems(VerticalAlign.Center)
        }
        // .width(280)
        // .height(56)
        .onDragStart((event) => {
          // this.backGroundColor = Color.Transparent;
          // let data: UDC.PlainText = new UDC.PlainText();
          // data.abstract = 'this is abstract';
          // // data.textContent = this.textContent;
          // let unifiedData = new UDC.UnifiedData(data);


          let name: string = randomString(6, 'UDMFDemo');
          let fileTestDirPathNew = filesDir + "/" + 'new_' + name;
          saveAsFileContent(fileTestDirPathNew, this.textContent);

          this.backGroundColor = Color.Transparent;
          let data: UDC.PlainText = new UDC.PlainText();
          data.abstract = 'this is abstract';
          data.textContent = 'Content save as ' + 'new_' + name;
          (event as DragEvent).setData(new UDC.UnifiedData(data));
        })
        .width('100%')
        .height('20%')
        // .alignItems(HorizontalAlign.Start)
        .backgroundColor(Color.Green)
        .margin(10)        // 下拉选择框
      }
      .width('100%')
      .height('95%')
      .alignItems(HorizontalAlign.Start)
      .backgroundColor(Color.Pink)
    }
    .height('100%')
    .padding({top:0})
    .margin({top:0})
    .backgroundColor(Color.Black)
  }
}

