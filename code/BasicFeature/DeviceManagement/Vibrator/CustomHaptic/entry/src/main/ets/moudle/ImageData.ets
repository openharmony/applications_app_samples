/*export class ImagesData {
  id: number
  src: Resource
  name: string
  vibratorFile:string
  audioName:string
}

export function getImageRacingList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Racing1"), "name": "撞击", "vibratorFile": "CarCrash_ohos.json" ,"audioName":  "CarCrash.wav"},
    {"id": 1, "src": $r("app.media.Racing2"), "name": "启动", "vibratorFile": "CarIgnite_ohos.json" ,"audioName": "CarIgnite.wav"},
    {"id": 2, "src": $r("app.media.Racing3"), "name": "漂移", "vibratorFile": "CarSkid_ohos.json" ,"audioName": "CarSkid.wav"},
    {"id": 3, "src": $r("app.media.Racing4"), "name": "漂移喷射", "vibratorFile": "DriftingJet_ohos.json" ,"audioName": "DriftingJet.wav"},
    {"id": 4, "src": $r("app.media.Racing5"), "name": "喷射", "vibratorFile": "JetN2O_ohos.json" ,"audioName": "JetN2O.wav"},
    {"id": 5, "src": $r("app.media.Racing6"), "name": "比赛出发", "vibratorFile": "RacingStart_ohos.json" ,"audioName": "RacingStart.wav"},
    {"id": 6, "src": $r("app.media.Racing8"), "name": "加速", "vibratorFile": "SpeedUp_ohos.json" ,"audioName": "SpeedUp.wav"},
  ]
  return ImagesDataArray;
}

export function getImageBattleList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Battle7"), "name": "翻滚", "vibratorFile": "Tumble_ohos.json" ,"audioName": "Tumble.wav"},
    {"id": 1, "src": $r("app.media.Battle2"), "name": "拳击", "vibratorFile": "Punch_ohos.json" ,"audioName": "Punch.wav"},
    {"id": 2, "src": $r("app.media.Battle3"), "name": "踢腿", "vibratorFile": "Kick_ohos.json" ,"audioName": "Kick.wav"},
    {"id": 3, "src": $r("app.media.Battle4"), "name": "受伤", "vibratorFile": "Hurt_ohos.json" ,"audioName": "Hurt.wav"},
    {"id": 4, "src": $r("app.media.Battle5"), "name": "爆炸", "vibratorFile": "Blast_ohos.json" ,"audioName": "Blast.wav"},
    {"id": 5, "src": $r("app.media.Battle6"), "name": "炸弹", "vibratorFile": "Bomb_ohos.json" ,"audioName": "Bomb.wav"},
  ]
  return ImagesDataArray;
}

export function getImageShootList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.AK47"), "name": "AK47", "vibratorFile": "AK47_ohos.json" ,"audioName": "AK47.wav"},
    {"id": 1, "src": $r("app.media.HK416"), "name": "HK416", "vibratorFile": "HK416_ohos.json" ,"audioName": "HK416.wav"},
    {"id": 2, "src": $r("app.media.M4"), "name": "M4", "vibratorFile": "M4_ohos.json" ,"audioName": "M4.wav"},
    {"id": 3, "src": $r("app.media.MP5"), "name": "MP5", "vibratorFile": "MP5_ohos.json" ,"audioName": "MP5.wav"},
    {"id": 4, "src": $r("app.media.CZ75"), "name": "CZ75", "vibratorFile": "CZ75_ohos.json" ,"audioName": "CZ75.wav"},
    {"id": 5, "src": $r("app.media.Winchester"), "name": "来福", "vibratorFile": "Winchester_ohos.json" ,"audioName": "Winchester.wav"},
    {"id": 6, "src": $r("app.media.Rifle"), "name": "步枪", "vibratorFile": "Rifle_ohos.json" ,"audioName": "Rifle.wav"},
    {"id": 7, "src": $r("app.media.AssaultRifle"), "name": "冲锋枪", "vibratorFile": "AssaultRifle_ohos.json" ,"audioName": "AssaultRifle.wav"},
    {"id": 8, "src": $r("app.media.HitSand"), "name": "枪击地面", "vibratorFile": "HitSand_ohos.json" ,"audioName": "HitSand.wav"},
    {"id": 9, "src": $r("app.media.HitWater"), "name": "枪击水面", "vibratorFile": "HitWater_ohos.json" ,"audioName": "HitWater.wav"},
    {"id": 10, "src": $r("app.media.HitMetal"), "name": "枪击金属", "vibratorFile": "HitMetal_ohos.json" ,"audioName": "HitMetal.wav"},
    {"id": 11, "src": $r("app.media.HitWood"), "name": "枪击木板", "vibratorFile": "HitWood_ohos.json" ,"audioName": "HitWood.wav"},
    {"id": 12, "src": $r("app.media.HitGlass"), "name": "枪击玻璃", "vibratorFile": "HitGlass_ohos.json" ,"audioName": "HitGlass.wav"},
  ]
  return ImagesDataArray;
}

export function getImageInstrumentsList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Cymbals"), "name": "钹", "vibratorFile": "Cymbals_ohos.json" ,"audioName": "Cymbals.wav"},
    {"id": 1, "src": $r("app.media.Cymbals2"), "name": "大镲", "vibratorFile": "Cymbals2_ohos.json" ,"audioName": "Cymbals2.wav"},
    {"id": 2, "src": $r("app.media.KickDrum"), "name": "底鼓", "vibratorFile": "Kick_Drum_ohos.json" ,"audioName": "KickDrum.wav"},
    {"id": 3, "src": $r("app.media.KickDrum2"), "name": "底鼓2", "vibratorFile": "Kick_Drum2_ohos.json" ,"audioName": "KickDrum2.wav"},
    {"id": 4, "src": $r("app.media.Guitar"), "name": "吉他", "vibratorFile": "Guitar_ohos.json" ,"audioName": "Guitar.wav"},
    {"id": 5, "src": $r("app.media.Tambourine"), "name": "手鼓", "vibratorFile": "Tambourine_ohos.json" ,"audioName": "Tambourine.wav"},
    {"id": 6, "src": $r("app.media.Bell"), "name": "钟", "vibratorFile": "bell_ohos.json" ,"audioName": "bell.wav"},
    {"id": 7, "src": $r("app.media.Claves"), "name": "节奏棒", "vibratorFile": "Claves_ohos.json" ,"audioName": "Claves.wav"},
    {"id": 8, "src": $r("app.media.Gong"), "name": "锣", "vibratorFile": "Gong_ohos.json" ,"audioName": "Gong.wav"},
    {"id": 9, "src": $r("app.media.Triangle"), "name": "三角铁", "vibratorFile": "triangle_ohos.json" ,"audioName": "triangle.wav"},
  ]
  return ImagesDataArray;
}

export function getImageRealisticList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Ice"), "name": "冰块", "vibratorFile": "ice_ohos.json" ,"audioName": "ice.wav"},
    {"id": 1, "src": $r("app.media.Keyboard"), "name": "键盘", "vibratorFile": "Keyboard_ohos.json" ,"audioName": "Keyboard.wav"},
    {"id": 2, "src": $r("app.media.Typewriter"), "name": "打字机", "vibratorFile": "Typewriter_ohos.json" ,"audioName": "Typewriter.wav"},
    {"id": 3, "src": $r("app.media.CoinDrop"), "name": "金币掉落", "vibratorFile": "CoinDrop_ohos.json" ,"audioName": "CoinDrop.wav"},
    {"id": 4, "src": $r("app.media.Timer"), "name": "定时器", "vibratorFile": "timer_ohos.json" ,"audioName": "timer.wav"},
    {"id": 5, "src": $r("app.media.Walk"), "name": "走路", "vibratorFile": "Walk_ohos.json" ,"audioName": "Walk.wav"},
    {"id": 6, "src": $r("app.media.camerashutter"), "name": "相机", "vibratorFile": "camerashutter_ohos.json" ,"audioName": "camerashutter.wav"},
    {"id": 7, "src": $r("app.media.camerashutter2"), "name": "相机2", "vibratorFile": "camerashutter2_ohos.json" ,"audioName": "camerashutter2.wav"},
    {"id": 8, "src": $r("app.media.Clock"), "name": "时钟", "vibratorFile": "clock_ohos.json" ,"audioName": "clock.wav"},
    {"id": 9, "src": $r("app.media.Water"), "name": "落水", "vibratorFile": "Water_ohos.json" ,"audioName": "Water.wav"},
    {"id": 10, "src": $r("app.media.heartbeat"), "name": "心跳", "vibratorFile": "heartbeat_ohos.json" ,"audioName": "heartbeat.wav"},
    {"id": 11, "src": $r("app.media.Firework"), "name": "烟花", "vibratorFile": "Firework_ohos.json" ,"audioName": "Firework.wav"},
    {"id": 12, "src": $r("app.media.Picker"), "name": "选择器", "vibratorFile": "Picker_ohos.json" ,"audioName": "Picker.wav"},
  ]
  return ImagesDataArray;
}

export function getImageFootstepList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Footstep1"), "name": "地毯", "vibratorFile": "OnCarpet_ohos.json" ,"audioName": "OnCarpet.wav"},
    {"id": 1, "src": $r("app.media.Footstep2"), "name": "水泥地面", "vibratorFile": "OnConcrete_ohos.json" ,"audioName": "OnConcrete.wav"},
    {"id": 2, "src": $r("app.media.Footstep3"), "name": "草地", "vibratorFile": "OnGrass_ohos.json" ,"audioName": "OnGrass.wav"},
    {"id": 3, "src": $r("app.media.Footstep4"), "name": "木板", "vibratorFile": "OnWood_ohos.json" ,"audioName": "OnWood.wav"},
    {"id": 4, "src": $r("app.media.Footstep5"), "name": "沙地", "vibratorFile": "OnGravel_ohos.json" ,"audioName": "OnGravel.wav"},
    {"id": 5, "src": $r("app.media.Footstep6"), "name": "泥地", "vibratorFile": "OnMud_ohos.json" ,"audioName": "OnMud.wav"},
    {"id": 6, "src": $r("app.media.Footstep7"), "name": "雪地", "vibratorFile": "OnSnow_ohos.json" ,"audioName": "OnSnow.wav"},
  ]
  return ImagesDataArray;
}

export function getImageEnvironmentList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Rain"), "name": "雨水", "vibratorFile": "Rain_ohos.json" ,"audioName": "Rain.wav"},
    {"id": 1, "src": $r("app.media.Snowdrift"), "name": "风雪", "vibratorFile": "Snowdrift_ohos.json" ,"audioName": "Snowdrift.wav"},
    {"id": 2, "src": $r("app.media.Campfire"), "name": "燃烧", "vibratorFile": "Campfire_ohos.json" ,"audioName": "Campfire.wav"},
    {"id": 3, "src": $r("app.media.Creek"), "name": "溪流", "vibratorFile": "Creek_ohos.json" ,"audioName": "Creek.wav"},
    {"id": 4, "src": $r("app.media.Wave"), "name": "冰川风暴", "vibratorFile": "Wave_ohos.json" ,"audioName": "Wave.wav"},
    {"id": 5, "src": $r("app.media.Wind"), "name": "沙漠风暴", "vibratorFile": "Wind_ohos.json" ,"audioName": "Wind.wav"},
    {"id": 6, "src": $r("app.media.Thunder"), "name": "闪电雷鸣", "vibratorFile": "Thunder_ohos.json" ,"audioName": "Thunder.wav"},
  ]
  return ImagesDataArray;
}

export function getImageExerciseList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Badminton"), "name": "羽毛球", "vibratorFile": "Badminton_ohos.json" ,"audioName": "Badminton.wav"},
    {"id": 1, "src": $r("app.media.Baseball"), "name": "棒球", "vibratorFile": "Baseball_ohos.json" ,"audioName": "Baseball.wav"},
    {"id": 2, "src": $r("app.media.Basketball"), "name": "篮球", "vibratorFile": "Basketball_ohos.json" ,"audioName": "Basketball.wav"},
    {"id": 3, "src": $r("app.media.Skating"), "name": "滑冰", "vibratorFile": "Skating_ohos.json" ,"audioName": "Skating.wav"},
    {"id": 4, "src": $r("app.media.Skiing"), "name": "滑雪", "vibratorFile": "Skiing_ohos.json" ,"audioName": "Skiing.wav"},
    {"id": 5, "src": $r("app.media.TableTennis"), "name": "兵乓球", "vibratorFile": "TableTennis_ohos.json" ,"audioName": "TableTennis.wav"},
    {"id": 6, "src": $r("app.media.Diving"), "name": "跳水", "vibratorFile": "Diving_ohos.json" ,"audioName": "Diving.wav"},
  ]
  return ImagesDataArray;
}*/

//强度选择

export class ImagesData {
  id: number
  src: Resource
  name: string
  vibratorFileL:string
  vibratorFileM:string
  vibratorFileH:string
  vibratorFileOHOS:string
  audioName:string
}
export function getImageRacingList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Racing1"), "name": "撞击", "vibratorFileL": "CarCrash_l.json", "vibratorFileM": "CarCrash_m.json", "vibratorFileH": "CarCrash_h.json", "audioName":  "CarCrash.wav", "vibratorFileOHOS": "CarCrash_ohos.json"},
    {"id": 1, "src": $r("app.media.Racing2"), "name": "启动", "vibratorFileL": "CarIgnite_l.json", "vibratorFileM": "CarIgnite_m.json", "vibratorFileH": "CarIgnite_h.json", "audioName": "CarIgnite.wav", "vibratorFileOHOS": "CarIgnite_ohos.json"},
    {"id": 2, "src": $r("app.media.Racing3"), "name": "漂移", "vibratorFileL": "CarSkid_l.json", "vibratorFileM": "CarSkid_m.json", "vibratorFileH": "CarSkid_h.json", "audioName": "CarSkid.wav", "vibratorFileOHOS": "CarSkid_ohos.json"},
    {"id": 3, "src": $r("app.media.Racing4"), "name": "漂移喷射", "vibratorFileL": "DriftingJet_l.json", "vibratorFileM": "DriftingJet_m.json", "vibratorFileH": "DriftingJet_h.json", "audioName": "DriftingJet.wav", "vibratorFileOHOS": "DriftingJet_ohos.json"},
    {"id": 4, "src": $r("app.media.Racing5"), "name": "喷射", "vibratorFileL": "JetN2O_l.json", "vibratorFileM": "JetN2O_m.json", "vibratorFileH": "JetN2O_h.json", "audioName": "JetN2O.wav", "vibratorFileOHOS": "JetN2O_ohos.json"},
    {"id": 5, "src": $r("app.media.Racing6"), "name": "比赛出发", "vibratorFileL": "RacingStart_l.json", "vibratorFileM": "RacingStart_m.json", "vibratorFileH": "RacingStart_h.json", "audioName": "RacingStart.wav", "vibratorFileOHOS": "RacingStart_ohos.json"},
    {"id": 6, "src": $r("app.media.Racing8"), "name": "加速", "vibratorFileL": "SpeedUp_l.json", "vibratorFileM": "SpeedUp_m.json", "vibratorFileH": "SpeedUp_h.json", "audioName": "SpeedUp.wav", "vibratorFileOHOS": "SpeedUp_ohos.json"},
  ]
  return ImagesDataArray;
}

export function getImageBattleList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Battle7"), "name": "翻滚", "vibratorFileL": "Tumble_l.json", "vibratorFileM": "Tumble_m.json", "vibratorFileH": "Tumble_h.json", "audioName": "Tumble.wav", "vibratorFileOHOS": "Tumble_ohos.json"},
    {"id": 1, "src": $r("app.media.Battle2"), "name": "拳击", "vibratorFileL": "Punch_l.json", "vibratorFileM": "Punch_m.json", "vibratorFileH": "Punch_h.json", "audioName": "Punch.wav", "vibratorFileOHOS": "Punch_ohos.json"},
    {"id": 2, "src": $r("app.media.Battle3"), "name": "踢腿", "vibratorFileL": "Kick_l.json", "vibratorFileM": "Kick_m.json", "vibratorFileH": "Kick_h.json", "audioName": "Kick.wav", "vibratorFileOHOS": "Kick_ohos.json"},
    {"id": 3, "src": $r("app.media.Battle4"), "name": "受伤", "vibratorFileL": "Hurt_l.json", "vibratorFileM": "Hurt_m.json", "vibratorFileH": "Hurt_h.json", "audioName": "Hurt.wav", "vibratorFileOHOS": "Hurt_ohos.json"},
    {"id": 4, "src": $r("app.media.Battle5"), "name": "爆炸", "vibratorFileL": "Blast_l.json", "vibratorFileM": "Blast_m.json", "vibratorFileH": "Blast_h.json", "audioName": "Blast.wav", "vibratorFileOHOS": "Blast_ohos.json"},
    {"id": 5, "src": $r("app.media.Battle6"), "name": "炸弹", "vibratorFileL": "Bomb_l.json", "vibratorFileM": "Bomb_m.json", "vibratorFileH": "Bomb_h.json", "audioName": "Bomb.wav", "vibratorFileOHOS": "Bomb_ohos.json"},
  ]
  return ImagesDataArray;
}

export function getImageShootList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.AK47"), "name": "AK47", "vibratorFileL": "AK47_l.json", "vibratorFileM": "AK47_m.json", "vibratorFileH": "AK47_h.json", "audioName": "AK47.wav", "vibratorFileOHOS": "AK47_ohos.json"},
    {"id": 1, "src": $r("app.media.HK416"), "name": "HK16", "vibratorFileL": "HK416_l.json", "vibratorFileM": "HK416_m.json", "vibratorFileH": "HK416_h.json", "audioName": "HK416.wav", "vibratorFileOHOS": "HK416_ohos.json"},
    {"id": 2, "src": $r("app.media.M4"), "name": "M4", "vibratorFileL": "M4_l.json", "vibratorFileM": "M4_m.json", "vibratorFileH": "M4_h.json", "audioName": "M4.wav", "vibratorFileOHOS": "M4_ohos.json"},
    {"id": 3, "src": $r("app.media.MP5"), "name": "MP5", "vibratorFileL": "MP5_l.json", "vibratorFileM": "MP5_m.json", "vibratorFileH": "MP5_h.json", "audioName": "MP5.wav", "vibratorFileOHOS": "MP5_ohos.json"},
    {"id": 4, "src": $r("app.media.CZ75"), "name": "CZ75", "vibratorFileL": "CZ75_l.json", "vibratorFileM": "CZ75_m.json", "vibratorFileH": "CZ75_h.json", "audioName": "CZ75.wav", "vibratorFileOHOS": "CZ75_ohos.json"},
    {"id": 5, "src": $r("app.media.Winchester"), "name": "来福", "vibratorFileL": "Winchester_l.json", "vibratorFileM": "Winchester_m.json", "vibratorFileH": "Winchester_h.json", "audioName": "Winchester.wav", "vibratorFileOHOS": "Winchester_ohos.json"},
    {"id": 6, "src": $r("app.media.Rifle"), "name": "步枪", "vibratorFileL": "Rifle_l.json", "vibratorFileM": "Rifle_m.json", "vibratorFileH": "Rifle_h.json", "audioName": "Rifle.wav", "vibratorFileOHOS": "Rifle_ohos.json"},
    {"id": 7, "src": $r("app.media.AssaultRifle"), "name": "冲锋枪", "vibratorFileL": "AssaultRifle_l.json", "vibratorFileM": "AssaultRifle_m.json", "vibratorFileH": "AssaultRifle_h.json", "audioName": "AssaultRifle.wav", "vibratorFileOHOS": "AssaultRifle_ohos.json"},
    {"id": 8, "src": $r("app.media.HitSand"), "name": "枪击地面", "vibratorFileL": "HitSand_l.json", "vibratorFileM": "HitSand_m.json", "vibratorFileH": "HitSand_h.json", "audioName": "HitSand.wav", "vibratorFileOHOS": "HitSand_ohos.json"},
    {"id": 9, "src": $r("app.media.HitWater"), "name": "枪击水面", "vibratorFileL": "HitWater_l.json", "vibratorFileM": "HitWater_m.json", "vibratorFileH": "HitWater_h.json", "audioName": "HitWater.wav", "vibratorFileOHOS": "HitWater_ohos.json"},
    {"id": 10, "src": $r("app.media.HitMetal"), "name": "枪击金属", "vibratorFileL": "HitMetal_l.json", "vibratorFileM": "HitMetal_m.json", "vibratorFileH": "HitMetal_h.json", "audioName": "HitMetal.wav", "vibratorFileOHOS": "HitMetal_ohos.json"},
    {"id": 11, "src": $r("app.media.HitWood"), "name": "枪击木板", "vibratorFileL": "HitWood_l.json", "vibratorFileM": "HitWood_m.json", "vibratorFileH": "HitWood_h.json", "audioName": "HitWood.wav", "vibratorFileOHOS": "HitWood_ohos.json"},
    {"id": 12, "src": $r("app.media.HitGlass"), "name": "枪击玻璃", "vibratorFileL": "HitGlass_l.json", "vibratorFileM": "HitGlass_m.json", "vibratorFileH": "HitGlass_h.json", "audioName": "HitGlass.wav", "vibratorFileOHOS": "HitGlass_ohos.json"},
  ]
  return ImagesDataArray;
}

export function getImageInstrumentsList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Cymbals"), "name": "钹", "vibratorFileL": "Cymbals_l.json", "vibratorFileM": "Cymbals_m.json", "vibratorFileH": "Cymbals_h.json", "audioName": "Cymbals.wav", "vibratorFileOHOS": "Cymbals_ohos.json"},
    {"id": 1, "src": $r("app.media.Cymbals2"), "name": "大镲", "vibratorFileL": "Cymbals2_l.json", "vibratorFileM": "Cymbals2_m.json", "vibratorFileH": "Cymbals2_h.json", "audioName": "Cymbals2.wav", "vibratorFileOHOS": "Cymbals2_ohos.json"},
    {"id": 2, "src": $r("app.media.KickDrum"), "name": "底鼓", "vibratorFileL": "KickDrum_l.json", "vibratorFileM": "KickDrum_m.json", "vibratorFileH": "KickDrum_h.json", "audioName": "KickDrum.wav", "vibratorFileOHOS": "KickDrum_ohos.json"},
    {"id": 3, "src": $r("app.media.KickDrum2"), "name": "底鼓2", "vibratorFileL": "KickDrum2_l.json", "vibratorFileM": "KickDrum2_m.json", "vibratorFileH": "KickDrum2_h.json", "audioName": "KickDrum2.wav", "vibratorFileOHOS": "KickDrum2_ohos.json"},
    {"id": 4, "src": $r("app.media.Guitar"), "name": "吉他", "vibratorFileL": "Guitar_l.json", "vibratorFileM": "Guitar_m.json", "vibratorFileH": "Guitar_h.json", "audioName": "Guitar.wav", "vibratorFileOHOS": "Guitar_ohos.json"},
    {"id": 5, "src": $r("app.media.Tambourine"), "name": "手鼓", "vibratorFileL": "Tambourine_l.json", "vibratorFileM": "Tambourine_m.json", "vibratorFileH": "Tambourine_h.json", "audioName": "Tambourine.wav", "vibratorFileOHOS": "Tambourine_ohos.json"},
    {"id": 6, "src": $r("app.media.Bell"), "name": "钟", "vibratorFileL": "bell_l.json", "vibratorFileM": "bell_m.json", "vibratorFileH": "bell_h.json", "audioName": "bell.wav", "vibratorFileOHOS": "bell_ohos.json"},
    {"id": 7, "src": $r("app.media.Claves"), "name": "节奏棒", "vibratorFileL": "Claves_l.json", "vibratorFileM": "Claves_m.json", "vibratorFileH": "Claves_h.json", "audioName": "Claves.wav", "vibratorFileOHOS": "Claves_ohos.json"},
    {"id": 8, "src": $r("app.media.Gong"), "name": "锣", "vibratorFileL": "Gong_l.json", "vibratorFileM": "Gong_m.json", "vibratorFileH": "Gong_h.json", "audioName": "Gong.wav", "vibratorFileOHOS": "Gong_ohos.json"},
    {"id": 9, "src": $r("app.media.Triangle"), "name": "三角铁", "vibratorFileL": "triangle_l.json", "vibratorFileM": "triangle_m.json", "vibratorFileH": "triangle_h.json", "audioName": "triangle.wav", "vibratorFileOHOS": "triangle_ohos.json"},
  ]
  return ImagesDataArray;
}

export function getImageRealisticList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Ice"), "name": "冰块", "vibratorFileL": "ice_l.json", "vibratorFileM": "ice_m.json", "vibratorFileH": "ice_h.json", "audioName": "ice.wav", "vibratorFileOHOS": "ice_ohos.json"},
    {"id": 1, "src": $r("app.media.Keyboard"), "name": "键盘", "vibratorFileL": "Keyboard_l.json", "vibratorFileM": "Keyboard_m.json", "vibratorFileH": "Keyboard_h.json", "audioName": "Keyboard.wav", "vibratorFileOHOS": "Keyboard_ohos.json"},
    {"id": 2, "src": $r("app.media.Typewriter"), "name": "打字机", "vibratorFileL": "Typewriter_l.json", "vibratorFileM": "Typewriter_m.json", "vibratorFileH": "Typewriter_h.json", "audioName": "Typewriter.wav", "vibratorFileOHOS": "Typewriter_ohos.json"},
    {"id": 3, "src": $r("app.media.CoinDrop"), "name": "金币掉落", "vibratorFileL": "CoinDrop_l.json", "vibratorFileM": "CoinDrop_m.json", "vibratorFileH": "CoinDrop_h.json", "audioName": "CoinDrop.wav", "vibratorFileOHOS": "CoinDrop_ohos.json"},
    {"id": 4, "src": $r("app.media.Timer"), "name": "定时器", "vibratorFileL": "timer_l.json", "vibratorFileM": "timer_m.json", "vibratorFileH": "timer_h.json", "audioName": "timer.wav", "vibratorFileOHOS": "timer_ohos.json"},
    {"id": 5, "src": $r("app.media.Walk"), "name": "走路", "vibratorFileL": "Walk_l.json", "vibratorFileM": "Walk_m.json", "vibratorFileH": "Walk_h.json", "audioName": "Walk.wav", "vibratorFileOHOS": "Walk_ohos.json"},
    {"id": 6, "src": $r("app.media.camerashutter"), "name": "相机", "vibratorFileL": "camerashutter_l.json", "vibratorFileM": "camerashutter_m.json", "vibratorFileH": "camerashutter_h.json", "audioName": "camerashutter.wav", "vibratorFileOHOS": "camerashutter_ohos.json"},
    {"id": 7, "src": $r("app.media.camerashutter2"), "name": "相机2", "vibratorFileL": "camerashutter2_l.json", "vibratorFileM": "camerashutter2_m.json", "vibratorFileH": "camerashutter2_h.json", "audioName": "camerashutter2.wav", "vibratorFileOHOS": "camerashutter2_ohos.json"},
    {"id": 8, "src": $r("app.media.Clock"), "name": "时钟", "vibratorFileL": "clock_l.json", "vibratorFileM": "clock_m.json", "vibratorFileH": "clock_h.json", "audioName": "clock.wav", "vibratorFileOHOS": "clock_ohos.json"},
    {"id": 9, "src": $r("app.media.Water"), "name": "落水", "vibratorFileL": "Water_l.json", "vibratorFileM": "Water_m.json", "vibratorFileH": "Water_h.json", "audioName": "Water.wav", "vibratorFileOHOS": "Water_ohos.json"},
    {"id": 10, "src": $r("app.media.heartbeat"), "name": "心跳", "vibratorFileL": "heartbeat_l.json", "vibratorFileM": "heartbeat_m.json", "vibratorFileH": "heartbeat_h.json", "audioName": "heartbeat.wav", "vibratorFileOHOS": "heartbeat_ohos.json"},
    {"id": 11, "src": $r("app.media.Firework"), "name": "烟花", "vibratorFileL": "Firework_l.json", "vibratorFileM": "Firework_m.json", "vibratorFileH": "Firework_h.json", "audioName": "Firework.wav", "vibratorFileOHOS": "Firework_ohos.json"},
    {"id": 12, "src": $r("app.media.Picker"), "name": "选择器", "vibratorFileL": "Picker_l.json", "vibratorFileM": "Picker_m.json", "vibratorFileH": "Picker_h.json", "audioName": "Picker.wav", "vibratorFileOHOS": "Picker_ohos.json"},
  ]
  return ImagesDataArray;
}

export function getImageFootstepList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Footstep1"), "name": "地毯", "vibratorFileL": "OnCarpet_l.json", "vibratorFileM": "OnCarpet_m.json", "vibratorFileH": "OnCarpet_h.json", "audioName": "OnCarpet.wav", "vibratorFileOHOS": "OnCarpet_ohos.json"},
    {"id": 1, "src": $r("app.media.Footstep2"), "name": "水泥地面", "vibratorFileL": "OnConcrete_l.json", "vibratorFileM": "OnConcrete_m.json", "vibratorFileH": "OnConcrete_h.json", "audioName": "OnConcrete.wav", "vibratorFileOHOS": "OnConcrete_ohos.json"},
    {"id": 2, "src": $r("app.media.Footstep3"), "name": "草地", "vibratorFileL": "OnGrass_l.json", "vibratorFileM": "OnGrass_m.json", "vibratorFileH": "OnGrass_h.json", "audioName": "OnGrass.wav", "vibratorFileOHOS": "OnGrass_ohos.json"},
    {"id": 3, "src": $r("app.media.Footstep4"), "name": "木板", "vibratorFileL": "OnWood_l.json", "vibratorFileM": "OnWood_m.json", "vibratorFileH": "OnWood_h.json", "audioName": "OnWood.wav", "vibratorFileOHOS": "OnWood_ohos.json"},
    {"id": 4, "src": $r("app.media.Footstep5"), "name": "沙地", "vibratorFileL": "OnGravel_l.json", "vibratorFileM": "OnGravel_m.json", "vibratorFileH": "OnGravel_h.json", "audioName": "OnGravel.wav", "vibratorFileOHOS": "OnGravel_ohos.json"},
    {"id": 5, "src": $r("app.media.Footstep6"), "name": "泥地", "vibratorFileL": "OnMud_l.json", "vibratorFileM": "OnMud_m.json", "vibratorFileH": "OnMud_h.json", "audioName": "OnMud.wav", "vibratorFileOHOS": "OnMud_ohos.json"},
    {"id": 6, "src": $r("app.media.Footstep7"), "name": "雪地", "vibratorFileL": "OnSnow_l.json", "vibratorFileM": "OnSnow_m.json", "vibratorFileH": "OnSnow_h.json", "audioName": "OnSnow.wav", "vibratorFileOHOS": "OnSnow_ohos.json"},
  ]
  return ImagesDataArray;
}

export function getImageEnvironmentList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Rain"), "name": "雨水", "vibratorFileL": "Rain_l.json", "vibratorFileM": "Rain_m.json", "vibratorFileH": "Rain_h.json", "audioName": "Rain.wav", "vibratorFileOHOS": "Rain_ohos.json"},
    {"id": 1, "src": $r("app.media.Snowdrift"), "name": "风雪", "vibratorFileL": "Snowdrift_l.json", "vibratorFileM": "Snowdrift_m.json", "vibratorFileH": "Snowdrift_h.json", "audioName": "Snowdrift.wav", "vibratorFileOHOS": "Snowdrift_ohos.json"},
    {"id": 2, "src": $r("app.media.Campfire"), "name": "燃烧", "vibratorFileL": "Campfire_l.json", "vibratorFileM": "Campfire_m.json", "vibratorFileH": "Campfire_h.json", "audioName": "Campfire.wav", "vibratorFileOHOS": "Campfire_ohos.json"},
    {"id": 3, "src": $r("app.media.Creek"), "name": "溪流", "vibratorFileL": "Creek_l.json", "vibratorFileM": "Creek_m.json", "vibratorFileH": "Creek_h.json", "audioName": "Creek.wav", "vibratorFileOHOS": "Creek_ohos.json"},
    {"id": 4, "src": $r("app.media.Wave"), "name": "冰川风暴", "vibratorFileL": "Wave_l.json", "vibratorFileM": "Wave_m.json", "vibratorFileH": "Wave_h.json", "audioName": "Wave.wav", "vibratorFileOHOS": "Wave_ohos.json"},
    {"id": 5, "src": $r("app.media.Wind"), "name": "沙漠风暴", "vibratorFileL": "Wind_l.json", "vibratorFileM": "Wind_m.json", "vibratorFileH": "Wind_h.json", "audioName": "Wind.wav", "vibratorFileOHOS": "Wind_ohos.json"},
    {"id": 6, "src": $r("app.media.Thunder"), "name": "闪电雷鸣", "vibratorFileL": "Thunder_l.json", "vibratorFileM": "Thunder_m.json", "vibratorFileH": "Thunder_h.json", "audioName": "Thunder.wav", "vibratorFileOHOS": "Thunder_ohos.json"},
  ]
  return ImagesDataArray;
}

export function getImageExerciseList() : Array<ImagesData> {
  let ImagesDataArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.Badminton"), "name": "羽毛球", "vibratorFileL": "Badminton_l.json", "vibratorFileM": "Badminton_m.json", "vibratorFileH": "Badminton_h.json", "audioName": "Badminton.wav", "vibratorFileOHOS": "Badminton_ohos.json"},
    {"id": 1, "src": $r("app.media.Baseball"), "name": "棒球", "vibratorFileL": "Baseball_l.json", "vibratorFileM": "Baseball_m.json", "vibratorFileH": "Baseball_h.json", "audioName": "Baseball.wav", "vibratorFileOHOS": "Baseball_ohos.json"},
    {"id": 2, "src": $r("app.media.Basketball"), "name": "篮球", "vibratorFileL": "Basketball_l.json", "vibratorFileM": "Basketball_m.json", "vibratorFileH": "Basketball_h.json", "audioName": "Basketball.wav", "vibratorFileOHOS": "Basketball_ohos.json"},
    {"id": 3, "src": $r("app.media.Skating"), "name": "滑冰", "vibratorFileL": "Skating_l.json", "vibratorFileM": "Skating_m.json", "vibratorFileH": "Skating_h.json", "audioName": "Skating.wav", "vibratorFileOHOS": "Skating_ohos.json"},
    {"id": 4, "src": $r("app.media.Skiing"), "name": "滑雪", "vibratorFileL": "Skiing_l.json", "vibratorFileM": "Skiing_m.json", "vibratorFileH": "Skiing_h.json", "audioName": "Skiing.wav", "vibratorFileOHOS": "Skiing_ohos.json"},
    {"id": 5, "src": $r("app.media.TableTennis"), "name": "兵乓球", "vibratorFileL": "TableTennis_l.json", "vibratorFileM": "TableTennis_m.json", "vibratorFileH": "TableTennis_h.json", "audioName": "TableTennis.wav", "vibratorFileOHOS": "TableTennis_ohos.json"},
    {"id": 6, "src": $r("app.media.Diving"), "name": "跳水", "vibratorFileL": "Diving_l.json", "vibratorFileM": "Diving_m.json", "vibratorFileH": "Diving_h.json", "audioName": "Diving.wav", "vibratorFileOHOS": "Diving_ohos.json"},
  ]
  return ImagesDataArray;
}


export class VideoImages {

}
/*export function getVideoImageList(): Array<ImagesData> {
  let VideoImageArray: Array<ImagesData> = [
    {"id": 0, "src": $r("app.media.image"), "name": "", "vibratorFile": "", "audioName":''},
  ]
  return VideoImageArray;
}*/

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