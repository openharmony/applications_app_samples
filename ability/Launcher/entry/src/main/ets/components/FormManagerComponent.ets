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

import router from '@ohos.router'
import CheckEmptyUtils from '../../../../../base/src/main/ets/default/utils/CheckEmptyUtils'
import CommonConstants from '../../../../../base/src/main/ets/default/constants/CommonConstants'
import DesktopLayoutModel from '../../../../../desktop/src/main/ets/default/model/DesktopLayoutModel'
import FormModel from '../../../../../base/src/main/ets/default/model/FormModel'
import Logger from '../../../../../base/src/main/ets/default/utils/Logger'

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

const TAG: string = 'FormManagerComponent'

@Component
export default struct FormManagerComponent {
  @StorageLink('formAppInfo') formAppInfo: any = {}
  @StorageLink('formMgrItem') formItem: any = []
  private mSwiperController: SwiperController = new SwiperController()
  private mSwiperIndex: number = 0
  private mFormIdList: number[] = []
  private index: number = 0

  build() {
    Column() {
      Text(this.formAppInfo.appName)
        .fontColor(Color.White)
        .fontSize(22)
      Column({ space: 5 }) {
        Swiper(this.mSwiperController) {
          LazyForEach(new MyDataSource(this.formItem), (item) => {
            LazyForEach(new MyDataSource(item.supportDimensions), (dimensionItem) => {
              Column() {
                Text(item.description)
                  .width('70%')
                  .fontColor(0xe5ffffff)
                  .fontSize(20)
                  .textAlign(TextAlign.Center)
                Column() {
                  Flex({
                    direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
                    if (this.formAppInfo.bundleName == item.bundleName) {
                      FormComponent({
                        id: item.cardId,
                        name: item.cardName,
                        bundle: item.bundleName,
                        ability: item.abilityName,
                        module: item.moduleName,
                        dimension: dimensionItem,
                      })
                        .clip(new Rect({
                          width: CommonConstants.FORM_COMPONENT_WIDTH[dimensionItem - 1],
                          height: CommonConstants.FORM_COMPONENT_HEIGHT[dimensionItem - 1],
                          radius: CommonConstants.DEFAULT_CARD_RADIUS
                        }))
                        .size({
                          width: CommonConstants.FORM_COMPONENT_WIDTH[dimensionItem - 1],
                          height: CommonConstants.FORM_COMPONENT_HEIGHT[dimensionItem - 1]
                        })
                        .onAcquired((form) => {
                          this.mFormIdList.push(form.id);
                          Logger.info(TAG, `onAcquired mFormIdList: ${JSON.stringify(this.mFormIdList)}`);
                        })
                    }
                  }
                }
                .height('80%')
              }.width('100%')
            }, (dimensionItem) => JSON.stringify(dimensionItem))
          }, (item) => JSON.stringify(item))
        }
        .width('100%')
        .height('100%')
        .loop(false)
        .index(this.index)
        .indicatorStyle({
          selectedColor: Color.White
        })
        .onChange((index: number) => {
          this.index = index
        })
      }.alignItems(HorizontalAlign.Center)
      .height('70%')

      Blank()
      Button({ type: ButtonType.Capsule }) {
        Row() {
          Text($r('app.string.add_to_desktop'))
            .fontColor(Color.White)
            .fontSize(22)
        }
      }
      .backgroundColor(0x66ffffff)
      .width(220)
      .height(50)
      .margin({
        top: 20,
        bottom: 20,
        left: 20,
        right: 20 })
      .onClick(async () => {
        Logger.info(TAG, `add card to desktop`)
        let selectForm = this.getSelectedFormInfo()
        if (!CheckEmptyUtils.isEmpty(selectForm)) {
          await DesktopLayoutModel.getInstance(getContext(this))
            .createCardToDeskTop(this.getSelectedFormInfo())
        }
        router.back()
      })
    }
  }

  aboutToAppear(): void {
    Logger.info(TAG, `aboutToAppear formAppInfo: ${JSON.stringify(this.formAppInfo)}`)
    this.getCurrentFormInfo()
  }

  /**
   * Get current form information by bundle name.
   */
  private async getCurrentFormInfo() {
    FormModel.getFormsInfoByBundleName(this.formAppInfo.bundleName)
  }

  getSelectedFormInfo() {
    if (CheckEmptyUtils.isEmptyArr(this.formItem) || this.index > this.formItem.length) {
      return undefined
    }
    let formCardItem: any = {}
    let count = 0
    let isStop = false
    for (let i = 0; i < this.formItem.length; i++) {
      if (isStop) {
        break
      }
      for (let j = 0; j < this.formItem[i].supportDimensions.length; j++) {
        if (count === this.index) {
          formCardItem.cardId = this.mFormIdList[this.index]
          formCardItem.appName = this.formAppInfo.appName
          formCardItem.cardName = this.formItem[i].cardName
          formCardItem.bundleName = this.formItem[i].bundleName
          formCardItem.abilityName = this.formItem[i].abilityName
          formCardItem.moduleName = this.formItem[i].moduleName
          formCardItem.dimension = this.formItem[i].supportDimensions[j]
          formCardItem.formConfigAbility = this.formItem[i].formConfigAbility
          formCardItem.appLabelId = this.formAppInfo.appLabelId
          isStop = true
          break
        }
        count++
      }
    }
    Logger.info(TAG, `getSelectedFormInfo formCardItem: ${JSON.stringify(formCardItem)}`)
    return formCardItem
  }
}