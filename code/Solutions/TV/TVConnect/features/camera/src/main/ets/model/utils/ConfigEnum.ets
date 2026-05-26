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
/**
 * 设备连接
 */
export enum DeviceTypeModeEnum {
  INPUTDEVICESERIALNUMBER = 'input_device_serial_number', // 输入设备序列号
  EQUIPMENTQUALIFICATION = 'equipment_qualification', // 设备确认
  DEVICEDISTRIBUTIONMETWORKDESCRIPTION = 'device_distribution_network_description', // 设备配网说明
  DEVICEINITIALIZEONE = 'device_initialize_one', // 设备初始化1
  DEVICEINITIALIZETWO = 'device_initialize_two', // 设备初始化2
  DEVICEINITIALIZETHREE = 'device_initialize_three', // 设备初始化3
  DEVICENAMEANDSCENARIO = 'device_name_and_scenario', // 设备名称与场景
  DEVICEADDEDSUCCESSFULLY = 'device_added_successfully', // 设备添加成功
}


/**
 * 设备控制
 */
export enum DeviceControlTypeModeEnum {
  CAMERA = 'camera', // 摄像头
  SET = 'set', // 设置
  ESSENTIALINFORMATION = 'essential_information', // 基本信息
  DEVICNAME = 'devic_name', // 设备名称
  APPLICATIONOFEQUIPMENT = 'application_of_equipment', // 设备用途
  DATABASECOORDINATESYSTEM = 'database_coordinate_system', // 坐标库
  CREATECOORDINATE = 'create_coordinate', // 创建坐标
  ENDCOORDINATE = 'end_coordinate', // 编辑坐标
  TRANSCRIBETRANSCRIBE = 'transcribe_transcribe', // 录制记录
}


/**
 * 生产设备
 */
export enum ProductionEquipmentEnum {
  ADDEQUIPMENTS = 'addEquipments', // 添加设备
  SELECTIONSORT = 'selectionSort', // 选择分类
  CONFIGURATIONWIZARD = 'configurationWizard', // 配置向导
  CONNECTINGDEVICE = 'connectingDevice', // 连接设备
  PRODUCTIONDIFFICULTY = 'productionDifficulty', // 生产设备、故障管理
}


