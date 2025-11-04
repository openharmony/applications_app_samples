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
import resource from '../../common/Resource';
import { MigrationClassAttributeV1 } from './MigrationClassAttributeV1';
import { MigrationClassAttributeV2 } from './MigrationClassAttributeV2';
import { MigrationNestedObjectPropertiesV1 } from './MigrationNestedObjectPropertiesV1';
import { MigrationNestedObjectPropertiesV2 } from './MigrationNestedObjectPropertiesV2';

export const MIGRATION_DATA: string = 'migration_data';

const routes: Route[] = [
  {
    name: `${MIGRATION_DATA}/MigrationNestedObjectProperties`,
    title: resource.resourceToString($r('app.string.migration_nested_object_properties')),
  },
  {
    name: `${MIGRATION_DATA}/MigrationNestedObjectPropertiesV2`,
    title: resource.resourceToString($r('app.string.migration_nested_object_properties_v2')),
  },
  {
    name: `${MIGRATION_DATA}/MigrationClassAttributeV1`,
    title: resource.resourceToString($r('app.string.migration_class_attribute_v1')),
  },
  {
    name: `${MIGRATION_DATA}/MigrationClassAttributeV2`,
    title: resource.resourceToString($r('app.string.migration_class_attribute_v2')),
  },
];

@Builder
export function MigrationDestination(name: string) {
  if (name === MIGRATION_DATA) {
    migrationExample();
  } else if (name === `${MIGRATION_DATA}/MigrationNestedObjectProperties`) {
    MigrationNestedObjectPropertiesV1();
  } else if (name === `${MIGRATION_DATA}/MigrationNestedObjectPropertiesV2`) {
    MigrationNestedObjectPropertiesV2();
  } else if (name === `${MIGRATION_DATA}/MigrationClassAttributeV1`) {
    MigrationClassAttributeV1();
  } else if (name === `${MIGRATION_DATA}/MigrationClassAttributeV2`) {
    MigrationClassAttributeV2();
  }
}

@Entry
@Component
struct migrationExample {
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
      .width('100%')
      .height('100%')
      .contentStartOffset(56)
      .padding({ left: 16, right: 16 })
    }
    .backgroundColor($r('sys.color.comp_background_focus'))
    .title($r('app.string.migration_data_object_variables'), {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}