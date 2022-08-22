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


import DesktopLayoutModel from '../model/DesktopLayoutModel'
import GridLayoutItemInfo from '../../../../../../base/src/main/ets/default/bean/GridLayoutItemInfo'
import LauncherGridLayout from '../components/LauncherGridLayout'
import Logger from '../../../../../../base/src/main/ets/default/utils/Logger'

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

const TAG: string = 'WorkSpace'

@Component
export default struct WorkSpace {
  @StorageLink('isRefresh') @Watch('refreshWorkSpace') isRefresh: boolean = false;
  @State appPages: Array<Array<GridLayoutItemInfo>> = [[]]
  private swiperController: SwiperController = new SwiperController()
  private desktopLayoutModel: DesktopLayoutModel = DesktopLayoutModel.getInstance(getContext(this))

  build() {
    Column() {
      Swiper(this.swiperController) {
        LazyForEach(new MyDataSource(this.appPages), item => {
          Row(){
            LauncherGridLayout({ gridInfos: item })
          }
        }, item => item.length.toString())
      }
      .indicatorStyle({
        selectedColor: Color.White
      })
      .width('100%')
      .height('95%')
      .margin({ top: '5%' })
    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear() {
    Logger.info(TAG, 'aboutToAppear')
    this.getData()
  }

  refreshWorkSpace() {
    if (this.isRefresh) {
      this.appPages = this.desktopLayoutModel.getLayoutInfoCache()
      AppStorage.SetOrCreate('isRefresh', false)
    }
  }

  async getData() {
    this.appPages = await this.desktopLayoutModel.getLayoutInfo()
    Logger.info(TAG, `getLauncherAbilityList end,appPages = ${JSON.stringify(this.appPages)}`)
  }
}