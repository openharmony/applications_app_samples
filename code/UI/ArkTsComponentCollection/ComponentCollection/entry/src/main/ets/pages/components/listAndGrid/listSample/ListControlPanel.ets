/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import { CommonItemTwoRowSlider, CommonItemSelect, CommonItemColorSelect, CommonSwitcher, CommonItemColorSelectDef } from '../../../../common/AttributeModificationTool';
import { getStringArrayData } from '../../../../data/ResourceDataHandle';
import { LIST_DIRECTION_SELECT_DATA, LIST_SCROLLBAR_SELECT_DATA,LIST_EDGE_EFFECT_SELECT_DATA, LIST_ALIGN_LIST_ITEM_SELECT_DATA } from '../../ComponentData';

@Component
export struct ArgumentsSpaceControlPanel {
  @Link space : number;
  build() {
    Column() {
      CommonItemTwoRowSlider({
        changeValue: $space,
        min: 0,
        max: 30,
        name: $r('app.string.list_argument_space'),
        testId: `list_001`
      })
    }
  }
}

@Component
export struct ArgumentsInitIndexControlPanel {
  @Link initIndex : number;
  build() {
    Column() {
      CommonItemSelect({
        name: $r('app.string.list_properties_initial_index'),
        selects : ['0','1','2','3','4','5','6','7','8','9'],
        callback : (index,value)=>{
          this.initIndex = Number.parseInt(value);
          AppStorage.setOrCreate('listSampleInitIndex', Number.parseInt(value));
        },
        testId: `list_002`
      })
    }
  }
}

@Component
export struct PropertiesListDirectionControlPanel {
  @Link listDirection : Axis;

  build(){
    Column(){
      CommonItemSelect({
        name: $r('app.string.list_properties_direction'),
        selects : getStringArrayData(LIST_DIRECTION_SELECT_DATA),
        callback : (index)=>{
          switch (index) {
            case 1:
              this.listDirection = Axis.Horizontal;
              break;
            default:
              this.listDirection = Axis.Vertical;
              break;
          }
        },
        testId: `list_003`
      })
    }
  }
}


@Component
export struct PropertiesStrokeWidthControlPanel {
  @Link strokeWidth : number;

  build(){
    Column(){
      CommonItemTwoRowSlider({
        changeValue: $strokeWidth,
        min: 0,
        max: 15,
        name: $r('app.string.list_properties_divider_stroke_width'),
        testId: `list_004`
      })
    }
  }
}

@Component
export struct PropertiesLineColorControlPanel {
  @Link lineColor : Resource;

  build(){
    Column(){
      CommonItemColorSelect({
        name: $r('app.string.list_properties_divider_color'),
        selectColor: $lineColor,
        testId: 'list_005',
      })
    }
  }
}

@Component
export struct PropertiesBarStateControlPanel {
  @Link barState : BarState;

  build(){
    Column(){
      CommonItemSelect({
        name: $r('app.string.list_properties_scroll_bar'),
        selects : getStringArrayData(LIST_SCROLLBAR_SELECT_DATA),
        callback : (index)=>{
          switch (index) {
            case 1:
              this.barState = BarState.On
              break;
            case 2:
              this.barState = BarState.Auto
              break;
            default:
              this.barState = BarState.Off
              break;
          }
        },
        testId: `list_006`
      })

    }
  }
}


@Component
export struct PropertiesScrollBarColorControlPanel {
  @Link scrollBarColor: Color;

  build(){
    Column(){
      CommonItemColorSelectDef({
        name: $r('app.string.list_properties_scroll_bar_color'),
        selectColor: $scrollBarColor,
        testId: 'list_013',
      })
    }
  }
}



@Component
export struct PropertiesScrollBarWidthControlPanel {
  @Link scrollBarWidth: number;

  build(){
    Column(){
      CommonItemTwoRowSlider({
        changeValue: $scrollBarWidth,
        min: 0,
        max: 15,
        name: $r('app.string.list_properties_scroll_bar_width'),
        testId: `list_012`
      })
    }
  }
}



@Component
export struct PropertiesEdgeEffectControlPanel {
  @Link edgeEffect : EdgeEffect;

  build(){
    Column(){
      CommonItemSelect({
        name: $r('app.string.list_properties_edge_effect'),
        selects : getStringArrayData(LIST_EDGE_EFFECT_SELECT_DATA),
        callback : (index)=>{
          switch (index) {
            case 0:
              this.edgeEffect = EdgeEffect.Spring;
              break;
            case 1:
              this.edgeEffect = EdgeEffect.Fade;
              break;
            default:
              this.edgeEffect = EdgeEffect.None;
              break;
          }
        },
        testId: `list_007`
      })
    }
  }
}


@Component
export struct PropertiesChainAnimationControlPanel {
  @Link isChainAnimation : boolean;

  build(){
    Column(){
      CommonSwitcher({
        name: $r('app.string.list_properties_chain_animation'),
        bool : $isChainAnimation,
        testID: `list_008`
      })
    }
  }
}

@Component
export struct PropertiesMultiControlPanel {
  @Link multiSelectable : boolean;

  build(){
    Column(){
      CommonSwitcher({
        name: $r('app.string.list_properties_multi_selectable'),
        bool : $multiSelectable,
        testID: `list_009`
      })
    }
  }
}

@Component
export struct PropertiesLanesControlPanel {
  @Link lanes : number;

  build(){
    Column(){

      CommonItemSelect({
        name: $r('app.string.list_properties_lanes'),
        selects : ['0','1','2','3','4','5','6','7','8','9'],
        callback : (index,value)=>{
          this.lanes = Number.parseInt(value);
        },
        testId: `list_010`
      })
    }
  }
}

@Component
export struct PropertiesAlignListItemControlPanel {
  @Link alignListItem : ListItemAlign;

  build(){
    Column(){
      CommonItemSelect({
        name: $r('app.string.list_properties_align_list_item'),
        selects : getStringArrayData(LIST_ALIGN_LIST_ITEM_SELECT_DATA),
        callback : (index,value)=>{
          switch (index) {
            case 1:
              this.alignListItem = ListItemAlign.Center;
              break;
            case 2:
              this.alignListItem = ListItemAlign.End;
              break;
            default:
              this.alignListItem = ListItemAlign.Start;
              break;
          }
        },
        testId: `list_011`
      })

    }
  }
}