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

import NavigationBar from '../../componets/NavigationBar'
import { AddPictures } from '../../componets/AddPictures'
import { RequestBar } from '../../componets/RequestBar'
import emitter from '@ohos.events.emitter'
import Logger from '../../util/Logger'
import common from '@ohos.app.ability.common'


@Entry
@Component
struct Upload {
  @StorageLink('imageList') @Watch("onImageListChange") imageList: Array<string> = []
  @State buttonEnable: boolean = false;
  controller: TextAreaController = new TextAreaController()

  getString(id) {
    let context: common.Context = getContext(this) as common.Context;
    return context.resourceManager.getStringSync(id)
  }

  aboutToDisappear() {
    this.imageList = [];
  }

  onImageListChange() {
    this.buttonEnable = this.imageList.length > 0;
  }

  startUpload() {
    let innerEvent = {
      eventId: 1,
      priority: emitter.EventPriority.HIGH
    };
    let eventData = {
      data: {
        "content": "test"
      }
    };
    emitter.emit(innerEvent,eventData);
    Logger.info("send publish event!")
  }

  build() {
    Column() {
      NavigationBar(
        {
          title: this.getString($r('app.string.upload_title')),
          buttonTip: this.getString($r('app.string.publish')),
          clickCallback: () => {
            this.startUpload()
          },
          buttonEnable: this.buttonEnable
        }
      )
      TextArea({
        placeholder: $r('app.string.tip'),
        controller: this.controller
      })
        .placeholderFont({ size: $r('app.float.upload_font_size'), weight: 400 })
        .width('90%')
        .height($r('app.float.upload_area_height'))
        .margin($r('app.float.upload_area_margin'))
        .fontSize($r('app.float.upload_font_size'))
        .fontColor($r('app.color.medium_gray'))
        .backgroundColor($r('app.color.white'))
      AddPictures()
      RequestBar()
    }
    .width('100%')
    .height('100%')
    .margin({ left: $r('app.float.upload_margin_left'), right: $r("app.float.upload_margin_right") })
  }
}