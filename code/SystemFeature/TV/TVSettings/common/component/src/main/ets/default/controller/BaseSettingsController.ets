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

import ISettingsController from './ISettingsController';

export default abstract class BaseSettingsController implements ISettingsController {
  protected component: Object | null = null;
  protected boundComponentProperties: string[] = [];
  protected boundControllerProperties: string[] = [];

  /**
   * Bind component.
   */
  bindComponent(component: Object): ISettingsController{
    this.component = component;
    const keys = Object.keys(component as Object);
    for (let i = 0; i < keys.length; i++) {
      const key = keys[i];
      if (Reflect.has(this as Object, key)) {
        Reflect.set(this as Object, key, Reflect.get(component as Object, key) as Object);
      }
    }
    this.notifyComponent();
    return this;
  }

  /**
   * Bind component's properties, note that only basic types can be transported.
   * Type like Resource may meet unexpected error.
   * If you want to transport resource string or color, ets. AppStorage is suggested @StorageLink.
   */
  bindProperties(componentProperties: string[], controllerProperties?: string[]): ISettingsController {
    this.boundComponentProperties = componentProperties;
    this.boundControllerProperties = controllerProperties ? controllerProperties : componentProperties;
    this.syncBoundPropertiesToComponent();
    this.notifyComponent();
    return this;
  }

  /**
   * Initialize data.
   */
  initData(): ISettingsController {
    return this;
  };

  /**
   * Subscribe listeners.
   */
  subscribe(): ISettingsController {
    return this;
  };

  /**
   * Unsubscribe listeners.
   */
  unsubscribe(): ISettingsController {
    return this;
  };

  /**
   * Define bound properties.
   */
  protected notifyComponent(): void {
    if (this.component !== null) {
      const syncController = Reflect.get(this.component, 'syncController') as ((controller: ISettingsController) => void) | undefined;
      if (typeof syncController === 'function') {
        syncController(this);
      }
    }
  }

  protected syncBoundPropertiesToComponent(): void {
    if (this.component === null) {
      return;
    }
    const boundCount = Math.min(this.boundComponentProperties.length, this.boundControllerProperties.length);
    for (let i = 0; i < boundCount; i++) {
      this.syncBoundProperty(this.boundComponentProperties[i], this.boundControllerProperties[i]);
    }
  }

  protected syncBoundProperty(componentProperty: string, controllerProperty: string): void {
    if (this.component === null || !Reflect.has(this as Object, controllerProperty)) {
      return;
    }
    Reflect.set(
      this.component as Object,
      componentProperty,
      Reflect.get(this as Object, controllerProperty) as Object
    );
  }

}
