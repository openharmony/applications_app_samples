/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * 按钮组件，背景/图标可根据use切换展示状态
 */
@Component
export default struct ComponentOption {
  private useResource: Resource = $r('app.media.icon_openvalley_hangup');
  private unUseResource: Resource = $r('app.media.icon_openvalley_hangup');
  private useBgColorResource?: Resource = $r('app.color.color_fff');
  @Link use: boolean;
  private callback: ((use: boolean) => void) | null = null;
  private canChange: (() => boolean) | null = null;
  private mSize = 72;
  private btnId = 'btnId';

  build() {
    Button() {
      Image(this.use ? this.useResource : this.unUseResource)
        .width('60%')
        .objectFit(ImageFit.Contain)
        .height('60%')
    }
    .id(this.btnId)
    .align(Alignment.Center)
    .width(this.mSize)
    .height(this.mSize)
    .type(ButtonType.Circle)
    .backgroundColor(this.use ? this.useBgColorResource : $r('app.color.color_01_fff'))
    .onClick(() => {
      if (this.canChange && this.canChange()) {
        this.use = !this.use
      }
      if (this.callback) {
        this.callback(this.use)
      }
    })
  }
}