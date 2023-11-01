/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

/**
 * Indicates form info
 */
export class CardItemInfo {
  /**
   * Indicates form id
   */
  cardId: number;

  /**
   * Indicates form bundleName.
   */
  bundleName: string;

  /**
   * Indicates form abilityName.
   */
  abilityName: string;

  /**
   * Indicates form moduleName.
   */
  moduleName: string;

  /**
   * Indicates cardName.
   */
  cardName: string;

  /**
   * Indicates form dimension.
   */
  cardDimension: number | undefined;

  /**
   * Indicates form size.
   */
  area: number[] | undefined;

  /**
   * Indicates form description.
   */
  description = '';

  /**
   * Indicates form formConfigAbility.
   */
  formConfigAbility: string;

  /**
   * Indicates form of app labelId.
   */
  appLabelId: string;

  /**
   * Indicates form of app name.
   */
  appName: string | undefined;

  /**
   * Indicates form of support Dimensions.
   */
  supportDimensions: number[] = [];
}