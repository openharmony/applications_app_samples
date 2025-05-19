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

// [Start napi_get_property_names_api]
export const getPropertyNames: (obj: Object) => Array<string> | void; // napi_get_property_names
// [End napi_get_property_names_api]

// [Start napi_set_property_api]
export const setProperty: (obj: Object, key: String, value: string) => Object | void; // napi_set_property
// [End napi_set_property_api]

// [Start napi_get_property_api]
export const getProperty: (obj: Object, key: string) => string | void; // napi_get_property
// [End napi_get_property_api]

// [Start napi_has_property_api]
export const hasProperty: (obj: Object, key: number | string) => boolean | void; // napi_has_property
// [End napi_has_property_api]

// [Start napi_delete_property_api]
export const deleteProperty: (obj: Object, key: string) => boolean; // napi_delete_property
// [End napi_delete_property_api]

// [Start napi_has_own_property_api]
export const napiHasOwnProperty: (obj: Object, key: string) => boolean | void; // napi_has_own_property
// [End napi_has_own_property_api]

// [Start napi_set_named_property_api]
export const napiSetNamedProperty: (key: string) => Object | void; // napi_set_named_property
// [End napi_set_named_property_api]

// [Start napi_get_named_property_api]
export const napiGetNamedProperty: (obj: Object,
  key: string) => boolean | number | string | Object | void; // napi_get_named_property
// [End napi_get_named_property_api]

// [Start napi_has_named_property_api]
export const napiHasNamedProperty: (obj: Object, key: string) => boolean | void; // napi_has_named_property
// [End napi_has_named_property_api]

// [Start napi_define_properties_api]
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
// [End napi_define_properties_api]

// [Start napi_get_all_property_names_api]
export const getAllPropertyNames: (obj: Object) => Array<string> | void; // napi_get_all_property_names
// [End napi_get_all_property_names_api]