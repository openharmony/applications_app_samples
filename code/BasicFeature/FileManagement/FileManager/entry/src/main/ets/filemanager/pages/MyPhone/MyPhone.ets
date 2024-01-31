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

import router from '@ohos.router';
import prompt from '@ohos.promptAction';
import contextConstant from '@ohos.app.ability.contextConstant';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import { Logger, FileSystem, NewFileSystem } from '@ohos/feature-file-manager';
import { FileStructure, FileType } from '@ohos/feature-file-manager/src/main/ets/mock/local/FileData';

// 添加文件的弹窗
import { InputNameDialog } from './InputNameDialog';
// 删除文件的弹窗
import { DeleteDialog } from './DeleteDialog';
//修改文件(夹)时间的弹窗
import { ChangeTimeDialog } from './ChangeTimeDialog';

// 基础沙箱路径---固定路径
const BASE_PATH = '/data/storage/el2/base/haps/';
// el3基础沙箱路径---固定路径
const EL3_BASE_PATH = '/data/storage/el3/base/';
// el4基础沙箱路径---固定路径
const EL4_BASE_PATH = '/data/storage/el4/base/';
// 通过沙箱路径前缀作为context切换加密分区的标志
const EL1_AREA_FLAG = '/data/storage/el1';
const EL2_AREA_FLAG = '/data/storage/el2';
const EL3_AREA_FLAG = '/data/storage/el3';
const EL4_AREA_FLAG = '/data/storage/el4';

const TAG: string = 'MyPhone';

let myContext = getContext(this) as common.UIAbilityContext;

// 处理日期格式
function str2TimeStamp(time: string): number {
  let dateString = time.slice(0, 10);
  let timeString = time.slice(11, 19);

  let dateParts = dateString.split('/');
  let year = Number(dateParts[0]);
  let month = Number(dateParts[1]);
  let day = Number(dateParts[2]);

  let timeParts = timeString.split(':');
  let hour = Number(timeParts[0]);
  let minites = Number(timeParts[1]);
  let seconds = Number(timeParts[2]);

  let date = new Date(year, month - 1, day, hour, minites, seconds, 0);
  let tt = date.getTime();

  return tt;
}

export function updateContextArea(directoryPath: string, context: common.UIAbilityContext): string {
  let subTitle: string = '';
  Logger.info(TAG, "updateContextArea para: " + directoryPath);
  if (directoryPath.includes(EL1_AREA_FLAG)) {
    context.area = contextConstant.AreaMode.EL1;
    subTitle = 'el1';
    Logger.info(TAG, "updateContextArea directoryPath: " + directoryPath + " in el1");
  } else if (directoryPath.includes(EL2_AREA_FLAG)) {
    context.area = contextConstant.AreaMode.EL2;
    subTitle = 'el2';
    Logger.info(TAG, "updateContextArea directoryPath: " + directoryPath + " in el2");
  } else if (directoryPath.includes(EL3_AREA_FLAG)) {
    context.area = contextConstant.AreaMode.EL3;
    subTitle = 'el3';
    Logger.info(TAG, "updateContextArea directoryPath: " + directoryPath + " in el3");
  } else if (directoryPath.includes(EL4_AREA_FLAG)) {
    context.area = contextConstant.AreaMode.EL4;
    subTitle = 'el4';
    Logger.info(TAG, "updateContextArea directoryPath: " + directoryPath + " in el4");
  } else {
    Logger.error(TAG, "updateContextArea directoryPath: " + directoryPath + " not in el part！");
  }
  Logger.info(TAG, "updateContextArea new context area: " + context.area);

  return subTitle;
}

@Entry
@Component
export struct MyPhone {
  // 需要删除的文件
  private needDeleteFiles: Map<string, number> = new Map();
  // 需要移动的文件
  @StorageLink('needMoveFiles') needMoveFiles: Array<FileType> = [];
  @State totalSize: string = '';
  @State freeSize: string = '';
  // 是否开启选择模式
  @State @Watch('clearTempData') isSelect: boolean = false;
  // 被选中的数组---样式判断
  @State selectedFiles: Array<string> = [];
  @State selectedFilesTime: string = '';
  // 读取的文件结构
  @State fileData: Array<FileStructure> = [];
  // 命名弹窗的类型---默认是文件夹
  @State fileDialogType: number = 1;
  // 是否进入移动文件模式
  @StorageLink('isMoveFile') isMoveFile: boolean = false;
  // 是否能够移动
  @StorageLink('canMove') canMove: boolean = true;
  // 目录路径
  @State @Watch('updateFileData') directoryPath: string = BASE_PATH;
  // 目录名称
  @State directoryName: string = '';
  // 刷新页面
  @StorageLink('flashPage') @Watch('updateFileData') flashPage: boolean = false;
  @State subTitle: string = 'el2';

  @Styles
  itemPressedStyles() {
    .backgroundColor($r('app.color.item_pressed'))
  }

  // 路由返回后刷新页面
  onPageShow() {
    AppStorage.SetOrCreate('flashPage',!AppStorage.Get<number>('flashPage'));
    this.subTitle = updateContextArea(this.directoryPath, myContext);
  }

  async aboutToAppear() {
    // 有路由参数就加载当前路由文件路径
    let params = router.getParams() as Record<string, Object>;
    this.directoryPath = params.directoryPath as string;
    this.directoryName = params.directoryName as string;
    Logger.info(TAG, "aboutToAppear after get router param test directoryPath: " + this.directoryPath + ", directoryName: " + this.directoryName);

    this.subTitle = updateContextArea(this.directoryPath, myContext);
    /*
      // 回到首页就读取当前内存变化
      if (this.directoryPath === BASE_PATH) {
        this.totalSize = await FileSystem.getTotalSize();
        this.freeSize = await FileSystem.getFreeSize();
      }
    */

    this.updateFileData();
  }

  // 刷新当前页面数据
  updateFileData() {
    Logger.info(TAG, "updateFileData directoryPath2: " + this.directoryPath + ", directoryName: " + this.directoryName);
    this.subTitle = updateContextArea(this.directoryPath, myContext);
    this.fileData = [];
    try {
      let subdirectory = FileSystem.getSubdirectory(this.directoryPath);
      // 构建我们的文件结构
      subdirectory.forEach(item => {
        this.fileData.push(new FileStructure(item.name, item.type, item.time, item.childrenNum, item.fileSize));
      })
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error(TAG, `Get subdirectory of path ${this.directoryPath} failed. error code is ${error.code}, message is ${error.message}`);
    }
  }

  // 每次退出选择状态就将临时数据清空
  clearTempData() {
    if (this.isSelect) {
      this.selectedFiles = [];
      this.selectedFilesTime = '';
      this.needDeleteFiles.clear();
      this.needMoveFiles = [];
    }
  }

  // 用户输入名字的弹窗
  inputNameDialog: CustomDialogController = new CustomDialogController({
    builder: InputNameDialog({
      type: this.fileDialogType,
      confirm: () => {
        const name: string | undefined = AppStorage.Get('name');
        if (!name) {
          return prompt.showToast({ message: $r('app.string.tip_input_name') });
        }
        if (this.fileDialogType === 1) {
          NewFileSystem.createDirectory(this.directoryPath + name);
        } else {
          // 创建文件
          FileSystem.createFile(this.directoryPath + name);
        }
        this.updateFileData();
        this.inputNameDialog.close();
      }
    }),
    autoCancel: true
  });

  // 重命名弹窗
  renameDialog: CustomDialogController = new CustomDialogController({
    builder: InputNameDialog({
      name: this.selectedFiles[0],
      confirm: () => {
        const name: string | undefined = AppStorage.Get('name');
        if (!name) {
          return prompt.showToast({ message: $r('app.string.tip_input_name') });
        }
        const sourcePath = this.directoryPath + this.selectedFiles[0];
        const destinationPath = this.directoryPath + name;
        FileSystem.renameFile(sourcePath, destinationPath);
        this.updateFileData();
        this.renameDialog.close();
      }
    }),
    autoCancel: true
  });

  // 删除文件的弹窗
  deleteDialog: CustomDialogController = new CustomDialogController({
    builder: DeleteDialog({
      confirm: () => {
        // 将处理后的数据存进去---删除
        FileSystem.deleteSelected(this.needDeleteFiles);
        this.isSelect = false;
        this.updateFileData();
        this.deleteDialog.close();
      }
    })
  })
  //修改文件(夹)时间的弹窗
  changeTimeDialog: CustomDialogController = new CustomDialogController({
    builder: ChangeTimeDialog({
      time: this.selectedFilesTime,
      confirm: () => {
        const time: string | undefined = AppStorage.Get('time');
        if (!time) {
          return prompt.showToast({ message: $r('app.string.tip_input_name') });
        }
        NewFileSystem.setFileTime(this.directoryPath + this.selectedFiles[0], time);
        this.isSelect = false;
        this.updateFileData();
        this.changeTimeDialog.close();
      }
    })
  })

  @Builder MenuBuilder() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      Text($r('app.string.label_change_time'))
        .fontSize(16)
        .height(48)
        .fontWeight(400)
        .margin({ left: 16, top: 4 })
        .onClick(() => {
          if (this.selectedFiles.length == 1) {
            this.changeTimeDialog.open();
          } else {
            prompt.showToast({
              message: $r('app.string.tip_choose_can_onlyone')
            });
          }
        })
      Divider().strokeWidth(0.5).margin({ left: 16, right: 16 }).color('#182431').opacity(0.05)
      Text($r('app.string.label_delete'))
        .fontSize(16)
        .height(48)
        .fontWeight(400)
        .margin({ left: 16, bottom: 4 })
        .onClick(() => {
          if (this.selectedFiles.length > 0) {
            this.deleteDialog.open();
          } else {
            prompt.showToast({
              message: $r('app.string.tip_choose_one')
            });
          }
        })
    }
    .borderRadius(16)
    .width(176)
  }

  build() {
    Column() {
      //默认首页标题栏
      if (this.directoryPath === BASE_PATH) {
        Row() {
          Image($r('app.media.ic_back'))
            .id('back2Home')
            .width(24)
            .height(24)
            .objectFit(ImageFit.Fill)
            .alignSelf(ItemAlign.Auto)
            .margin({ right: 16 })
            .onClick(() => {
              router.back();
            })
          Text($r('app.string.title'))
            .fontSize(20)
            .fontWeight(700)
            .fontFamily('HarmonyHeiTi-Bold')
            .textAlign(TextAlign.Start)
        }
        .width('100%')
        .height(56)
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
        .padding({ left: 12, right: 12 })

        //首页第二行 内存: / 选择
        Row() {
          Text() {
            if (this.directoryPath === BASE_PATH) {
              Span($r('app.string.label_memory')).fontSize(14)

              Span(`: ${this.freeSize}/${this.totalSize}`).fontSize(14)
            } else {
              Span($r('app.string.label_current_directory')).fontSize(14)
            }
          }
          .fontWeight(500)
          .fontFamily('HarmonyHeiTi-Medium')
          .fontColor($r('app.color.font_gray'))

          //首页第二行 选择图标、取消text
          Row() {
            if (this.isSelect || this.isMoveFile) {
              Text($r('app.string.label_cancel'))
                .fontSize(14)
                .fontColor($r('app.color.font_gray'))
                .fontWeight(500)
                .textAlign(TextAlign.Start)
                .onClick(() => {
                  this.isSelect = false;
                  this.isMoveFile = false;
                })
            } else {
              Image($r('app.media.select'))
                .id('select')
                .width(24)
                .height(24)
                .objectFit(ImageFit.Fill)
                .alignSelf(ItemAlign.Auto)
                .onClick(() => {
                  this.isSelect = true;
                })
            }
          }
        }
        .width('100%')
        .height(48)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .padding({ left: 12, right: 12 })
      } else {
        //文件夹内容页 标题栏
        Row() {
          Row() {
            Image($r('app.media.ic_back'))
              .id('left')
              .width(24)
              .height(24)
              .objectFit(ImageFit.Fill)
              .alignSelf(ItemAlign.Auto)
              .onClick(() => {
                this.fileData = [];
                AppStorage.SetOrCreate('flashPage',!AppStorage.Get<string>('flashPage'));
                router.back();
                this.canMove = true;
              })

            Text(this.directoryName)
              .fontSize(20)
              .fontWeight(700)
              .fontFamily('HarmonyHeiTi-Bold')
              .margin({ left: 16 })
              .textAlign(TextAlign.Start)
          }

          Row() {
            if (this.isSelect || this.isMoveFile) {
              Text($r('app.string.label_cancel'))
                .fontSize(20)
                .fontWeight(500)
                .textAlign(TextAlign.Start)
                .fontColor($r('app.color.font_gray'))
                .onClick(() => {
                  this.isSelect = false;
                  this.isMoveFile = false;
                })
            } else {
              Image($r('app.media.select'))
                .id('secondarySelect')
                .width(24)
                .height(24)
                .objectFit(ImageFit.Fill)
                .alignSelf(ItemAlign.Auto)
                .onClick(() => {
                  this.isSelect = true;
                })
            }
          }
        }
        .width('100%')
        .height(56)
        .padding({ left: 12, right: 12 })
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)

        //文件夹内容页 第二行 文件夹: 路径
        Row() {
          Text(this.subTitle)
            .fontWeight(500)
            .fontFamily('HarmonyHeiTi-Medium')
            .fontColor($r('app.color.font_gray'))
            .textAlign(TextAlign.Start)
            .fontSize(14)
          Text(`: ${this.directoryPath}`)
            .fontWeight(500)
            .fontFamily('HarmonyHeiTi-Medium')
            .fontColor($r('app.color.font_gray'))
            .textAlign(TextAlign.Start)
            .fontSize(14)
        }
        .width('100%')
        .height(48)
        .padding({ left: 12, right: 12 })
        .justifyContent(FlexAlign.Start)
      }
      //文件夹下文件列表
      if (this.fileData.length > 0) {
        // 目录列表
        List({ space: 12 }) {
          ForEach(this.fileData, (file: FileStructure, index: number) => {
            ListItem() {
              Row() {
                Row() {
                  if (this.isSelect) {
                    Image(this.selectedFiles.includes(file.name) ? $r('app.media.select') : $r('app.media.option'))
                      .width(24)
                      .height(24)
                      .objectFit(ImageFit.Fill)
                      .alignSelf(ItemAlign.Auto)
                      .margin({ right: 12 })
                  }
                  if (file.type === 1) {
                    Image($r('app.media.ic_folder'))
                      .width(24)
                      .height(24)
                      .objectFit(ImageFit.Fill)
                      .alignSelf(ItemAlign.Auto)
                  } else {
                    Image($r('app.media.ic_file'))
                      .width(24)
                      .height(24)
                      .objectFit(ImageFit.Fill)
                      .alignSelf(ItemAlign.Auto)
                  }
                  Column({ space: 6 }) {
                    Text(file.name)
                      .fontSize(16)
                      .fontWeight(500)
                      .fontFamily('HarmonyHeiTi-Medium')
                      .textAlign(TextAlign.Start)
                    Row({ space: 6 }) {
                      Text(file.time)
                        .fontSize(14)
                        .fontWeight(400)
                        .fontColor($r('app.color.font_gray'))
                        .fontFamily('HarmonyHeiTi')
                        .textAlign(TextAlign.Start)
                      Text(file.size)
                        .fontSize(14)
                        .fontWeight(400)
                        .fontColor($r('app.color.font_gray'))
                        .fontFamily('HarmonyHeiTi')
                        .textAlign(TextAlign.Start)
                    }
                  }
                  .margin({ left: 16 })
                  .alignItems(HorizontalAlign.Start)
                }

                Row() {
                  if (file.type === 1) {
                    Text() {
                      Span(`${file.childrenNum}`)
                        .fontSize(14)
                        .fontWeight(400)
                        .fontColor($r('app.color.font_gray'))
                        .fontFamily('HarmonyHeiTi')
                      Span($r('app.string.label_item'))
                        .fontSize(14)
                        .fontWeight(400)
                        .fontColor($r('app.color.font_gray'))
                        .fontFamily('HarmonyHeiTi')
                    }

                    Image($r('app.media.ic_arrow_right'))
                      .width(24)
                      .height(24)
                      .objectFit(ImageFit.Fill)
                      .alignSelf(ItemAlign.End)
                  }
                }
                .alignItems(VerticalAlign.Center)
                .justifyContent(FlexAlign.End)
              }
              .width('100%')
              .height(72)
              .borderRadius(24)
              .backgroundColor(0xFFFFFF)
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
              .padding({ left: 12, right: 12 })
              .stateStyles({
                pressed: this.itemPressedStyles
              })
              .onClick(() => {
                // 点击过后判断是否是选中模式
                if (this.isSelect) {
                  // 如果已经存在就删掉
                  if (this.selectedFiles.includes(file.name)) {
                    let index = this.selectedFiles.indexOf(file.name);
                    this.selectedFiles.splice(index, 1);
                    this.needDeleteFiles.delete(this.directoryPath + file.name);
                    // 复制和移动需要的数据---因为这里的数据跟选中的列表数据一致，所以可以使用相同的index
                    this.needMoveFiles.splice(index, 1);
                  } else {
                    this.selectedFiles.push(file.name);
                    this.selectedFilesTime = file.time;
                    // 处理需要删除的数据格式
                    this.needDeleteFiles.set(this.directoryPath + file.name, file.type);
                    // 需要移动的文件的格式
                    this.needMoveFiles.push({
                      filePath: this.directoryPath + file.name,
                      fileName: file.name,
                      type: file.type
                    });
                  }
                } else {
                  // 如果是移动模式
                  if (this.isMoveFile) {
                    // 判断被点击的对象是不是在选中的列表中
                    this.needMoveFiles.forEach((needMoveFile: FileType) => {
                      if ((this.directoryPath + file.name) === needMoveFile.filePath) {
                        this.canMove = false;
                        return prompt.showToast({ message: $r('app.string.label_no_move') });
                      } else {
                        this.canMove = true;
                      }
                    });
                  }
                  // 如果是目录就跳转页面
                  if (file.type === 1) {
                    router.pushUrl({
                      url: 'filemanager/pages/MyPhone/MyPhone',
                      params: {
                        directoryName: file.name,
                        directoryPath: `${this.directoryPath}${file.name}/`
                      }
                    });
                  } else {
                    //如果是文件就打开文件
                    let filePath = this.directoryPath + file.name;
                    Logger.info(TAG, filePath);
                    router.pushUrl({
                      url: 'filemanager/pages/MyPhone/OpenFile',
                      params: {
                        filePath: this.directoryPath,
                        fileName: file.name,
                        fileSize: file.size,
                        fileContent: "",
                      }
                    }, router.RouterMode.Standard);
                  }
                }
              })
            }
            .id("ListItem" + index)
            .width('100%')
          })
        }
        .width('100%')
        .listDirection(Axis.Vertical) // 排列方向
        .scrollBar(BarState.Auto)
        .borderRadius(24)
        .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
        .flexShrink(1)

        // 切换到el3，el4加密分区
        if (this.directoryPath === BASE_PATH && this.isSelect == false) {
          Row() {
            Text($r('app.string.get_el3'))
              .id('el3')
              .fontSize(16)
              .fontWeight(500)
              .fontFamily('HarmonyHeiTi-Medium')
              .textAlign(TextAlign.Start)
              .margin({ left: 12 })
          }
          .height(56)
          .width('100%')
          .borderRadius(24)
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Center)
          .margin({ top: 12, bottom: 12 })
          .backgroundColor(0xFFFFFF)
          .stateStyles({
            pressed: this.itemPressedStyles
          })
          .onClick(() => {
            router.pushUrl({
              url: 'filemanager/pages/MyPhone/MyPhone',
              params: {
                directoryName: 'base',
                directoryPath: `${EL3_BASE_PATH}`
              }
            });
          })

          Row() {
            Text($r('app.string.get_el4'))
              .id('el4')
              .fontSize(16)
              .fontWeight(500)
              .fontFamily('HarmonyHeiTi-Medium')
              .textAlign(TextAlign.Start)
              .margin({ left: 12 })
          }
          .height(56)
          .width('100%')
          .borderRadius(24)
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Center)
          .backgroundColor(0xFFFFFF)
          .stateStyles({
            pressed: this.itemPressedStyles
          })
          .onClick(() => {
            router.pushUrl({
              url: 'filemanager/pages/MyPhone/MyPhone',
              params: {
                directoryName: 'base',
                directoryPath: `${EL4_BASE_PATH}`
              }
            });
          })
        }
      } else {
        Column({ space: 20 }) {
          Image($r('app.media.nothing'))
            .width(60)
            .height(60)

          Text($r('app.string.label_nothing'))
            .id('blank')
            .fontSize(30)
            .fontColor(Color.Gray)
            .opacity(.5)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
      }
      Blank()
      // 底部弹窗
      if (this.isMoveFile) {
        Row() {
          Text($r('app.string.label_move_to'))
            .fontSize(20)
            .fontColor(this.canMove ? Color.Black : Color.Gray)
        }
        .id('move')
        // 样式需要，这里给出50%
        .width('50%')
        .borderRadius(18)
        .justifyContent(FlexAlign.Center)
        .padding({ left: 24, right: 24, top: 10, bottom: 10 })
        .margin({ bottom: 10 })
        .borderWidth(1)
        .borderColor(this.canMove ? Color.Black : Color.Gray)
        .onClick(() => {
          if (this.canMove) {
            // 关闭移动模式
            this.isMoveFile = false;
            // 开始移动
            FileSystem.startMoveFile(this.needMoveFiles, this.directoryPath);
            // 刷新页面
            this.updateFileData();
          }
        })
      }
      //点击了选择图标
      else if (this.isSelect) {
        Row() {
          Column({ space: 8 }) {
            Image($r('app.media.copy'))
              .width(24)
              .height(24)
              .objectFit(ImageFit.Fill)
              .alignSelf(ItemAlign.Auto)
            Text($r('app.string.label_copy_move'))
              .id('copy')
              .fontSize(10)
              .fontWeight(500)
              .fontFamily('HarmonyHeiTi-Medium')
              .textAlign(TextAlign.Center)
          }
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            if (this.selectedFiles.length < 1) {
              return prompt.showToast({ message: $r('app.string.tip_choose_one') });
            }
            this.isSelect = false;
            this.isMoveFile = true;
            this.canMove = true;
          })

          Column({ space: 8 }) {
            Image(this.selectedFiles.length === 1 ? $r('app.media.rename') : $r('app.media.rename_gray'))
              .width(24)
              .height(24)
              .objectFit(ImageFit.Fill)
              .alignSelf(ItemAlign.Auto)
            Text($r('app.string.label_rename'))
              .id('rename')
              .fontSize(10)
              .fontWeight(500)
              .fontFamily('HarmonyHeiTi-Medium')
              .textAlign(TextAlign.Center)
              .fontColor(this.selectedFiles.length === 1 ? Color.Black : Color.Gray)
          }
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            // 如果只选中则允许修改名字
            if (this.selectedFiles.length === 1) {
              this.isSelect = false;
              this.renameDialog.open();
            }
          })

          Column({ space: 8 }) {
            Image($r('app.media.share'))
              .width(24)
              .height(24)
              .objectFit(ImageFit.Fill)
              .alignSelf(ItemAlign.Auto)
            Text($r('app.string.label_share'))
              .id('share')
              .fontSize(10)
              .fontWeight(500)
              .fontFamily('HarmonyHeiTi-Medium')
              .textAlign(TextAlign.Center)
          }
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            prompt.showToast({ message: $r('app.string.tip_develop') });
          })

          Column({ space: 8 }) {
            Image($r('app.media.ic_more'))
              .width(24)
              .height(24)
              .objectFit(ImageFit.Fill)
              .alignSelf(ItemAlign.Auto)
            Text($r('app.string.label_more'))
              .id('more')
              .fontSize(10)
              .fontWeight(500)
              .fontFamily('HarmonyHeiTi-Medium')
              .textAlign(TextAlign.Center)
          }
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .bindMenu(this.MenuBuilder, {
            enableArrow: true,
            placement: Placement.Top,
          })
        }
        .width('100%')
        .height(56)
        .padding({ left: 12, right: 12 })
        .justifyContent(FlexAlign.SpaceBetween)
      }
      else {
        Row() {
          Column({ space: 8 }) {
            Image($r('app.media.addDirectory'))
              .width(24)
              .height(24)
              .objectFit(ImageFit.Fill)
              .alignSelf(ItemAlign.Auto)
            Text($r('app.string.label_make_directory'))
              .id('makeDirectory')
              .fontSize(10)
              .fontWeight(500)
              .fontFamily('HarmonyHeiTi-Medium')
              .textAlign(TextAlign.Center)
          }
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            // 给出自定义弹窗，用户输入新文件夹名称后创建
            this.fileDialogType = 1;
            this.inputNameDialog.open();
          })

          Column({ space: 8 }) {
            Image($r('app.media.addFile'))
              .width(24)
              .height(24)
              .objectFit(ImageFit.Fill)
              .alignSelf(ItemAlign.Auto)
            Text($r('app.string.label_make_file'))
              .id('makeFile')
              .fontSize(10)
              .fontWeight(500)
              .fontFamily('HarmonyHeiTi-Medium')
              .textAlign(TextAlign.Center)
          }
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            // 给出自定义弹窗，用户输入新文件夹名称后创建
            this.fileDialogType = 2;
            this.inputNameDialog.open();
          })

          Column({ space: 8 }) {
            Image($r('app.media.ic_rank'))
              .width(24)
              .height(24)
              .objectFit(ImageFit.Fill)
              .alignSelf(ItemAlign.Auto)
            Text($r('app.string.label_sort'))
              .id('sort')
              .fontSize(10)
              .fontWeight(500)
              .fontFamily('HarmonyHeiTi-Medium')
              .textAlign(TextAlign.Center)
          }
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            prompt.showToast({ message: $r('app.string.tip_develop') });
          })

          Column({ space: 8 }) {
            Image($r('app.media.ic_public_clean'))
              .width(24)
              .height(24)
              .objectFit(ImageFit.Fill)
              .alignSelf(ItemAlign.Auto)
            Text($r('app.string.label_clean'))
              .id('clean')
              .fontSize(10)
              .fontWeight(500)
              .fontFamily('HarmonyHeiTi-Medium')
              .textAlign(TextAlign.Center)
          }
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            prompt.showToast({ message: $r('app.string.tip_develop') });
          })
        }
        .width('100%')
        .height(56)
        .padding({ left: 12, right: 12 })
        .justifyContent(FlexAlign.SpaceBetween)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
    .padding({ left: 12, right: 12 })
  }
}
