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

import { CommonItemSlider, CommonItemSelect,CommonItemColorSelect,CommonSwitcher} from '../../../../common/AttributeModificationTool';
import { getStringArrayData } from '../../../../data/ResourceDataHandle';
import {OBJECT_FIT_SELECT,CURRENT_RATE} from'../../../components/ComponentData';

@Component
export struct AutoPlaySwitchPanel {
  @Link AutoPlay:boolean ;
  @Link controlsShow:boolean;
  @Link muted:boolean;
  @Link loop:boolean;
  build() {
    Column() {
      CommonSwitcher({name:$r('app.string.video_auto_play'),bool:$AutoPlay,testId: 'video_switch_001'})
      CommonSwitcher({name:$r('app.string.video_controls_show'),bool:$controlsShow,testId: 'video_switch_002'})
      CommonSwitcher({name:$r('app.string.video_muted_show'),bool:$muted,testId: 'video_switch_003'})
      CommonSwitcher({name:$r('app.string.video_loop_show'),bool:$loop,testId: 'video_switch_004'})
    }
  }
}
@Component
export struct VideoFitControlPanel {
  @Link VideoObjectFit: ImageFit;

  build() {
    Column() {
      CommonItemSelect({
        name: $r('app.string.video_fit_change'),
        selects: getStringArrayData(OBJECT_FIT_SELECT),
        callback: (index) => {
          switch (index) {
            case 1:
              this.VideoObjectFit = ImageFit.None;
              break;
            case 2:
              this.VideoObjectFit = ImageFit.Cover;
              break;
            case 3:
              this.VideoObjectFit = ImageFit.Contain;
              break;
            case 4:
              this.VideoObjectFit = ImageFit.Fill;
              break;
            case 5:
              this.VideoObjectFit = ImageFit.ScaleDown;
            default:
              this.VideoObjectFit = ImageFit.Auto;
          }
        },testId: 'video_select_001'
      })
    }
  }
}@Component
export struct CurrentRateControlPanel {
  @Link currentRate: number;

  build() {
    Column() {
      CommonItemSelect({
        name: $r('app.string.video_current_rate_change'),
        selects: CURRENT_RATE,
        callback: (index) => {
          switch (index) {
            case 1:
              this.currentRate = 1;
              break;
            case 2:
              this.currentRate = 1.25;
              break;
            case 3:
              this.currentRate = 1.75;
              break;
            case 4:
              this.currentRate = 2;
              break;
            default:
              this.currentRate = 0.75;
          }
        },testId: 'video_select_002'
      })
    }
  }
}