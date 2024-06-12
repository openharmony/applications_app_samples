/*
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import Contact from '../model/Contact';
import { TYPE_DELETE, TYPE_INSERT, TYPE_UPDATE } from '../model/RdbConst'

@CustomDialog
export struct DataChangeDetailDialog {
  private controller?: CustomDialogController;
  @State detailList: Array<Contact> = [];

  build() {
    Column() {
      Text($r('app.string.change_detail'))
        .fontSize(24)
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)
        .margin(8)
      List() {
        ForEach(this.detailList, (item: Contact, index: number) => {
          ListItem() {
            Column() {
              if (item.type === TYPE_DELETE) {
                Text($r('app.string.change_delete'))
                  .fontSize(20)
                  .width('80%')
                  .fontColor(Color.Black)
              }
              if (item.type === TYPE_UPDATE) {
                Text($r('app.string.change_update'))
                  .fontSize(20)
                  .width('80%')
                  .fontColor(Color.Black)
              }
              if (item.type === TYPE_INSERT) {
                Text($r('app.string.change_insert'))
                  .fontSize(20)
                  .width('80%')
                  .fontColor(Color.Black)
              }
              Column() {
                Row() {
                  Text($r('app.string.id'))
                    .fontSize(20)
                    .width('40%')
                    .fontColor(Color.Black)
                  Text(item.id.toString())
                    .fontSize(20)
                    .width('40%')
                    .fontColor(Color.Black)
                }

                if (item.type !== TYPE_DELETE) {
                  Row() {
                    Text($r('app.string.contact_name'))
                      .fontSize(20)
                      .width('40%')
                      .fontColor(Color.Black)
                    Text(item.name)
                      .fontSize(20)
                      .width('40%')
                      .fontColor(Color.Black)
                  }

                  Row() {
                    Text($r('app.string.gender1'))
                      .fontSize(20)
                      .width('40%')
                      .fontColor(Color.Black)
                    if (item.gender == 0) {
                      Text($r('app.string.male'))
                        .fontSize(20)
                        .width('40%')
                        .fontColor(Color.Black)
                    } else {
                      Text($r('app.string.female'))
                        .fontSize(20)
                        .width('40%')
                        .fontColor(Color.Black)
                    }
                  }

                  Row() {
                    Text($r('app.string.phone'))
                      .fontSize(20)
                      .width('40%')
                      .fontColor(Color.Black)
                    Text(item.phone)
                      .fontSize(20)
                      .width('40%')
                      .fontColor(Color.Black)
                  }

                  Row() {
                    Text($r('app.string.remark'))
                      .fontSize(20)
                      .width('40%')
                      .fontColor(Color.Black)
                    Text(item.remark)
                      .fontSize(20)
                      .width('40%')
                      .fontColor(Color.Black)
                  }

                  Row() {
                    Text($r('app.string.age'))
                      .fontSize(20)
                      .width('40%')
                      .fontColor(Color.Black)
                    Text(item.age.toString())
                      .fontSize(20)
                      .width('40%')
                      .fontColor(Color.Black)
                  }
                }
              }
              .margin(8)
              .padding({ left: 12 })
            }
          }

        })
      }
      .divider({ strokeWidth: 1, color: Color.Gray })
      .width('80%')
      .height('80%')

      Button() {
        Text($r('app.string.sure'))
          .fontColor('#0D9FFB')
          .width('90%')
          .textAlign(TextAlign.Center)
          .fontSize(20)
      }
      .key('sureBtn')
      .type(ButtonType.Capsule)
      .backgroundColor(Color.White)
      .onClick(() => {
        if (this.controller != null) {
          this.controller.close()
        }
      })
    }
    .backgroundColor(Color.White)
    .border({ color: Color.White, radius: 20 })
    .padding(10)
  }
}