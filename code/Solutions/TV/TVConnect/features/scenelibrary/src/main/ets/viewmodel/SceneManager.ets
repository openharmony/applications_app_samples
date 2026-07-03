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
import common from '@ohos.app.ability.common';
import PositionComputerUtil from '../util/PositionComputingUtil';
import WindowsUtil from '../util/WindowsUtils';
import DragSceneInitParams from './DragSceneInitParams';

export default class SceneManager {
  public static init(context: common.UIAbilityContext) {
    WindowsUtil.getInstance().initWindows(context);
    DragSceneInitParams.getInstance().initParams(context);
    PositionComputerUtil.getInstance().init(DragSceneInitParams.getInstance());
  }
};
