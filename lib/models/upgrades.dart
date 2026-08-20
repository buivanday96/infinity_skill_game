import 'upgrade_data.dart';
import 'upgrade_ids.dart';
import 'upgrades/arrow_upgrades.dart';
import 'upgrades/core_upgrades.dart';
import 'upgrades/slow_upgrades.dart';
import 'upgrades/lightning_upgrades.dart';
import 'upgrades/burn_upgrades.dart';
import 'upgrades/economy_upgrades.dart';
import 'upgrades/explosive_upgrades.dart';
import 'upgrades/artifact_upgrades.dart';
import 'upgrades/misc_upgrades.dart';

export 'upgrade_ids.dart';

final Map<Upgrade, UpgradeData> upgradesMap = {
  ...arrowUpgrades,
  ...coreUpgrades,
  ...slowUpgrades,
  ...lightningUpgrades,
  ...burnUpgrades,
  ...economyUpgrades,
  ...explosiveUpgrades,
  ...artifactUpgrades,
  ...miscUpgrades,
};
