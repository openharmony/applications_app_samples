/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

enum EntryForm {
  NORMAL = 0,
  CAMERA = 1,
  SINGLE_SELECT = 2,
  MULTIPLE_SELECT = 3,
  RECYCLE = 4,
  DISTRIBUTED = 5,
  CARD = 6,
  VIEW_DATA = 7
}

export class RouterConstants {
  static readonly ENTRY_FROM_NONE = 0;
  static readonly ENTRY_FROM_CAMERA = 1;
  static readonly ENTRY_FROM_SINGLE_SELECT = 2;
  static readonly ENTRY_FROM_MULTIPLE_SELECT = 3;
  static readonly ENTRY_FROM_RECYCLE = 4;
  static readonly ENTRY_FROM_DISTRIBUTED = 5;
  static readonly ENTRY_FROM_NORMAL = 6;
  static readonly ENTRY_FROM_FORM_ABILITY = 7;
  static readonly ENTRY_FROM_FORM_FORM_EDITOR = 8;
  static readonly ENTRY_FROM_VIEW_DATA = 9;
  static readonly ENTRY_FROM_FORM_ABILITY_NONE = 12;
  static readonly ENTRY_FROM = EntryForm;
}