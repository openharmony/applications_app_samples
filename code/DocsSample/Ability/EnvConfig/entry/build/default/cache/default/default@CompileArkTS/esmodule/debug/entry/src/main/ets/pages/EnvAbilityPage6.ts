if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Index_Params {
    context?;
    callbackId?: number;
}
import type common from "@ohos:app.ability.common";
import type EnvironmentCallback from "@ohos:app.ability.EnvironmentCallback";
import type { Configuration as Configuration } from "@ohos:app.ability.Configuration";
import hilog from "@ohos:hilog";
import type { BusinessError as BusinessError } from "@ohos:base";
const TAG: string = '[MyAbility]';
const DOMAIN_NUMBER: number = 0xFF00;
class Index extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.context = this.getUIContext().getHostContext() as common.UIAbilityContext;
        this.callbackId = 0;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Index_Params) {
        if (params.context !== undefined) {
            this.context = params.context;
        }
        if (params.callbackId !== undefined) {
            this.callbackId = params.callbackId;
        }
    }
    updateStateVars(params: Index_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private context;
    private callbackId: number; // 注册订阅系统环境变化的ID
    subscribeConfigurationUpdate(): void {
        let systemLanguage: string | undefined = this.context.config.language; // 获取系统当前语言
        // 1.获取ApplicationContext
        let applicationContext = this.context.getApplicationContext();
        // 2.通过applicationContext订阅环境变量变化
        let environmentCallback: EnvironmentCallback = {
            onConfigurationUpdated(newConfig: Configuration) {
                hilog.info(DOMAIN_NUMBER, TAG, `onConfigurationUpdated systemLanguage is ${systemLanguage}, newConfig: ${JSON.stringify(newConfig)}`);
                if (systemLanguage !== newConfig.language) {
                    hilog.info(DOMAIN_NUMBER, TAG, `systemLanguage from ${systemLanguage} changed to ${newConfig.language}`);
                    systemLanguage = newConfig.language; // 将变化之后的系统语言保存，作为下一次变化前的系统语言
                }
            },
            onMemoryLevel(level) {
                hilog.info(DOMAIN_NUMBER, TAG, `onMemoryLevel level: ${level}`);
            }
        };
        try {
            this.callbackId = applicationContext.on('environment', environmentCallback);
        }
        catch (err) {
            let code = (err as BusinessError).code;
            let message = (err as BusinessError).message;
            hilog.error(DOMAIN_NUMBER, TAG, `Failed to register applicationContext. Code is ${code}, message is ${message}`);
        }
    }
    // 页面展示
    initialRender() {
        //...
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Index";
    }
}
registerNamedRoute(() => new Index(undefined, {}), "", { bundleName: "com.example.envconfig", moduleName: "entry", pagePath: "pages/EnvAbilityPage6", pageFullPath: "entry/src/main/ets/pages/EnvAbilityPage6", integratedHsp: "false", moduleType: "followWithHap" });
