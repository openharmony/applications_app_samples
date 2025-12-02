/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
@Builder
export function PageTwoNavDesBuilder() {
  PageTwoNavDes();
}

@Component
struct PageTwoNavDes {
  stack: NavPathStack = AppStorage.get<NavPathStack>('basicNavigationStack')!;

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        Button('pop-push normal')
          .onClick(() => {
            // [Start PopAndPush-Normal]
            this.stack.pop();
            this.stack.pushPath({ name: 'animation-BasicNavDestination' });
            // [End PopAndPush-Normal]
          })

        Button('pop-push NEW_INSTANCE')
          .onClick(() => {
            // [Start PopAndPush-NEW_INSTANCE]
            this.stack.pop();
            this.stack.pushPath({ name: 'animation-BasicNavDestination' }, { launchMode: LaunchMode.NEW_INSTANCE });
            // [End PopAndPush-NEW_INSTANCE]
          })
      }
    }
    .title('PageTwoNavDes')
  }
}