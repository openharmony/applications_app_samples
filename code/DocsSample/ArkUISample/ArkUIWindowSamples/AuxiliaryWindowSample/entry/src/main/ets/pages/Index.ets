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
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

const MARGIN_SIZE: number = 5;

// [Start dialog_window]
let dialogWindowClass: window.Window | undefined = undefined;
// [StartExclude dialog_window]
// [Start floating_window]
let floatWindowClass: window.Window | undefined = undefined;
// [StartExclude floating_window]
// [Start create_independent_subWindow]
let independentWindowClass: window.Window | undefined = undefined;
// [StartExclude create_independent_subWindow]
// [Start create_subWindow]
let windowStage_: window.WindowStage | undefined = undefined;
let subWindowClass: window.Window | undefined = undefined;
// [StartExclude create_subWindow]
@Entry
@Component
struct Index {
  @State message: string = '辅助窗口demo';

  // 使用createSubWindow接口创建子窗
  async createSubWindow() {
    try {
      // [EndExclude create_subWindow]
      // 获取windowStage
      windowStage_ = AppStorage.get('windowStage');
      // 创建应用子窗口。
      if (windowStage_ == null) {
        console.error('Failed to create the subwindow. Cause: windowStage_ is null');
      } else {
        // 1.使用createSubWindow接口创建子窗
        windowStage_.createSubWindow('SubWindow', (err, data) => {
          if (err?.code) {
            console.error('Failed to create the subwindow. Cause: ' + JSON.stringify(err));
          }
          subWindowClass = data;
          if (!subWindowClass) {
            console.error('sub_windowClass is null');
            return;
          }
          console.info('Succeeded in creating the subwindow. Data: ' + JSON.stringify(data));
          // [StartExclude create_subWindow]
          // [Start subWindow_properties]
          // 2.子窗口创建成功后，设置子窗口的位置、大小及相关属性等。
          subWindowClass.moveWindowTo(100, 100, (err) => {
            if (err?.code) {
              console.error('Failed to move the window. Cause:' + JSON.stringify(err));
              return;
            }
            console.info('Succeeded in moving the window.');
            if (!subWindowClass) {
              console.error('sub_windowClass is null');
              return;
            }
            subWindowClass.resize(600, 600, (err) => {
              if (err?.code) {
                console.error('Failed to change the window size. Cause:' + JSON.stringify(err));
                return;
              }
              console.info('Succeeded in changing the window size.');
            });
          });
          // 3.为子窗口加载对应的目标页面。
          subWindowClass.setUIContent('pages/SubWindow', (err) => {
            if (err?.code) {
              console.error('Failed to load the content. Cause:' + JSON.stringify(err));
              return;
            }
            console.info('Succeeded in loading the content.');
            if (!subWindowClass) {
              console.error('sub_windowClass is null');
              return;
            }
            // 显示子窗口。
            subWindowClass.showWindow((err) => {
              if (err?.code) {
                console.error('Failed to show the window. Cause: ' + JSON.stringify(err));
                return;
              }
              console.info('Succeeded in showing the window.');
            });
          })
          // [End subWindow_uiContent]
          // [EndExclude create_subWindow]
        })
        // [End create_subWindow]
      }
    } catch(e) {
      console.error('TAG', `OnCreateSubWindowWithOptions failed ${JSON.stringify(e)}`);
    }
  }

  destroySubWindow() {
    if (!subWindowClass) {
      console.error('sub_windowClass is null');
      return;
    }
    // 4.销毁子窗口。当不再需要子窗口时，可根据具体实现逻辑，使用destroy对其进行销毁。
    subWindowClass.destroyWindow((err) => {
      if (err?.code) {
        console.error('Failed to destroy the window. Cause: ' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in destroying the window.');
    });
  }

  // 使用createSubWindowWithOptions接口创建独立子窗，仅自由多窗模式下支持
  createIndependentSubWindow() {
    // [EndExclude create_independent_subWindow]
    // 获取windowStage
    windowStage_ = AppStorage.get('windowStage');
    // 1.创建独立子窗口。
    // [StartExclude create_independent_subWindow]
    if (windowStage_ == null) {
      console.error('Failed to create the subwindow. Cause: windowStage_ is null');
    } else {
      try {
        // [EndExclude create_independent_subWindow]
        let options : window.SubWindowOptions = {
          title: 'IndependentSubWindow',
          decorEnabled: true,
          zLevelAboveParentLoosened: true  // 独立子窗需将zLevelAboveParentLoosened置为true
        };
        let promise = windowStage_.createSubWindowWithOptions('IndependentSubWindow', options);
        promise.then((data: window.Window | undefined) => {
          independentWindowClass = data;
          if (!independentWindowClass) {
            console.error('independent_sub_windowClass is null');
            return;
          }
          console.info(`Succeeded in creating the subwindow. Data: ${JSON.stringify(data)}`);
          // [StartExclude create_independent_subWindow]
          // [Start independent_subWindow_properties]
          // 2.子窗口创建成功后，设置子窗口的位置、大小及相关属性等。
          independentWindowClass.moveWindowTo(100, 100, (err) => {
            if (err?.code) {
              console.error('Failed to move the window. Cause:' + JSON.stringify(err));
              return;
            }
            console.info('Succeeded in moving the window.');
            if (!independentWindowClass) {
              console.error('independent_windowClass is null');
              return;
            }
            independentWindowClass.resize(1000, 500, (err) => {
              if (err?.code) {
                console.error('Failed to change the window size. Cause:' + JSON.stringify(err));
                return;
              }
              console.info('Succeeded in changing the window size.');
            });
          });
          // [End independent_subWindow_properties]
          // [Start independent_subWindow_uiContent]
          // 3.为子窗口加载对应的目标页面。
          independentWindowClass.setUIContent('pages/IndependentSubWindow', (err) => {
            if (err?.code) {
              console.error('Failed to load the content. Cause:' + JSON.stringify(err));
              return;
            }
            console.info('Succeeded in loading the content.');
            if (!independentWindowClass) {
              console.error('independent_windowClass is null');
              return;
            }
            // 显示子窗口。
            independentWindowClass.showWindow((err) => {
              if (err?.code) {
                console.error('Failed to show the window. Cause: ' + JSON.stringify(err));
                return;
              }
              console.info('Succeeded in showing the window.');
            });
            // [End independent_subWindow_uiContent]
            // [EndExclude create_independent_subWindow]
          });
          // [End create_independent_subWindow]
        }).catch((err: Error) => {
          let businessError = err as BusinessError;
          console.error(`Failed to create the subwindow. Cause code: ${businessError.code}, message: ${businessError.message}`);
        });
      } catch (exception) {
        console.error(`Failed to create the subwindow. Cause code: ${exception.code}, message: ${exception.message}`);
      }
    }
  }

  destroyIndependentSubWindow() {
    if (!independentWindowClass) {
      console.error('independent_windowClass is null');
      return;
    }
    // [Start destroy_independent_subWindow]
    // 4.销毁子窗口。当不再需要子窗口时，可根据具体实现逻辑，使用destroy对其进行销毁。
    independentWindowClass.destroyWindow((err) => {
      if (err?.code) {
        console.error('Failed to destroy the window. Cause: ' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in destroying the window.');
    });
    // [End destroy_independent_subWindow]
  }

  createFloatingWindow() {
    try {
      // [EndExclude floating_window]
      // 1.创建全局悬浮窗。
      let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('context');
      let config: window.Configuration = {
        name: 'floatWindow', windowType: window.WindowType.TYPE_FLOAT, ctx: context as common.BaseContext
      };
      window.createWindow(config, (err, data) => {
        if (err?.code) {
          console.error('Failed to create the floatWindow. Cause: ' + JSON.stringify(err));
          return;
        }
        floatWindowClass = data;
        console.info('Succeeded in creating the floatWindow. Data: ' + JSON.stringify(data));
        // [StartExclude floating_window]
        // [Start floating_window_properties]
        // 2.全局悬浮窗窗口创建成功后，设置全局悬浮窗的位置、大小及相关属性等。
        floatWindowClass.moveWindowTo(100, 100, (err) => {
          if (err?.code) {
            console.error('Failed to move the window. Cause:' + JSON.stringify(err));
            return;
          }
          console.info('Succeeded in moving the window.');
          if (!floatWindowClass) {
            console.error('float_windowClass is null');
            return;
          }
          floatWindowClass.resize(600, 900, (err) => {
            if (err?.code) {
              console.error('Failed to change the window size. Cause:' + JSON.stringify(err));
              return;
            }
            console.info('Succeeded in changing the window size.');
          });
        });
        // [End floating_window_properties]
        // [Start floating_window_uiContent]
        // 3.为全局悬浮窗加载对应的目标页面。
        floatWindowClass.setUIContent('pages/FloatWindow', (err) => {
          if (err?.code) {
            console.error('Failed to load the content. Cause:' + JSON.stringify(err));
            return;
          }
          console.info('Succeeded in loading the content.');
          // 显示全局悬浮窗。
          (floatWindowClass as window.Window).showWindow((err) => {
            if (err?.code) {
              console.error('Failed to show the window. Cause: ' + JSON.stringify(err));
              return;
            }
            console.info('Succeeded in showing the window.');
          });
        });
        // [End floating_window_uiContent]
        // [EndExclude floating_window]
      });
      // [End floating_window]
    } catch (exception) {
      console.error(`[getInfo] Failed to unregister callback. Cause code: ${exception.code}, message: ${exception.message}`);
    }
  }

  destroyFloatingWindow() {
    if (!floatWindowClass) {
      console.error('float_windowClass is null');
      return;
    }
    // [Start destroy_floating_window]
    // 4.销毁子窗口。当不再需要子窗口时，可根据具体实现逻辑，使用destroy对其进行销毁。
    floatWindowClass.destroyWindow((err) => {
      if (err?.code) {
        console.error('Failed to destroy the window. Cause: ' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in destroying the window.');
    });
    // [End destroy_floating_window]
  }


  createDialogWindow() {
    // [EndExclude dialog_window]
    // 1.创建模态窗口。
    let context1: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('context');
    let config: window.Configuration = {
      name: 'dialogWindow', windowType: window.WindowType.TYPE_DIALOG, ctx: context1 as common.BaseContext
    };
    window.createWindow(config, (err, data) => {
      if (err?.code) {
        console.error('Failed to create the dialogWindow. Cause: ' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in creating the dialogWindow. Data: ' + JSON.stringify(data));
      dialogWindowClass = data;
      // [StartExclude dialog_window]
      // [Start dialog_window_properties]
      // 2.模态窗口创建成功后，设置模态窗口的位置、大小及相关属性等。
      dialogWindowClass.moveWindowTo(100, 100, (err) => {
        if (err?.code) {
          console.error('Failed to move the window. Cause:' + JSON.stringify(err));
          return;
        }
        console.info('Succeeded in moving the window.');
        if (!dialogWindowClass) {
          console.error('dialog_windowClass is null');
          return;
        }
        dialogWindowClass.resize(500, 500, (err) => {
          if (err?.code) {
            console.error('Failed to change the window size. Cause:' + JSON.stringify(err));
            return;
          }
          console.info('Succeeded in changing the window size.');
        });
      });
      // [End dialog_window_properties]
      // [Start dialog_window_uiContent]
      // 3.为模态窗口加载对应的目标页面。
      dialogWindowClass.setUIContent('pages/DialogWindow', (err) => {
        if (err?.code) {
          console.error('Failed to load the content. Cause:' + JSON.stringify(err));
          return;
        }
        console.info('Succeeded in loading the content.');
        // 显示模态窗口。
        (dialogWindowClass as window.Window).showWindow((err) => {
          if (err?.code) {
            console.error('Failed to show the window. Cause: ' + JSON.stringify(err));
            return;
          }
          console.info('Succeeded in showing the window.');
        });
      });
      // [End dialog_window_uiContent]
      // [EndExclude dialog_window]
    });
    // [End dialog_window]
  }

  build() {
    RelativeContainer() {
      Column() {
        Text(this.message)
          .id('DialogWindowHelloWorld')
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
      .alignRules({
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
      Column() {
        Row() {
          Button('创建子窗')
            .onClick(async () => {
              this.createSubWindow();
            }).margin(MARGIN_SIZE)

          Button('销毁子窗')
            .onClick(async () => {
              this.destroySubWindow();
            }).margin(MARGIN_SIZE)
        }

        Row() {
          Button('创建独立子窗')
            .onClick(async () => {
              this.createIndependentSubWindow();
            }).margin(MARGIN_SIZE)

          Button('销毁独立子窗')
            .onClick(async () => {
              this.destroyIndependentSubWindow();
            }).margin(MARGIN_SIZE)
        }

        Row() {
          Button('创建全局悬浮窗')
            .onClick(async () => {
              this.createFloatingWindow();
            }).margin(MARGIN_SIZE)

          Button('销毁全局悬浮窗')
            .onClick(async () => {
              this.destroyFloatingWindow();
            }).margin(MARGIN_SIZE)
        }

        Row() {
          Button('创建模态窗')
            .onClick(async () => {
              this.createDialogWindow();
            }).margin(MARGIN_SIZE)

        }

      }
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })

    }
    .height('100%')
    .width('100%')
  }
}