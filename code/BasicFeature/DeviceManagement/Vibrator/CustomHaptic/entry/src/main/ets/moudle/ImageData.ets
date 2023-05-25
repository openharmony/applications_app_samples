/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

export class ImagesData {
  id: number
  src: Resource
  name: string
  vibratorFileL:string
  vibratorFileM:string
  vibratorFileH:string
  audioName:string
}

export function getImageRacingList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Racing1"), "name": "撞击", "vibratorFileL": "CarCrash_l.json", "vibratorFileM": "CarCrash_m.json", "vibratorFileH": "CarCrash_h.json", "audioName":  "CarCrash.wav"},
    {"id": 1, "src": $r("app.media.Racing2"), "name": "启动", "vibratorFileL": "CarIgnite_l.json", "vibratorFileM": "CarIgnite_m.json", "vibratorFileH": "CarIgnite_h.json", "audioName": "CarIgnite.wav"},
    {"id": 2, "src": $r("app.media.Racing3"), "name": "漂移", "vibratorFileL": "CarSkid_l.json", "vibratorFileM": "CarSkid_m.json", "vibratorFileH": "CarSkid_h.json", "audioName": "CarSkid.wav"},
    {"id": 3, "src": $r("app.media.Racing4"), "name": "漂移喷射", "vibratorFileL": "DriftingJet_l.json", "vibratorFileM": "DriftingJet_m.json", "vibratorFileH": "DriftingJet_h.json", "audioName": "DriftingJet.wav"},
    {"id": 4, "src": $r("app.media.Racing5"), "name": "喷射", "vibratorFileL": "JetN2O_l.json", "vibratorFileM": "JetN2O_m.json", "vibratorFileH": "JetN2O_h.json", "audioName": "JetN2O.wav"},
    {"id": 5, "src": $r("app.media.Racing6"), "name": "比赛出发", "vibratorFileL": "RacingStart_l.json", "vibratorFileM": "RacingStart_m.json", "vibratorFileH": "RacingStart_h.json", "audioName": "RacingStart.wav"},
    {"id": 6, "src": $r("app.media.Racing8"), "name": "加速", "vibratorFileL": "SpeedUp_l.json", "vibratorFileM": "SpeedUp_m.json", "vibratorFileH": "SpeedUp_h.json", "audioName": "SpeedUp.wav"},
  ]
  return ImagesDataArray;
}

export function getImageBattleList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Battle7"), "name": "翻滚", "vibratorFileL": "Tumble_l.json", "vibratorFileM": "Tumble_m.json", "vibratorFileH": "Tumble_h.json", "audioName": "Tumble.wav"},
    {"id": 1, "src": $r("app.media.Battle2"), "name": "拳击", "vibratorFileL": "Punch_l.json", "vibratorFileM": "Punch_m.json", "vibratorFileH": "Punch_h.json", "audioName": "Punch.wav"},
    {"id": 2, "src": $r("app.media.Battle3"), "name": "踢腿", "vibratorFileL": "Kick_l.json", "vibratorFileM": "Kick_m.json", "vibratorFileH": "Kick_h.json", "audioName": "Kick.wav"},
    {"id": 3, "src": $r("app.media.Battle4"), "name": "受伤", "vibratorFileL": "Hurt_l.json", "vibratorFileM": "Hurt_m.json", "vibratorFileH": "Hurt_h.json", "audioName": "Hurt.wav"},
    {"id": 4, "src": $r("app.media.Battle5"), "name": "爆炸", "vibratorFileL": "Blast_l.json", "vibratorFileM": "Blast_m.json", "vibratorFileH": "Blast_h.json", "audioName": "Blast.wav"},
    {"id": 5, "src": $r("app.media.Battle6"), "name": "炸弹", "vibratorFileL": "Bomb_l.json", "vibratorFileM": "Bomb_m.json", "vibratorFileH": "Bomb_h.json", "audioName": "Bomb.wav"},
  ]
  return ImagesDataArray;
}

export function getImageShootList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.AK47"), "name": "AK47", "vibratorFileL": "AK47_l.json", "vibratorFileM": "AK47_m.json", "vibratorFileH": "AK47_h.json", "audioName": "AK47.wav"},
    {"id": 1, "src": $r("app.media.HK416"), "name": "HK16", "vibratorFileL": "HK416_l.json", "vibratorFileM": "HK416_m.json", "vibratorFileH": "HK416_h.json", "audioName": "HK416.wav"},
    {"id": 2, "src": $r("app.media.M4"), "name": "M4", "vibratorFileL": "M4_l.json", "vibratorFileM": "M4_m.json", "vibratorFileH": "M4_h.json", "audioName": "M4.wav"},
    {"id": 3, "src": $r("app.media.MP5"), "name": "MP5", "vibratorFileL": "MP5_l.json", "vibratorFileM": "MP5_m.json", "vibratorFileH": "MP5_h.json", "audioName": "MP5.wav"},
    {"id": 4, "src": $r("app.media.CZ75"), "name": "CZ75", "vibratorFileL": "CZ75_l.json", "vibratorFileM": "CZ75_m.json", "vibratorFileH": "CZ75_h.json", "audioName": "CZ75.wav"},
    {"id": 5, "src": $r("app.media.Winchester"), "name": "来福", "vibratorFileL": "Winchester_l.json", "vibratorFileM": "Winchester_m.json", "vibratorFileH": "Winchester_h.json", "audioName": "Winchester.wav"},
    {"id": 6, "src": $r("app.media.Rifle"), "name": "步枪", "vibratorFileL": "Rifle_l.json", "vibratorFileM": "Rifle_m.json", "vibratorFileH": "Rifle_h.json", "audioName": "Rifle.wav"},
    {"id": 7, "src": $r("app.media.AssaultRifle"), "name": "冲锋枪", "vibratorFileL": "AssaultRifle_l.json", "vibratorFileM": "AssaultRifle_m.json", "vibratorFileH": "AssaultRifle_h.json", "audioName": "AssaultRifle.wav"},
    {"id": 8, "src": $r("app.media.HitSand"), "name": "枪击地面", "vibratorFileL": "HitSand_l.json", "vibratorFileM": "HitSand_m.json", "vibratorFileH": "HitSand_h.json", "audioName": "HitSand.wav"},
    {"id": 9, "src": $r("app.media.HitWater"), "name": "枪击水面", "vibratorFileL": "HitWater_l.json", "vibratorFileM": "HitWater_m.json", "vibratorFileH": "HitWater_h.json", "audioName": "HitWater.wav"},
    {"id": 10, "src": $r("app.media.HitMetal"), "name": "枪击金属", "vibratorFileL": "HitMetal_l.json", "vibratorFileM": "HitMetal_m.json", "vibratorFileH": "HitMetal_h.json", "audioName": "HitMetal.wav"},
    {"id": 11, "src": $r("app.media.HitWood"), "name": "枪击木板", "vibratorFileL": "HitWood_l.json", "vibratorFileM": "HitWood_m.json", "vibratorFileH": "HitWood_h.json", "audioName": "HitWood.wav"},
    {"id": 12, "src": $r("app.media.HitGlass"), "name": "枪击玻璃", "vibratorFileL": "HitGlass_l.json", "vibratorFileM": "HitGlass_m.json", "vibratorFileH": "HitGlass_h.json", "audioName": "HitGlass.wav"},
  ]
  return ImagesDataArray;
}

export function getImageInstrumentsList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Cymbals"), "name": "钹", "vibratorFileL": "Cymbals_l.json", "vibratorFileM": "Cymbals_m.json", "vibratorFileH": "Cymbals_h.json", "audioName": "Cymbals.wav"},
    {"id": 1, "src": $r("app.media.Cymbals2"), "name": "大镲", "vibratorFileL": "Cymbals2_l.json", "vibratorFileM": "Cymbals2_m.json", "vibratorFileH": "Cymbals2_h.json", "audioName": "Cymbals2.wav"},
    {"id": 2, "src": $r("app.media.KickDrum"), "name": "底鼓", "vibratorFileL": "KickDrum_l.json", "vibratorFileM": "KickDrum_m.json", "vibratorFileH": "KickDrum_h.json", "audioName": "KickDrum.wav"},
    {"id": 3, "src": $r("app.media.KickDrum2"), "name": "底鼓2", "vibratorFileL": "KickDrum2_l.json", "vibratorFileM": "KickDrum2_m.json", "vibratorFileH": "KickDrum2_h.json", "audioName": "KickDrum2.wav"},
    {"id": 4, "src": $r("app.media.Guitar"), "name": "吉他", "vibratorFileL": "Guitar_l.json", "vibratorFileM": "Guitar_m.json", "vibratorFileH": "Guitar_h.json", "audioName": "Guitar.wav"},
    {"id": 5, "src": $r("app.media.Tambourine"), "name": "手鼓", "vibratorFileL": "Tambourine_l.json", "vibratorFileM": "Tambourine_m.json", "vibratorFileH": "Tambourine_h.json", "audioName": "Tambourine.wav"},
    {"id": 6, "src": $r("app.media.Bell"), "name": "钟", "vibratorFileL": "bell_l.json", "vibratorFileM": "bell_m.json", "vibratorFileH": "bell_h.json", "audioName": "bell.wav"},
    {"id": 7, "src": $r("app.media.Claves"), "name": "节奏棒", "vibratorFileL": "Claves_l.json", "vibratorFileM": "Claves_m.json", "vibratorFileH": "Claves_h.json", "audioName": "Claves.wav"},
    {"id": 8, "src": $r("app.media.Gong"), "name": "锣", "vibratorFileL": "Gong_l.json", "vibratorFileM": "Gong_m.json", "vibratorFileH": "Gong_h.json", "audioName": "Gong.wav"},
    {"id": 9, "src": $r("app.media.Triangle"), "name": "三角铁", "vibratorFileL": "triangle_l.json", "vibratorFileM": "triangle_m.json", "vibratorFileH": "triangle_h.json", "audioName": "triangle.wav"},
  ]
  return ImagesDataArray;
}

export function getImageRealisticList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Ice"), "name": "冰块", "vibratorFileL": "ice_l.json", "vibratorFileM": "ice_m.json", "vibratorFileH": "ice_h.json", "audioName": "ice.wav"},
    {"id": 1, "src": $r("app.media.Keyboard"), "name": "键盘", "vibratorFileL": "Keyboard_l.json", "vibratorFileM": "Keyboard_m.json", "vibratorFileH": "Keyboard_h.json", "audioName": "Keyboard.wav"},
    {"id": 2, "src": $r("app.media.Typewriter"), "name": "打字机", "vibratorFileL": "Typewriter_l.json", "vibratorFileM": "Typewriter_m.json", "vibratorFileH": "Typewriter_h.json", "audioName": "Typewriter.wav"},
    {"id": 3, "src": $r("app.media.CoinDrop"), "name": "金币掉落", "vibratorFileL": "CoinDrop_l.json", "vibratorFileM": "CoinDrop_m.json", "vibratorFileH": "CoinDrop_h.json", "audioName": "CoinDrop.wav"},
    {"id": 4, "src": $r("app.media.Timer"), "name": "定时器", "vibratorFileL": "timer_l.json", "vibratorFileM": "timer_m.json", "vibratorFileH": "timer_h.json", "audioName": "timer.wav"},
    {"id": 5, "src": $r("app.media.Walk"), "name": "走路", "vibratorFileL": "Walk_l.json", "vibratorFileM": "Walk_m.json", "vibratorFileH": "Walk_h.json", "audioName": "Walk.wav"},
    {"id": 6, "src": $r("app.media.camerashutter"), "name": "相机", "vibratorFileL": "camerashutter_l.json", "vibratorFileM": "camerashutter_m.json", "vibratorFileH": "camerashutter_h.json", "audioName": "camerashutter.wav"},
    {"id": 7, "src": $r("app.media.camerashutter2"), "name": "相机2", "vibratorFileL": "camerashutter2_l.json", "vibratorFileM": "camerashutter2_m.json", "vibratorFileH": "camerashutter2_h.json", "audioName": "camerashutter2.wav"},
    {"id": 8, "src": $r("app.media.Clock"), "name": "时钟", "vibratorFileL": "clock_l.json", "vibratorFileM": "clock_m.json", "vibratorFileH": "clock_h.json", "audioName": "clock.wav"},
    {"id": 9, "src": $r("app.media.Water"), "name": "落水", "vibratorFileL": "Water_l.json", "vibratorFileM": "Water_m.json", "vibratorFileH": "Water_h.json", "audioName": "Water.wav"},
    {"id": 10, "src": $r("app.media.heartbeat"), "name": "心跳", "vibratorFileL": "heartbeat_l.json", "vibratorFileM": "heartbeat_m.json", "vibratorFileH": "heartbeat_h.json", "audioName": "heartbeat.wav"},
    {"id": 11, "src": $r("app.media.Firework"), "name": "烟花", "vibratorFileL": "Firework_l.json", "vibratorFileM": "Firework_m.json", "vibratorFileH": "Firework_h.json", "audioName": "Firework.wav"},
    {"id": 12, "src": $r("app.media.Picker"), "name": "选择器", "vibratorFileL": "Picker_l.json", "vibratorFileM": "Picker_m.json", "vibratorFileH": "Picker_h.json", "audioName": "Picker.wav"},
  ]
  return ImagesDataArray;
}

export function getImageFootstepList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Footstep1"), "name": "地毯", "vibratorFileL": "OnCarpet_l.json", "vibratorFileM": "OnCarpet_m.json", "vibratorFileH": "OnCarpet_h.json", "audioName": "OnCarpet.wav"},
    {"id": 1, "src": $r("app.media.Footstep2"), "name": "水泥地面", "vibratorFileL": "OnConcrete_l.json", "vibratorFileM": "OnConcrete_m.json", "vibratorFileH": "OnConcrete_h.json", "audioName": "OnConcrete.wav"},
    {"id": 2, "src": $r("app.media.Footstep3"), "name": "草地", "vibratorFileL": "OnGrass_l.json", "vibratorFileM": "OnGrass_m.json", "vibratorFileH": "OnGrass_h.json", "audioName": "OnGrass.wav"},
    {"id": 3, "src": $r("app.media.Footstep4"), "name": "木板", "vibratorFileL": "OnWood_l.json", "vibratorFileM": "OnWood_m.json", "vibratorFileH": "OnWood_h.json", "audioName": "OnWood.wav"},
    {"id": 4, "src": $r("app.media.Footstep5"), "name": "沙地", "vibratorFileL": "OnGravel_l.json", "vibratorFileM": "OnGravel_m.json", "vibratorFileH": "OnGravel_h.json", "audioName": "OnGravel.wav"},
    {"id": 5, "src": $r("app.media.Footstep6"), "name": "泥地", "vibratorFileL": "OnMud_l.json", "vibratorFileM": "OnMud_m.json", "vibratorFileH": "OnMud_h.json", "audioName": "OnMud.wav"},
    {"id": 6, "src": $r("app.media.Footstep7"), "name": "雪地", "vibratorFileL": "OnSnow_l.json", "vibratorFileM": "OnSnow_m.json", "vibratorFileH": "OnSnow_h.json", "audioName": "OnSnow.wav"},
  ]
  return ImagesDataArray;
}

export function getImageEnvironmentList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Rain"), "name": "雨水", "vibratorFileL": "Rain_l.json", "vibratorFileM": "Rain_m.json", "vibratorFileH": "Rain_h.json", "audioName": "Rain.wav"},
    {"id": 1, "src": $r("app.media.Snowdrift"), "name": "风雪", "vibratorFileL": "Snowdrift_l.json", "vibratorFileM": "Snowdrift_m.json", "vibratorFileH": "Snowdrift_h.json", "audioName": "Snowdrift.wav"},
    {"id": 2, "src": $r("app.media.Campfire"), "name": "燃烧", "vibratorFileL": "Campfire_l.json", "vibratorFileM": "Campfire_m.json", "vibratorFileH": "Campfire_h.json", "audioName": "Campfire.wav"},
    {"id": 3, "src": $r("app.media.Creek"), "name": "溪流", "vibratorFileL": "Creek_l.json", "vibratorFileM": "Creek_m.json", "vibratorFileH": "Creek_h.json", "audioName": "Creek.wav"},
    {"id": 4, "src": $r("app.media.Wave"), "name": "冰川风暴", "vibratorFileL": "Wave_l.json", "vibratorFileM": "Wave_m.json", "vibratorFileH": "Wave_h.json", "audioName": "Wave.wav"},
    {"id": 5, "src": $r("app.media.Wind"), "name": "沙漠风暴", "vibratorFileL": "Wind_l.json", "vibratorFileM": "Wind_m.json", "vibratorFileH": "Wind_h.json", "audioName": "Wind.wav"},
    {"id": 6, "src": $r("app.media.Thunder"), "name": "闪电雷鸣", "vibratorFileL": "Thunder_l.json", "vibratorFileM": "Thunder_m.json", "vibratorFileH": "Thunder_h.json", "audioName": "Thunder.wav"},
  ]
  return ImagesDataArray;
}

export function getImageExerciseList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Badminton"), "name": "羽毛球", "vibratorFileL": "Badminton_l.json", "vibratorFileM": "Badminton_m.json", "vibratorFileH": "Badminton_h.json", "audioName": "Badminton.wav"},
    {"id": 1, "src": $r("app.media.Baseball"), "name": "棒球", "vibratorFileL": "Baseball_l.json", "vibratorFileM": "Baseball_m.json", "vibratorFileH": "Baseball_h.json", "audioName": "Baseball.wav"},
    {"id": 2, "src": $r("app.media.Basketball"), "name": "篮球", "vibratorFileL": "Basketball_l.json", "vibratorFileM": "Basketball_m.json", "vibratorFileH": "Basketball_h.json", "audioName": "Basketball.wav"},
    {"id": 3, "src": $r("app.media.Skating"), "name": "滑冰", "vibratorFileL": "Skating_l.json", "vibratorFileM": "Skating_m.json", "vibratorFileH": "Skating_h.json", "audioName": "Skating.wav"},
    {"id": 4, "src": $r("app.media.Skiing"), "name": "滑雪", "vibratorFileL": "Skiing_l.json", "vibratorFileM": "Skiing_m.json", "vibratorFileH": "Skiing_h.json", "audioName": "Skiing.wav"},
    {"id": 5, "src": $r("app.media.TableTennis"), "name": "兵乓球", "vibratorFileL": "TableTennis_l.json", "vibratorFileM": "TableTennis_m.json", "vibratorFileH": "TableTennis_h.json", "audioName": "TableTennis.wav"},
    {"id": 6, "src": $r("app.media.Diving"), "name": "跳水", "vibratorFileL": "Diving_l.json", "vibratorFileM": "Diving_m.json", "vibratorFileH": "Diving_h.json", "audioName": "Diving.wav"},
  ]
  return ImagesDataArray;
}

export abstract class BaseDataSource<T> implements IDataSource {
  private mDataSource: T[] = null;

  constructor(dataList: T[]) {
    this.mDataSource = dataList;
  }

  totalCount(): number {
    return this.mDataSource == null ? 0 : this.mDataSource.length
  }

  getData(index: number): T {
    return index >= 0 && index < this.totalCount() ? this.mDataSource[index] : null;
  }

  registerDataChangeListener(listener: DataChangeListener) {
  }

  unregisterDataChangeListener(listener: DataChangeListener) {
  }
}

export class ImageDataSource extends BaseDataSource<ImagesData> {
  constructor(students: ImagesData[]) {
    super(students)
  }
}
