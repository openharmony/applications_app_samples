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
import { InternalObservedV2TraceV1pag1 } from './Internal@ObservedV2@TraceV1/pages/Page1';
import { InternalObservedV2TraceV1pag2 } from './Internal@ObservedV2@TraceV1/pages/Page2';
import { InternalObservedV2TraceV2pag1 } from './Internal@ObservedV2@TraceV2/Page1';
import { InternalObservedV2TraceV2pag2 } from './Internal@ObservedV2@TraceV2/Page2';
import { InternalTracesetOrCreateV1pag1 } from './Internal@TracesetOrCreateV1/Page1';
import { InternalTracesetOrCreateV1pag2 } from './Internal@TracesetOrCreateV1/Page2';
import { InternalTraceCustomizeParam } from './InternalTraceCustomize/storage';
import { InternalTraceCustomizeV1 } from './InternalTraceCustomize/InternalTraceCustomizeV1';
import { LocalStorageMultiInstance } from './LocalStorageMultiInstance/Index';
import { InternalAppStorageV1one } from './InternalAppStorageV1one';
import { InternalAppStorageV1two } from './InternalAppStorageV1two';
import { InternalAppStorageV2one } from './InternalAppStorageV2one';
import { InternalAppStorageV2two } from './InternalAppStorageV2two';
import { InternalStoragePropV1one } from './InternalStoragePropV1one';
import { InternalStoragePropV1two } from './InternalStoragePropV1two';
import { InternalStoragePropV2one } from './InternalStoragePropV2one';
import { InternalStoragePropV2two } from './InternalStoragePropV2two';
import { InternalEnvironmentV1 } from './InternalEnvironmentV1';
import { InternalEnvironmentV2 } from './InternalEnvironmentV2/Index';
import { InternalPersistentStorageV1 } from './InternalPersistentStorageV1';
import { InternalPersistentStorageV2 } from './InternalPersistentStorageV2';
import { InternalGradualMigration } from './InternalGradualMigration';
import { InternalOtherMigrationsListV1 } from './InternalOtherMigrationsListV1';
import { InternalOtherMigrationsListV2 } from './InternalOtherMigrationsListV2';
import { InternalOtherMigrationsWaterFlowV1 } from './InternalOtherMigrationsWaterFlowV1';
import { InternalOtherMigrationsWaterFlowV2 } from './InternalOtherMigrationsWaterFlowV2';
import { InternalattributeModifierV1 } from './InternalattributeModifierV1';
import { InternalattributeModifierV2 } from './InternalattributeModifierV2';
import { InternalCommonModifierV1 } from './InternalCommonModifierV1';
import { InternalCommonModifierV2 } from './InternalCommonModifierV2';
import { InternalModuleModifierV2 } from './InternalModuleModifierV2';
import { InternalModuleModifierV1 } from './InternalModuleModifierV1';
import { InternalAttributeUpdaterV1 } from './InternalAttributeUpdaterV1';
import { InternalAttributeUpdaterV2 } from './InternalAttributeUpdaterV2';

export const INTERNAL_MIGRATE: string = 'internal_migrate';

const routes: Route[] = [
  {
    name: `${INTERNAL_MIGRATE}/Internal@ObservedV2@TraceV1/pages/Page1`,
    title: resource.resourceToString($r('app.string.Internal_ObservedV2_Trace_V1_pag1')),
  },
  {
    name: `${INTERNAL_MIGRATE}/Internal@ObservedV2@TraceV1/pages/Page2`,
    title: resource.resourceToString($r('app.string.Internal_ObservedV2_Trace_V1_pag2')),
  },
  {
    name: `${INTERNAL_MIGRATE}/Internal@ObservedV2@TraceV2/Page1`,
    title: resource.resourceToString($r('app.string.Internal_ObservedV2_Trace_V2_pag1')),
  },
  {
    name: `${INTERNAL_MIGRATE}/Internal@ObservedV2@TraceV2/Page2`,
    title: resource.resourceToString($r('app.string.Internal_ObservedV2_Trace_V2_pag2')),
  },
  {
    name: `${INTERNAL_MIGRATE}/Internal@TracesetOrCreateV1/Page1`,
    title: resource.resourceToString($r('app.string.Internal_Trace_setOrCreate_V1_pag1')),
  },
  {
    name: `${INTERNAL_MIGRATE}/Internal@TracesetOrCreateV1/Page2`,
    title: resource.resourceToString($r('app.string.Internal_Trace_setOrCreate_V1_pag2')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalTraceCustomize/storage`,
    title: resource.resourceToString($r('app.string.Internal_Trace_customize_Param')),
  },
  {
    name: `${INTERNAL_MIGRATE}/LocalStorageMultiInstance/Index`,
    title: resource.resourceToString($r('app.string.Internal_Trace_multiInstance_V2')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalAppStorageV1one`,
    title: resource.resourceToString($r('app.string.Internal_AppStorage_V1_one')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalAppStorageV2one`,
    title: resource.resourceToString($r('app.string.Internal_AppStorage_V1_two')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalAppStorageV2one`,
    title: resource.resourceToString($r('app.string.Internal_AppStorage_V2_one')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalAppStorageV2two`,
    title: resource.resourceToString($r('app.string.Internal_AppStorage_V2_two')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalStoragePropV1one`,
    title: resource.resourceToString($r('app.string.Internal_StorageProp_V1_one')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalStoragePropV1two`,
    title: resource.resourceToString($r('app.string.Internal_StorageProp_V1_two')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalStoragePropV2one`,
    title: resource.resourceToString($r('app.string.Internal_StorageProp_V2_one')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalStoragePropV2two`,
    title: resource.resourceToString($r('app.string.Internal_StorageProp_V2_two')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalEnvironmentV1`,
    title: resource.resourceToString($r('app.string.Internal_Environment_V1')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalEnvironmentV2/Index`,
    title: resource.resourceToString($r('app.string.Internal_Environment_V2')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalPersistentStorageV1`,
    title: resource.resourceToString($r('app.string.Internal_Persistent_Storage_V1')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalPersistentStorageV2`,
    title: resource.resourceToString($r('app.string.Internal_Persistent_Storage_V2')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalGradualMigration`,
    title: resource.resourceToString($r('app.string.Internal_Gradual_Migration')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalOtherMigrationsListV1`,
    title: resource.resourceToString($r('app.string.Internal_Other_Migrations_List_V1')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalOtherMigrationsListV2`,
    title: resource.resourceToString($r('app.string.Internal_Other_Migrations_List_V2')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalOtherMigrationsWaterFlowV1`,
    title: resource.resourceToString($r('app.string.Internal_Other_Migrations_WaterFlow_V1')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalOtherMigrationsWaterFlowV2`,
    title: resource.resourceToString($r('app.string.Internal_Other_Migrations_WaterFlow_V2')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalattributeModifierV1`,
    title: resource.resourceToString($r('app.string.Internal_attribute_Modifier_V1')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalattributeModifierV2`,
    title: resource.resourceToString($r('app.string.Internal_attribute_Modifier_V2')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalCommonModifierV1`,
    title: resource.resourceToString($r('app.string.Internal_Common_Modifier_V1')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalCommonModifierV2`,
    title: resource.resourceToString($r('app.string.Internal_Common_Modifier_V2')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalModuleModifierV1`,
    title: resource.resourceToString($r('app.string.Internal_Module_Modifier_V1')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalModuleModifierV2`,
    title: resource.resourceToString($r('app.string.Internal_Module_Modifier_V2')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalAttributeUpdaterV1`,
    title: resource.resourceToString($r('app.string.Internal_Attribute_Updater_V1')),
  },
  {
    name: `${INTERNAL_MIGRATE}/InternalAttributeUpdaterV2`,
    title: resource.resourceToString($r('app.string.Internal_Attribute_Updater_V2')),
  },
];

@Builder
export function internalTraceDestination(name: string) {
  if (name === INTERNAL_MIGRATE) {
    InternalTraceV1();
  } else if (name === `${INTERNAL_MIGRATE}/Internal@ObservedV2@TraceV1/pages/Page1`) {
    InternalObservedV2TraceV1pag1()
  } else if (name === `${INTERNAL_MIGRATE}/Internal@ObservedV2@TraceV1/pages/Page2`) {
    InternalObservedV2TraceV1pag2()
  } else if (name === `${INTERNAL_MIGRATE}/Internal@ObservedV2@TraceV2/Page1`) {
    InternalObservedV2TraceV2pag1()
  } else if (name === `${INTERNAL_MIGRATE}/Internal@ObservedV2@TraceV2/Page2`) {
    InternalObservedV2TraceV2pag2()
  } else if (name === `${INTERNAL_MIGRATE}/Internal@TracesetOrCreateV1/Page1`) {
    InternalTracesetOrCreateV1pag1()
  } else if (name === `${INTERNAL_MIGRATE}/Internal@TracesetOrCreateV1/Page2`) {
    InternalTracesetOrCreateV1pag2()
  } else if (name === `${INTERNAL_MIGRATE}/InternalTraceCustomize/InternalTraceCustomizeV1`) {
    InternalTraceCustomizeV1()
  } else if (name === `${INTERNAL_MIGRATE}/LocalStorageMultiInstance/Index`) {
    LocalStorageMultiInstance()
  } else if (name === `${INTERNAL_MIGRATE}/InternalTraceCustomize/storage`) {
    InternalTraceCustomizeParam()
  } else if (name === `${INTERNAL_MIGRATE}/InternalAppStorageV1one`) {
    InternalAppStorageV1one()
  } else if (name === `${INTERNAL_MIGRATE}/InternalAppStorageV1two`) {
    InternalAppStorageV1two()
  } else if (name === `${INTERNAL_MIGRATE}/InternalAppStorageV2one`) {
    InternalAppStorageV2one()
  } else if (name === `${INTERNAL_MIGRATE}/InternalAppStorageV2two`) {
    InternalAppStorageV2two()
  } else if (name === `${INTERNAL_MIGRATE}/InternalStoragePropV1one`) {
    InternalStoragePropV1one()
  } else if (name === `${INTERNAL_MIGRATE}/InternalStoragePropV1two`) {
    InternalStoragePropV1two()
  } else if (name === `${INTERNAL_MIGRATE}/InternalStoragePropV2one`) {
    InternalStoragePropV2one()
  } else if (name === `${INTERNAL_MIGRATE}/InternalStoragePropV2two`) {
    InternalStoragePropV2two()
  } else if (name === `${INTERNAL_MIGRATE}/InternalEnvironmentV1`) {
    InternalEnvironmentV1()
  } else if (name === `${INTERNAL_MIGRATE}/InternalEnvironmentV2/Index`) {
    InternalEnvironmentV2()
  } else if (name === `${INTERNAL_MIGRATE}/InternalPersistentStorageV1`) {
    InternalPersistentStorageV1()
  } else if (name === `${INTERNAL_MIGRATE}/InternalPersistentStorageV2`) {
    InternalPersistentStorageV2()
  } else if (name === `${INTERNAL_MIGRATE}/InternalGradualMigration`) {
    InternalGradualMigration()
  } else if (name === `${INTERNAL_MIGRATE}/InternalOtherMigrationsListV1`) {
    InternalOtherMigrationsListV1()
  } else if (name === `${INTERNAL_MIGRATE}/InternalOtherMigrationsListV2`) {
    InternalOtherMigrationsListV2()
  } else if (name === `${INTERNAL_MIGRATE}/InternalOtherMigrationsWaterFlowV1`) {
    InternalOtherMigrationsWaterFlowV1()
  } else if (name === `${INTERNAL_MIGRATE}/InternalOtherMigrationsWaterFlowV2`) {
    InternalOtherMigrationsWaterFlowV2()
  } else if (name === `${INTERNAL_MIGRATE}/InternalattributeModifierV1`) {
    InternalattributeModifierV1()
  } else if (name === `${INTERNAL_MIGRATE}/InternalattributeModifierV2`) {
    InternalattributeModifierV2()
  } else if (name === `${INTERNAL_MIGRATE}/InternalCommonModifierV1`) {
    InternalCommonModifierV1()
  } else if (name === `${INTERNAL_MIGRATE}/InternalCommonModifierV2`) {
    InternalCommonModifierV2()
  } else if (name === `${INTERNAL_MIGRATE}/InternalModuleModifierV1`) {
    InternalModuleModifierV1()
  } else if (name === `${INTERNAL_MIGRATE}/InternalModuleModifierV2`) {
    InternalModuleModifierV2()
  } else if (name === `${INTERNAL_MIGRATE}/InternalAttributeUpdaterV1`) {
    InternalAttributeUpdaterV1()
  } else if (name === `${INTERNAL_MIGRATE}/InternalAttributeUpdaterV2`) {
    InternalAttributeUpdaterV2()
  }
}

@Entry
@Component
struct InternalTraceV1 {
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
    .title($r('app.string.internal_trace'), {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
  }
}