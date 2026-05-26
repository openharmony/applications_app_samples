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
import { PageViewUtils } from '@ohos/common';
import { CustomIconList } from '../../model/SceneCondition';

@Component
struct TitleHeader {
  cancel?: () => void;
  confirm?: () => void;

  build() {
    Row() {
      Text($r('app.string.button_text_cancel'))
        .fontColor('#0A59F7')
        .fontSize($r('app.string.font_14'))
        .onClick(() => this.cancel && this.cancel());
      Text($r('app.string.select_scene_icon')).fontColor('#000000').fontSize($r('app.string.font_16'));
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
struct SceneIconContentItem {
  @Prop contentItem: CustomIconList;

  build() {
    Column() {
      Image($r(`app.media.${this.contentItem.value}`))
        .size({
          width: $r('app.string.scene_icon_width'),
          height: $r('app.string.scene_icon_height'),
        }).objectFit(ImageFit.Contain);
    }
    .borderColor(this.contentItem.check ? 'red' : '#ffffff')
    .borderWidth(1)
    .borderRadius($r('app.string.scene_icon_height'));
  }
}

@Entry
@Component
export struct modifySceneIcon {
  cancel?: () => void;
  confirm?: (form: CustomIconList) => void;
  @State customIconList: CustomIconList[] = [
    new CustomIconList('card', 'ic_scene_card', false),
    new CustomIconList('traffic', 'ic_scene_traffic', false),
    new CustomIconList('governmentAffairs', 'ic_scene_governmentAffairs', false),
    new CustomIconList('medicalTreatment', 'ic_scene_medicalTreatment', false),
    new CustomIconList('education', 'ic_scene_education', false),
    new CustomIconList('light', 'ic_scene_light', false),
  ];

  aboutToAppear(): void {
    PageViewUtils.tabClick();
  }

  build() {
    Column() {
      TitleHeader({
        cancel: () => this.cancel && this.cancel(),
        confirm: () => {
          let data = this.customIconList.find((res) => res.check);
          if (data) {
            this.confirm && this.confirm(data);
          } else {
            promptAction.showToast({
              message: '请选择场景图标',
              duration: 2000
            });
          }
        },
      });

      Column() {
        Grid() {
          ForEach(this.customIconList, (item: CustomIconList) => {
            GridItem() {
              Row() {
                SceneIconContentItem({ contentItem: item });
              }.onClick(() => {
                this.customIconList.forEach((res) => res.check = false);
                item.check = !item.check;
              });
            };
          });
        }
        .padding(px2vp(20))
        .columnsTemplate('1fr '.repeat(4))
        .rowsGap(px2vp(20))
        .width('100%')
        .height('100%');
      }.padding($r('app.string.p_24'));
    }.height('100%').width('100%');
  }
}