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

import { CompletedRoutableCard } from '../../common/Card';
import { Route } from '../../common/Route';
import resource from '../../common/resource';
import { router } from '@kit.ArkUI';

export const PROPERTY_STRING_ROUTE_PREFIX: string = 'propertyString';

const routes: Route[] = [
  {
    name: `${PROPERTY_STRING_ROUTE_PREFIX}/CreateApply`,
    title: resource.resourceToString($r('app.string.Create_Apply_StyledString_MutableStyledString_title')),
    description: $r('app.string.Create_Apply_StyledString_MutableStyledString_desc')
  },
  {
    name: `${PROPERTY_STRING_ROUTE_PREFIX}/StyledStringStyle`,
    title: resource.resourceToString($r('app.string.StyledStringStyle_title')),
    description: $r('app.string.StyledStringStyle_description')
  },
  {
    name: `${PROPERTY_STRING_ROUTE_PREFIX}/StyledStringParagraphStyle`,
    title: resource.resourceToString($r('app.string.StyledStringParagraphStyle_title')),
    description: $r('app.string.StyledStringParagraphStyle_description')
  },
  {
    name: `${PROPERTY_STRING_ROUTE_PREFIX}/StyledStringImageAttachment`,
    title: resource.resourceToString($r('app.string.StyledStringImageAttachment_title')),
    description: $r('app.string.StyledStringImageAttachment_description')
  },
  {
    name: `${PROPERTY_STRING_ROUTE_PREFIX}/StyledStringGestureStyle`,
    title: resource.resourceToString($r('app.string.TStyledStringGestureStyle_title')),
    description: $r('app.string.StyledStringGestureStyle_description')
  },
  {
    name: `${PROPERTY_STRING_ROUTE_PREFIX}/StyledStringHtml`,
    title: resource.resourceToString($r('app.string.StyledStringHtml_title')),
    description: $r('app.string.StyledStringHtml_description')
  },
  {
    name: `${PROPERTY_STRING_ROUTE_PREFIX}/StyledStringSceneExample`,
    title: resource.resourceToString($r('app.string.StyledStringSceneExample_title')),
    description: $r('app.string.StyledStringSceneExample_description')
  }
];

@Builder
export function PropertyStringDestination(name: string) {
  if (name === PROPERTY_STRING_ROUTE_PREFIX) {
    PropertyStringExample();
  }
}

@Entry
@Component
struct PropertyStringExample {
  goToSample(url: string): void {
    router.pushUrl({
      url: url,
    }, router.RouterMode.Single, (err) => {
      if (err) {
        console.error(`pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      console.info('pushUrl success');
    })
  }

  build() {
    NavDestination() {
      List({ space: 12 }) {
        ForEach(routes, (route: Route) => {
          ListItem() {
            CompletedRoutableCard({ title: route.title, description: route.description })
          }
          .width('100%')
          .onClick(() => {
            this.goToSample('pages/' + route.name);
          })
        })
      }
      .contentStartOffset(56)
      .padding({ left: 16, right: 16 })
    }
    .backgroundColor('#f1f3f5')
    .title('propertyString', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}