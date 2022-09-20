import Ability from '@ohos.application.Ability'

export default class MainAbility extends Ability {
  onCreate(want, launchParam) {
    console.log("[Sample_Vegetable] MainAbility onCreate")
    globalThis.abilityWant = want
  }

  onDestroy() {
    console.log("[Sample_Vegetable] MainAbility onDestroy")
  }

  onWindowStageCreate(windowStage) {
    // Main window is created, set main page for this ability
    console.log("[Sample_Vegetable] MainAbility onWindowStageCreate")

    windowStage.loadContent("pages/index/Index", (err, data) => {
      if (err.code) {
        console.error('Failed to load the content. Cause:' + JSON.stringify(err))
        return
      }
      console.info('Succeeded in loading the content. Data: ' + JSON.stringify(data))
    })
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    console.log("[Sample_Vegetable] MainAbility onWindowStageDestroy")
  }

  onForeground() {
    // Ability has brought to foreground
    console.log("[Sample_Vegetable] MainAbility onForeground")
  }

  onBackground() {
    // Ability has back to background
    console.log("[Sample_Vegetable] MainAbility onBackground")
  }
}
