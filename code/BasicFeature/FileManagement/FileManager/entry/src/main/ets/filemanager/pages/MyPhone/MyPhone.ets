/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import router from '@ohos.router'
import prompt from '@ohos.promptAction'
import { FileSystem } from '@ohos/feature-file-manager'
import { FileStructure, FileType } from '@ohos/feature-file-manager/src/main/ets/mock/local/FileData'
// 添加文件的弹窗
import { InputNameDialog } from './InputNameDialog'
// 删除文件的弹窗
import { DeleteDialog } from './DeleteDialog'
// 基础沙箱路径---固定路径
const BASE_PATH = '/data/storage/el2/base/haps/'

@Entry
@Component
export struct MyPhone {
  // 需要删除的文件
  private needDeleteFiles: Map<string, number> = new Map()
  // 需要移动的文件
  @StorageLink('needMoveFiles') needMoveFiles: Array<FileType> = []
  @State totalSize: string = ''
  @State freeSize: string = ''
  // 是否开启选择模式
  @State @Watch('clearTempData') isSelect: boolean = false
  // 被选中的数组---样式判断
  @State selectedFiles: Array<string> = []
  // 读取的文件结构
  @State fileData: Array<FileStructure> = []
  // 命名弹窗的类型---默认是文件夹
  @State fileDialogType: number = 1
  // 是否进入移动文件模式
  @StorageLink('isMoveFile') isMoveFile: boolean = false
  // 是否能够移动
  @StorageLink('canMove') canMove: boolean = true
  // 目录路径
  @State @Watch('updateFileData') directoryPath: string = BASE_PATH
  // 目录名称
  @State directoryName: string = ''
  // 刷新页面
  @StorageLink('flashPage') @Watch('updateFileData') flashPage: boolean = false

  // 路由返回后刷新页面
  onPageShow() {
    AppStorage.SetOrCreate('flashPage', !AppStorage.Get<number>('flashPage'))
  }

  async aboutToAppear() {
    // 有路由参数就加载当前路由文件路径
    if (router.getParams()) {
      this.directoryPath = router.getParams()['directoryPath'] ? router.getParams()['directoryPath'] : ''
      this.directoryName = router.getParams()['directoryName'] ? router.getParams()['directoryName'] : ''
    }
    // 回到首页就读取当前内存变化
    if (this.directoryPath === BASE_PATH) {
      this.totalSize = await FileSystem.getTotalSize()
      this.freeSize = await FileSystem.getFreeSize()
    }
    this.updateFileData()
  }

  // 刷新当前页面数据
  updateFileData() {
    this.fileData = []
    let subdirectory = FileSystem.getSubdirectory(this.directoryPath)
    // 构建我们的文件结构
    subdirectory.forEach(item => {
      this.fileData.push(new FileStructure(item.name, item.type, item.time, item.childrenNum, item.fileSize))
    })
  }

  // 每次退出选择状态就降临时数据清空
  clearTempData() {
    if (this.isSelect) {
      this.selectedFiles = []
      this.needDeleteFiles.clear()
      this.needMoveFiles = []
    }
  }

  // 用户输入名字的弹窗
  inputNameDialog: CustomDialogController = new CustomDialogController({
    builder: InputNameDialog({
      type: this.fileDialogType,
      confirm: () => {
        if (!AppStorage.Get('name')) {
          return prompt.showToast({ message: $r('app.string.tip_input_name') })
        }
        if (this.fileDialogType === 1) {
          FileSystem.createDirectory(this.directoryPath + AppStorage.Get('name'))
        } else {
          // 创建文件
          FileSystem.createFile(this.directoryPath + AppStorage.Get('name'))
        }
        this.updateFileData()
        this.inputNameDialog.close()
      }
    }),
    autoCancel: true
  })

  // 重命名弹窗
  renameDialog: CustomDialogController = new CustomDialogController({
    builder: InputNameDialog({
      name: this.selectedFiles[0],
      confirm: () => {
        if (!AppStorage.Get('name')) {
          return prompt.showToast({ message: $r('app.string.tip_input_name') })
        }
        FileSystem.renameFile(this.directoryPath + this.selectedFiles[0], this.directoryPath + AppStorage.Get('name'))
        this.updateFileData()
        this.renameDialog.close()
      }
    }),
    autoCancel: true
  })

  // 删除文件的弹窗
  deleteDialog: CustomDialogController = new CustomDialogController({
    builder: DeleteDialog({
      confirm: () => {
        // 将处理后的数据存进去---删除
        FileSystem.deleteSelected(this.needDeleteFiles)
        this.isSelect = false
        this.updateFileData()
        this.deleteDialog.close()
      }
    })
  })

  build() {
    Column() {
      if (this.directoryPath === BASE_PATH) {
        Row() {
          Text($r('app.string.title'))
            .fontSize(30)
            .fontWeight(600)
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .padding({ top: 20, bottom: 20 })

        Row() {
          Text() {
            if (this.directoryPath === BASE_PATH) {
              Span($r('app.string.label_memory')).fontSize(24)

              Span(`: ${this.freeSize}/${this.totalSize}`).fontSize(24)
            } else {
              Span($r('app.string.label_current_directory')).fontSize(24)
            }
          }

          Row() {
            if (this.isSelect || this.isMoveFile) {
              Text($r('app.string.label_cancel'))
                .fontSize(24)
                .fontColor(Color.Gray)
                .onClick(() => {
                  this.isSelect = false
                  this.isMoveFile = false
                })
            } else {
              Image($r('app.media.select'))
                .width(30)
                .height(30)
                .onClick(() => {
                  this.isSelect = true
                })
            }
          }
          .offset({ x: 40, y: 0 })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
      } else {
        Row() {
          Image($r('app.media.left'))
            .width(30)
            .height(20)
            .onClick(() => {
              this.fileData = []
              AppStorage.SetOrCreate('flashPage',!AppStorage.Get('flashPage'))
              router.back()
              this.canMove = true
            })

          Text(this.directoryName)
            .fontSize(20)

          Row() {
            if (this.isSelect || this.isMoveFile) {
              Text($r('app.string.label_cancel'))
                .fontSize(24)
                .fontColor(Color.Gray)
                .onClick(() => {
                  this.isSelect = false
                  this.isMoveFile = false
                })
            } else {
              Image($r('app.media.select'))
                .width(30)
                .height(30)
                .onClick(() => {
                  this.isSelect = true
                })
            }
          }
        }
        .width('100%')
        .padding({ top: 20, bottom: 20 })
        .justifyContent(FlexAlign.SpaceBetween)
      }

      if (this.fileData.length > 0) {
        // 目录列表
        List({ space: 16 }) {
          ForEach(this.fileData, (file: FileStructure) => {
            ListItem() {
              Row() {
                if (this.isSelect) {
                  Image(this.selectedFiles.includes(file.name) ? $r('app.media.select') : $r('app.media.option'))
                    .width(26)
                    .height(26)
                    .margin({ left: 10, right: 10 })
                }
                if (file.type === 1) {
                  Image($r('app.media.directory'))
                    .width(30)
                    .height(30)
                } else {
                  Image($r('app.media.file'))
                    .width(30)
                    .height(30)
                }
                Column({ space: 6 }) {
                  Text(file.name)
                    .fontSize(16)

                  Row({ space: 6 }) {
                    Text(file.time)
                      .fontSize(16)
                      .fontColor(Color.Gray)

                    Text(file.size)
                      .fontSize(16)
                      .fontColor(Color.Gray)
                  }
                }
                .margin({ left: 12 })
                .alignItems(HorizontalAlign.Start)

                Blank()

                if (file.type === 1) {
                  Text() {
                    Span(`${file.childrenNum}`)
                      .fontSize(16)
                      .fontColor(Color.Gray)

                    Span($r('app.string.label_item'))
                      .fontSize(16)
                      .fontColor(Color.Gray)
                  }
                  .padding({ right: 10 })

                  Image($r('app.media.right'))
                    .width(26)
                    .height(26)
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.Start)
              .alignItems(VerticalAlign.Center)
              .onClick(() => {
                // 点击过后判断是否是选中模式
                if (this.isSelect) {
                  // 如果已经存在就删掉
                  if (this.selectedFiles.includes(file.name)) {
                    let index = this.selectedFiles.indexOf(file.name)
                    this.selectedFiles.splice(index, 1)
                    this.needDeleteFiles.delete(this.directoryPath + file.name)
                    // 复制和移动需要的数据---因为这里的数据跟选中的列表数据一致，所以可以使用相同的index
                    this.needMoveFiles.splice(index, 1)
                  } else {
                    this.selectedFiles.push(file.name)
                    // 处理需要删除的数据格式
                    this.needDeleteFiles.set(this.directoryPath + file.name, file.type)
                    // 需要移动的文件的格式
                    this.needMoveFiles.push({
                      filePath: this.directoryPath + file.name,
                      fileName: file.name,
                      type: file.type
                    })
                  }
                } else {
                  // 如果是移动模式
                  if (this.isMoveFile) {
                    // 判断被点击的对象是不是在选中的列表中
                    this.needMoveFiles.forEach((needMoveFile: FileType) => {
                      if ((this.directoryPath + file.name) === needMoveFile.filePath) {
                        this.canMove = false
                        return prompt.showToast({ message: $r('app.string.label_no_move') })
                      } else {
                        this.canMove = true
                      }
                    })
                  }

                  // 如果是目录就跳转页面
                  if (file.type === 1) {
                    router.pushUrl({
                      url: 'filemanager/pages/MyPhone/MyPhone',
                      params: {
                        directoryName: file.name,
                        directoryPath: `${this.directoryPath}${file.name}/`
                      }
                    })
                  }
                }
              })
            }
            .width('100%')
          })
        }
        .padding({ top: 10, bottom: 10 })
        .width('100%')
        .flexGrow(1)
        .flexShrink(1)
      } else {
        Column({ space: 20 }) {
          Image($r('app.media.nothing'))
            .width(60)
            .height(60)

          Text($r('app.string.label_nothing'))
            .fontSize(30)
            .fontColor(Color.Gray)
            .opacity(.5)
        }
        .width('100%')
        .flexGrow(1)
        .flexShrink(1)
        .justifyContent(FlexAlign.Center)
      }

      // 底部弹窗
      if (this.isMoveFile) {
        Row() {
          Text($r('app.string.label_move_to'))
            .fontSize(20)
            .fontColor(this.canMove ? Color.Black : Color.Gray)
        }
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
            this.isMoveFile = false
            // 开始移动
            FileSystem.startMoveFile(this.needMoveFiles, this.directoryPath)
            // 刷新页面
            this.updateFileData()
          }
        })
      }
      else if (this.isSelect) {
        Row() {
          Column({ space: 8 }) {
            Image($r('app.media.copy'))
              .width(30)
              .height(30)

            Text($r('app.string.label_copy_move'))
              .fontSize(16)
          }
          .onClick(() => {
            if (this.selectedFiles.length < 1) {
              return prompt.showToast({ message: $r('app.string.tip_choose_one') })
            }
            this.isSelect = false
            this.isMoveFile = true
            this.canMove = true
          })

          Column({ space: 8 }) {
            Image(this.selectedFiles.length === 1 ? $r('app.media.rename') : $r('app.media.rename_gray'))
              .width(30)
              .height(30)

            Text($r('app.string.label_rename'))
              .fontSize(16)
              .fontColor(this.selectedFiles.length === 1 ? Color.Black : Color.Gray)
          }
          .onClick(() => {
            // 如果只选中则允许修改名字
            if (this.selectedFiles.length === 1) {
              this.isSelect = false
              this.renameDialog.open()
            }
          })

          Column({ space: 8 }) {
            Image($r('app.media.share'))
              .width(30)
              .height(30)

            Text($r('app.string.label_share'))
              .fontSize(16)
          }
          .onClick(() => {
            prompt.showToast({ message: $r('app.string.tip_develop') })
          })

          Column({ space: 8 }) {
            Image($r('app.media.delete'))
              .width(30)
              .height(30)

            Text($r('app.string.label_delete'))
              .fontSize(16)
          }
          .onClick(() => {
            if (this.selectedFiles.length > 0) {
              this.deleteDialog.open()
            } else {
              prompt.showToast({
                message: $r('app.string.tip_choose_one')
              })
            }
          })
        }
        .width('100%')
        .borderRadius(18)
        .padding({ left: 24, right: 24, top: 10, bottom: 10 })
        .margin({ bottom: 10 })
        .borderWidth(1)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      else {
        Row() {
          Column({ space: 8 }) {
            Image($r('app.media.addDirectory'))
              .width(30)
              .height(30)

            Text($r('app.string.label_make_directory'))
              .fontSize(16)
          }
          .onClick(() => {
            // 给出自定义弹窗，用户输入新文件夹名称后创建
            this.fileDialogType = 1
            this.inputNameDialog.open()
          })

          Column({ space: 8 }) {
            Image($r('app.media.addFile'))
              .width(30)
              .height(30)

            Text($r('app.string.label_make_file'))
              .fontSize(16)
          }
          .onClick(() => {
            // 给出自定义弹窗，用户输入新文件夹名称后创建
            this.fileDialogType = 2
            this.inputNameDialog.open()
          })

          Column({ space: 8 }) {
            Image($r('app.media.sort'))
              .width(30)
              .height(30)

            Text($r('app.string.label_sort'))
              .fontSize(16)
          }
          .onClick(() => {
            prompt.showToast({ message: $r('app.string.tip_develop') })
          })

          Column({ space: 8 }) {
            Image($r('app.media.clean'))
              .width(30)
              .height(30)

            Text($r('app.string.label_clean'))
              .fontSize(16)
          }
          .onClick(() => {
            prompt.showToast({ message: $r('app.string.tip_develop') })
          })
        }
        .width('100%')
        .borderRadius(18)
        .padding({ left: 24, right: 24, top: 10, bottom: 10 })
        .margin({ bottom: 10 })
        .borderWidth(1)
        .justifyContent(FlexAlign.SpaceBetween)
      }
    }
    .width('100%')
    .height('100%')
    .padding({ left: 12, right: 12 })
  }
}