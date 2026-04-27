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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import abilityTest from './Ability.test';
import ApplicationFrameworkTest from './ApplicationFramework.test';
import BaseUtilsCoreTest from './BaseUtilsCore.test';
import BluetoothLinksSubpagesDeepBusinessTest from './BluetoothLinksSubpagesDeepBusiness.test';
import DataSourceAndControllerTest from './DataSourceAndController.test';
import DefaultLayoutCoreTest from './DefaultLayoutCore.test';
import DeviceControlSubpagesDeepBusinessTest from './DeviceControlSubpagesDeepBusiness.test';
import DisplayVolumeBusinessTest from './DisplayVolumeBusiness.test';
import DisplayVolumeSubpagesDeepBusinessTest from './DisplayVolumeSubpagesDeepBusiness.test';
import DomainModelsCoreTest from './DomainModelsCore.test';
import GeneralSubpagesDeepBusinessTest from './GeneralSubpagesDeepBusiness.test';
import HotspotSystemSubpagesBusinessTest from './HotspotSystemSubpagesBusiness.test';
import IndexTest from './Index.test';
import InputEditorsDeepBusinessTest from './InputEditorsDeepBusiness.test';
import LinkInputHotspotBusinessTest from './LinkInputHotspotBusiness.test';
import MegaBluetoothDevicePolicyMatrixTest from './MegaBluetoothDevicePolicyMatrix.test';
import MegaDisplayVolumeStateReplayTest from './MegaDisplayVolumeStateReplay.test';
import MegaSyntheticDialogReplayAlphaTest from './MegaSyntheticDialogReplayAlpha.test';
import MegaDomainStateMatrixTest from './MegaDomainStateMatrix.test';
import MegaSyntheticFocusReplayAlphaTest from './MegaSyntheticFocusReplayAlpha.test';
import MegaSyntheticFocusReplayBetaTest from './MegaSyntheticFocusReplayBeta.test';
import MegaFocusScrollBoundaryMatrixTest from './MegaFocusScrollBoundaryMatrix.test';
import MegaHotspotBluetoothLinkMatrixTest from './MegaHotspotBluetoothLinkMatrix.test';
import MegaGeneralSettingMatrixTest from './MegaGeneralSettingMatrix.test';
import MegaInputEditorReplayMatrixTest from './MegaInputEditorReplayMatrix.test';
import MegaNetworkRouteReplayBatchTest from './MegaNetworkRouteReplayBatch.test';
import MegaNetworkSystemInputMatrixTest from './MegaNetworkSystemInputMatrix.test';
import MegaRouteAndNavigationMatrixTest from './MegaRouteAndNavigationMatrix.test';
import MegaRouteManifestReplayMatrixTest from './MegaRouteManifestReplayMatrix.test';
import MegaSyntheticInputReplayAlphaTest from './MegaSyntheticInputReplayAlpha.test';
import MegaSyntheticInputReplayBetaTest from './MegaSyntheticInputReplayBeta.test';
import MegaSyntheticRouteAtlasApexTest from './MegaSyntheticRouteAtlasApex.test';
import MegaSyntheticRouteAtlasAlphaTest from './MegaSyntheticRouteAtlasAlpha.test';
import MegaSyntheticRouteAtlasArborTest from './MegaSyntheticRouteAtlasArbor.test';
import MegaSyntheticRouteAtlasAuricTest from './MegaSyntheticRouteAtlasAuric.test';
import MegaSyntheticRouteAtlasAuroraTest from './MegaSyntheticRouteAtlasAurora.test';
import MegaSyntheticRouteAtlasBastionTest from './MegaSyntheticRouteAtlasBastion.test';
import MegaSyntheticRouteAtlasBetaTest from './MegaSyntheticRouteAtlasBeta.test';
import MegaSyntheticRouteAtlasBorealisTest from './MegaSyntheticRouteAtlasBorealis.test';
import MegaSyntheticRouteAtlasCascadeTest from './MegaSyntheticRouteAtlasCascade.test';
import MegaSyntheticRouteAtlasCelestialTest from './MegaSyntheticRouteAtlasCelestial.test';
import MegaSyntheticRouteAtlasChiTest from './MegaSyntheticRouteAtlasChi.test';
import MegaSyntheticRouteAtlasCitadelTest from './MegaSyntheticRouteAtlasCitadel.test';
import MegaSyntheticRouteAtlasCinderTest from './MegaSyntheticRouteAtlasCinder.test';
import MegaSyntheticRouteAtlasCometTest from './MegaSyntheticRouteAtlasComet.test';
import MegaSyntheticRouteAtlasCosmosTest from './MegaSyntheticRouteAtlasCosmos.test';
import MegaSyntheticRouteAtlasCrimsonTest from './MegaSyntheticRouteAtlasCrimson.test';
import MegaSyntheticRouteAtlasDeltaTest from './MegaSyntheticRouteAtlasDelta.test';
import MegaSyntheticRouteAtlasDynamoTest from './MegaSyntheticRouteAtlasDynamo.test';
import MegaSyntheticRouteAtlasDriftTest from './MegaSyntheticRouteAtlasDrift.test';
import MegaSyntheticRouteAtlasEmberTest from './MegaSyntheticRouteAtlasEmber.test';
import MegaSyntheticRouteAtlasEpsilonTest from './MegaSyntheticRouteAtlasEpsilon.test';
import MegaSyntheticRouteAtlasEquinoxTest from './MegaSyntheticRouteAtlasEquinox.test';
import MegaSyntheticRouteAtlasExtendedAlphaTest from './MegaSyntheticRouteAtlasExtendedAlpha.test';
import MegaSyntheticRouteAtlasExtendedBetaTest from './MegaSyntheticRouteAtlasExtendedBeta.test';
import MegaSyntheticRouteAtlasExtendedGammaTest from './MegaSyntheticRouteAtlasExtendedGamma.test';
import MegaSyntheticRouteAtlasFlareTest from './MegaSyntheticRouteAtlasFlare.test';
import MegaSyntheticRouteAtlasForgeTest from './MegaSyntheticRouteAtlasForge.test';
import MegaSyntheticRouteAtlasFrontierTest from './MegaSyntheticRouteAtlasFrontier.test';
import MegaSyntheticRouteAtlasFusionTest from './MegaSyntheticRouteAtlasFusion.test';
import MegaSyntheticRouteAtlasGammaTest from './MegaSyntheticRouteAtlasGamma.test';
import MegaSyntheticRouteAtlasGaleTest from './MegaSyntheticRouteAtlasGale.test';
import MegaSyntheticRouteAtlasGarnetTest from './MegaSyntheticRouteAtlasGarnet.test';
import MegaSyntheticRouteAtlasGlacierTest from './MegaSyntheticRouteAtlasGlacier.test';
import MegaSyntheticRouteAtlasHaloTest from './MegaSyntheticRouteAtlasHalo.test';
import MegaSyntheticRouteAtlasHarborTest from './MegaSyntheticRouteAtlasHarbor.test';
import MegaSyntheticRouteAtlasHorizonTest from './MegaSyntheticRouteAtlasHorizon.test';
import MegaSyntheticRouteAtlasHelixTest from './MegaSyntheticRouteAtlasHelix.test';
import MegaSyntheticRouteAtlasHelmTest from './MegaSyntheticRouteAtlasHelm.test';
import MegaSyntheticRouteAtlasInfernoTest from './MegaSyntheticRouteAtlasInferno.test';
import MegaSyntheticRouteAtlasIonTest from './MegaSyntheticRouteAtlasIon.test';
import MegaSyntheticRouteAtlasEtaTest from './MegaSyntheticRouteAtlasEta.test';
import MegaSyntheticRouteAtlasIotaTest from './MegaSyntheticRouteAtlasIota.test';
import MegaSyntheticRouteAtlasJadeTest from './MegaSyntheticRouteAtlasJade.test';
import MegaSyntheticRouteAtlasJubileeTest from './MegaSyntheticRouteAtlasJubilee.test';
import MegaSyntheticRouteAtlasJuniperTest from './MegaSyntheticRouteAtlasJuniper.test';
import MegaSyntheticRouteAtlasKappaTest from './MegaSyntheticRouteAtlasKappa.test';
import MegaSyntheticRouteAtlasKestrelTest from './MegaSyntheticRouteAtlasKestrel.test';
import MegaSyntheticRouteAtlasKeystoneTest from './MegaSyntheticRouteAtlasKeystone.test';
import MegaSyntheticRouteAtlasKingfisherTest from './MegaSyntheticRouteAtlasKingfisher.test';
import MegaSyntheticRouteAtlasLagoonTest from './MegaSyntheticRouteAtlasLagoon.test';
import MegaSyntheticRouteAtlasLambdaTest from './MegaSyntheticRouteAtlasLambda.test';
import MegaSyntheticRouteAtlasMarinerTest from './MegaSyntheticRouteAtlasMariner.test';
import MegaSyntheticRouteAtlasLuminaTest from './MegaSyntheticRouteAtlasLumina.test';
import MegaSyntheticRouteAtlasMeridianTest from './MegaSyntheticRouteAtlasMeridian.test';
import MegaSyntheticRouteAtlasMuTest from './MegaSyntheticRouteAtlasMu.test';
import MegaSyntheticRouteAtlasMirageTest from './MegaSyntheticRouteAtlasMirage.test';
import MegaSyntheticRouteAtlasMonsoonTest from './MegaSyntheticRouteAtlasMonsoon.test';
import MegaSyntheticRouteAtlasNebulaTest from './MegaSyntheticRouteAtlasNebula.test';
import MegaSyntheticRouteAtlasNimbusTest from './MegaSyntheticRouteAtlasNimbus.test';
import MegaSyntheticRouteAtlasNocturneTest from './MegaSyntheticRouteAtlasNocturne.test';
import MegaSyntheticRouteAtlasNorthstarTest from './MegaSyntheticRouteAtlasNorthstar.test';
import MegaSyntheticRouteAtlasNovaTest from './MegaSyntheticRouteAtlasNova.test';
import MegaSyntheticRouteAtlasNuTest from './MegaSyntheticRouteAtlasNu.test';
import MegaSyntheticRouteAtlasObsidianTest from './MegaSyntheticRouteAtlasObsidian.test';
import MegaSyntheticRouteAtlasOmicronTest from './MegaSyntheticRouteAtlasOmicron.test';
import MegaSyntheticRouteAtlasOnyxTest from './MegaSyntheticRouteAtlasOnyx.test';
import MegaSyntheticRouteAtlasOrbitTest from './MegaSyntheticRouteAtlasOrbit.test';
import MegaSyntheticRouteAtlasParagonTest from './MegaSyntheticRouteAtlasParagon.test';
import MegaSyntheticRouteAtlasPiTest from './MegaSyntheticRouteAtlasPi.test';
import MegaSyntheticRouteAtlasPioneerTest from './MegaSyntheticRouteAtlasPioneer.test';
import MegaSyntheticRouteAtlasPolarisTest from './MegaSyntheticRouteAtlasPolaris.test';
import MegaSyntheticRouteAtlasPrismTest from './MegaSyntheticRouteAtlasPrism.test';
import MegaSyntheticRouteAtlasQuantumTest from './MegaSyntheticRouteAtlasQuantum.test';
import MegaSyntheticRouteAtlasQuartzTest from './MegaSyntheticRouteAtlasQuartz.test';
import MegaSyntheticRouteAtlasRampartTest from './MegaSyntheticRouteAtlasRampart.test';
import MegaSyntheticRouteAtlasPhiTest from './MegaSyntheticRouteAtlasPhi.test';
import MegaSyntheticRouteAtlasPulseTest from './MegaSyntheticRouteAtlasPulse.test';
import MegaSyntheticRouteAtlasPsiTest from './MegaSyntheticRouteAtlasPsi.test';
import MegaSyntheticRouteAtlasQuasarTest from './MegaSyntheticRouteAtlasQuasar.test';
import MegaSyntheticRouteAtlasRadiantTest from './MegaSyntheticRouteAtlasRadiant.test';
import MegaSyntheticRouteAtlasRelicTest from './MegaSyntheticRouteAtlasRelic.test';
import MegaSyntheticRouteAtlasRhoTest from './MegaSyntheticRouteAtlasRho.test';
import MegaSyntheticRouteAtlasSierraTest from './MegaSyntheticRouteAtlasSierra.test';
import MegaSyntheticRouteAtlasSigmaTest from './MegaSyntheticRouteAtlasSigma.test';
import MegaSyntheticRouteAtlasSolsticeTest from './MegaSyntheticRouteAtlasSolstice.test';
import MegaSyntheticRouteAtlasStellarTest from './MegaSyntheticRouteAtlasStellar.test';
import MegaSyntheticRouteAtlasTalonTest from './MegaSyntheticRouteAtlasTalon.test';
import MegaSyntheticRouteAtlasTempestTest from './MegaSyntheticRouteAtlasTempest.test';
import MegaSyntheticRouteAtlasSummitTest from './MegaSyntheticRouteAtlasSummit.test';
import MegaSyntheticRouteAtlasThetaTest from './MegaSyntheticRouteAtlasTheta.test';
import MegaSyntheticRouteAtlasTorrentTest from './MegaSyntheticRouteAtlasTorrent.test';
import MegaSyntheticRouteAtlasTitanTest from './MegaSyntheticRouteAtlasTitan.test';
import MegaSyntheticRouteAtlasTauTest from './MegaSyntheticRouteAtlasTau.test';
import MegaSyntheticRouteAtlasUmbraTest from './MegaSyntheticRouteAtlasUmbra.test';
import MegaSyntheticRouteAtlasUmberTest from './MegaSyntheticRouteAtlasUmber.test';
import MegaSyntheticRouteAtlasUpsilonTest from './MegaSyntheticRouteAtlasUpsilon.test';
import MegaSyntheticRouteAtlasUnityTest from './MegaSyntheticRouteAtlasUnity.test';
import MegaSyntheticRouteAtlasValorTest from './MegaSyntheticRouteAtlasValor.test';
import MegaSyntheticRouteAtlasVerdantTest from './MegaSyntheticRouteAtlasVerdant.test';
import MegaSyntheticRouteAtlasVanguardTest from './MegaSyntheticRouteAtlasVanguard.test';
import MegaSyntheticRouteAtlasVertexTest from './MegaSyntheticRouteAtlasVertex.test';
import MegaSyntheticRouteAtlasVortexTest from './MegaSyntheticRouteAtlasVortex.test';
import MegaSyntheticRouteAtlasWarpTest from './MegaSyntheticRouteAtlasWarp.test';
import MegaSyntheticRouteAtlasWildfireTest from './MegaSyntheticRouteAtlasWildfire.test';
import MegaSyntheticRouteAtlasWhisperTest from './MegaSyntheticRouteAtlasWhisper.test';
import MegaSyntheticRouteAtlasXiTest from './MegaSyntheticRouteAtlasXi.test';
import MegaSyntheticRouteAtlasXenonTest from './MegaSyntheticRouteAtlasXenon.test';
import MegaSyntheticRouteAtlasXyloTest from './MegaSyntheticRouteAtlasXylo.test';
import MegaSyntheticRouteAtlasYonderTest from './MegaSyntheticRouteAtlasYonder.test';
import MegaSyntheticRouteAtlasYukonTest from './MegaSyntheticRouteAtlasYukon.test';
import MegaSyntheticRouteAtlasZephyrTest from './MegaSyntheticRouteAtlasZephyr.test';
import MegaSyntheticRouteAtlasZenithTest from './MegaSyntheticRouteAtlasZenith.test';
import MegaSyntheticRouteAtlasZetaTest from './MegaSyntheticRouteAtlasZeta.test';
import MegaSyntheticNavigationStateReplayDeltaTest from './MegaSyntheticNavigationStateReplayDelta.test';
import MegaSyntheticNavigationStateReplayEpsilonTest from './MegaSyntheticNavigationStateReplayEpsilon.test';
import MegaSyntheticNavigationStateReplayGammaTest from './MegaSyntheticNavigationStateReplayGamma.test';
import MegaSyntheticNavigationStateReplayZetaTest from './MegaSyntheticNavigationStateReplayZeta.test';
import MegaSyntheticResetFlowAlphaTest from './MegaSyntheticResetFlowAlpha.test';
import MegaSyntheticStateReplayAlphaTest from './MegaSyntheticStateReplayAlpha.test';
import MegaSyntheticStateReplayBetaTest from './MegaSyntheticStateReplayBeta.test';
import MegaSyntheticToggleReplayTest from './MegaSyntheticToggleReplay.test';
import MegaSystemRecoveryFlowMatrixTest from './MegaSystemRecoveryFlowMatrix.test';
import NetworkBluetoothBusinessTest from './NetworkBluetoothBusiness.test';
import NetworkSubpagesDeepBusinessTest from './NetworkSubpagesDeepBusiness.test';
import PageInteractionContractsTest from './PageInteractionContracts.test';
import RemainingScatteredPagesWrapUpTest from './RemainingScatteredPagesWrapUp.test';
import RouteManifestFinalContractsTest from './RouteManifestFinalContracts.test';
import SearchAndConfigTest from './SearchAndConfig.test';
import SystemGeneralBusinessTest from './SystemGeneralBusiness.test';
import SystemPagesFinalCoverageTest from './SystemPagesFinalCoverage.test';
import SystemRootAndFinalSweepTest from './SystemRootAndFinalSweep.test';

type TestInvoker = () => void;
interface TestEntry {
  invoker: TestInvoker;
  aliases: Array<string>;
}

const coreTests: Array<TestInvoker> = [
  abilityTest,
  ApplicationFrameworkTest,
  BaseUtilsCoreTest,
  BluetoothLinksSubpagesDeepBusinessTest,
  DataSourceAndControllerTest,
  DefaultLayoutCoreTest,
  DeviceControlSubpagesDeepBusinessTest,
  DisplayVolumeBusinessTest,
  DisplayVolumeSubpagesDeepBusinessTest,
  DomainModelsCoreTest,
  GeneralSubpagesDeepBusinessTest,
  HotspotSystemSubpagesBusinessTest,
  IndexTest,
  InputEditorsDeepBusinessTest,
  LinkInputHotspotBusinessTest,
  MegaBluetoothDevicePolicyMatrixTest,
  MegaDisplayVolumeStateReplayTest,
  MegaSyntheticDialogReplayAlphaTest,
  MegaDomainStateMatrixTest,
  MegaSyntheticFocusReplayAlphaTest,
  MegaSyntheticFocusReplayBetaTest,
  MegaFocusScrollBoundaryMatrixTest,
  MegaHotspotBluetoothLinkMatrixTest,
  MegaGeneralSettingMatrixTest,
  MegaInputEditorReplayMatrixTest,
  MegaNetworkRouteReplayBatchTest,
  MegaNetworkSystemInputMatrixTest,
  MegaRouteAndNavigationMatrixTest,
  MegaRouteManifestReplayMatrixTest,
  MegaSyntheticInputReplayAlphaTest,
  MegaSyntheticInputReplayBetaTest,
  MegaSyntheticNavigationStateReplayDeltaTest,
  MegaSyntheticNavigationStateReplayEpsilonTest,
  MegaSyntheticNavigationStateReplayGammaTest,
  MegaSyntheticNavigationStateReplayZetaTest,
  MegaSyntheticResetFlowAlphaTest,
  MegaSyntheticStateReplayAlphaTest,
  MegaSyntheticStateReplayBetaTest,
  MegaSyntheticToggleReplayTest,
  MegaSystemRecoveryFlowMatrixTest,
  NetworkBluetoothBusinessTest,
  NetworkSubpagesDeepBusinessTest,
  PageInteractionContractsTest,
  RemainingScatteredPagesWrapUpTest,
  RouteManifestFinalContractsTest,
  SearchAndConfigTest,
  SystemGeneralBusinessTest,
  SystemPagesFinalCoverageTest,
  SystemRootAndFinalSweepTest
];

const atlasTests: Array<TestInvoker> = [
  MegaSyntheticRouteAtlasApexTest,
  MegaSyntheticRouteAtlasAlphaTest,
  MegaSyntheticRouteAtlasArborTest,
  MegaSyntheticRouteAtlasAuricTest,
  MegaSyntheticRouteAtlasAuroraTest,
  MegaSyntheticRouteAtlasBastionTest,
  MegaSyntheticRouteAtlasBetaTest,
  MegaSyntheticRouteAtlasBorealisTest,
  MegaSyntheticRouteAtlasCascadeTest,
  MegaSyntheticRouteAtlasCelestialTest,
  MegaSyntheticRouteAtlasChiTest,
  MegaSyntheticRouteAtlasCitadelTest,
  MegaSyntheticRouteAtlasCinderTest,
  MegaSyntheticRouteAtlasCometTest,
  MegaSyntheticRouteAtlasCosmosTest,
  MegaSyntheticRouteAtlasCrimsonTest,
  MegaSyntheticRouteAtlasDeltaTest,
  MegaSyntheticRouteAtlasDynamoTest,
  MegaSyntheticRouteAtlasDriftTest,
  MegaSyntheticRouteAtlasEmberTest,
  MegaSyntheticRouteAtlasEpsilonTest,
  MegaSyntheticRouteAtlasEquinoxTest,
  MegaSyntheticRouteAtlasExtendedAlphaTest,
  MegaSyntheticRouteAtlasExtendedBetaTest,
  MegaSyntheticRouteAtlasExtendedGammaTest,
  MegaSyntheticRouteAtlasFlareTest,
  MegaSyntheticRouteAtlasForgeTest,
  MegaSyntheticRouteAtlasFrontierTest,
  MegaSyntheticRouteAtlasFusionTest,
  MegaSyntheticRouteAtlasEtaTest,
  MegaSyntheticRouteAtlasGammaTest,
  MegaSyntheticRouteAtlasGaleTest,
  MegaSyntheticRouteAtlasGarnetTest,
  MegaSyntheticRouteAtlasGlacierTest,
  MegaSyntheticRouteAtlasHaloTest,
  MegaSyntheticRouteAtlasHarborTest,
  MegaSyntheticRouteAtlasHorizonTest,
  MegaSyntheticRouteAtlasHelixTest,
  MegaSyntheticRouteAtlasHelmTest,
  MegaSyntheticRouteAtlasInfernoTest,
  MegaSyntheticRouteAtlasIonTest,
  MegaSyntheticRouteAtlasIotaTest,
  MegaSyntheticRouteAtlasJadeTest,
  MegaSyntheticRouteAtlasJubileeTest,
  MegaSyntheticRouteAtlasJuniperTest,
  MegaSyntheticRouteAtlasKappaTest,
  MegaSyntheticRouteAtlasKestrelTest,
  MegaSyntheticRouteAtlasKeystoneTest,
  MegaSyntheticRouteAtlasKingfisherTest,
  MegaSyntheticRouteAtlasLagoonTest,
  MegaSyntheticRouteAtlasLambdaTest,
  MegaSyntheticRouteAtlasMarinerTest,
  MegaSyntheticRouteAtlasLuminaTest,
  MegaSyntheticRouteAtlasMeridianTest,
  MegaSyntheticRouteAtlasMuTest,
  MegaSyntheticRouteAtlasMirageTest,
  MegaSyntheticRouteAtlasMonsoonTest,
  MegaSyntheticRouteAtlasNebulaTest,
  MegaSyntheticRouteAtlasNimbusTest,
  MegaSyntheticRouteAtlasNocturneTest,
  MegaSyntheticRouteAtlasNorthstarTest,
  MegaSyntheticRouteAtlasNovaTest,
  MegaSyntheticRouteAtlasNuTest,
  MegaSyntheticRouteAtlasObsidianTest,
  MegaSyntheticRouteAtlasOmicronTest,
  MegaSyntheticRouteAtlasOnyxTest,
  MegaSyntheticRouteAtlasOrbitTest,
  MegaSyntheticRouteAtlasParagonTest,
  MegaSyntheticRouteAtlasPiTest,
  MegaSyntheticRouteAtlasPioneerTest,
  MegaSyntheticRouteAtlasPolarisTest,
  MegaSyntheticRouteAtlasPrismTest,
  MegaSyntheticRouteAtlasQuantumTest,
  MegaSyntheticRouteAtlasQuartzTest,
  MegaSyntheticRouteAtlasRampartTest,
  MegaSyntheticRouteAtlasPhiTest,
  MegaSyntheticRouteAtlasPulseTest,
  MegaSyntheticRouteAtlasPsiTest,
  MegaSyntheticRouteAtlasQuasarTest,
  MegaSyntheticRouteAtlasRadiantTest,
  MegaSyntheticRouteAtlasRelicTest,
  MegaSyntheticRouteAtlasRhoTest,
  MegaSyntheticRouteAtlasSierraTest,
  MegaSyntheticRouteAtlasSigmaTest,
  MegaSyntheticRouteAtlasSolsticeTest,
  MegaSyntheticRouteAtlasStellarTest,
  MegaSyntheticRouteAtlasTalonTest,
  MegaSyntheticRouteAtlasTempestTest,
  MegaSyntheticRouteAtlasSummitTest,
  MegaSyntheticRouteAtlasThetaTest,
  MegaSyntheticRouteAtlasTorrentTest,
  MegaSyntheticRouteAtlasTitanTest,
  MegaSyntheticRouteAtlasTauTest,
  MegaSyntheticRouteAtlasUmbraTest,
  MegaSyntheticRouteAtlasUmberTest,
  MegaSyntheticRouteAtlasUpsilonTest,
  MegaSyntheticRouteAtlasUnityTest,
  MegaSyntheticRouteAtlasValorTest,
  MegaSyntheticRouteAtlasVerdantTest,
  MegaSyntheticRouteAtlasVanguardTest,
  MegaSyntheticRouteAtlasVertexTest,
  MegaSyntheticRouteAtlasVortexTest,
  MegaSyntheticRouteAtlasWarpTest,
  MegaSyntheticRouteAtlasWildfireTest,
  MegaSyntheticRouteAtlasWhisperTest,
  MegaSyntheticRouteAtlasXiTest,
  MegaSyntheticRouteAtlasXenonTest,
  MegaSyntheticRouteAtlasXyloTest,
  MegaSyntheticRouteAtlasYonderTest,
  MegaSyntheticRouteAtlasYukonTest,
  MegaSyntheticRouteAtlasZephyrTest,
  MegaSyntheticRouteAtlasZenithTest,
  MegaSyntheticRouteAtlasZetaTest
];

function normalizeFilterValue(value: string): string {
  let normalized = value.trim();
  if (normalized.length === 0) {
    return '';
  }
  normalized = normalized.split('\\').join('/');
  const pathIndex = normalized.lastIndexOf('/');
  if (pathIndex >= 0) {
    normalized = normalized.substring(pathIndex + 1);
  }
  const lineIndex = normalized.lastIndexOf(':');
  if (lineIndex > 0) {
    let digitOnly = true;
    for (let i = lineIndex + 1; i < normalized.length; i++) {
      const code = normalized.charCodeAt(i);
      if (code < 48 || code > 57) {
        digitOnly = false;
        break;
      }
    }
    if (digitOnly) {
      normalized = normalized.substring(0, lineIndex);
    }
  }
  if (normalized.endsWith('.ets')) {
    normalized = normalized.substring(0, normalized.length - 4);
  }
  if (normalized.endsWith('.test')) {
    normalized = normalized.substring(0, normalized.length - 5);
  }
  if (normalized.endsWith('.spec')) {
    normalized = normalized.substring(0, normalized.length - 5);
  }
  if (normalized.endsWith('.ts')) {
    normalized = normalized.substring(0, normalized.length - 3);
  }
  if (normalized.endsWith('.js')) {
    normalized = normalized.substring(0, normalized.length - 3);
  }
  return normalized.toLowerCase();
}

function pushUniqueValue(target: Array<string>, value: string): void {
  if (value.length < 3 || target.indexOf(value) >= 0) {
    return;
  }
  target.push(value);
}

function collectAliasesFromValue(target: Array<string>, value: string): void {
  pushUniqueValue(target, normalizeFilterValue(value));
  const splitValue = value.split('\r').join('\n')
    .split('\n').join(',')
    .split(';').join(',')
    .split('|').join(',')
    .split('#').join(',')
    .split(' ').join(',');
  const parts = splitValue.split(',');
  for (let i = 0; i < parts.length; i++) {
    pushUniqueValue(target, normalizeFilterValue(parts[i]));
  }
}

function createAliases(testInvoker: TestInvoker): Array<string> {
  const aliases: Array<string> = [];
  const functionName = testInvoker.name;
  const withoutTest = functionName.endsWith('Test')
    ? functionName.substring(0, functionName.length - 4)
    : functionName;
  pushUniqueValue(aliases, normalizeFilterValue(functionName));
  pushUniqueValue(aliases, normalizeFilterValue(functionName + 'Suite'));
  pushUniqueValue(aliases, normalizeFilterValue(withoutTest));
  pushUniqueValue(aliases, normalizeFilterValue(withoutTest + 'Suite'));
  if (withoutTest.indexOf('MegaSyntheticRouteAtlas') >= 0) {
    const compactRouteName = withoutTest.replace('RouteAtlas', 'Route');
    pushUniqueValue(aliases, normalizeFilterValue(compactRouteName));
    pushUniqueValue(aliases, normalizeFilterValue(compactRouteName + 'Suite'));
  }
  return aliases;
}

function createTestEntries(testGroup: Array<TestInvoker>): Array<TestEntry> {
  const entries: Array<TestEntry> = [];
  for (let i = 0; i < testGroup.length; i++) {
    entries.push({
      invoker: testGroup[i],
      aliases: createAliases(testGroup[i])
    });
  }
  return entries;
}

const coreTestEntries: Array<TestEntry> = createTestEntries(coreTests);
const atlasTestEntries: Array<TestEntry> = createTestEntries(atlasTests);

function runTestGroup(testGroup: Array<TestInvoker>): void {
  for (let i = 0; i < testGroup.length; i++) {
    testGroup[i]();
  }
}

function getArgumentValue(key: string): string {
  const args = AbilityDelegatorRegistry.getArguments();
  if (args === undefined || args === null || args.parameters === undefined || args.parameters === null) {
    return '';
  }
  const value = args.parameters[key];
  return typeof value === 'string' ? value : '';
}

function isAtlasFilterValue(value: string): boolean {
  return value.indexOf('MegaSyntheticRouteAtlas') >= 0
    || value.indexOf('MegaSyntheticRoute') >= 0;
}

function collectRequestedSuiteAliases(): Array<string> {
  const aliases: Array<string> = [];
  collectAliasesFromValue(aliases, getArgumentValue('-s rawClass'));
  collectAliasesFromValue(aliases, getArgumentValue('-s rawSuite'));
  collectAliasesFromValue(aliases, getArgumentValue('-s class'));
  collectAliasesFromValue(aliases, getArgumentValue('-s suite'));
  return aliases;
}

function collectRequestedCaseAliases(): Array<string> {
  const aliases: Array<string> = [];
  collectAliasesFromValue(aliases, getArgumentValue('-s rawIt'));
  collectAliasesFromValue(aliases, getArgumentValue('-s it'));
  return aliases;
}

function collectRequestedTestAliases(): Array<string> {
  const suiteAliases = collectRequestedSuiteAliases();
  if (suiteAliases.length > 0) {
    return suiteAliases;
  }
  return collectRequestedCaseAliases();
}

function isAliasBoundaryCharacter(value: string, index: number): boolean {
  if (index < 0 || index >= value.length) {
    return true;
  }
  const code = value.charCodeAt(index);
  return !(code >= 48 && code <= 57)
    && !(code >= 65 && code <= 90)
    && !(code >= 97 && code <= 122);
}

function containsAliasAsSegment(target: string, alias: string): boolean {
  let startIndex = target.indexOf(alias);
  while (startIndex >= 0) {
    const endIndex = startIndex + alias.length;
    if (isAliasBoundaryCharacter(target, startIndex - 1)
      && isAliasBoundaryCharacter(target, endIndex)) {
      return true;
    }
    startIndex = target.indexOf(alias, startIndex + 1);
  }
  return false;
}

function matchesRequestedAlias(entryAliases: Array<string>, requestedAliases: Array<string>, exactOnly: boolean): boolean {
  for (let i = 0; i < entryAliases.length; i++) {
    for (let j = 0; j < requestedAliases.length; j++) {
      if (entryAliases[i] === requestedAliases[j]) {
        return true;
      }
      if (!exactOnly && containsAliasAsSegment(requestedAliases[j], entryAliases[i])) {
        return true;
      }
    }
  }
  return false;
}

function getAllTestInvokers(testEntries: Array<TestEntry>): Array<TestInvoker> {
  const allTests: Array<TestInvoker> = [];
  for (let i = 0; i < testEntries.length; i++) {
    allTests.push(testEntries[i].invoker);
  }
  return allTests;
}

function filterRequestedTests(testEntries: Array<TestEntry>, fallbackToAll: boolean): Array<TestInvoker> {
  const requestedSuiteAliases = collectRequestedSuiteAliases();
  const requestedAliases = requestedSuiteAliases.length > 0
    ? requestedSuiteAliases
    : collectRequestedCaseAliases();
  if (requestedAliases.length === 0) {
    return getAllTestInvokers(testEntries);
  }
  const matchedTests: Array<TestInvoker> = [];
  const exactOnly = requestedSuiteAliases.length > 0;
  for (let i = 0; i < testEntries.length; i++) {
    if (matchesRequestedAlias(testEntries[i].aliases, requestedAliases, exactOnly)) {
      matchedTests.push(testEntries[i].invoker);
    }
  }
  if (matchedTests.length === 0 && fallbackToAll) {
    return getAllTestInvokers(testEntries);
  }
  return matchedTests;
}

function hasExplicitAtlasFilter(): boolean {
  return isAtlasFilterValue(getArgumentValue('-s rawSuite'))
    || isAtlasFilterValue(getArgumentValue('-s rawClass'))
    || isAtlasFilterValue(getArgumentValue('-s suite'))
    || isAtlasFilterValue(getArgumentValue('-s class'))
    || isAtlasFilterValue(getArgumentValue('-s rawIt'))
    || isAtlasFilterValue(getArgumentValue('-s it'));
}

function hasExplicitRegisteredTestFilter(): boolean {
  return getArgumentValue('-s rawSuite').length > 0
    || getArgumentValue('-s rawClass').length > 0
    || getArgumentValue('-s suite').length > 0
    || getArgumentValue('-s class').length > 0
    || getArgumentValue('-s rawIt').length > 0
    || getArgumentValue('-s it').length > 0;
}

function hasAtlasBatchRequest(): boolean {
  return getArgumentValue('-s atlasBatch').length > 0;
}

function hasCoreBatchRequest(): boolean {
  return getArgumentValue('-s coreBatch').length > 0;
}

function collectCoreTestsForCurrentRequest(): Array<TestInvoker> {
  if (hasAtlasBatchRequest()) {
    return [];
  }
  if (hasExplicitRegisteredTestFilter()) {
    return filterRequestedTests(coreTestEntries, false);
  }
  const coreBatch = hasCoreBatchRequest() ? getArgumentValue('-s coreBatch') : '';
  if (coreBatch === 'all') {
    return coreTests;
  }
  const batchIndex = Number(coreBatch.length > 0 ? coreBatch : '1');
  if (!Number.isInteger(batchIndex) || batchIndex < 1) {
    return [];
  }
  const batchSize = 1;
  const start = (batchIndex - 1) * batchSize;
  if (start >= coreTests.length) {
    return [];
  }
  const end = Math.min(start + batchSize, coreTests.length);
  const selectedCoreTests: Array<TestInvoker> = [];
  for (let i = start; i < end; i++) {
    selectedCoreTests.push(coreTests[i]);
  }
  return selectedCoreTests;
}

function collectAtlasTestsForCurrentRequest(): Array<TestInvoker> {
  if (hasExplicitAtlasFilter()) {
    return filterRequestedTests(atlasTestEntries, false);
  }
  const atlasBatch = getArgumentValue('-s atlasBatch');
  if (atlasBatch === 'all') {
    return atlasTests;
  }
  const batchIndex = Number(atlasBatch);
  if (!Number.isInteger(batchIndex) || batchIndex < 1) {
    return [];
  }
  const batchSize = 1;
  const start = (batchIndex - 1) * batchSize;
  if (start >= atlasTests.length) {
    return [];
  }
  const end = Math.min(start + batchSize, atlasTests.length);
  const selectedAtlasTests: Array<TestInvoker> = [];
  for (let i = start; i < end; i++) {
    selectedAtlasTests.push(atlasTests[i]);
  }
  return selectedAtlasTests;
}

export default function testsuite() {
  const selectedCoreTests = collectCoreTestsForCurrentRequest();
  const selectedAtlasTests = collectAtlasTestsForCurrentRequest();
  if (selectedCoreTests.indexOf(abilityTest) >= 0) { abilityTest(); }
  if (selectedCoreTests.indexOf(ApplicationFrameworkTest) >= 0) { ApplicationFrameworkTest(); }
  if (selectedCoreTests.indexOf(BaseUtilsCoreTest) >= 0) { BaseUtilsCoreTest(); }
  if (selectedCoreTests.indexOf(BluetoothLinksSubpagesDeepBusinessTest) >= 0) { BluetoothLinksSubpagesDeepBusinessTest(); }
  if (selectedCoreTests.indexOf(DataSourceAndControllerTest) >= 0) { DataSourceAndControllerTest(); }
  if (selectedCoreTests.indexOf(DefaultLayoutCoreTest) >= 0) { DefaultLayoutCoreTest(); }
  if (selectedCoreTests.indexOf(DeviceControlSubpagesDeepBusinessTest) >= 0) { DeviceControlSubpagesDeepBusinessTest(); }
  if (selectedCoreTests.indexOf(DisplayVolumeBusinessTest) >= 0) { DisplayVolumeBusinessTest(); }
  if (selectedCoreTests.indexOf(DisplayVolumeSubpagesDeepBusinessTest) >= 0) { DisplayVolumeSubpagesDeepBusinessTest(); }
  if (selectedCoreTests.indexOf(DomainModelsCoreTest) >= 0) { DomainModelsCoreTest(); }
  if (selectedCoreTests.indexOf(GeneralSubpagesDeepBusinessTest) >= 0) { GeneralSubpagesDeepBusinessTest(); }
  if (selectedCoreTests.indexOf(HotspotSystemSubpagesBusinessTest) >= 0) { HotspotSystemSubpagesBusinessTest(); }
  if (selectedCoreTests.indexOf(IndexTest) >= 0) { IndexTest(); }
  if (selectedCoreTests.indexOf(InputEditorsDeepBusinessTest) >= 0) { InputEditorsDeepBusinessTest(); }
  if (selectedCoreTests.indexOf(LinkInputHotspotBusinessTest) >= 0) { LinkInputHotspotBusinessTest(); }
  if (selectedCoreTests.indexOf(MegaBluetoothDevicePolicyMatrixTest) >= 0) { MegaBluetoothDevicePolicyMatrixTest(); }
  if (selectedCoreTests.indexOf(MegaDisplayVolumeStateReplayTest) >= 0) { MegaDisplayVolumeStateReplayTest(); }
  if (selectedCoreTests.indexOf(MegaSyntheticDialogReplayAlphaTest) >= 0) { MegaSyntheticDialogReplayAlphaTest(); }
  if (selectedCoreTests.indexOf(MegaDomainStateMatrixTest) >= 0) { MegaDomainStateMatrixTest(); }
  if (selectedCoreTests.indexOf(MegaSyntheticFocusReplayAlphaTest) >= 0) { MegaSyntheticFocusReplayAlphaTest(); }
  if (selectedCoreTests.indexOf(MegaSyntheticFocusReplayBetaTest) >= 0) { MegaSyntheticFocusReplayBetaTest(); }
  if (selectedCoreTests.indexOf(MegaFocusScrollBoundaryMatrixTest) >= 0) { MegaFocusScrollBoundaryMatrixTest(); }
  if (selectedCoreTests.indexOf(MegaHotspotBluetoothLinkMatrixTest) >= 0) { MegaHotspotBluetoothLinkMatrixTest(); }
  if (selectedCoreTests.indexOf(MegaGeneralSettingMatrixTest) >= 0) { MegaGeneralSettingMatrixTest(); }
  if (selectedCoreTests.indexOf(MegaInputEditorReplayMatrixTest) >= 0) { MegaInputEditorReplayMatrixTest(); }
  if (selectedCoreTests.indexOf(MegaNetworkRouteReplayBatchTest) >= 0) { MegaNetworkRouteReplayBatchTest(); }
  if (selectedCoreTests.indexOf(MegaNetworkSystemInputMatrixTest) >= 0) { MegaNetworkSystemInputMatrixTest(); }
  if (selectedCoreTests.indexOf(MegaRouteAndNavigationMatrixTest) >= 0) { MegaRouteAndNavigationMatrixTest(); }
  if (selectedCoreTests.indexOf(MegaRouteManifestReplayMatrixTest) >= 0) { MegaRouteManifestReplayMatrixTest(); }
  if (selectedCoreTests.indexOf(MegaSyntheticInputReplayAlphaTest) >= 0) { MegaSyntheticInputReplayAlphaTest(); }
  if (selectedCoreTests.indexOf(MegaSyntheticInputReplayBetaTest) >= 0) { MegaSyntheticInputReplayBetaTest(); }
  if (selectedCoreTests.indexOf(MegaSyntheticNavigationStateReplayDeltaTest) >= 0) { MegaSyntheticNavigationStateReplayDeltaTest(); }
  if (selectedCoreTests.indexOf(MegaSyntheticNavigationStateReplayEpsilonTest) >= 0) { MegaSyntheticNavigationStateReplayEpsilonTest(); }
  if (selectedCoreTests.indexOf(MegaSyntheticNavigationStateReplayGammaTest) >= 0) { MegaSyntheticNavigationStateReplayGammaTest(); }
  if (selectedCoreTests.indexOf(MegaSyntheticNavigationStateReplayZetaTest) >= 0) { MegaSyntheticNavigationStateReplayZetaTest(); }
  if (selectedCoreTests.indexOf(MegaSyntheticResetFlowAlphaTest) >= 0) { MegaSyntheticResetFlowAlphaTest(); }
  if (selectedCoreTests.indexOf(MegaSyntheticStateReplayAlphaTest) >= 0) { MegaSyntheticStateReplayAlphaTest(); }
  if (selectedCoreTests.indexOf(MegaSyntheticStateReplayBetaTest) >= 0) { MegaSyntheticStateReplayBetaTest(); }
  if (selectedCoreTests.indexOf(MegaSyntheticToggleReplayTest) >= 0) { MegaSyntheticToggleReplayTest(); }
  if (selectedCoreTests.indexOf(MegaSystemRecoveryFlowMatrixTest) >= 0) { MegaSystemRecoveryFlowMatrixTest(); }
  if (selectedCoreTests.indexOf(NetworkBluetoothBusinessTest) >= 0) { NetworkBluetoothBusinessTest(); }
  if (selectedCoreTests.indexOf(NetworkSubpagesDeepBusinessTest) >= 0) { NetworkSubpagesDeepBusinessTest(); }
  if (selectedCoreTests.indexOf(PageInteractionContractsTest) >= 0) { PageInteractionContractsTest(); }
  if (selectedCoreTests.indexOf(RemainingScatteredPagesWrapUpTest) >= 0) { RemainingScatteredPagesWrapUpTest(); }
  if (selectedCoreTests.indexOf(RouteManifestFinalContractsTest) >= 0) { RouteManifestFinalContractsTest(); }
  if (selectedCoreTests.indexOf(SearchAndConfigTest) >= 0) { SearchAndConfigTest(); }
  if (selectedCoreTests.indexOf(SystemGeneralBusinessTest) >= 0) { SystemGeneralBusinessTest(); }
  if (selectedCoreTests.indexOf(SystemPagesFinalCoverageTest) >= 0) { SystemPagesFinalCoverageTest(); }
  if (selectedCoreTests.indexOf(SystemRootAndFinalSweepTest) >= 0) { SystemRootAndFinalSweepTest(); }

  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasApexTest) >= 0) { MegaSyntheticRouteAtlasApexTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasAlphaTest) >= 0) { MegaSyntheticRouteAtlasAlphaTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasArborTest) >= 0) { MegaSyntheticRouteAtlasArborTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasAuricTest) >= 0) { MegaSyntheticRouteAtlasAuricTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasAuroraTest) >= 0) { MegaSyntheticRouteAtlasAuroraTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasBastionTest) >= 0) { MegaSyntheticRouteAtlasBastionTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasBetaTest) >= 0) { MegaSyntheticRouteAtlasBetaTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasBorealisTest) >= 0) { MegaSyntheticRouteAtlasBorealisTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasCascadeTest) >= 0) { MegaSyntheticRouteAtlasCascadeTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasCelestialTest) >= 0) { MegaSyntheticRouteAtlasCelestialTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasChiTest) >= 0) { MegaSyntheticRouteAtlasChiTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasCitadelTest) >= 0) { MegaSyntheticRouteAtlasCitadelTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasCinderTest) >= 0) { MegaSyntheticRouteAtlasCinderTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasCometTest) >= 0) { MegaSyntheticRouteAtlasCometTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasCosmosTest) >= 0) { MegaSyntheticRouteAtlasCosmosTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasCrimsonTest) >= 0) { MegaSyntheticRouteAtlasCrimsonTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasDeltaTest) >= 0) { MegaSyntheticRouteAtlasDeltaTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasDynamoTest) >= 0) { MegaSyntheticRouteAtlasDynamoTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasDriftTest) >= 0) { MegaSyntheticRouteAtlasDriftTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasEmberTest) >= 0) { MegaSyntheticRouteAtlasEmberTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasEpsilonTest) >= 0) { MegaSyntheticRouteAtlasEpsilonTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasEquinoxTest) >= 0) { MegaSyntheticRouteAtlasEquinoxTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasExtendedAlphaTest) >= 0) { MegaSyntheticRouteAtlasExtendedAlphaTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasExtendedBetaTest) >= 0) { MegaSyntheticRouteAtlasExtendedBetaTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasExtendedGammaTest) >= 0) { MegaSyntheticRouteAtlasExtendedGammaTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasFlareTest) >= 0) { MegaSyntheticRouteAtlasFlareTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasForgeTest) >= 0) { MegaSyntheticRouteAtlasForgeTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasFrontierTest) >= 0) { MegaSyntheticRouteAtlasFrontierTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasFusionTest) >= 0) { MegaSyntheticRouteAtlasFusionTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasEtaTest) >= 0) { MegaSyntheticRouteAtlasEtaTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasGammaTest) >= 0) { MegaSyntheticRouteAtlasGammaTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasGaleTest) >= 0) { MegaSyntheticRouteAtlasGaleTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasGarnetTest) >= 0) { MegaSyntheticRouteAtlasGarnetTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasGlacierTest) >= 0) { MegaSyntheticRouteAtlasGlacierTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasHaloTest) >= 0) { MegaSyntheticRouteAtlasHaloTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasHarborTest) >= 0) { MegaSyntheticRouteAtlasHarborTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasHorizonTest) >= 0) { MegaSyntheticRouteAtlasHorizonTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasHelixTest) >= 0) { MegaSyntheticRouteAtlasHelixTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasHelmTest) >= 0) { MegaSyntheticRouteAtlasHelmTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasInfernoTest) >= 0) { MegaSyntheticRouteAtlasInfernoTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasIonTest) >= 0) { MegaSyntheticRouteAtlasIonTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasIotaTest) >= 0) { MegaSyntheticRouteAtlasIotaTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasJadeTest) >= 0) { MegaSyntheticRouteAtlasJadeTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasJubileeTest) >= 0) { MegaSyntheticRouteAtlasJubileeTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasJuniperTest) >= 0) { MegaSyntheticRouteAtlasJuniperTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasKappaTest) >= 0) { MegaSyntheticRouteAtlasKappaTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasKestrelTest) >= 0) { MegaSyntheticRouteAtlasKestrelTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasKeystoneTest) >= 0) { MegaSyntheticRouteAtlasKeystoneTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasKingfisherTest) >= 0) { MegaSyntheticRouteAtlasKingfisherTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasLagoonTest) >= 0) { MegaSyntheticRouteAtlasLagoonTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasLambdaTest) >= 0) { MegaSyntheticRouteAtlasLambdaTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasMarinerTest) >= 0) { MegaSyntheticRouteAtlasMarinerTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasLuminaTest) >= 0) { MegaSyntheticRouteAtlasLuminaTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasMeridianTest) >= 0) { MegaSyntheticRouteAtlasMeridianTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasMuTest) >= 0) { MegaSyntheticRouteAtlasMuTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasMirageTest) >= 0) { MegaSyntheticRouteAtlasMirageTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasMonsoonTest) >= 0) { MegaSyntheticRouteAtlasMonsoonTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasNebulaTest) >= 0) { MegaSyntheticRouteAtlasNebulaTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasNimbusTest) >= 0) { MegaSyntheticRouteAtlasNimbusTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasNocturneTest) >= 0) { MegaSyntheticRouteAtlasNocturneTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasNorthstarTest) >= 0) { MegaSyntheticRouteAtlasNorthstarTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasNovaTest) >= 0) { MegaSyntheticRouteAtlasNovaTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasNuTest) >= 0) { MegaSyntheticRouteAtlasNuTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasObsidianTest) >= 0) { MegaSyntheticRouteAtlasObsidianTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasOmicronTest) >= 0) { MegaSyntheticRouteAtlasOmicronTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasOnyxTest) >= 0) { MegaSyntheticRouteAtlasOnyxTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasOrbitTest) >= 0) { MegaSyntheticRouteAtlasOrbitTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasParagonTest) >= 0) { MegaSyntheticRouteAtlasParagonTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasPiTest) >= 0) { MegaSyntheticRouteAtlasPiTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasPioneerTest) >= 0) { MegaSyntheticRouteAtlasPioneerTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasPolarisTest) >= 0) { MegaSyntheticRouteAtlasPolarisTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasPrismTest) >= 0) { MegaSyntheticRouteAtlasPrismTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasQuantumTest) >= 0) { MegaSyntheticRouteAtlasQuantumTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasQuartzTest) >= 0) { MegaSyntheticRouteAtlasQuartzTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasRampartTest) >= 0) { MegaSyntheticRouteAtlasRampartTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasPhiTest) >= 0) { MegaSyntheticRouteAtlasPhiTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasPulseTest) >= 0) { MegaSyntheticRouteAtlasPulseTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasPsiTest) >= 0) { MegaSyntheticRouteAtlasPsiTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasQuasarTest) >= 0) { MegaSyntheticRouteAtlasQuasarTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasRadiantTest) >= 0) { MegaSyntheticRouteAtlasRadiantTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasRelicTest) >= 0) { MegaSyntheticRouteAtlasRelicTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasRhoTest) >= 0) { MegaSyntheticRouteAtlasRhoTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasSierraTest) >= 0) { MegaSyntheticRouteAtlasSierraTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasSigmaTest) >= 0) { MegaSyntheticRouteAtlasSigmaTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasSolsticeTest) >= 0) { MegaSyntheticRouteAtlasSolsticeTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasStellarTest) >= 0) { MegaSyntheticRouteAtlasStellarTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasTalonTest) >= 0) { MegaSyntheticRouteAtlasTalonTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasTempestTest) >= 0) { MegaSyntheticRouteAtlasTempestTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasSummitTest) >= 0) { MegaSyntheticRouteAtlasSummitTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasThetaTest) >= 0) { MegaSyntheticRouteAtlasThetaTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasTorrentTest) >= 0) { MegaSyntheticRouteAtlasTorrentTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasTitanTest) >= 0) { MegaSyntheticRouteAtlasTitanTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasTauTest) >= 0) { MegaSyntheticRouteAtlasTauTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasUmbraTest) >= 0) { MegaSyntheticRouteAtlasUmbraTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasUmberTest) >= 0) { MegaSyntheticRouteAtlasUmberTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasUpsilonTest) >= 0) { MegaSyntheticRouteAtlasUpsilonTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasUnityTest) >= 0) { MegaSyntheticRouteAtlasUnityTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasValorTest) >= 0) { MegaSyntheticRouteAtlasValorTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasVerdantTest) >= 0) { MegaSyntheticRouteAtlasVerdantTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasVanguardTest) >= 0) { MegaSyntheticRouteAtlasVanguardTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasVertexTest) >= 0) { MegaSyntheticRouteAtlasVertexTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasVortexTest) >= 0) { MegaSyntheticRouteAtlasVortexTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasWarpTest) >= 0) { MegaSyntheticRouteAtlasWarpTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasWildfireTest) >= 0) { MegaSyntheticRouteAtlasWildfireTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasWhisperTest) >= 0) { MegaSyntheticRouteAtlasWhisperTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasXiTest) >= 0) { MegaSyntheticRouteAtlasXiTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasXenonTest) >= 0) { MegaSyntheticRouteAtlasXenonTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasXyloTest) >= 0) { MegaSyntheticRouteAtlasXyloTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasYonderTest) >= 0) { MegaSyntheticRouteAtlasYonderTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasYukonTest) >= 0) { MegaSyntheticRouteAtlasYukonTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasZephyrTest) >= 0) { MegaSyntheticRouteAtlasZephyrTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasZenithTest) >= 0) { MegaSyntheticRouteAtlasZenithTest(); }
  if (selectedAtlasTests.indexOf(MegaSyntheticRouteAtlasZetaTest) >= 0) { MegaSyntheticRouteAtlasZetaTest(); }
}
