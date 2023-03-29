/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

const FORM_CARD_SIZE: number = 80;
const FORM_CARD_LITTLE: number = 2;
const FORM_CARD_BIG: number = 4;

export class CommonConstants {
  /**
   * Grid item type for apps.
   */
  static readonly TYPE_APP: number = 0;

  /**
   * Grid item type for cards.
   */
  static readonly TYPE_CARD: number = 1;

  /**
   * Grid item type for iamge.
   */
  static readonly TYPE_IMAGE: number = 256;

  /**
   * Default invalid value.
   */
  static readonly INVALID_VALUE: number = -1;

  /**
   * Card dimension constants for 1 row 2 columns.
   */
  static readonly CARD_DIMENSION_1x2: number = 1;

  /**
   * Card dimension constants for 2 rows 2 columns.
   */
  static readonly CARD_DIMENSION_2x2: number = 2;

  /**
   * Card dimension constants for 2 rows 4 columns.
   */
  static readonly CARD_DIMENSION_2x4: number = 3;

  /**
   * Card dimension constants for 4 rows 4 columns.
   */
  static readonly CARD_DIMENSION_4x4: number = 4;

  /**
   * Menu type for dynamic items.
   */
  static readonly MENU_TYPE_DYNAMIC: number = 1;

  /**
   * if uninstal succeeded, success, successful.
   */
  static readonly UNINSTALL_SUCCESS: number = 0;

  /**
   * uninstall is forbidden.
   */
  static readonly UNINSTALL_FORBID: number = 1;

  /**
   * default page for launcher
   */
  static readonly DEFAULT_PAGE_COUNT: number = 1;

  /**
   * default row count for launcher
   */
  static readonly DEFAULT_ROW_COUNT: number = 6;

  /**
   * default column count for launcher
   */
  static readonly DEFAULT_COLUMN_COUNT: number = 5;

  /**
   * default form components radius for launcher
   */
  static readonly DEFAULT_CARD_RADIUS: number = 16;

  /**
   * form components width for launcher
   */
  static readonly FORM_COMPONENT_WIDTH: number[] = [
    FORM_CARD_SIZE * FORM_CARD_LITTLE,
    FORM_CARD_SIZE * FORM_CARD_LITTLE,
    FORM_CARD_SIZE * FORM_CARD_BIG,
    FORM_CARD_SIZE * FORM_CARD_BIG
  ];

  /**
   * form components height for launcher
   */
  static readonly FORM_COMPONENT_HEIGHT: number[] = [
    FORM_CARD_SIZE,
    FORM_CARD_SIZE * FORM_CARD_LITTLE,
    FORM_CARD_SIZE * FORM_CARD_LITTLE,
    FORM_CARD_SIZE * FORM_CARD_BIG
  ];

  /**
   * image form components size for launcher
   */
  static readonly DEFAULT_IMAGE_AREA: Array<number> = [
    FORM_CARD_LITTLE,
    FORM_CARD_LITTLE
  ];
}