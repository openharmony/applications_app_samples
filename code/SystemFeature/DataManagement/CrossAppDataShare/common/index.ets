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

export {
  TABLE_NAME,
  STORE_CONFIG,
  SQL_CREATE_TABLE,
  BASE_URI,
  COLUMNS,
  OPERATE_STATUS,
  SYNC_STATE
} from './src/main/ets/utils/Consts'

export { logger } from './src/main/ets/utils/Logger'

export { Contact, arrayToString, getListFromResultSet } from './src/main/ets/model/Contact'

export { ContactDataSource } from './src/main/ets/data/BasicDataSource'

export { dialogUtil } from './src/main/ets/utils/DialogUtil'

export { contactDataShareUtil } from './src/main/ets/data/ContactDataShareUtil'

export { ContactInfo } from './src/main/ets/components/ContactInfo'

export { ContactDetailInfo } from './src/main/ets/components/ContactDetailInfo'

export { TitleBar } from './src/main/ets/components/TitleBar'