# Policy-as-code guardrail (Conftest / OPA): every resource that ends up in state must
# carry our cost-allocation tags. Run it against a plan and fail the pipeline before apply,
# instead of "ask the senior engineer to eyeball it."
#
#   tofu plan -out tfplan.binary
#   tofu show -json tfplan.binary > plan.json
#   conftest test --policy policy plan.json
package main

import rego.v1

required := {"owner", "project", "env"}

deny contains msg if {
	some rc in input.resource_changes
	rc.change.after != null # skip pure deletes
	tags := object.get(rc.change.after, "tags", {})
	present := {k | some k, _ in tags}
	missing := required - present
	count(missing) > 0
	msg := sprintf("%s is missing required tags: %v", [rc.address, missing])
}
