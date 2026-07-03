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


export class DeviceType {
  //设备标识
  public readonly name: string;
  //设备名
  public readonly desc: Resource;
  //设备图标
  public readonly image: Resource;

  constructor(name: string, desc: Resource, image: Resource) {
    this.name = name;
    this.desc = desc;
    this.image = image;
  }
}


export class DeviceTypes {
  public static BIG_SCREEN: DeviceType =
    new DeviceType('BIG_SCREEN', $r('app.string.type_big_screen'), $r('app.media.ic_big_screen'));
  public static CAMERA: DeviceType = new DeviceType('CAMERA', $r('app.string.type_camera'), $r('app.media.ic_camera'));
  public static CONTROLLER: DeviceType =
    new DeviceType('CONTROLLER', $r('app.string.type_controller'), $r('app.media.ic_controller'));
  public static DEVELOPMENT_BOARD: DeviceType =
    new DeviceType('DEVELOPMENT_BOARD', $r('app.string.type_controller'), $r('app.media.ic_development_board'));
  public static GATE: DeviceType = new DeviceType('GATE', $r('app.string.type_gate'), $r('app.media.ic_gate'));
  public static PEN: DeviceType = new DeviceType('PEN', $r('app.string.type_pen'), $r('app.media.ic_pen'));
  public static POS: DeviceType = new DeviceType('POS', $r('app.string.type_pos'), $r('app.media.ic_pos'));
  public static PRINTER: DeviceType =
    new DeviceType('PRINTER', $r('app.string.type_printer'), $r('app.media.ic_printer'));
  public static SCREEN: DeviceType =
    new DeviceType('SCREEN', $r('app.string.type_screen'), $r('app.media.ic_small_screen'));
  public static SOUND: DeviceType = new DeviceType('SOUND', $r('app.string.type_sound'), $r('app.media.ic_sound'));
  public static STUDENT_CARD: DeviceType =
    new DeviceType('STUDENT_CARD', $r('app.string.type_student_card'), $r('app.media.ic_student_card'));
  public static TEST_BOX: DeviceType =
    new DeviceType('TEST_BOX', $r('app.string.type_test_box'), $r('app.media.ic_test_box'));
  public static WATCH: DeviceType = new DeviceType('WATCH', $r('app.string.type_watch'), $r('app.media.ic_watch'));
  //所有设备类型集合
  public static ALL_DEVICE_TYPES_ARR: DeviceType[] = [
    DeviceTypes.BIG_SCREEN,
    DeviceTypes.CAMERA,
    DeviceTypes.CONTROLLER,
    DeviceTypes.DEVELOPMENT_BOARD,
    DeviceTypes.GATE,
    DeviceTypes.PEN,
    DeviceTypes.POS,
    DeviceTypes.PRINTER,
    DeviceTypes.SCREEN,
    DeviceTypes.SOUND,
    DeviceTypes.STUDENT_CARD,
    DeviceTypes.TEST_BOX,
    DeviceTypes.WATCH,
  ];
}

