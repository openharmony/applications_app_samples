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

import { CommonItemSelect } from '../../../../common/AttributeModificationTool';
import { getStringArrayData } from '../../../../data/ResourceDataHandle';
import { STACK_ARGUMENTS_SELECT_DATA, STACK_ZIND_SELECT_DATA } from '../../ComponentData';

@Component
export struct ZIndexControlPanel{
  @Link  zindex: number;
  build(){
    Column(){
      CommonItemSelect({
        name:$r('app.string.stack_zindex'),
        selects : getStringArrayData(STACK_ZIND_SELECT_DATA),
        callback : (index)=>{
          switch (index) {
            case 1:
              this.zindex = 1;
              break;
            default:
              this.zindex = 4
              break;
          }
        },
        testId:`stack_002`
      })
    }
  }
}

@Component
export struct ArgumentsControlPanel {
  @Link alignContent : Alignment;

  build() {
    Column() {
      CommonItemSelect({
        name:$r('app.string.stack_alignment'),
        selects:getStringArrayData(STACK_ARGUMENTS_SELECT_DATA),
        callback: (index)=>{
          switch (index) {
            case 1:
              this.alignContent = Alignment.Top;
              break;
            case 2:
              this.alignContent = Alignment.TopEnd;
              break;
            case 3:
              this.alignContent = Alignment.Start;
              break;
            case 4:
              this.alignContent = Alignment.Center;
              break;
            case 5:
              this.alignContent = Alignment.End;
              break;
            case 6:
              this.alignContent = Alignment.BottomStart;
              break;
            case 7:
              this.alignContent = Alignment.Bottom;
              break;
            case 8:
              this.alignContent = Alignment.BottomEnd;
              break;
            default:
              this.alignContent = Alignment.TopStart;
              break;
          }
        },
        testId:`stack_001`
      })
    }
  }
}
