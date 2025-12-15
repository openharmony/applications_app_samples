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
import { NavNode } from './Index'

@Builder
export function NavTreePageBuilder(_: string, param: NavNode[]) {
  NavTreePage({ nodes: param });
}

@Component
export default struct NavTreePage {
  private pathStack: NavPathStack = new NavPathStack();
  @Prop nodes: NavNode[];

  build() {
    NavDestination() {
      Scroll() {
        Column({ space: 17 }) {
          ForEach(this.nodes, (node: NavNode) => {
            Button(node.label)
              .width('70%')
              .onClick(() => {
                this.pathStack.pushPathByName(node.targetPage!, node.params!);
              })
          })
        }
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height('100%')
    }
    .onReady(context => {
      this.pathStack = context.pathStack;
    })
  }
}