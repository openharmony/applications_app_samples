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

import { HMDefaultGlobalAnimator, HMNavigation, HMRouterMgr } from '@hadss/hmrouter';
import { AttributeUpdater } from '@kit.ArkUI';
import { JumpInfoInterceptor } from '../hmrouter/JumpInfoInterceptor';
import { PageDurationLifecycle } from '../hmrouter/PageDurationLifecycle';

class MyNavModifier extends AttributeUpdater<NavigationAttribute> {
  initializeModifier(instance: NavigationAttribute): void {
    instance.hideNavBar(true);
  }
}

const TAG = 'HomeIndex';

@Entry
@Component
struct HomeIndex {
  modifier: MyNavModifier = new MyNavModifier();

  aboutToAppear(): void {
    HMRouterMgr.registerGlobalInterceptor({
      interceptor: new JumpInfoInterceptor(),
      interceptorName: 'JumpInfo',
      priority: 5
    });

    HMRouterMgr.registerGlobalLifecycle({
      lifecycle: new PageDurationLifecycle(),
      lifecycleName: 'PageDuration',
      priority: 5
    });
  }

  build() {
    Column() {
      HMNavigation({
        navigationId: 'mainNavigationId', homePageUrl: 'CategoryPage', options: {
          standardAnimator: HMDefaultGlobalAnimator.STANDARD_ANIMATOR,
          modifier: this.modifier
        }
      });
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.page_background'));
  }
}