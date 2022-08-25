// @ts-nocheck
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
import router from '@ohos.router';
import { Header, User } from '../components/Header';

@Entry
@Component
struct UserInfo {
  private scroller: Scroller = new Scroller()

  build() {
    Scroll(this.scroller) {
      Column() {
        Header({ title: "个人信息" })
        Column() {
          User({ img: $r('app.media.personality3'), text: "头像", text2: "" })
          User({ img: $r('app.media.personality3'), text: "名字", text2: "自己" })
          User({ img: $r('app.media.personality3'), text: "拍一拍", text2: "的额头" })
          User({ img: $r('app.media.personality3'), text: "聊天号", text2: "********" })
          User({ img: $r('app.media.ic_public_code'), text: "我的二维码", text2: "" })
          User({ img: $r('app.media.personality3'), text: "更多", text2: "" })
          User({ img: $r('app.media.personality3'), text: "聊天豆", text2: "" })
          User({ img: $r('app.media.personality3'), text: "我的地址", text2: "" })
        }
        .backgroundColor('#ffffff')
        .width("100%")
      }
      .alignItems(HorizontalAlign.Center)
      .width("100%")
      .backgroundColor(0xDCDCDC)
      .padding({ top: 5 })
    }
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }
}