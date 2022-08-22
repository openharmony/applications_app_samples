/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import featureAbility from '@ohos.ability.featureAbility'
import router from '@ohos.router'
import Logger from '../model/Logger'
import TitleBar from '../view/TitleBar'
import OperationView from '../view/OperationView'
import ResourceUtil from '../model/ResourceUtil'

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

const TAG: string = 'Index'
const operationUrls: Array<string> = ['pages/Language', 'pages/DateAndTime', 'pages/Examples']
const PERMISSIONS: Array<string> = [
  'ohos.permission.UPDATE_CONFIGURATION',
  'ohos.permission.SET_TIME_ZONE',
  'ohos.permission.SET_TIME']
const REQUEST_CODE: number = 3 // 要传递给PermissionRequestResult的请求码，自己定义

@Entry
@Component
struct Index {
  @State operations: MyDataSource = new MyDataSource([])

  aboutToAppear() {
    Logger.info(TAG, 'aboutToAppear')
    featureAbility.getContext().requestPermissionsFromUser(PERMISSIONS, REQUEST_CODE, () => {
      Logger.info(TAG, 'grantPermission,requestPermissionsFromUser')
    })
    this.getOperation()
  }

  async getOperation() {
    var operations = await ResourceUtil.getStringArray($r('app.strarray.operation_arr').id)
    this.operations = new MyDataSource(operations)
  }

  build() {
    Column() {
      TitleBar()
      LazyForEach(this.operations, (item, index) => {
        Row(){
          OperationView({ mKey: item, value: '', handleClick: () => {
            router.push({
              url: operationUrls[index]
            })
          } })
        }
      }, item => JSON.stringify(item))
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}