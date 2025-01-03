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

import { AddListItem } from './AddListItem';
import { CompletedRoutableCard } from '../../common/Card';
import { ControlledScrollPositionList } from './ControlledScrollPositionList';
import { CustomListStyle } from './CustomListStyle';
import { DataInList } from './DataInList';
import { DeleteListItem } from './DeleteListItem';
import { GroupedList } from './GroupedList';
import { ListIteration } from './ListIteration';
import { ListLayout } from './ListLayout';
import { ResponsiveScrollPositionList } from './ResponsiveScrollPositionList';
import { Route } from '../../common/Route';
import { StickyHeaderList } from './StickyHeaderList';
import { SwipeListItem } from './SwipeableListItem';
import { TaggedListItems } from './TaggedListItems';
import resource from '../../common/resource';

export const List_ROUTE_PREFIX: string = 'list';

const routes: Route[] = [
  {
    name: `${List_ROUTE_PREFIX}/ListLayout`,
    title: resource.resourceToString($r('app.string.ListLayout_title')),
    description: $r('app.string.ListLayout_description')
  },
  {
    name: `${List_ROUTE_PREFIX}/DataInList`,
    title: resource.resourceToString($r('app.string.DataInList_title')),
    description: $r('app.string.DataInList_description')
  },
  {
    name: `${List_ROUTE_PREFIX}/ListIteration`,
    title: resource.resourceToString($r('app.string.ListIteration_title')),
    description: $r('app.string.ListIteration_description')
  },
  {
    name: `${List_ROUTE_PREFIX}/CustomListStyle`,
    title: resource.resourceToString($r('app.string.CustomListStyle_title')),
    description: $r('app.string.CustomListStyle_description')
  },
  {
    name: `${List_ROUTE_PREFIX}/GroupedList`,
    title: resource.resourceToString($r('app.string.GroupedList_title')),
    description: $r('app.string.GroupedList_description')
  },
  {
    name: `${List_ROUTE_PREFIX}/StickyHeaderList`,
    title: resource.resourceToString($r('app.string.StickyHeaderList_title')),
    description: $r('app.string.StickyHeaderList_description')
  },
  {
    name: `${List_ROUTE_PREFIX}/ControlledScrollPositionList`,
    title: resource.resourceToString($r('app.string.ControlledScrollPositionList_title')),
    description: $r('app.string.ControlledScrollPositionList_description')
  },
  {
    name: `${List_ROUTE_PREFIX}/ResponsiveScrollPositionList`,
    title: resource.resourceToString($r('app.string.ResponsiveScrollPositionList_title')),
    description: $r('app.string.ResponsiveScrollPositionList_description')
  },
  {
    name: `${List_ROUTE_PREFIX}/SwipeListItem`,
    title: resource.resourceToString($r('app.string.SwipeListItem_title')),
    description: $r('app.string.SwipeListItem_description')
  },
  {
    name: `${List_ROUTE_PREFIX}/TaggedListItems`,
    title: resource.resourceToString($r('app.string.TaggedListItems_title')),
    description: $r('app.string.TaggedListItems_description')
  },
  {
    name: `${List_ROUTE_PREFIX}/AddListItem`,
    title: resource.resourceToString($r('app.string.AddListItem_title')),
    description: $r('app.string.AddListItem_description')
  },
  {
    name: `${List_ROUTE_PREFIX}/DeleteListItem`,
    title: resource.resourceToString($r('app.string.DeleteListItem_title')),
    description: $r('app.string.DeleteListItem_description')
  }
];

@Builder
export function listDestination(name: string) {
  if (name === List_ROUTE_PREFIX) {
    ListExample();
  } else if (name === routes[0].name) {
    ListLayout();
  } else if (name === routes[1].name) {
    DataInList();
  } else if (name === routes[2].name) {
    ListIteration();
  } else if (name === routes[3].name) {
    CustomListStyle();
  } else if (name === routes[4].name) {
    GroupedList();
  } else if (name === routes[5].name) {
    StickyHeaderList();
  } else if (name === routes[6].name) {
    ControlledScrollPositionList();
  } else if (name === routes[7].name) {
    ResponsiveScrollPositionList();
  } else if (name === routes[8].name) {
    SwipeListItem();
  } else if (name === routes[9].name) {
    TaggedListItems();
  } else if (name === routes[10].name) {
    AddListItem();
  } else if (name === routes[11].name) {
    DeleteListItem();
  }
}

@Entry
@Component
struct ListExample {
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      List({ space: 12 }) {
        ForEach(routes, (route: Route) => {
          ListItem() {
            CompletedRoutableCard({ title: route.title, description: route.description })
          }
          .width('100%')
          .onClick(() => {
            this.pathStack.pushPath({ name: route.name });
          })
        })
      }
      .contentStartOffset(56)
      .padding({ left: 16, right: 16 })
    }
    .backgroundColor('#f1f3f5')
    .title('List', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}