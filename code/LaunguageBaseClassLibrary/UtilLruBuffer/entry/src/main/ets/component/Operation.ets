/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import util from '@ohos.util'
import { ActionSheetDialog } from '../component/ActionSheetDialog'
import Logger from '../model/Logger'

class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = []

  public totalCount(): number {
    return 0
  }

  public getData(index: number): any {
    return undefined
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdded(index)
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChanged(index)
    })
  }
}

class MyDataSource extends BasicDataSource {
  public dataArray: string[] = []

  constructor(ele) {
    super()
    for (var index = 0;index < ele.length; index++) {
      this.dataArray.push(ele[index])
    }
  }

  public totalCount(): number {
    return this.dataArray.length
  }

  public getData(index: number): any {
    return this.dataArray[index]
  }

  public addData(index: number, data: string): void {
    this.dataArray.splice(index, 0)
    this.notifyDataAdd(index)
  }
}

const TAG = 'LruBuffer.Operation'
let buffer = null
let self = null // this指向

@Component
export struct Operation {
  private operation: Array<any> = [
  $r('app.string.initialize_buffer'),
  $r('app.string.get_buffer_capacity'),
  $r('app.string.update_buffer_capacity'),
  $r('app.string.get_buffer_string'),
  $r('app.string.add_key_value'),
  $r('app.string.get_value_with_key'),
  $r('app.string.get_all_key_values'),
  $r('app.string.delete_key_and_value'),
  $r('app.string.clear_all_key_values'),
  $r('app.string.view_operation_record'),
  ]
  private isGet: boolean = true
  @State actionSheets: Array<string> = []
  @Link resultText: string
  private actionDialogController: CustomDialogController = new CustomDialogController({
    builder: ActionSheetDialog({
      title: 'Click the key',
      sheets: this.actionSheets,
      action: this.action
    }),
    autoCancel: true
  })

  randomString(length: number) {
    length = length || 32 // 随机设置字符串长度为32
    let string = 'abcdefhijkmnprstwxyz123456789' // 声明一个默认字符串
    let maxLength = string.length
    let resultString = ''
    for (let i = 0; i < length; i++) {
      resultString += string.charAt(Math.floor(Math.random() * maxLength))
    }
    return resultString
  }

  action(key) {
    Logger.info(TAG, `action:key=${key}`)
    if (self.isGet) {
      if (buffer.contains(key)) {
        let value = buffer.get(key)
        self.resultText = `key = ${key}, value=${value}`
      } else {
        self.resultText = `the key:${key} is not found`
      }
    } else {
      buffer.remove(key)
      self.resultText = `key:${key} is removed\n`
    }
  }

  getAllKeyValues() {
    let result = ''
    let entries = buffer.entries()
    for (let iterator of entries) {
      result += `key: ${iterator[0]}, value: ${iterator[1]}\n`
    }
    return result
  }

  doOperation(index) {
    Logger.info(TAG, `doOperation index:${index}`) // index指的是循环数据的index值
    switch (index) {
      case 0:
        Logger.info(TAG, ' case 0:')
        buffer = new util.LruBuffer()
        this.resultText = 'create LruBuffer success'
        break
      case 1:
        this.resultText = `capacity = ${buffer.getCapacity()}`
        break
      case 2:
        buffer.updateCapacity(100) // 将缓冲区容量更新为指定容量100
        this.resultText = `update capacity success,capacity=${buffer.getCapacity()}`
        break
      case 3:
        this.resultText = buffer.toString()
        break
      case 4:
        buffer.put(this.randomString(3), this.randomString(5)) // 随机生成字符串的长度分别为3和5
        this.resultText = 'put key-value success'
        break
      case 5:
        this.isGet = true
        this.actionSheets = buffer.keys()
        this.actionDialogController.open()
        break
      case 6:
        this.resultText = this.getAllKeyValues()
        break
      case 7:
        this.isGet = false
        this.actionSheets = buffer.keys()
        this.actionDialogController.open()
        break
      case 8:
        buffer.clear()
        this.resultText = 'Clear success'
        break
      case 9:
        buffer.createDefault(10)
        buffer.get(10)
        this.resultText = `getCreateCount=${buffer.getCreateCount()}\n`
        + `getMissCount=${buffer.getMissCount()}\n`
        + `getRemovalCount=${buffer.getRemovalCount()}\n`
        + `getMatchCount=${buffer.getMatchCount()}\n`
        + `getPutCount=${buffer.getPutCount()}\n`
      default:
        break
    }
  }

  aboutToAppear() {
    Logger.info(TAG, 'aboutToAppear')
    self = this
  }

  build() {
    Column() {
      GridRow({ columns: 12, gutter: { x: 2, y: 5 },
        breakpoints: { value: ["400vp", "600vp", "800vp"], reference: BreakpointsReference.WindowSize },
        direction: GridRowDirection.Row
      }) {
        LazyForEach(new MyDataSource(this.operation), (item, index) => {
          GridCol({ span: { xs: 6, sm: 6, md: 4, lg: 3 } }) {
            Row() {
              Button() {
                Text(item)
                  .fontSize(16)
                  .fontColor(Color.White)
              }
              .width(160)
              .height(50)
              .type(ButtonType.Capsule)
              .margin({ right: 10, top: 10 })
              .onClick(() => {
                Logger.info(TAG, `Click index:${item.id}`)
                if (index !== 0 && buffer === null) {
                  this.resultText = 'Click the first button and then operate'
                  return
                }
                this.doOperation(index)
              })
            }
            .justifyContent(FlexAlign.Center)
          }
        }, index => index)
      }
    }
    .width('100%')
    .padding({ bottom: 15 })
  }
}