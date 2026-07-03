/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import emitter from '@ohos.events.emitter'; //4.1和5.0引用不一样

@Component
export struct textBtn {
  @Link ifFocus: string;
  text: ResourceStr = $r('app.string.move');
  focusItem: string = 'move';

  build() {
    Row() {
      Text(this.text)
        .fontColor(this.ifFocus === this.focusItem ? 'rgba(0, 0, 0, 0.86)' : 'rgba(255, 255, 255, 0.86)')
        .backgroundColor(this.ifFocus === this.focusItem ? 'rgba(255,255,255,0.86)' :
          'rgba(255,255,255,0.2)')//.width('50%')
        .focusable(true)
        .fontSize('36lpx')
        .width('248lpx')
        .height('72lpx')
        .borderRadius('36lpx')
        .textAlign(TextAlign.Center)
        .defaultFocus(true)
        .id(this.focusItem)
        .onAppear(() => {
          focusControl.requestFocus(this.focusItem);
        })
        .onClick(() => {
          emitter.emit(this.focusItem);
        })
        .onFocus(() => {
          this.ifFocus = this.focusItem;
        });
    }.padding('5lpx')
    .border({
      radius: '40lpx',
      color: this.ifFocus === this.focusItem ? Color.White : '',
      width: this.ifFocus === this.focusItem ? '2lpx' : 0,
    });
  }
}