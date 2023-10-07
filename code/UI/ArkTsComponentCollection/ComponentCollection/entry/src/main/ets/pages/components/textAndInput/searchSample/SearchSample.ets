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

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';
import {searchControlPanel} from './ChangePanel';

@Extend(Column) function cardStyle() {
  .backgroundColor(Color.White)
  .padding(12)
  .borderRadius(16)
  .width('100%')
}

@Entry
@Component
struct SearchSample {
  @State changeValue: string = '';
  @State submitValue: string = '';
  @State copyValue: string = '';
  @State cutValue: string = '';
  @State pasteValue: string = '';
  @State placeholderColor: Color = Color.Blue;
  @State textAlign: TextAlign = TextAlign.Start;
  @State copyOptions: CopyOptions = CopyOptions.None;
  controller: SearchController = new SearchController();

  build() {
    Column() {
      TitleBar({ title: $r('app.string.search_title') })
      Column() {
        Text('onSubmit:' + this.submitValue).fontSize(18).margin(15)
        Text('onChange:' + this.changeValue).fontSize(18).margin(15)
        Text('onCopy:' + this.copyValue).fontSize(18).margin(15)
        Text('onCut:' + this.cutValue).fontSize(18).margin(15)
        Text('onPaste:' + this.pasteValue).fontSize(18).margin(15)
        Search({ value: this.changeValue, placeholder: 'Type to search...', controller: this.controller })
          .searchButton('SEARCH')
          .id('search_001')
          .width('95%')
          .height(40)
          .backgroundColor('#F5F5F5')
          .placeholderColor(this.placeholderColor)
          .textAlign(this.textAlign)
          .copyOption(this.copyOptions)
          .placeholderFont({ size: 14, weight: 400 })
          .textFont({ size: 14, weight: 400 })
          .enableKeyboardOnFocus(false)
          .onSubmit((value: string) => {
            this.submitValue = value;
          })
          .onChange((value: string) => {
            this.changeValue = value;
          })
          .onCopy((value)=>{
            this.copyValue = value;
          })
          .onCut((value)=>{
            this.cutValue = value;
          })
          .onPaste((value)=>{
            this.pasteValue = value;
          })
          .margin(20)
      }.cardStyle()
      IntroductionTitle({introduction:$r('app.string.search_change')})
      Column() {
        searchControlPanel({placeholderColor:$placeholderColor,textAlign:$textAlign,copyOption:$copyOptions})
      }.cardStyle()
    }
    .backgroundColor($r('app.color.background_light_gray'))
    .height('100%')
    .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
  }
}