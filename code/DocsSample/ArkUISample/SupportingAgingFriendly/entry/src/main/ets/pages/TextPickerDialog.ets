/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start trigger_aging_friendly_by_set_font_size]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_SupportingAgingFriendly]';
const DOMAIN = 0xF811;
const BUNDLE = 'SupportingAgingFriendly_';

@Entry
@Component
struct TextPickerExample {
  private select: number | number[] = 0;
  private cascade: TextCascadePickerRangeContent[] = [
    {
      // $r('app.string.xxx')需要替换为开发者所需的资源文件
      text: $r('app.string.liaoning'),
      children: [{ text: $r('app.string.shenyang'), children: [{ text: $r('app.string.shenhe') },
        { text: $r('app.string.heping') }, { text: $r('app.string.hunnan') }] },
        { text: $r('app.string.dalian'), children: [{ text: $r('app.string.zhongshan') },
        { text: $r('app.string.jinzhou') }, { text: $r('app.string.changhai') }] }]
    },
    {
      // $r('app.string.xxx')需要替换为开发者所需的资源文件
      text: $r('app.string.jilin'),
      children: [{ text: $r('app.string.changchun'), children: [{ text: $r('app.string.nangang') },
        { text: $r('app.string.kuanchen') }, { text: $r('app.string.chaoyang') }] },
        { text: $r('app.string.sipin'), children: [{ text: $r('app.string.tiexi') },
        { text: $r('app.string.tiedong') }, { text: $r('app.string.lishu') }] }]
    },
    {
      // $r('app.string.xxx')需要替换为开发者所需的资源文件
      text: $r('app.string.heilingjiang'),
      children: [{ text: $r('app.string.haerbin'), children: [{ text: $r('app.string.daoli') },
        { text: $r('app.string.daowai') }, { text: $r('app.string.nangang') }] },
        { text: $r('app.string.mudanjiang'), children: [{ text: $r('app.string.dongan') },
        { text: $r('app.string.xian')}, { text: $r('app.string.aimin') }] }]
    }
  ]
  @State value: string = '';
  @State showTriggered: string = '';
  private triggered: string = '';
  private maxLines: number = 3; // 最大的行数为3

  linesNum(max: number): void {
    let items: string[] = this.triggered.split('\n').filter(item => item != '');
    if (items.length > max) {
      this.showTriggered = items.slice(-this.maxLines).join('\n');
    } else {
      this.showTriggered = this.triggered;
    }
  }

  build() {
    Column() {
      Button('TextPickerDialog.show:' + this.value)
        .onClick(() => {
          this.getUIContext().showTextPickerDialog({
            range: this.cascade,
            selected: this.select,
            onAccept: (value: TextPickerResult) => {
              this.select = value.index;
              hilog.info(DOMAIN, TAG, BUNDLE + this.select + '');
              this.value = value.value as string;
              hilog.info(DOMAIN, TAG, BUNDLE + 'TextPickerDialog:onAccept()' + JSON.stringify(value));
              if (this.triggered != '') {
                this.triggered += `\nonAccept(${JSON.stringify(value)})`;
              } else {
                this.triggered = `onAccept(${JSON.stringify(value)})`;
              }
              this.linesNum(this.maxLines);
            },
            onCancel: () => {
              hilog.info(DOMAIN, TAG, BUNDLE + 'TextPickerDialog:onCancel()');
              if (this.triggered != '') {
                this.triggered += `\nonCancel()`;
              } else {
                this.triggered = `onCancel()`;
              }
              this.linesNum(this.maxLines);
            },
            onChange: (value: TextPickerResult) => {
              hilog.info(DOMAIN, TAG, BUNDLE + 'TextPickerDialog:onChange()' + JSON.stringify(value));
              if (this.triggered != '') {
                this.triggered += `\nonChange(${JSON.stringify(value)})`;
              } else {
                this.triggered = `onChange(${JSON.stringify(value)})`;
              }
              this.linesNum(this.maxLines);
            },
          })
        })
        .margin({ top: 60 });
    }
  }
}
// [End trigger_aging_friendly_by_set_font_size]
