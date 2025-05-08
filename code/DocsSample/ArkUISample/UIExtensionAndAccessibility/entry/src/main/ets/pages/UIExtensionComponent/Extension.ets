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

import { UIExtensionContentSession } from '@kit.AbilityKit';

let storage = LocalStorage.getShared()
AppStorage.setOrCreate('message', 'UIExtensionAbility')

@Entry(storage)
@Component
struct Extension {
  @StorageLink('message') storageLink: string = '';
  private session: UIExtensionContentSession | undefined = storage.get<UIExtensionContentSession>('session');
  pathStack: NavPathStack = new NavPathStack()

  @Builder
  PageMap(name: string) {
    if (name === 'hello') {
      pageOneTmp()
    }
  }

  onPageShow() {
    if (this.session != undefined) {
      this.session.setReceiveDataCallback((data)=> {
        this.storageLink = JSON.stringify(data)
        console.info('invoke for test, handle callback set by setReceiveDataCallback successfully');
      })

      this.session.setReceiveDataForResultCallback(func1)
    }
  }

  build() {
    Navigation(this.pathStack) {
      Row() {
        Column() {
          Text(this.storageLink)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Button($r('app.string.UIExtensionComponent_button1')).onClick(()=>{
            if (this.session != undefined) {
              this.session.sendData({'data': 543321})
              console.info('send 543321, for test')
            }
          })
          Button('terminate').onClick(()=> {
            if (this.session != undefined) {
              this.session.terminateSelf();
            }
            storage.clear()
          })
          Button('terminate with result').onClick(()=>{
            if (this.session != undefined) {
              this.session.terminateSelfWithResult({
                resultCode: 0,
                want: {
                  bundleName: 'myBundleName',
                  parameters: { 'result': 123456 }
                }
              })
            }
            storage.clear()
          })

          Button($r('app.string.UIExtensionComponent_button2')).onClick(()=> {
            this.pathStack.pushPath({ name: 'hello'})
          })
        }
      }
      .height('100%')
    }.navDestination(this.PageMap)
    .mode(NavigationMode.Stack)
  }
}

// pageOne
@Component
export struct pageOneTmp {
  pathStack: NavPathStack = new NavPathStack()

  build() {
    NavDestination() {
      Column() {
        Text('Hello World')
      }.width('100%').height('100%')
    }.title('pageOne')
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop()
      console.log('pop' + $r('app.string.UIExtensionComponent_return') + JSON.stringify(popDestinationInfo))
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}

function func1(data: Record<string, Object>): Record<string, Object> {
  let linkToMsg: SubscribedAbstractProperty<string> = AppStorage.link('message');
  linkToMsg.set(JSON.stringify(data))
  console.info('invoke for test, handle callback set by setReceiveDataForResultCallback successfully');
  return data;
}
