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
import TextNapi from 'libentry.so';
import { NodeContent } from '@kit.ArkUI';

enum TextPickerRangeType {
  ARKUI_TEXTPICKER_RANGETYPE_SINGLE = 0,
  ARKUI_TEXTPICKER_RANGETYPE_MULTI = 1,
  RKUI_TEXTPICKER_RANGETYPE_RANGE_CONTENT,
  ARKUI_TEXTPICKER_RANGETYPE_CASCADE_RANGE_CONTENT
}
@Entry
@Component
struct secondIndex {
  private nodeContent: Content = new NodeContent();
  @State rangeType: number = TextPickerRangeType.ARKUI_TEXTPICKER_RANGETYPE_SINGLE;
  @State isCross: boolean = false;
  @State isInit: boolean = false;
  @Builder
  SubMenuModeType() {
    Menu() {
      MenuItem({content: 'ARKUI_TEXTPICKER_RANGETYPE_SINGLE' })
        .width('50%')
        .onChange(()=> {
          this.isInit = true;
          this.rangeType = TextPickerRangeType.ARKUI_TEXTPICKER_RANGETYPE_SINGLE;
          TextNapi.createTextPickerWithCustomContent(this.rangeType);
        })
      MenuItem({content: 'ARKUI_TEXTPICKER_RANGETYPE_MULTI'})
        .width('50%')
        .onChange(()=> {
          this.isInit = true;
          this.rangeType = TextPickerRangeType.ARKUI_TEXTPICKER_RANGETYPE_MULTI;
          TextNapi.createTextPickerWithCustomContent(this.rangeType);
        })
      MenuItem({content: 'RKUI_TEXTPICKER_RANGETYPE_RANGE_CONTENT'})
        .width('50%')
        .onChange(()=> {
          this.isInit = true;
          this.rangeType = TextPickerRangeType.RKUI_TEXTPICKER_RANGETYPE_RANGE_CONTENT;
          TextNapi.createTextPickerWithCustomContent(this.rangeType);
        })
      MenuItem({content: 'ARKUI_TEXTPICKER_RANGETYPE_CASCADE_RANGE_CONTENT'})
        .width('50%')
        .onChange(()=> {
          this.isInit = true;
          this.rangeType = TextPickerRangeType.ARKUI_TEXTPICKER_RANGETYPE_CASCADE_RANGE_CONTENT;
          TextNapi.createTextPickerWithCustomContent(this.rangeType);
        })
    }
  }

  @Builder
  CrossLanguageOption() {
    Menu() {
      MenuItem({content: 'true' })
        .width('50%')
        .onChange(()=> {
          this.isCross = true;
          TextNapi.setUpTextCrossLanguage(this.isCross);
        })
      MenuItem({content: 'false'})
        .width('50%')
        .onChange(()=> {
          this.isCross = false;
          TextNapi.setUpTextCrossLanguage(this.isCross);
        })
    }
  }

  build() {
    Row() {
      Column() {
        Button($r('app.string.Select_textPicker_type'))
          .height(50)
          .width('50%')
          .bindMenu(this.SubMenuModeType)
        if (this.isInit) {
          Button($r('app.string.Set_crossLanguage'))
            .height(50)
            .width('50%')
            .bindMenu(this.CrossLanguageOption)
        }
        Column() {
          ContentSlot(this.nodeContent)
        }
        .width('100%')
      }
    }
    .height('100%')
  }
  async aboutToAppear() {
    TextNapi.setContentHandle(this.nodeContent);
  }
  async aboutToDisappear() {
    TextNapi.clearNodes();
  }
}
