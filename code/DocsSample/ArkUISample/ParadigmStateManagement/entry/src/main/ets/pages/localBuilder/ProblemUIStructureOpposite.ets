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
// [Start problem_ui_structure_opposite]
@Entry
@Component
struct Pant {
  @State message: string[] = ['1', '2', '3'];

  build() {
    List() {
      ListItemGroup({ space: 10, footer: this.itemFoot() }) {
        ForEach(this.message, (item: string, index: number) => {
          ListItem() {
            Stack() {
              Text(item)
                .fontSize(30)
            }
          }
        })
      }
    }
  }

  @LocalBuilder
  itemFoot() {
    Column() {
      Text('itemFoot')
        .fontSize(30)
    }
  }
}
// [End problem_ui_structure_opposite]

@Component
export struct ProblemUIStructureOpposite {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Pant()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.problem_ui_not_refresh_opposite'))
  }
}