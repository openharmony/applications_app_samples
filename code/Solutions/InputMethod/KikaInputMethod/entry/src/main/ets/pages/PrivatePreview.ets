import inputMethod from '@ohos.inputMethod';
import inputMethodEngine from '@ohos.inputMethodEngine';
import Log from '../model/Log';
import { BusinessError } from '@ohos.base';

// import { privatePreviewController } from '../model/PrivatePreviewController';

const TAG: string = 'PrivatePreview->';
const InputMethodEngine: inputMethodEngine.InputMethodAbility = inputMethodEngine.getInputMethodAbility();

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
    this.addLog(`private command onPageShow begin!`);
    // try {
    //   let defaultIme = inputMethod.getDefaultInputMethod();
    // } catch(err) {
    //   console.error(`Failed to getDefaultInputMethod: ${JSON.stringify(err)}`);
    // }
    // inputMethod.getSetting().showOptionalInputMethods();

    // privatePreviewController.onCreate(this.context);

    // inputMethod.getSetting().showOptionalInputMethods().then((data: boolean) => {
    //   console.log('onPageShow Succeeded in showing optionalInputMethods.');
    // }).catch((err: BusinessError) => {
    //   console.error(`onPageShow Failed to showOptionalInputMethods: ${JSON.stringify(err)}`);
    // })

    // try {// getInputMethodEngine  getInputMethodAbility
    //   inputMethodEngine.getInputMethodAbility().on('inputStart', (kbController: inputMethodEngine.KeyboardController, textInputClient: inputMethodEngine.InputClient) => {
    //       this.addLog('onPageShow keyboard inputStart');
    //       // this.inputHandle.onInputStart(kbController, textInputClient);
    //       let inputClient = textInputClient;
    //     })
    // } catch (err) {
    //       let error = err as BusinessError;
    //       this.addLog(`onPageShow keyboard inputStart command error: ${error.code} ${error.message}`);
    // }
  }

  addLog(message: string): void {
    Log.showInfo(TAG, `kikaInput-new: ${message}`);
  }

  build() {
    Column() {
      // Text(this.message)
      //   .fontSize(50)
      //   .fontWeight(FontWeight.Bold)

      Text($r('app.string.Preview_Text'))
        .width("100%")
        .height(56)// .position({ x: "7%", y: "0vp" })
        .fontFamily("HarmonyHeiTi-Medium")
        .fontSize("16fp")
        .fontColor("#182431")
        .lineHeight(22)
        .fontWeight(500)

      TextInput({
        text: this.preViewText,
        placeholder: $r('app.string.Preview_tip'), //'The text area can hold an unlimited amount of text. input your word...'
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
          // this.preViewText = value
          this.addLog('preViewText onChange begin.');
        })
        .onSubmit(() => {
          this.addLog('preViewText onSubmit begin.');
        })
    }
    .width('100%')
    .padding(20)
  }
}