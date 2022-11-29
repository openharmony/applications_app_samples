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
import Contact from '../Model/Contact'
import ContactsManager from '../Service/ContactsManager'
import router from '@ohos.router'

@CustomDialog
struct MyCustomDialog {
  controller: CustomDialogController
  contact: Contact = null

  onConfirm() {
    ContactsManager.getInstance().removeContact(this.contact?.id)
  }

  build() {
    Column() {
      Text('删除联系人').fontSize(20).margin({ top: 10, bottom: 10 })
      Stack() {
        Circle({ width: '90%', height: '90%' })
          .fill(this.contact?.color)
        Text(this.contact?.name?.slice(0, 1))
          .height('80%')
          .fontSize('28fp')
          .fontColor(Color.White)
      }.width(80).height(80)

      Text('是否删除联系人: ' + this.contact?.name).fontSize(16).margin({ bottom: 10 })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            this.controller.close()
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('确定')
          .onClick(() => {
            this.controller.close()
            this.onConfirm()
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }
  }
}

@Component
export struct ContactComp {
  contact: Contact = null
  @State backColor: string = 'rgb(255,255,255)'
  dialogController: CustomDialogController = new CustomDialogController({
    builder: MyCustomDialog({ contact: this.contact }),
    autoCancel: true
  })
  touchStartTime: number
  timeId: number

  build() {
    Row() {
      Stack() {
        Circle({ width: '90%', height: '90%'})
          .fill(this.contact?.color)
        Text(this.contact?.name?.slice(0, 1))
          .height('80%')
          .fontSize('28fp')
          .fontColor(Color.White)
      }
      .width('25%')
      .height('100%')
      Blank().width('5%')
      Column() {
        Text(this.contact?.name)
          .height('95%')
          .width('100%')
          .fontSize('22fp')
        Line({ width: '100%', height: '5%'})
          .startPoint([0, 0])
          .endPoint(['100%', 0])
          .strokeWidth(0)
          .backgroundColor(Color.Grey)
      }
      .height('80%')
      .width('60%')
      Blank().width('10%')
    }
    .backgroundColor(this.backColor)
    .onTouch((event: TouchEvent) => {
      if (event.type == TouchType.Down) {
        this.backColor = '#f1f3f5'
        this.touchStartTime = Date.now()
        //长按删除
        this.timeId = setTimeout(() => {
          this.dialogController.open()
        }, 500)
      }
      if (event.type == TouchType.Up) {
        this.backColor = 'rgb(255,255,255)'
        //短按跳转详情页
        if (Date.now() - this.touchStartTime <= 200) {
          router.push({
            url: 'pages/ContactInfoPage',
            params: {contactId: this.contact?.id}
          })
          //提前松开手指不触发长按删除
          clearTimeout(this.timeId)
        }
      }
    })
    .width('100%')
    .height('100%')
  }
}