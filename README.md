Removes bloat from Windows.
This script is based around Dell laptops.

First WSL is uninstalled, as general users are not using this.
Next there is a modified verson of IntegratedServicesRegionPolicySet.json that adds the GB region, to put Windows in DMA mode.
Lastly a bulk of useless preinstalled apps are removed.

This is not a full clean as currently I have other cleanup done through group policy.
More will be added to the script over time.
