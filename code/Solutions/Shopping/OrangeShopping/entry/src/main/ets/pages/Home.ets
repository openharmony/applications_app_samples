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

import mediaquery from '@ohos.mediaquery'
import window from '@ohos.window'
import { NavigationHomePage } from '@ohos/navigation-component'
import { UpdateDialog } from '@ohos/updatedialog'
import { EventsDialog } from '@ohos/details-page-component'
import { EmitterClass } from '@ohos/emitter'

@Entry
@Component
struct HomePage {
  @State url: string = ''
  @State option: object = undefined
  @State curBp: string = 'md' // curBp指当前窗口断点，sm代表小屏，md代表中屏，lg代表大屏
  private smListener: any
  private mdListener: any
  private lgListener: any
  @StorageLink('shoppingCartGoodsList') shoppingCartGoodsList: { data: { id: number } }[] = []
  private emitterClass: EmitterClass = new EmitterClass()

  EventsDialogController: CustomDialogController = new CustomDialogController({
    builder: EventsDialog(),
    customStyle: true
  })

  UpdateDialogController: CustomDialogController = new CustomDialogController({
    builder: UpdateDialog(),
    customStyle: true
  })

  build() {
    Column() {
      NavigationHomePage({ url: this.url })
    }
  }

  aboutToAppear() {
    if(AppStorage.Get('nowIndex') === undefined || AppStorage.Get('nowIndex') === 0){
      this.UpdateDialogController.open()
    }
    this.emitterClass.showEventsDialog(()=>{
      if(AppStorage.Get('nowIndex') === undefined || AppStorage.Get('nowIndex') === 0){
        this.EventsDialogController.open()
      }
    })
    this.emitterClass.setShoppingCartGoodsList((eventData)=>{
      this.shoppingCartGoodsList.push(eventData.data.id)
      AppStorage.SetOrCreate('shoppingCartGoodsList', this.shoppingCartGoodsList)
    })
    this.smListener = mediaquery.matchMediaSync('(320vp<=width<520vp)')
    this.smListener.on('change', this.isBreakpointSM)
    this.mdListener = mediaquery.matchMediaSync('(520vp<=width<840vp)')
    this.mdListener.on('change', this.isBreakpointMD)
    this.lgListener = mediaquery.matchMediaSync('(840vp<=width)')
    this.lgListener.on('change', this.isBreakpointLG)
    window.getTopWindow({ stageMode: true }).then(result => {
      result.setFullScreen(false)
    })
  }

  aboutToDisappear() {
    this.smListener.off('change', this.isBreakpointSM)
    this.mdListener.off('change', this.isBreakpointMD)
    this.lgListener.off('change', this.isBreakpointLG)
  }

  isBreakpointSM = (mediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.curBp = 'sm'
      AppStorage.SetOrCreate('curBp', this.curBp)
    }
  }
  isBreakpointMD = (mediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.curBp = 'md'
      AppStorage.SetOrCreate('curBp', this.curBp)
    }
  }
  isBreakpointLG = (mediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.curBp = 'lg'
      AppStorage.SetOrCreate('curBp', this.curBp)
    }
  }
}