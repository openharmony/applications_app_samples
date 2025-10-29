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
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

class TmpClass {
  count: number = 10;
};

@Builder
export function PageOneBuilder(name: string, param: Object) {
  PageOne();
}
const DOMAIN = 0x0000;
@Component
export struct PageOne {
  pageStack: NavPathStack = new NavPathStack();
  @State message: string = 'Hello World';
  scroller: Scroller = new Scroller();
  onPageShow(): void {
    this.message = JSON.stringify(this.pageStack);
  }
  build() {
    Stack({ alignContent: Alignment.TopStart }) {
    NavDestination() {
        Scroll(this.scroller){
          Column() {
            Button('pushPathByName', { stateEffect: true, type: ButtonType.Capsule })
              .width('80%')
              .height(40)
              .onClick(() => {
                // [Start PushPathByNameParam]
                this.pageStack.pushPathByName('pageTwo', 'PageOne Param');
                // [End PushPathByNameParam]
              })
            Button('pushDestination', { stateEffect: true, type: ButtonType.Capsule })
              .width('80%')
              .height(40)
              .margin(10)
              .onClick(() => {
                // [Start PushDestination]
                this.pageStack.pushDestination({
                  name: 'pageTwo', param: 'PageOne Param'}).catch((error: BusinessError) => {
                  hilog.info(DOMAIN, 'testTag', '[pushDestination]failed', 'error code = ', error.code,
                    'error.message = ', error.message);
                }).then(() => {
                  hilog.info(DOMAIN, 'testTag', '[pushDestination]success.');
                });
                // [End PushDestination]
              })
            Button('pushDestinationByName', { stateEffect: true, type: ButtonType.Capsule })
              .width('80%')
              .height(40)
              .onClick(() => {
                // [Start PushDestinationByName]
                this.pageStack.pushDestinationByName('pageTwo', 'PageOne Param').catch((error: BusinessError) => {
                  hilog.info(DOMAIN, 'testTag', '[pushDestinationByName]failed', 'error code = ', error.code,
                    'error.message = ', error.message);
                }).then(() => {
                  hilog.info(DOMAIN, 'testTag', '[pushDestinationByName]success.');
                });
                // [End PushDestinationByName]
              })

            Button('moveToTop', { stateEffect: true, type: ButtonType.Capsule })
              .width('80%')
              .height(40)
              .margin(10)
              .onClick(() => {
                // [Start moveToTop]
                // 移动栈中name为pageTwo的页面到栈顶
                this.pageStack.moveToTop('pageTwo');
                // [End moveToTop]
                this.message = 'moveToTop' + JSON.stringify(this.pageStack);
                hilog.info(DOMAIN, 'testTag', 'moveToTop', JSON.stringify(this.pageStack), 'Return value',
                  JSON.stringify(this.pageStack.moveToTop('pageTwo')));
              })

            Button('moveIndexToTop', { stateEffect: true, type: ButtonType.Capsule })
              .width('80%')
              .height(40)
              .onClick(() => {
                // [Start moveIndexToTop]
                // 移动栈中索引为1的页面到栈顶
                this.pageStack.moveIndexToTop(1);
                // [End moveIndexToTop]
                this.message = 'moveIndexToTop' + JSON.stringify(this.pageStack);
                hilog.info(DOMAIN, 'testTag', 'moveIndexToTop', JSON.stringify(this.pageStack));
              })

            Button('removeByName', { stateEffect: true, type: ButtonType.Capsule })
              .width('80%')
              .height(40)
              .margin(10)
              .onClick(() => {
                // [Start removeByName]
                // 删除栈中name为pageTwo的所有页面
                this.pageStack.removeByName('pageTwo');
                // [End removeByName]
                this.message = 'removeByName' + JSON.stringify(this.pageStack);
                hilog.info(DOMAIN, 'testTag', 'removeByName', JSON.stringify(this.pageStack));
              })

            Button('replacePathByName', { stateEffect: true, type: ButtonType.Capsule })
              .width('80%')
              .height(40)
              .onClick(() => {
                // [Start replacePathByName]
                this.pageStack.replacePathByName('pageTwo', 'PageOne Param');
                // [End replacePathByName]
                this.message = 'replacePathByName' + JSON.stringify(this.pageStack);
                hilog.info(DOMAIN, 'testTag', 'replacePathByName', JSON.stringify(this.pageStack));
              })

            Button('replacePath', { stateEffect: true, type: ButtonType.Capsule })
              .width('80%')
              .height(40)
              .margin(10)
              .onClick(() => {
                // [Start replacePath]
                // 将栈顶页面替换为pageTwo
                this.pageStack.replacePath({ name: 'pageTwo', param: 'PageOne Param' });
                // [End replacePath]
                this.message = 'replacePath' + JSON.stringify(this.pageStack);
                hilog.info(DOMAIN, 'testTag', 'replacePath', JSON.stringify(this.pageStack));
              })

            Button('replaceDestination', { stateEffect: true, type: ButtonType.Capsule })
              .width('80%')
              .height(40)
              .onClick(() => {
                // [Start replaceDestination]
                // 带错误码的替换，跳转结束会触发异步回调，返回错误码信息
                this.pageStack.replaceDestination({ name: 'pageTwo', param: 'PageOne Param' })
                  .catch((error: BusinessError) => {
                    hilog.info(DOMAIN, 'testTag', '[replaceDestination]failed', 'error code = ', error.code,
                      'error.message = ', error.message);
                  }).then(() => {
                  hilog.info(DOMAIN, 'testTag', '[replaceDestination]success.');
                })
                // [End replaceDestination]
              })

            Button('removeByIndexes', { stateEffect: true, type: ButtonType.Capsule })
              .width('80%')
              .height(40)
              .margin(10)
              .onClick(() => {
                // [Start removeByIndexes]
                // 删除指定索引的页面
                this.pageStack.removeByIndexes([1]);
                // [End removeByIndexes]
                this.message = 'removeByIndexes' + JSON.stringify(this.pageStack);
                hilog.info(DOMAIN, 'testTag', 'removeByIndexes', JSON.stringify(this.pageStack));
              })

            Button('removeByNavDestinationId', { stateEffect: true, type: ButtonType.Capsule })
              .width('80%')
              .height(40)
              .onClick(() => {
                // [Start removeByNavDestinationId]
                // 删除指定id的页面
                this.pageStack.removeByNavDestinationId('1');
                // [End removeByNavDestinationId]
                this.message = 'removeByNavDestinationId' + JSON.stringify(this.pageStack);
                hilog.info(DOMAIN, 'testTag', 'removeByNavDestinationId', JSON.stringify(this.pageStack));
              })
            Button('clear', { stateEffect: true, type: ButtonType.Capsule })
              .width('80%')
              .height(40)
              .margin(10)
              .onClick(() => {
                // [Start clear]
                // 返回到根首页（清除栈中所有页面）
                this.pageStack.clear();
                // [End clear]
                this.message = 'clear' + JSON.stringify(this.pageStack);
                hilog.info(DOMAIN, 'testTag', 'clear', JSON.stringify(this.pageStack));
              })
            Button('get', { stateEffect: true, type: ButtonType.Capsule })
              .width('80%')
              .height(40)
              .onClick(() => {
                // [Start GetParam]
                // 获取栈中所有页面name集合
                this.pageStack.getAllPathName();
                // 获取索引为1的页面参数
                this.pageStack.getParamByIndex(1);
                // 获取PageOne页面的参数
                this.pageStack.getParamByName('PageOne');
                // 获取PageOne页面的索引集合
                this.pageStack.getIndexByName('pageOne');
                // [End GetParam]
                hilog.info(DOMAIN, 'testTag', 'Get the names of all NavDestination pages in the stack.',
                  JSON.stringify(this.pageStack.getAllPathName()));
                hilog.info(DOMAIN, 'testTag',
                  'Get the parameter information of the NavDestination page specified by index.',
                  JSON.stringify(this.pageStack.getParamByIndex(1)));
                hilog.info(DOMAIN, 'testTag', 'Get all parameter information of NavDestination pages named "name"',
                  JSON.stringify(this.pageStack.getParamByName('pageTwo')));
                hilog.info(DOMAIN, 'testTag', 'Get the position indices of all NavDestination pages named "name"',
                  JSON.stringify(this.pageStack.getIndexByName('pageOne')));
              })

            Text(this.message)
              .width('80%')
              .height(50)
          }.width('100%').height('100%')
        }
        .width('100%')
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Vertical)
        .edgeEffect(EdgeEffect.None)
        .id('ScrollNoParam')

    }
    .width('100%')
    .height('100%')
    .title('pageOne')
    .onWillShow(()=>{
      this.message = JSON.stringify(this.pageStack);
    })
    .onBackPressed(() => {
      const popDestinationInfo = this.pageStack.pop(); // 弹出路由栈栈顶元素
      hilog.info(DOMAIN, 'testTag', 'pop', 'Return value', JSON.stringify(popDestinationInfo));
      return true;
    }).onReady((context: NavDestinationContext) => {
      this.pageStack = context.pathStack;
    })
    }
  }
}