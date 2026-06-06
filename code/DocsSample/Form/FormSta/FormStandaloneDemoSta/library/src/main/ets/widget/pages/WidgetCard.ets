/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { ControlButtonParameter, BottomItem } from '../viewmodel/ControlButtonParameter';
import { ControlButtonComponent } from '../view/ControlButtonComponent';

@Entry
@Component
struct WidgetCard {
  /*
   * The action type.
   */
  readonly actionType = 'router';
  /*
   * The ability name.
   */
  readonly abilityName = 'EntryAbility';
  /*
   * The message.
   */
  readonly message = 'add detail';
  /*
   * The height percentage setting.
   */
  readonly fullHeightPercent = '100%';
  private readonly bottomItemList: BottomItem[] = [
    {
      formLinkParam: {
        action: this.actionType,
        abilityName: this.abilityName,
        params: {
          message: this.message
        }
      },
      title: $r('app.string.widget_explored'),
      icon: $r('app.media.ic_widget_explored')
    },
    {
      formLinkParam: {
        action: this.actionType,
        abilityName: this.abilityName,
        params: {
          message: this.message
        }
      },
      title: $r('app.string.widget_study'),
      icon: $r('app.media.ic_widget_study')
    },
    {
      formLinkParam: {
        action: this.actionType,
        abilityName: this.abilityName,
        params: {
          message: this.message
        }
      },
      title: $r('app.string.widget_action'),
      icon: $r('app.media.ic_widget_main')
    },
    {
      formLinkParam: {
        action: this.actionType,
        abilityName: this.abilityName,
        params: {
          message: this.message
        }
      },
      title: $r('app.string.widget_mine'),
      icon: $r('app.media.ic_widget_mine')
    }
  ];
  @State controlButtonParameter: ControlButtonParameter = new ControlButtonParameter(
    this.bottomItemList, BlurStyle.COMPONENT_ULTRA_THIN, undefined, $r('app.media.ic_widget_background'),
    ImageSize.Cover, $r('app.string.card_list_title'), Color.White, $r('sys.float.ohos_id_dialog_opacity_end'),
    undefined, $r('app.string.card_list_content'),
    Color.White, $r('sys.float.ohos_id_dialog_opacity_end'), undefined, $r('app.media.startIcon'), undefined,
    $r('app.string.widget_more'), Color.White, $r('sys.float.ohos_id_dialog_opacity_end'),
    undefined,
    {
      color: Color.White,
      width: $r('app.float.border_width')
    }, true, undefined, undefined, undefined);

  build() {
    FormLink({
      action: this.actionType,
      abilityName: this.abilityName,
      params: {
        message: this.message
      }
    }) {
      Row() {
        ControlButtonComponent({ controlButtonParameter: this.controlButtonParameter })
      }
      .height(this.fullHeightPercent)
    }
  }
}