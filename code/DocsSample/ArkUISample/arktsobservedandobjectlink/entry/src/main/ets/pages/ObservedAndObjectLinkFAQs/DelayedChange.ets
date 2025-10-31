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
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0001;
const TAG = 'arktsobservedandobjectlink';

// [Start Delayed_change]
@Observed
class RenderClass {
  public waitToRender: boolean = false;

  constructor() {
  }
}

@Entry
@Component
struct DelayedChangeIndex {
  @State @Watch('renderClassChange') renderClass: RenderClass = new RenderClass();
  // [StartExclude Delayed_change]
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  // [EndExclude Delayed_change]
  renderClassChange() {
    // $r('app.string.renderClass_Change')需要替换为开发者所需的资源文件
    hilog.info(DOMAIN, TAG, `${this.context.resourceManager.getStringSync($r('app.string.renderClass_Change').id)}：` +
    this.renderClass.waitToRender);
  }

  onPageShow() {
    setTimeout(() => {
      this.renderClass.waitToRender = true;
    }, 1000);
  }

  build() {
    Row() {
      Column() {
        // $r('app.string.renderClass')需要替换为开发者所需的资源文件
        Text(`${this.context.resourceManager.getStringSync($r('app.string.renderClass').id)}：` +
        this.renderClass.waitToRender)
          .fontSize(20)
      }
      .width('100%')
    }
    .height('100%')
  }
}

// [End Delayed_change]