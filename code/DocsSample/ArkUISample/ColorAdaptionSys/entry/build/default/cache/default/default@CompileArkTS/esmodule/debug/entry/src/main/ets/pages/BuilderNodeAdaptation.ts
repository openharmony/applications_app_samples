if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Index_Params {
    message?: string;
    colorText?: string;
    textNodeController?: TextNodeController;
    currentMode?: number;
}
interface TextBuilder_Params {
    message?: string;
}
import { NodeController, BuilderNode } from "@ohos:arkui.node";
import { FrameCallback } from "@ohos:arkui.UIContext";
import type { FrameNode } from "@ohos:arkui.node";
import type { UIContext } from "@ohos:arkui.UIContext";
import ConfigurationConstant from "@ohos:app.ability.ConfigurationConstant";
import type AbilityConstant from "@ohos:app.ability.AbilityConstant";
import type { Configuration } from "@ohos:app.ability.Configuration";
import type EnvironmentCallback from "@ohos:app.ability.EnvironmentCallback";
import hilog from "@ohos:hilog";
const TAG = '[Sample_ColorAdaption_Sys]';
const DOMAIN = 0xFF00;
class Params {
    public text: string = '';
    constructor(text: string) {
        this.text = text;
    }
}
class TextBuilder extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__message = new SynchedPropertySimpleOneWayPU(params.message, this, "message");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: TextBuilder_Params) {
        if (params.message === undefined) {
            this.__message.set('TextBuilder');
        }
    }
    updateStateVars(params: TextBuilder_Params) {
        this.__message.reset(params.message);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__message.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__message.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    // 作为自定义组件中需要更新的属性，数据类型为基础属性，定义为@Prop
    private __message: SynchedPropertySimpleOneWayPU<string>;
    get message() {
        return this.__message.get();
    }
    set message(newValue: string) {
        this.__message.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.message);
            Text.fontSize(50);
            Text.fontWeight(FontWeight.Bold);
            Text.margin({ bottom: 36 });
        }, Text);
        Text.pop();
        Column.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
function buildText(params: Params, parent = null) {
    const __params__ = params;
    (parent ? parent : this).observeComponentCreation2((elmtId, isInitialRender, params = __params__) => {
        Column.create();
        Column.backgroundColor({ "id": 125829129, "type": 10001, params: [], "bundleName": "com.samples.ColorAdaption", "moduleName": "entry" });
    }, Column);
    (parent ? parent : this).observeComponentCreation2((elmtId, isInitialRender, params = __params__) => {
        Text.create(params.text);
        Text.fontSize(50);
        Text.fontWeight(FontWeight.Bold);
        Text.margin({ bottom: 36 });
    }, Text);
    Text.pop();
    {
        (parent ? parent : this).observeComponentCreation2((elmtId, isInitialRender, params = __params__) => {
            if (isInitialRender) {
                let componentCall = new TextBuilder(parent ? parent : this, { message: params.text }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/BuilderNodeAdaptation.ets", line: 56, col: 5 });
                ViewPU.create(componentCall);
                let paramsLambda = () => {
                    return {
                        message: params.text
                    };
                };
                componentCall.paramsGenerator_ = paramsLambda;
            }
            else {
                (parent ? parent : this).updateStateVarsOfChildByElmtId(elmtId, {
                    message: params.text
                });
            }
        }, { name: "TextBuilder" });
    }
    Column.pop();
}
// 继承NodeController实现自定义textNode控制器
class TextNodeController extends NodeController {
    private textNode: BuilderNode<[
        Params
    ]> | null = null;
    private message: string = '';
    constructor(message: string) {
        super();
        this.message = message;
    }
    makeNode(context: UIContext): FrameNode | null {
        return this.textNode?.getFrameNode() ? this.textNode?.getFrameNode() : null;
    }
    createNode(context: UIContext) {
        this.textNode = new BuilderNode(context);
        this.textNode.build(wrapBuilder<[
            Params
        ]>(buildText), new Params(this.message));
        builderNodeMap.push(this.textNode);
    }
    deleteNode() {
        let node = builderNodeMap.pop();
        node?.dispose();
    }
    update(message: string) {
        if (this.textNode !== null) {
            // 调用update进行更新
            this.textNode.update(new Params(message));
        }
    }
}
// [Start custom_node]
// 记录创建的自定义节点对象
const builderNodeMap: BuilderNode<[
    Params
]>[] = [];
class MyFrameCallback extends FrameCallback {
    onFrame() {
        updateColorMode();
    }
}
function updateColorMode() {
    builderNodeMap.forEach((value, index) => {
        // 通知BuilderNode环境变量改变，触发深浅色切换
        value.updateConfiguration();
    });
}
class Index extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__message = new ObservedPropertySimplePU('hello', this, "message");
        this.__colorText = new ObservedPropertySimplePU('light', this, "colorText");
        this.textNodeController = new TextNodeController(this.message);
        this.__currentMode = this.createStorageProp('currentColorMode', ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT, "currentMode");
        this.setInitiallyProvidedValue(params);
        this.declareWatch("currentMode", this.onColorModeChange);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Index_Params) {
        if (params.message !== undefined) {
            this.message = params.message;
        }
        if (params.colorText !== undefined) {
            this.colorText = params.colorText;
        }
        if (params.textNodeController !== undefined) {
            this.textNodeController = params.textNodeController;
        }
    }
    updateStateVars(params: Index_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__message.purgeDependencyOnElmtId(rmElmtId);
        this.__colorText.purgeDependencyOnElmtId(rmElmtId);
        this.__currentMode.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__message.aboutToBeDeleted();
        this.__colorText.aboutToBeDeleted();
        this.__currentMode.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __message: ObservedPropertySimplePU<string>;
    get message() {
        return this.__message.get();
    }
    set message(newValue: string) {
        this.__message.set(newValue);
    }
    private __colorText: ObservedPropertySimplePU<string>;
    get colorText() {
        return this.__colorText.get();
    }
    set colorText(newValue: string) {
        this.__colorText.set(newValue);
    }
    private textNodeController: TextNodeController;
    // [Start prop_sys]
    private __currentMode: ObservedPropertyAbstractPU<number>;
    get currentMode() {
        return this.__currentMode.get();
    }
    set currentMode(newValue: number) {
        this.__currentMode.set(newValue);
    }
    // [End prop_sys]
    // [EndExclude custom_node]
    // [Start color_mode_change_appear]
    aboutToAppear(): void {
        // [StartExclude custom_node]
        // [StartExclude color_mode_change_appear]
        let environmentCallback: EnvironmentCallback = {
            onMemoryLevel: (level: AbilityConstant.MemoryLevel): void => {
                hilog.info(DOMAIN, TAG, 'onMemoryLevel');
            },
            onConfigurationUpdated: (config: Configuration): void => {
                hilog.info(DOMAIN, TAG, 'onConfigurationUpdated ' + JSON.stringify(config));
                // [EndExclude custom_node]
                this.getUIContext()?.postFrameCallback(new MyFrameCallback());
                // [StartExclude custom_node]
            }
        };
        // 注册监听回调
        this.getUIContext().getHostContext()?.getApplicationContext().on('environment', environmentCallback);
        // 设置应用深浅色跟随系统
        this.getUIContext()
            .getHostContext()?.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
        // 创建自定义节点并添加至map
        this.textNodeController.createNode(this.getUIContext());
        // [EndExclude color_mode_change_appear]
        if (this.currentMode == ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
            // 当前为浅色模式，资源初始化逻辑
            // [StartExclude color_mode_change_appear]
            this.colorText == 'light';
            // [EndExclude color_mode_change_appear]
        }
        else {
            // 当前为深色模式，资源初始化逻辑
            // [StartExclude color_mode_change_appear]
            this.colorText == 'dark';
            // [EndExclude color_mode_change_appear]
        }
        // [EndExclude custom_node]
    }
    // [End color_mode_change_appear]
    // [End custom_node]
    // [Start color_mode_change]
    onColorModeChange(): void {
        if (this.currentMode == ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
            // 当前为浅色模式，资源初始化逻辑
            // [StartExclude color_mode_change]
            this.colorText = 'light';
            // [EndExclude color_mode_change]
        }
        else {
            // 当前为深色模式，资源初始化逻辑
            // [StartExclude color_mode_change]
            this.colorText = 'dark';
            // [EndExclude color_mode_change]
        }
    }
    // [End color_mode_change]
    aboutToDisappear(): void {
        // 移除map中的引用，并将自定义节点释放
        this.textNodeController.deleteNode();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.height('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            NodeContainer.create(this.textNodeController);
            NodeContainer.width('100%');
            NodeContainer.height(200);
            NodeContainer.backgroundColor('#FFF0F0F0');
        }, NodeContainer);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('Switch to Dark Mode');
            Button.onClick(() => {
                this.getUIContext()
                    .getHostContext()?.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
            });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('Switch to Light Mode');
            Button.onClick(() => {
                this.getUIContext()
                    .getHostContext()?.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
            });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('Switch to Color Not Set');
            Button.onClick(() => {
                this.getUIContext()
                    .getHostContext()?.getApplicationContext()
                    .setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
            });
        }, Button);
        Button.pop();
        Column.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Index";
    }
}
registerNamedRoute(() => new Index(undefined, {}), "", { bundleName: "com.samples.ColorAdaption", moduleName: "entry", pagePath: "pages/BuilderNodeAdaptation", pageFullPath: "entry/src/main/ets/pages/BuilderNodeAdaptation", integratedHsp: "false", moduleType: "followWithHap" });
