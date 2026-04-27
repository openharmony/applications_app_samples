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

import ComponentConfig from '../../../../../../../common/component/src/main/ets/default/ComponentConfig';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import lpx from '../../common/Lpx';


@Component
export default struct EntryComponent {
  @Prop isFocus: boolean = false
  @Prop settingIcon: string;
  @State endTextIsShow: Boolean = true;
  private settingTitle: string = '';
  @State settingValue: string | Resource = '';
  @State settingArrow: string | Resource = '';
  @Prop settingArrowStyle: string = '';
  private onArrowClick?: () => void;
  @State isTouched: boolean = false;
  private heights ? = $r('app.float.wh_value_70');
  private imageWh ? = $r('app.float.wh_value_50');
  private fontSize ? = lpx(34);
  @Prop maxLines: number = ComponentConfig.MAX_LINES_3

  build() {
    Row() {
      Row() {
        Image(this.settingIcon)
          .width(this.imageWh)
          .height(this.imageWh)
          .margin({ right: lpx(10) })
          .objectFit(ImageFit.Contain)
          .fillColor(this.isFocus ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')


        Text(this.settingTitle)
          .fontColor(this.isFocus ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
          .fontSize(this.fontSize)
          .textAlign(TextAlign.Start)
          .wordBreak(
            this.maxLines === ComponentConfig.MAX_LINES_1 ? WordBreak.BREAK_ALL : WordBreak.BREAK_WORD
          ) //当前最大行数为1行时折行规则是所有，否则恢复默认
          .maxLines(this.maxLines)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontWeight(500)
          .margin({ left: lpx(36), right: lpx(5) })
      }
      .flexShrink(0)
      .alignItems(VerticalAlign.Center)
      .align(Alignment.Start)
      .layoutWeight(ConfigData.LAYOUT_WEIGHT_1)

      Row() {
        Text(this.settingValue)
          .fontSize(this.fontSize)
          .fontColor(this.isFocus ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
          .fontWeight(500)
          .margin({ left: $r('sys.float.ohos_id_elements_margin_horizontal_l'), right: lpx(34) })
          .align(Alignment.End);


        Image(this.settingArrow)
          .visibility('' === this.settingArrow ? Visibility.None : Visibility.Visible)
          .fillColor(this.isFocus ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
          .width(lpx(24))
          .height(lpx(48))
          .margin({ right: lpx(24) })
          .onClick(() => {
            if (this.onArrowClick) {
              this.onArrowClick()
            }
          })
          .focusable(true)
          .stateStyles({
            focused: {
              .border({
                color: Color.Transparent
              })
            }
          })


      }
      .alignItems(VerticalAlign.Center)
      .align(Alignment.End);
    }
    .backgroundColor(this.isFocus ? 'rgba(255, 255, 255, 0.86)' : 'rgba(255, 255, 255, 0.2)')
    .height(this.heights)
    .width(lpx(840))
    .padding({ left: $r('sys.float.ohos_id_card_margin_start') })
    .borderRadius(lpx(18))
    .alignItems(VerticalAlign.Center)
    .borderColor('rgba(255, 255, 255, 0.2)')
  }
}
