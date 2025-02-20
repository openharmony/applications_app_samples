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

export const getPropertyNames: (obj: Object) => Array<string> | void; // napi_get_property_names

export const setProperty: (obj: Object, key: String, value: string) => Object | void; // napi_set_property

export const getProperty: (obj: Object, key: string) => string | void; // napi_get_property

export const hasProperty: (obj: Object, key: number | string) => boolean | void; // napi_has_property

export const deleteProperty: (obj: Object, key: string) => boolean; // napi_delete_property

export const napiHasOwnProperty: (obj: Object, key: string) => boolean | void; // napi_has_own_property

export const napiSetNamedProperty: (key: string) => Object | void; // napi_set_named_property

export const napiGetNamedProperty: (obj: Object,
  key: string) => boolean | number | string | Object | void; // napi_get_named_property

export const napiHasNamedProperty: (obj: Object, key: string) => boolean | void; // napi_has_named_property

export class DefineMethodObj {
  defineMethodPropertiesExample: Function;
}

export class DefineStringObj {
  defineStringPropertiesExample: string;
}

export class DefineGetterSetterObj {
  getterCallback: Function;
  setterCallback: Function;
}

export const defineMethodProperties: () => DefineMethodObj; // napi_define_properties

export const defineStringProperties: () => DefineStringObj;

export const createStringWithGetterSetter: () => DefineGetterSetterObj;

export const getAllPropertyNames: (obj: Object) => Array<string> | void; // napi_get_all_property_names