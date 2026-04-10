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

#include <map>
#include <string>
#include "napi_settings.h"
#include "napi_settings_log.h"

namespace OHOS {
namespace Settings {
class Date {
public:
    static const std::string dateFormat;
    static const std::string timeFormat;
    static const std::string autoGainTime;
    static const std::string autoGainTimeZone;
};

class Display {
public:
    static const std::string fontScale;
    static const std::string screenBrightnessStatus;
    static const std::string autoScreenBrightness;
    static const int autoScreenBrightnessMode;
    static const int manualScreenBrightnessMode;
    static const std::string screenOffTimeout;
    static const std::string defaultScreenRotation;
    static const std::string animatorDurationScale;
    static const std::string transitionAnimationScale;
    static const std::string windowAnimationScale;
    static const std::string displayInversionStatus;
};

class General {
public:
    static const std::string setupWizardFinished;
    static const std::string endButtonAction;
    static const std::string airplaneModeStatus;
    static const std::string accelerometerRotationStatus;
    static const std::string deviceProvisionStatus;
    static const std::string hdcStatus;
    static const std::string bootCounting;
    static const std::string contactMetadataSyncStatus;
    static const std::string developmentSettingsStatus;
    static const std::string deviceName;
    static const std::string usbStorageStatus;
    static const std::string debuggerWaiting;
    static const std::string debugAppPackage;
    static const std::string assistiveStatus;
    static const std::string enabledAssistiveServices;
    static const std::string geolocationOriginsAllowed;
    static const std::string skipUseHints;
    static const std::string touchExplorationStatus;
};

class Input {
public:
    static const std::string defaultInputMethod;
    static const std::string activatedInputMethodSubMode;
    static const std::string activatedInputMethods;
    static const std::string selectorVisibilityForInputMethod;
    static const std::string autoCapsTextInput;
    static const std::string autoPunctuateTextInput;
    static const std::string autoReplaceTextInput;
    static const std::string showPasswordTextInput;
};

class Network {
public:
    static const std::string dataRoamingStatus;
    static const std::string httpProxyCfg;
    static const std::string networkPreferenceUsage;
};

class Phone {
public:
    static const std::string rttCallingStatus;
};

class Sound {
public:
    static const std::string vibrateWhileRinging;
    static const std::string defaultAlarmAlert;
    static const std::string dtmfToneTypeWhileDialing;
    static const std::string dtmfToneWhileDialing;
    static const std::string hapticFeedbackStatus;
    static const std::string affectedModeRingerStreams;
    static const std::string affectedMuteStreams;
    static const std::string defaultNotificationSound;
    static const std::string defaultRingtone;
    static const std::string soundEffectsStatus;
    static const std::string vibrateStatus;
    // temp audio key, it will be modify in the feature
    static const std::string audioRingtone;
    static const std::string audioMedia;
    static const std::string audioVoicecall;
};

class TTS {
public:
    static const std::string defaultTtsPitch;
    static const std::string defaultTtsRate;
    static const std::string defaultTtsSynth;
    static const std::string enabledTtsPlugins;
};

class Wireless {
public:
    static const std::string bluetoothRadio;
    static const std::string cellRadio;
    static const std::string nfcRadio;
    static const std::string airplaneModeRadios;
    static const std::string bluetoothStatus;
    static const std::string bluetoothDiscoverAbilityStatus;
    static const std::string bluetoothDiscoverTimeout;
    static const std::string wifiDhcpMaxRetryCount;
    static const std::string wifiToMobileDataAwakeTimeout;
    static const std::string wifiStatus;
    static const std::string wifiWatchdogStatus;
    static const std::string wifiRadio;
    static const std::string ownerLockdownWifiCfg;
};

const std::string Date::dateFormat = "settings.date.date_format";
const std::string Date::timeFormat = "settings.date.time_format";
const std::string Date::autoGainTime = "settings.date.auto_gain_time";
const std::string Date::autoGainTimeZone = "settings.date.auto_gain_time_zone";

const std::string Display::fontScale = "settings.display.font_scale";
const std::string Display::screenBrightnessStatus = "settings.display.screen_brightness_status";
const std::string Display::autoScreenBrightness = "settings.display.auto_screen_brightness";
const int Display::autoScreenBrightnessMode = 1;
const int Display::manualScreenBrightnessMode = 0;
const std::string Display::screenOffTimeout = "settings.display.screen_off_timeout";
const std::string Display::defaultScreenRotation = "settings.display.default_screen_rotation";
const std::string Display::animatorDurationScale = "settings.display.animator_duration_scale";
const std::string Display::transitionAnimationScale = "settings.display.transition_animation_scale";
const std::string Display::windowAnimationScale = "settings.display.window_animation_scale";
const std::string Display::displayInversionStatus = "settings.display.display_inversion_status";

const std::string General::setupWizardFinished = "settings.general.setup_wizard_finished";
const std::string General::endButtonAction = "settings.general.end_button_action";
const std::string General::airplaneModeStatus = "settings.general.airplane_mode_status";
const std::string General::accelerometerRotationStatus = "settings.general.accelerometer_rotation_status";
const std::string General::deviceProvisionStatus = "settings.general.device_provision_status";
const std::string General::hdcStatus = "settings.general.hdc_status";
const std::string General::bootCounting = "settings.general.boot_counting";
const std::string General::contactMetadataSyncStatus = "settings.general.contact_metadata_sync_status";
const std::string General::developmentSettingsStatus = "settings.general.development_settings_status";
const std::string General::deviceName = "settings.general.device_name";
const std::string General::usbStorageStatus = "settings.general.usb_storage_status";
const std::string General::debuggerWaiting = "settings.general.debugger_waiting";
const std::string General::debugAppPackage = "settings.general.debug_app_package";
const std::string ASSISTIVE_FEATURE_LABEL = "access" "ibility";
const std::string General::assistiveStatus =
    "settings.general." + ASSISTIVE_FEATURE_LABEL + "_status";
const std::string General::enabledAssistiveServices =
    "settings.general.enabled_" + ASSISTIVE_FEATURE_LABEL + "_services";
const std::string General::geolocationOriginsAllowed = "settings.general.geolocation_origins_allowed";
const std::string General::skipUseHints = "settings.general.skip_use_hints";
const std::string General::touchExplorationStatus = "settings.general.touch_exploration_status";

const std::string Input::defaultInputMethod = "settings.input.default_input_method";
const std::string Input::activatedInputMethodSubMode = "settings.input.activated_input_method_submode";
const std::string Input::activatedInputMethods = "settings.input.activated_input_methods";
const std::string Input::selectorVisibilityForInputMethod = "settings.input.selector_visibility_for_input_method";
const std::string Input::autoCapsTextInput = "settings.input.auto_caps_text_input";
const std::string Input::autoPunctuateTextInput = "settings.input.auto_punctuate_text_input";
const std::string Input::autoReplaceTextInput = "settings.input.auto_replace_text_input";
const std::string Input::showPasswordTextInput = "settings.input.show_password_text_input";

const std::string Network::dataRoamingStatus = "settings.network.data_roaming_status";
const std::string Network::httpProxyCfg = "settings.network.http_proxy_cfg";
const std::string Network::networkPreferenceUsage = "settings.network.network_preference_usage";

const std::string Phone::rttCallingStatus = "settings.phone.rtt_calling_status";

const std::string Sound::vibrateWhileRinging = "settings.sound.vibrate_while_ringing";
const std::string Sound::defaultAlarmAlert = "settings.sound.default_alarm_alert";
const std::string Sound::dtmfToneTypeWhileDialing = "settings.sound.dtmf_tone_type_while_dialing";
const std::string Sound::dtmfToneWhileDialing = "settings.sound.dtmf_tone_while_dialing";
const std::string Sound::hapticFeedbackStatus = "settings.sound.haptic_feedback_status";
const std::string Sound::affectedModeRingerStreams = "settings.sound.affected_mode_ringer_streams";
const std::string Sound::affectedMuteStreams = "settings.sound.affected_mute_streams";
const std::string Sound::defaultNotificationSound = "settings.sound.default_notification_sound";
const std::string Sound::defaultRingtone = "settings.sound.default_ringtone";
const std::string Sound::soundEffectsStatus = "settings.sound.sound_effects_status";
const std::string Sound::vibrateStatus = "settings.sound.vibrate_status";

const std::string TTS::defaultTtsPitch = "settings.tts.default_tts_pitch";
const std::string TTS::defaultTtsRate = "settings.tts.default_tts_rate";
const std::string TTS::defaultTtsSynth = "settings.tts.default_tts_synth";
const std::string TTS::enabledTtsPlugins = "settings.tts.enabled_tts_plugins";

const std::string Wireless::bluetoothRadio = "settings.wireless.bluetooth_radio";
const std::string Wireless::cellRadio = "settings.wireless.cell_radio";
const std::string Wireless::nfcRadio = "settings.wireless.nfc_radio";
const std::string Wireless::airplaneModeRadios = "settings.wireless.airplane_mode_radios";
const std::string Wireless::bluetoothStatus = "settings.wireless.bluetooth_status";
const std::string Wireless::bluetoothDiscoverAbilityStatus = "settings.wireless.bluetooth_discoverability_status";
const std::string Wireless::bluetoothDiscoverTimeout = "settings.wireless.bluetooth_discover_timeout";
const std::string Wireless::wifiDhcpMaxRetryCount = "settings.wireless.wifi_dhcp_max_retry_count";
const std::string Wireless::wifiToMobileDataAwakeTimeout = "settings.wireless.wifi_to_mobile_data_awake_timeout";
const std::string Wireless::wifiStatus = "settings.wireless.wifi_status";
const std::string Wireless::wifiWatchdogStatus = "settings.wireless.wifi_watchdog_status";
const std::string Wireless::wifiRadio = "settings.wireless.wifi_radio";
const std::string Wireless::ownerLockdownWifiCfg = "settings.wireless.owner_lockdown_wifi_cfg";

const std::string DATE_CLASS_NAME = "date";
const std::string DISPLAY_CLASS_NAME = "display";
const std::string GENERAL_CLASS_NAME = "general";
const std::string INPUT_CLASS_NAME = "input";
const std::string NETWORK_CLASS_NAME = "network";
const std::string PHONE_CLASS_NAME = "phone";
const std::string SOUND_CLASS_NAME = "sound";
const std::string TTS_CLASS_NAME = "tts";
const std::string WIRELESS_CLASS_NAME = "wireless";

napi_value ClassConstructor(napi_env env, napi_callback_info info)
{
    SETTING_LOG_INFO("%{public}s is called", __FUNCTION__);
    size_t argc = 0;
    napi_value argv = nullptr;
    napi_value thisArg = nullptr;
    void* data = nullptr;
    napi_get_cb_info(env, info, &argc, &argv, &thisArg, &data);

    napi_value global = 0;
    napi_get_global(env, &global);
    SETTING_LOG_INFO("%{public}s is end", __FUNCTION__);
    return thisArg;
}

void AddStringProperty(napi_env env, std::map<const char*, napi_value>& paramMap,
    const char* propertyName, const std::string& propertyValue)
{
    napi_value napiProperty = nullptr;
    napi_create_string_utf8(env, propertyValue.c_str(), NAPI_AUTO_LENGTH, &napiProperty);
    paramMap[propertyName] = napiProperty;
}

void AddInt32Property(napi_env env, std::map<const char*, napi_value>& paramMap,
    const char* propertyName, int32_t propertyValue)
{
    napi_value napiProperty = nullptr;
    napi_create_int32(env, propertyValue, &napiProperty);
    paramMap[propertyName] = napiProperty;
}

void InitDateMap(napi_env env, std::map<const char*, napi_value>& paramMap)
{
    AddStringProperty(env, paramMap, "dateFormat", Date::dateFormat);
    AddStringProperty(env, paramMap, "timeFormat", Date::timeFormat);
    AddStringProperty(env, paramMap, "autoGainTime", Date::autoGainTime);
    AddStringProperty(env, paramMap, "autoGainTimeZone", Date::autoGainTimeZone);
}

void InitDisplayMap(napi_env env, std::map<const char*, napi_value>& paramMap)
{
    AddStringProperty(env, paramMap, "fontScale", Display::fontScale);
    AddStringProperty(env, paramMap, "screenBrightnessStatus", Display::screenBrightnessStatus);
    AddStringProperty(env, paramMap, "autoScreenBrightness", Display::autoScreenBrightness);
    AddInt32Property(env, paramMap, "autoScreenBrightnessMode", Display::autoScreenBrightnessMode);
    AddInt32Property(env, paramMap, "manualScreenBrightnessMode", Display::manualScreenBrightnessMode);
    AddStringProperty(env, paramMap, "screenOffTimeout", Display::screenOffTimeout);
    AddStringProperty(env, paramMap, "defaultScreenRotation", Display::defaultScreenRotation);
    AddStringProperty(env, paramMap, "animatorDurationScale", Display::animatorDurationScale);
    AddStringProperty(env, paramMap, "transitionAnimationScale", Display::transitionAnimationScale);
    AddStringProperty(env, paramMap, "windowAnimationScale", Display::windowAnimationScale);
    AddStringProperty(env, paramMap, "displayInversionStatus", Display::displayInversionStatus);
}

void InitGeneralMap(napi_env env, std::map<const char*, napi_value>& paramMap)
{
    AddStringProperty(env, paramMap, "setupWizardFinished", General::setupWizardFinished);
    AddStringProperty(env, paramMap, "endButtonAction", General::endButtonAction);
    AddStringProperty(env, paramMap, "airplaneModeStatus", General::airplaneModeStatus);
    AddStringProperty(env, paramMap, "accelerometerRotationStatus", General::accelerometerRotationStatus);
    AddStringProperty(env, paramMap, "deviceProvisionStatus", General::deviceProvisionStatus);
    AddStringProperty(env, paramMap, "hdcStatus", General::hdcStatus);
    AddStringProperty(env, paramMap, "bootCounting", General::bootCounting);
    AddStringProperty(env, paramMap, "contactMetadataSyncStatus", General::contactMetadataSyncStatus);
    AddStringProperty(env, paramMap, "developmentSettingsStatus", General::developmentSettingsStatus);
    AddStringProperty(env, paramMap, "deviceName", General::deviceName);
    AddStringProperty(env, paramMap, "usbStorageStatus", General::usbStorageStatus);
    AddStringProperty(env, paramMap, "debuggerWaiting", General::debuggerWaiting);
    AddStringProperty(env, paramMap, "debugAppPackage", General::debugAppPackage);
    AddStringProperty(env, paramMap, "access" "ibilityStatus", General::assistiveStatus);
    AddStringProperty(env, paramMap, "enabledAccess" "ibilityServices", General::enabledAssistiveServices);
    AddStringProperty(env, paramMap, "geolocationOriginsAllowed", General::geolocationOriginsAllowed);
    AddStringProperty(env, paramMap, "skipUseHints", General::skipUseHints);
    AddStringProperty(env, paramMap, "touchExplorationStatus", General::touchExplorationStatus);
}

void InitInputMap(napi_env env, std::map<const char*, napi_value>& paramMap)
{
    AddStringProperty(env, paramMap, "defaultInputMethod", Input::defaultInputMethod);
    AddStringProperty(env, paramMap, "activatedInputMethodSubMode", Input::activatedInputMethodSubMode);
    AddStringProperty(env, paramMap, "activatedInputMethods", Input::activatedInputMethods);
    AddStringProperty(env, paramMap, "selectorVisibilityForInputMethod", Input::selectorVisibilityForInputMethod);
    AddStringProperty(env, paramMap, "autoCapsTextInput", Input::autoCapsTextInput);
    AddStringProperty(env, paramMap, "autoPunctuateTextInput", Input::autoPunctuateTextInput);
    AddStringProperty(env, paramMap, "autoReplaceTextInput", Input::autoReplaceTextInput);
    AddStringProperty(env, paramMap, "showPasswordTextInput", Input::showPasswordTextInput);
}

void InitNetworkMap(napi_env env, std::map<const char*, napi_value>& paramMap)
{
    SETTING_LOG_INFO("%{public}s is called", __FUNCTION__);
    AddStringProperty(env, paramMap, "dataRoamingStatus", Network::dataRoamingStatus);
    AddStringProperty(env, paramMap, "httpProxyCfg", Network::httpProxyCfg);
    AddStringProperty(env, paramMap, "networkPreferenceUsage", Network::networkPreferenceUsage);
    SETTING_LOG_INFO("%{public}s is end", __FUNCTION__);
}

void InitPhoneMap(napi_env env, std::map<const char*, napi_value>& paramMap)
{
    SETTING_LOG_INFO("%{public}s is called", __FUNCTION__);
    AddStringProperty(env, paramMap, "rttCallingStatus", Phone::rttCallingStatus);
    SETTING_LOG_INFO("%{public}s is end", __FUNCTION__);
}

void InitSoundMap(napi_env env, std::map<const char*, napi_value>& paramMap)
{
    AddStringProperty(env, paramMap, "vibrateWhileRinging", Sound::vibrateWhileRinging);
    AddStringProperty(env, paramMap, "defaultAlarmAlert", Sound::defaultAlarmAlert);
    AddStringProperty(env, paramMap, "dtmfToneTypeWhileDialing", Sound::dtmfToneTypeWhileDialing);
    AddStringProperty(env, paramMap, "dtmfToneWhileDialing", Sound::dtmfToneWhileDialing);
    AddStringProperty(env, paramMap, "hapticFeedbackStatus", Sound::hapticFeedbackStatus);
    AddStringProperty(env, paramMap, "affectedModeRingerStreams", Sound::affectedModeRingerStreams);
    AddStringProperty(env, paramMap, "affectedMuteStreams", Sound::affectedMuteStreams);
    AddStringProperty(env, paramMap, "defaultNotificationSound", Sound::defaultNotificationSound);
    AddStringProperty(env, paramMap, "defaultRingtone", Sound::defaultRingtone);
    AddStringProperty(env, paramMap, "soundEffectsStatus", Sound::soundEffectsStatus);
    AddStringProperty(env, paramMap, "vibrateStatus", Sound::vibrateStatus);
}

void InitTTSMap(napi_env env, std::map<const char*, napi_value>& paramMap)
{
    AddStringProperty(env, paramMap, "defaultTtsPitch", TTS::defaultTtsPitch);
    AddStringProperty(env, paramMap, "defaultTtsRate", TTS::defaultTtsRate);
    AddStringProperty(env, paramMap, "defaultTtsSynth", TTS::defaultTtsSynth);
    AddStringProperty(env, paramMap, "enabledTtsPlugins", TTS::enabledTtsPlugins);
}

void InitWirelessMap(napi_env env, std::map<const char*, napi_value>& paramMap)
{
    AddStringProperty(env, paramMap, "bluetoothRadio", Wireless::bluetoothRadio);
    AddStringProperty(env, paramMap, "cellRadio", Wireless::cellRadio);
    AddStringProperty(env, paramMap, "nfcRadio", Wireless::nfcRadio);
    AddStringProperty(env, paramMap, "airplaneModeRadios", Wireless::airplaneModeRadios);
    AddStringProperty(env, paramMap, "bluetoothStatus", Wireless::bluetoothStatus);
    AddStringProperty(env, paramMap, "bluetoothDiscoverAbilityStatus", Wireless::bluetoothDiscoverAbilityStatus);
    AddStringProperty(env, paramMap, "bluetoothDiscoverTimeout", Wireless::bluetoothDiscoverTimeout);
    AddStringProperty(env, paramMap, "wifiDhcpMaxRetryCount", Wireless::wifiDhcpMaxRetryCount);
    AddStringProperty(env, paramMap, "wifiToMobileDataAwakeTimeout", Wireless::wifiToMobileDataAwakeTimeout);
    AddStringProperty(env, paramMap, "wifiStatus", Wireless::wifiStatus);
    AddStringProperty(env, paramMap, "wifiWatchdogStatus", Wireless::wifiWatchdogStatus);
    AddStringProperty(env, paramMap, "wifiRadio", Wireless::wifiRadio);
    AddStringProperty(env, paramMap, "ownerLockdownWifiCfg", Wireless::ownerLockdownWifiCfg);
}

void InitConstClassByName(napi_env env, napi_value exports, std::string name)
{
    std::map<const char*, napi_value> propertyMap;
    if (name == DATE_CLASS_NAME) {
        InitDateMap(env, propertyMap);
    } else if (name == DISPLAY_CLASS_NAME) {
        InitDisplayMap(env, propertyMap);
    } else if (name == GENERAL_CLASS_NAME) {
        InitGeneralMap(env, propertyMap);
    } else if (name == INPUT_CLASS_NAME) {
        InitInputMap(env, propertyMap);
    } else if (name == NETWORK_CLASS_NAME) {
        InitNetworkMap(env, propertyMap);
    } else if (name == PHONE_CLASS_NAME) {
        InitPhoneMap(env, propertyMap);
    } else if (name == SOUND_CLASS_NAME) {
        InitSoundMap(env, propertyMap);
    } else if (name == TTS_CLASS_NAME) {
        InitTTSMap(env, propertyMap);
    } else if (name == WIRELESS_CLASS_NAME) {
        InitWirelessMap(env, propertyMap);
    } else {
        return;
    }

    int i = 0;
    napi_property_descriptor descriptors[propertyMap.size()];
    for (auto it : propertyMap) {
        descriptors[i++] = DECLARE_NAPI_STATIC_PROPERTY(it.first, it.second);
    }

    napi_value result = nullptr;
    napi_define_class(env, name.c_str(), NAPI_AUTO_LENGTH, ClassConstructor, nullptr,
        sizeof(descriptors) / sizeof(*descriptors), descriptors, &result);
    napi_set_named_property(env, exports, name.c_str(), result);
}

napi_value InitNapiClass(napi_env env, napi_value exports)
{
    SETTING_LOG_INFO("%{public}s is called", __FUNCTION__);
    InitConstClassByName(env, exports, DATE_CLASS_NAME);
    InitConstClassByName(env, exports, DISPLAY_CLASS_NAME);
    InitConstClassByName(env, exports, GENERAL_CLASS_NAME);
    InitConstClassByName(env, exports, INPUT_CLASS_NAME);
    InitConstClassByName(env, exports, NETWORK_CLASS_NAME);
    InitConstClassByName(env, exports, PHONE_CLASS_NAME);
    InitConstClassByName(env, exports, SOUND_CLASS_NAME);
    InitConstClassByName(env, exports, TTS_CLASS_NAME);
    InitConstClassByName(env, exports, WIRELESS_CLASS_NAME);
    SETTING_LOG_INFO("%{public}s is end", __FUNCTION__);
    return exports;
}

} // Settings
} // OHOS
