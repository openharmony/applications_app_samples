/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import MyWatcher from '../filemanager/fileFs/MyWatcher';
import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import router from '@ohos.router';
import { Logger, sleep, bufferToString } from '../common/Common';

const TAG: string = '[FileIO].[WatcherFile]';

@CustomDialog
export struct DeleteDialog {
  @Link hitText: string
  @Link currentIndex: number
  controller: CustomDialogController
  cancel: () => void = () => {}
  confirm: (index: number) => void = () => {}

  build() {
    Column() {
      Text(this.hitText)
        .fontSize(20)
        .fontColor('#182431')
        .textAlign(TextAlign.Center)
        .lineHeight(26)
        .fontWeight(500)
        .width(288)
        .height(52)
        .margin({ top: 24, left: 24, right: 24 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Row() {
          Text($r('app.string.cancel'))
            .fontSize(16)
            .fontColor('#007DFF')
            .textAlign(TextAlign.Center)
            .lineHeight(22)
            .fontWeight(500)
            .width(136)
            .backgroundColor(0xffffff)
            .onClick(() => {
              this.controller.close()
              this.cancel()
            })
          Text('|')
            .backgroundColor(0xffffff)
            .fontColor(Color.Gray)
            .height(24)
          Text($r('app.string.deleteFile'))
            .fontSize(16)
            .fontColor('#FA2A2D')
            .textAlign(TextAlign.Center)
            .lineHeight(22)
            .fontWeight(500)
            .width(136)
            .backgroundColor(0xffffff)
            .id('deleteWatcher')
            .onClick(() => {
              this.controller.close()
              this.confirm(this.currentIndex)
            })
        }
      }
      .margin({ top: 9, bottom: 25 })
    }
    .backgroundColor(0xffffff)
    .width('80%')
    .height(132)
  }
}

@Entry
@Component
struct Watcher {
  @State message: Resource = $r('app.string.watcherFileText');
  @State myContext: Context = getContext(this) as common.UIAbilityContext;
  @State inputNameValue: string = 'text.txt';
  @State inputContentValue: string = 'abcdefg';
  @State currentIndex: number = 1;
  @State currentDelFileName: string = '';
  @State currentFileName: string = '';
  @State currentFileSize: number = 0;
  @State currentFileContent: string = '';
  @State eachEvent: string = '';
  @State isFromEdit: boolean = false;
  @State editFlag: boolean = true;
  @State watcherEvent: Array<string> = [
    'IN_ACCESS',
    'IN_MODIFY',
    'IN_ATTRIB',
    'IN_CLOSE_WRITE',
    'IN_CLOSE_NOWRITE',
    'IN_OPEN',
    'IN_MOVED_FROM',
    'IN_MOVED_TO',
    'IN_CREATE',
    'IN_DELETE',
    'IN_DELETE_SELF',
    'IN_MOVE_SELF',
  ];
  @State filePathSize: Array<number> = [];
  @State showFilePath: Array<string> = [];
  @StorageLink('eventLog') eventLog: string = 'unknown';
  @StorageLink('fileNameLog') fileNameLog: string = 'unknown';
  @StorageLink('cookieLog') cookieLog: string = 'unknown';
  @StorageLink('newFileName') newFileName: string = '';
  @StorageLink('newFileContent') newFileContent: string = '';
  @StorageLink('eventArray') eventArray: Array<string> = [];
  @StorageLink('addIndex') addIndex: number = 10;
  public baseDir: string = AppStorage.Get<string>('sanBoxFileDir') as string;

  @Builder itemEnd(index: number) { // 侧滑后尾端出现的组件
    Row() {
      Image($r('app.media.ic_edit'))
        .width(40)
        .height(40)
        .margin({ left: 16, right: 8 })
        .id('editFile')
        .onClick(() => {
          this.currentIndex = index;
          this.currentFileName = this.showFilePath[index];
          let length = this.currentFileName.length;
          this.currentFileName = this.currentFileName.substring(0, length - 4);
          let filePath = this.baseDir + '/watcherDir/' + this.showFilePath[index];
          this.currentFileSize = fs.statSync(filePath).size;
          let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE);
          let buf = new ArrayBuffer(4096);
          fs.readSync(file.fd, buf, {
            offset: 0
          });
          this.currentFileContent = bufferToString(buf);
          router.pushUrl({
            url: 'pages/EditFile',
            params: {
              fileName: this.currentFileName,
              fileSize: this.currentFileSize,
              fileContent: this.currentFileContent,
            }
          }, router.RouterMode.Standard);

        });

      Image($r('app.media.ic_delete'))
        .width(40)
        .height(40)
        .margin(1)
        .id('deleteFile')
        .onClick(() => {
          this.currentDelFileName = this.showFilePath[index];
          this.currentIndex = index;
          let lastIndex = this.currentDelFileName.length - 4;
          let isDelDile = AppStorage.Get<string>('isDelFile') as string;
          this.currentDelFileName = isDelDile + this.currentDelFileName.substring(0, lastIndex) + '?';
          this.deleteDialog.open();
        });
    }
    .padding(1)
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  private select: number = 1;
  private selectDel: number = 1;
  private isDelStr: Resource = $r('app.string.isDelFile');
  myWatcher: MyWatcher = new MyWatcher();
  scroller: Scroller = new Scroller();
  deleteDialog: CustomDialogController = new CustomDialogController({
    builder: DeleteDialog({
      hitText: $currentDelFileName,
      cancel: this.onCancel,
      confirm: (index: number): void => this.onDelete(index),
      currentIndex: $currentIndex,
    }),
    cancel: () => {},
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -12 },
    autoCancel: true
  })

  onCancel(): void {
    Logger.info('cancel');
  };

  onDelete(index: number): void {
    this.myWatcher.deleteFileToWatcher(this.showFilePath[index]);
    this.filePathSize.splice(index, 1);
    this.showFilePath.splice(index, 1);
  }

  onPageShow(): void {
    Logger.info('aboutToDisappear eventArray:  ' + this.eventArray.length);
    let filePathDir = this.baseDir + '/watcherDir';
    Logger.info('filePathDir = ' + filePathDir);
    let filenames = fs.listFileSync(filePathDir);
    Logger.info('listFile succeed');
    for (let i = 0; i < filenames.length; i++) {
      Logger.info('filename: %s', filenames[i]);
      this.showFilePath[i] = filenames[i];
      let filePath = filePathDir + '/' + filenames[i];
      this.filePathSize[i] = fs.statSync(filePath).size;
    }
  }

  onPageHide(): void {
    Logger.info('onPageHide eventArray:  ' + this.eventArray.length);
  }

  aboutToDisappear(): void {
    try {
      for (let i = 0; i < this.myWatcher.watcherList.length; i++) {
        Logger.info('aboutToDisappear this.myWatcher.watcherList.length:  ' + this.myWatcher.watcherList.length);
        this.myWatcher.stopWatcher(this.myWatcher.watcherList[i], i);
      }
    } catch (e) {
      Logger.error('stopwatcher fail and error: ' + JSON.stringify(e));
    }
  }

  aboutToAppear(): void {
    Logger.info('aboutToAppear eventArray:  ' + this.eventArray.length);
  }

  build() {
    Scroll(this.scroller) {
      Row() {
        Column() {
          Row() {
            Image($r('app.media.ic_back'))
              .width(24)
              .height(24)
              .align(Alignment.Start)
              .margin({ top: 13, bottom: 15, left: 26, right: 18 })
              .id('backIndex')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/Index',
                }, router.RouterMode.Standard);
              })
            Text(this.message)
              .fontSize(20)
              .fontColor('#182431')
              .textAlign(TextAlign.Start)
              .lineHeight(28)
              .fontWeight(700)
              .margin({ top: 13, bottom: 15 })

          }
          .width('100%')
          .height(56)
          .backgroundColor('#f1f3f5')
          .align(Alignment.Start)

          Flex({ direction: FlexDirection.Column }) {
            Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
              Row() {
                Text($r('app.string.watcherTitleText'))
                  .fontSize(14)
                  .margin({ top: 19.5, bottom: 9.5 })
                  .lineHeight(19)
                  .width(176)
                  .fontColor('#182431')
                  .fontWeight(500)
                  .textAlign(TextAlign.Start)
                  .backgroundColor('#f1f3f5')
                  .opacity(0.6)
              }
              .width('61%')
              .padding({ left: 24, right: 52 })
              .backgroundColor('#f1f3f5')

              Row() {
                Text($r('app.string.addFile'))
                  .margin({ top: 19.5, bottom: 9.5 })
                  .fontSize(14)
                  .height(48)
                  .backgroundColor('#f1f3f5')
                  .fontColor('#007DFF')
                  .textAlign(TextAlign.End)
                  .fontWeight(500)
                  .width(84)
                  .id('addFile')
                  .onClick(() => {
                    let filePathDir = this.baseDir + '/watcherDir/';
                    let fileName = `TestFile${this.addIndex}.txt`;
                    this.addIndex++;
                    this.myWatcher.addFileToWatcher(fileName);
                    let filePath = filePathDir + fileName;
                    let res = fs.accessSync(filePath);
                    this.showFilePath.push(fileName);
                    if (res) {
                      this.filePathSize.push(fs.statSync(filePath).size);
                      Logger.info('addFileToWatcher this.filePathSize size = ' + fs.statSync(filePath).size);
                    }
                  })
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .height(48)
              .margin({ right: 24 })
              .width('30%')
              .backgroundColor('#f1f3f5')
            }
            .width('100%')
            .backgroundColor('#f1f3f5')

            Column() {
              List({ space: 12, initialIndex: 0 }) {
                ForEach(this.showFilePath, (item: string, index?: number) => {
                  ListItem() {
                    Row() {
                      Text(item)
                        .fontSize(16)
                        .fontColor('#182431')
                        .width('70%')
                        .lineHeight(22)
                        .textAlign(TextAlign.Start)
                        .fontWeight(500)
                        .margin({ left: 12 })
                        .borderRadius(10)
                        .backgroundColor(0xFFFFFF)
                        .id('item' + index)
                      if (index != undefined) {
                        Text(JSON.stringify(this.filePathSize[index]) + 'B')
                          .fontSize(14)
                          .width('24.5%')
                          .lineHeight(19)
                          .textAlign(TextAlign.End)
                          .fontColor('#182431')
                          .fontWeight(400)
                          .opacity(0.6)
                          .margin({ right: 12 })
                          .borderRadius(10)
                          .backgroundColor(0xFFFFFF)
                      }
                    }
                    .borderRadius(20)
                    .width('94%')
                    .height(56)
                    .backgroundColor(0xFFFFFF)
                  }
                  .swipeAction({ end: () : void => this.itemEnd(index) }) // 设置左滑属性
                }, (item: string) => item)
              }
              .id('list')
              .alignListItem(ListItemAlign.Center)
              .scrollBar(BarState.Auto)
            }
            .padding({ top: 5 })
            .backgroundColor('#f1f3f5')
            .width('100%')
            .height(436)
            .align(Alignment.Center)

            Column() {
              Row() {
                Text($r('app.string.logTitle'))
                  .fontSize(14)
                  .fontColor('#182431')
                  .textAlign(TextAlign.Start)
                  .lineHeight(19)
                  .fontWeight(500)
                  .margin({ top: 19.5, left: 24 })
                  .width(176)
                  .opacity(0.6)
              }
              .width('100%')
              .align(Alignment.Start)

              Column() {
                Column() {
                  Text(`event: ${this.eventLog}`)
                    .fontSize(16)
                    .fontColor('#182431')
                    .fontWeight(400)
                    .width('100%')
                  Text(`fileName: ${this.fileNameLog}`)
                    .fontSize(16)
                    .fontColor('#182431')
                    .fontWeight(400)
                    .width('100%')
                  Text(`cookie: ${this.cookieLog}`)
                    .fontSize(16)
                    .fontColor('#182431')
                    .fontWeight(400)
                    .width('100%')
                }
                .margin({ top: 8, left: 12, right: 12, bottom: 8 })
                .height(64)
              }
              .borderRadius(20)
              .height(80)
              .margin({ top: 9.5, left: 16, right: 16 })
              .backgroundColor('#ffffff')

              Row({ space: 2 }) {
                Column() {
                  Button($r('app.string.stopWatcher'))
                    .fontSize(16)
                    .width(144)
                    .height(40)
                    .backgroundColor('#e6e9eb')
                    .fontColor('#007DFF')
                    .fontWeight(500)
                    .margin({ right: 24 })
                    .id('stopWatcher')
                    .onClick(() => {
                      let showEventArray : string[] = [];
                      Logger.info('onClick this.eventArray.length = ' + this.eventArray.length);
                      let j = 0;
                      for (let i = 0; i < this.eventArray.length; i++) {
                        Logger.info('onClick this.eventArray[' + i + '] = ' + this.eventArray[i]);
                        if (this.eventArray[i] === 'test') {
                          continue;
                        }
                        Logger.info('onClick2 this.eventArray[' + i + '] = ' + this.eventArray[i]);
                        showEventArray[j] = this.eventArray[i];
                        j++;
                        Logger.info('onClick showEventArray[' + j + '] = ' + showEventArray[j]);
                      }
                      if (showEventArray.length === 0) {
                        AlertDialog.show({
                          message: '当前无监听，请先添加监听'
                        })
                        return;
                      }
                      TextPickerDialog.show({
                        range: showEventArray,
                        selected: this.selectDel,
                        onAccept: (value: TextPickerResult) => {
                          this.selectDel = Number(value.index);
                          Logger.info('TextPickerDialog:onChange() this.selectDel = ' + this.selectDel);
                          Logger.info('TextPickerDialog:onChange() value = ' + JSON.stringify(value));
                          this.myWatcher.stopWatcher(this.myWatcher.watcherList[this.selectDel], this.selectDel);
                          this.eventArray.splice(this.selectDel, 1);
                          showEventArray.splice(this.selectDel, 1);
                        },
                      })
                    })
                }
                .width('50%')
                .align(Alignment.Start)

                Column() {
                  Button($r('app.string.addWatcher'))
                    .fontSize(16)
                    .width(144)
                    .height(40)
                    .fontColor('#FFFFFF')
                    .fontWeight(500)
                    .id('addWatcher')
                    .onClick(() => {
                      TextPickerDialog.show({
                        range: this.watcherEvent,
                        selected: this.select,
                        onAccept: (value: TextPickerResult) => {
                          this.select = Number(value.index);
                          Logger.info('TextPickerDialog:onChange() this.select = ' + this.select);
                          Logger.info('TextPickerDialog:onChange() value = ' + JSON.stringify(value));
                          Logger.info('TextPickerDialog:onChange() this.select = ' + this.select);
                          this.eachEvent = this.watcherEvent[this.select];
                          Logger.info('TextPickerDialog:onChange() this.eachEvent = ' + this.eachEvent);
                          this.myWatcher.startWatcher(this.eachEvent);
                          Logger.info(`onSelect-${this.eachEvent} end`);
                          this.eventArray.push(this.eachEvent); // 新增列表项数据
                        },
                      })
                    })
                }
                .width('50%')
                .align(Alignment.End)
              }
              .align(Alignment.Center)
              .width('70%')
              .margin({ top: 24, left: 24, right: 24, bottom: 24 })
            }
            .backgroundColor('#f1f3f5')
            .width('100%')
            .height(216)
          }
          .width('100%')
        }
        .width('100%')
      }
      .height('100%')
    }
    .id('scroller')
  }
}