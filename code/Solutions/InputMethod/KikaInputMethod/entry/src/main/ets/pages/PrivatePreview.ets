import inputMethod from '@ohos.inputMethod';
import inputMethodEngine from '@ohos.inputMethodEngine';
import Log from '../model/Log';
import { BusinessError } from '@ohos.base';

const TAG: string = 'PrivatePreview->';

@Entry
@Component
struct PrivatePreview {
  @State message: string = 'Hello World';
  @State accountText: string = ''; //177
  @State preViewText: string = ''; //helloworld
  @StorageLink('isTextPreviewSupported') isTextPreviewSupported: boolean = true;
  controllerPrivate: TextInputController = new TextInputController();
  controllerPreview: TextInputController = new TextInputController();

  aboutToAppear() {
    this.addLog(`private preview aboutToAppear begin!`);
    inputMethod.getSetting().showOptionalInputMethods().then((data: boolean) => {
      console.log('onPageShow Succeeded in showing optionalInputMethods.');
    }).catch((err: BusinessError) => {
      console.error(`onPageShow Failed to showOptionalInputMethods: ${JSON.stringify(err)}`);
    })
  }

  onPageShow() {
    this.addLog(`private command onPageShow!`);
  }

  addLog(message: string): void {
    Log.showInfo(TAG, `kikaInput-new: ${message}`);
  }

  build() {
    Column() {
      Text($r('app.string.Preview_Text'))
        .width("100%")
        .height(56)
        .fontFamily("HarmonyHeiTi-Medium")
        .fontSize("16fp")
        .fontColor("#182431")
        .lineHeight(22)
        .fontWeight(500)

      TextInput({
        text: this.preViewText,
        placeholder: $r('app.string.Preview_tip'),
        controller: this.controllerPreview
      })
        .placeholderFont({ size: 16, weight: 400 })
        .width("100%")
        .height(56)
        .margin(10)
        .fontSize(16)
        .fontColor('#182431')
        .backgroundColor('#FFFFFF')
        .border({ width: 1, color: Color.Gray, radius: 18 })
        .maxLength(50)
        .onChange((value: string) => {
          this.addLog('preViewText onChange.');
        })
        .onSubmit(() => {
          this.addLog('preViewText onSubmit.');
        })
    }
    .width('100%')
    .padding(20)
  }
}