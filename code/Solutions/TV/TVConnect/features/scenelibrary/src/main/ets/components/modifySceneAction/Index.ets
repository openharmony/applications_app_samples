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
import { promptAction } from '@kit.ArkUI';
import { Logger } from '@ohos/common';
import { EventActionUIInfoDataItem, IUiInfo } from '../../model/SceneCondition';

@Component
struct TitleHeader {
  @Prop title: string;
  cancel?: () => void;
  confirm?: () => void;

  build() {
    Row() {
      Text($r('app.string.button_text_cancel'))
        .fontColor('#0A59F7')
        .fontSize($r('app.string.font_14'))
        .onClick(() => this.cancel && this.cancel());
      Text($r('app.string.Choose',this.title)).fontColor('#000000').fontSize($r('app.string.font_16'));
      Text($r('app.string.button_text_confirm'))
        .fontColor('#0A59F7')
        .fontSize($r('app.string.font_14'))
        .onClick(() => this.confirm && this.confirm());
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height($r('app.string.scene_tab_height'))
    .padding({ left: $r('app.string.p_24'), right: $r('app.string.p_24') });
  }
}


@Component
export struct modifySceneAction {
  @Link data: EventActionUIInfoDataItem;
  cancel?: () => void;
  confirm?: () => void;
  @State actionVal: string = '';

  build() {
    Column() {
      TitleHeader({
        title: this.data.name || '',
        cancel: () => this.cancel && this.cancel(),
        confirm: () => {

          if (this.actionVal) {
            switch (this.data.type) {
              case 'enum':
                let data = this.data.uiInfo.find((res) => res.enumVal === this.actionVal);
                this.data.selectedName = data?.descCh || '';
                this.data.selectedValue = data?.enumVal || '';
                break;
              case 'int':
                this.data.selectedName = this.actionVal + this.data.unit || '';
                this.data.selectedValue = this.actionVal || '';
                break;
              default:
                break;
            }
            this.confirm && this.confirm();
          } else {
          }
        },
      });

      Column() {
        Flex({ justifyContent: FlexAlign.Center }) {
          if (this.data.type == 'enum') {
            GridRow({
              columns: 3,
              gutter: { x: 5, y: 10 },
              breakpoints: {
                value: ['400vp', '600vp', '800vp'],
                reference: BreakpointsReference.WindowSize
              },
              direction: GridRowDirection.Row
            }) {
              ForEach(this.data.uiInfo, (item: IUiInfo) => {
                GridCol() {
                  Row({ space: 8 }) {
                    Text(item.descCh)
                      .fontColor('#333333')
                      .fontSize('16fp')
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .maxLines(1)
                      .width('50vp');
                    Radio({ value: 'Radio1', group: 'radioGroup', indicatorType: RadioIndicatorType.TICK })
                      .checked(false)
                      .height('24vp')
                      .width('24vp')
                      .onChange((isChecked: boolean) => {
                        if (isChecked) {
                          this.actionVal = item.enumVal;
                          Logger.info('Radio1 status is2 ' + JSON.stringify(this.actionVal));
                        }
                      });
                  };
                };
              });
            }.width('100%').height('100%');
          } else if (this.data.type == 'int') {
            Row({ space: 8 }) {
              Slider({
                value: Number(this.actionVal),
                min: Number(this.data.min) || 0,
                max: Number(this.data.max) || 0,
                style: SliderStyle.NONE
              })
                .blockColor('#191970')
                .trackColor('#ADD8E6')
                .selectedColor('#4169E1')
                .onChange((value: number, mode: SliderChangeMode) => {
                  if (Number(this.data.min) <= value && Number(this.data.max) >= value) {
                    this.actionVal = `${value}`;
                    Logger.info('value:' + this.actionVal + 'mode:' + mode.toString());
                  }
                })
                .width('90%');

              Text(Number(this.actionVal).toFixed(0) + this.data.unit ?? '').fontSize(12);
            }.width('100%');
          }
        };

      }.padding($r('app.string.p_24'));
    }.height('100%').width('100%');
  }
}