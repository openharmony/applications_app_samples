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
import { AppLog } from '../utils/Logger'
import {Router} from '@ohos.arkui.UIContext';
import { common } from '@kit.AbilityKit';
import { image } from '@kit.ImageKit';

const router = new Router();
const TAG: string = 'DEBUG TEST';

@Component
export struct MyButton {
  //自定义button。
  public logger = new AppLog(TAG);
  public context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  public isOpen = false;
  public propertyKey = image.PropertyKey.BITS_PER_SAMPLE;
  public value = '';
  public chooseFun = 'fun';
  public fileName: string = 'test.jpeg';
  public fun: () => void = () => {};
  public fun1: (context: common.UIAbilityContext, fileName: string) => Promise<void> = () => {
    return new Promise(() => {});
  };
  public fun2: (propertyKey: string) => void = () => {};
  public fun3: (propertyKey: string, value: string) => void = () => {};
  public fun4: () => void = () => {};
  public fun5: (context: common.UIAbilityContext, fileName: string) => void = () => {};
  public text = 'This is a button';
  @State returnMessage: string = 'No';

  build() {
    Row() {
      Column() {
        Blank().height(20);
        Button(`${this.text}`)
          .labelStyle({
            overflow: TextOverflow.Clip,
            maxLines: 2,
            minFontSize: 20,
            maxFontSize: 20,
            font: {
              size: 20,
              weight: FontWeight.Bolder,
              family: 'cursive',
              style: FontStyle.Italic
            }
          })
          .onClick(async () => {
            this.logger.log('\n start->>>>>>>>>>>>>>>>>>>>>>');
            switch(this.chooseFun) {
              case 'fun':
                this.fun();
                break;
              case 'fun1':
                await this.fun1(this.context, this.fileName);
                break;
              case 'fun2':
                console.log(`this.propertyKey ${this.propertyKey}`);
                this.fun2(this.propertyKey);
                break;
              case 'fun3':
                console.log(`fun3 this.value ${this.value}`);
                this.fun3(this.propertyKey, this.value);
                break;
              case 'fun5':
                this.fun5(this.context, this.fileName);
                break;
              case 'funGroup':
                await this.fun1(this.context, this.fileName);
                this.fun();
                this.fun4();
                break;
              case 'funGroup1':
                this.fun();
                this.fun4();
                break;
              case 'noFun':
                this.fileName = this.fileName;
                break;
            }
            this.logger.log((this.fun.toString()) + '\n end:->>>>>>>>>>>>>>>>>>>>>>');
            this.returnMessage = 'Yes';
          })
        Blank().height(20);
        Divider();
      }
    }
  }
}

@Component
export struct GotoButton {
  public logger = new AppLog(TAG);
  public dstUri: string = '';
  public text = 'This is a goto button';
  @State returnMessage: string = 'No';

  build() {
    Row() {
      Column() {
        Blank().height(40);
        Button(`${this.text}`)
          .labelStyle({
            overflow: TextOverflow.Clip,
            maxLines: 2,
            minFontSize: 20,
            maxFontSize: 20,
            font: {
              size: 20,
              weight: FontWeight.Bolder,
              family: 'cursive',
              style: FontStyle.Italic
            }
          })
          .onClick( () => {
            this.logger.log(`\n start goto ${this.dstUri}->>>>>>>>>>>>>>>>>>>>>>`);
            router.pushUrl({ url: this.dstUri });
            this.logger.log(`\n end goto ${this.dstUri}->>>>>>>>>>>>>>>>>>>>>>`);
            this.returnMessage = 'Yes';
          })
        Blank().height(40);
        Divider();
      }
    }
  }
}

