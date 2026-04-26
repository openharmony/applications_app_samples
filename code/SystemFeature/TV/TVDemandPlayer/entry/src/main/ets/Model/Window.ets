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
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

export abstract class WindowDestroyErrorLike {
  abstract code: number;
}

export abstract class WindowRectLike {
  abstract width: number;
  abstract height: number;
}

export abstract class WindowContentLike {
  abstract resize(width: number, height: number, callback: (err: BusinessError) => void): void;
  abstract setUIContent(path: string, callback: (err: BusinessError) => void): void;
  abstract showWindow(callback: (err: BusinessError) => void): void;
}

export abstract class WindowStageLike {
  abstract createSubWindow(name: string, callback: (err: BusinessError, data: WindowContentLike) => void): void;
}

export abstract class WindowPropertiesLike {
  abstract windowRect: WindowRectLike;
}

export abstract class WindowLifecycleLike {
  abstract destroyWindow(callback: (err: BusinessError | WindowDestroyErrorLike) => void): void;
}

export class SubWindow {
  public static subWindow: SubWindow = new SubWindow();
  public context: common.UIAbilityContext | null = null;

  showSubWindow(windowSize: WindowPropertiesLike, windowStage: WindowStageLike | null): WindowContentLike | null {
    let subWindowClass: WindowContentLike | null = null
    if (windowStage == null) {
      console.error('Failed to create the subwindow. Cause: windowStage_ is null');
      return subWindowClass;
    }

    windowStage.createSubWindow('hiSubWindow', (err, data) => {
      if (err.code) {
        console.error('Failed to create the subwindow. Cause: ' + JSON.stringify(err));
        return;
      }
      subWindowClass = data;
      console.info('Succeeded in creating the subwindow. Data: ' + JSON.stringify(data));
      subWindowClass.resize(windowSize.windowRect.width, windowSize.windowRect.height, (resizeErr) => {
        if (resizeErr.code) {
          console.error('Failed to change the window size. Cause:' + JSON.stringify(resizeErr));
          return;
        }
        console.info('Succeeded in changing the window size.');
      });
      subWindowClass.setUIContent('pages/Index', (contentErr) => {
        if (contentErr.code) {
          console.error('Failed to load the content. Cause:' + JSON.stringify(contentErr));
          return;
        }
        console.info('Succeeded in loading the content.');
        subWindowClass!.showWindow((showErr) => {
          let errCode: number = showErr.code;
          if (errCode) {
            console.error('Failed to show the window. Cause: ' + JSON.stringify(showErr));
            return;
          }
          console.info('Succeeded in showing the window.');
        });
      });
    })
    return subWindowClass
  }

  destroySubWindow(subWindowClass: WindowLifecycleLike | null): void {
    if (subWindowClass == null) {
      console.error('Failed to create the subwindow. Cause: windowStage_ is null');
      return;
    }

    subWindowClass.destroyWindow((err) => {
      if (err.code) {
        console.error('Failed to destroy the window. Cause: ' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in destroying the window.');
    });
  }

  endUIAbility(): void {
    if (this.context != null) {
      this.context.terminateSelf()
        .then(() => {
          console.info('terminateSelf succeed');
        })
        .catch((err: BusinessError) => {
          console.error(`terminateSelf failed, code is ${err.code}, message is ${err.message}`);
        });
      return;
    }

    try {
      const currentContext = getContext(this) as common.UIAbilityContext;
      this.context = currentContext;
      currentContext.terminateSelf()
        .then(() => {
          console.info('terminateSelf succeed');
        })
        .catch((contextError: BusinessError) => {
          console.error(`terminateSelf failed, code is ${contextError.code}, message is ${contextError.message}`);
        });
    } catch (err) {
      const error = err as BusinessError;
      console.error(`terminateSelf failed, code is ${error.code}, message is ${error.message}`);
    }
  }
}
