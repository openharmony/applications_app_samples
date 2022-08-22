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

type appItem = {
  id: string,
  title: Resource,
  image: Resource
}

@Component
export default struct IndexApps {
  private title: Resource | string
  @Prop currentBreakpoint: string
  private apps: appItem[] = []

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        Text(this.title)
          .width(100)
          .height(21)
          .fontSize(14)
          .textAlign(TextAlign.Start)
          .fontWeight(500)
          .padding({ top: 18, bottom: 8.5 })
        Row() {
          Row() {
            Text($r('app.string.more'))
              .width(50)
              .height(19)
              .fontSize(14)
              .textAlign(TextAlign.End)
              .fontWeight(400)
              .margin({ right: 2 })
            Image($r("app.media.ic_public_arrow_right"))
              .width(12)
              .height(24)
              .opacity(0.9)
              .objectFit(ImageFit.Fill)
          }
        }
        .width(100)
        .height(48)
        .padding({ top: 15, bottom: 9 })
      }
      .width('100%')

      Column() {
        List(this.currentBreakpoint === "lg" ? { space: 44, initialIndex: 0 } : { space: 20, initialIndex: 0 }) {
          ForEach(this.apps, app => {
            ListItem() {
              Column() {
                Image(app.image)
                  .width(this.currentBreakpoint === "lg" ? 80 : 56)
                  .height(this.currentBreakpoint === "lg" ? 80 : 56)
                  .margin({ bottom: 8 })
                Text(app.title)
                  .width(this.currentBreakpoint === "lg" ? 80 : 56)
                  .height(16)
                  .fontSize(12)
                  .textAlign(TextAlign.Center)
                  .fontColor('#18181A')
                  .margin({ bottom: 8 })
                Button($r('app.string.install'), { type: ButtonType.Capsule, stateEffect: true })
                  .width(this.currentBreakpoint === "lg" ? 80 : 56)
                  .height(28)
                  .fontColor('#0A59F7')
                  .fontWeight(500)
                  .fontSize(12)
                  .padding({ top: 6, bottom: 6, left: 8, right: 8 })
                  .backgroundColor('rgba(0,0,0,0.05)')
              }
            }
          }, app => app.id)
        }
        .editMode(false)
        .width('100%')
        .listDirection(Axis.Horizontal)
        .edgeEffect(EdgeEffect.None)
        .chainAnimation(false)
        .height(this.currentBreakpoint === "lg" ? 140 : 120)
      }
      .width('100%')
    }
    .width('100%')
    .height(this.currentBreakpoint === "lg" ? 188 : 164)
    .margin({ bottom: 8, left: $r('app.float.app_safe_margin'), right: $r('app.float.app_safe_margin') })
  }
}


