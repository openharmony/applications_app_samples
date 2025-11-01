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

// [Start bind_menu_demo]
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0xF811;
const TAG = '[Sample_Animation]';

class BMD {
  public value: ResourceStr = '';
  public action: () => void = () => {
  };
}

@Entry
@Component
struct BindMenuDemo {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  // 第一步: 定义一组数据用来表示菜单按钮项
  @State items: BMD[] = [
    {
      value: this.context.resourceManager.getStringByNameSync('modal_transition_text23'),
      action: () => {
        hilog.info(DOMAIN, TAG, 'handle Menu1 select');
      }
    },
    {
      value: this.context.resourceManager.getStringByNameSync('modal_transition_text24'),
      action: () => {
        hilog.info(DOMAIN, TAG, 'handle Menu2 select');
      }
    },
  ]

  build() {
    Column() {
      Button('click')
        .backgroundColor(0x409eff)
        .borderRadius(5)
        // 第二步: 通过bindMenu接口将菜单数据绑定给元素
        .bindMenu(this.items)
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(437)
  }
}

// [End bind_menu_demo]