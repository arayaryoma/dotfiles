---
name: pnpm-harden
description: Enable pnpm's built-in supply-chain hardening features on a pnpm project — install-time delay (minimumReleaseAge), postinstall script allowlisting (allowBuilds / onlyBuiltDependencies), strict dep build gating (strictDepBuilds), exotic subdep blocking (blockExoticSubdeps), trust policy, dependency verification before run, audit policy, and any other security-relevant settings currently documented at https://pnpm.io/settings. Use this skill whenever the user asks to "enable pnpm security features", "harden pnpm", "lock down pnpm", "secure dependencies", "block postinstall scripts", or talks about supply-chain risk, npm/pnpm CVEs, postinstall scripts, or audit policy in a pnpm project — even if they don't name a specific setting. Also use it proactively when introducing pnpm to a project or upgrading pnpm to a version that ships new security knobs.
---

# pnpm-harden

Enable pnpm's supply-chain hardening features on a project in one pass. The user has agreed to an "apply recommended defaults, then adjust" stance — don't ask them to confirm each setting individually. Show the diff at the end and let them push back.

The pnpm settings surface evolves quickly. The skill always cross-references the live docs (`https://pnpm.io/<major>.x/settings`) and the project's installed pnpm version before applying anything. Don't trust this file's setting names blindly — they may have been renamed or moved between majors.

## Workflow

### 1. Probe the project

Run in parallel:
- `pnpm --version` — gates which settings are available. Record `<MAJOR>` and `<MINOR>`.
- `ls -la` at repo root to spot `.npmrc`, `package.json`, `pnpm-workspace.yaml`, and any nested copies in workspace packages
- Read `package.json` (top-level + `pnpm` field), `.npmrc`, and `pnpm-workspace.yaml` if present
- If a monorepo: read every workspace package's `package.json#pnpm` and any nested `.npmrc` so you can report and migrate stale settings later

Record:
- pnpm major/minor (gates feature availability — see version gate table below)
- workspace vs single project
- existing security-relevant settings, including any in stale locations that should move

### 2. Fetch the canonical settings list — pinned to the project's pnpm major

Use WebFetch on the version-specific URL:
- pnpm 10.x → `https://pnpm.io/10.x/settings`
- pnpm 11.x → `https://pnpm.io/settings` (latest)
- Also fetch `https://pnpm.io/<major>.x/cli/audit` for `auditConfig` details

Prompt:

> List every setting on this page that affects supply-chain security: postinstall / lifecycle script execution, install timing/freshness, audit policy, dependency verification, peer dependency strictness, trust policy, lockfile integrity, store integrity, exotic dependency sources. For each, give the setting name (exactly as written), the default value, the pnpm version it was introduced in (if mentioned), and a one-line description. Note any settings that replace or supersede older settings.

This is the source of truth. The baseline in step 4 is a starting hypothesis — reconcile it against the fetched list and prefer the fetched list when they disagree on names or defaults. If WebFetch fails, say so loudly in the report and proceed with the baseline knowing it may lag.

### 3. Choose the config file

**Always prefer `pnpm-workspace.yaml` at repo root**, even for single-project (non-monorepo) repos. pnpm 11 narrows `.npmrc` to auth/registry settings only, and `package.json#pnpm` is the legacy spot — both should be migrated *out* over time.

Decision rule:
- If `pnpm-workspace.yaml` exists → write pnpm settings there. Preserve the existing `packages:` array exactly.
- Else → create `pnpm-workspace.yaml` at repo root with just the security settings (no `packages:` is fine for a single-package repo; pnpm reads it as workspace-root config).
- Existing `package.json#pnpm` entries → **flag for migration in the report; show the user a proposed `pnpm-workspace.yaml` snippet and confirm before moving**. Don't relocate silently. The skill itself only ever *writes new settings*; relocating existing ones is a user-approved step.
- Existing `.npmrc` entries → handle by category:
  - **Keep in `.npmrc`** (pnpm 10 and 11): auth tokens and certificate material — `_authToken`, `_password`, `username`, `email`, `tokenHelper`, `ca`, `cafile`, `cert`, `key`.
  - **Migrate to `pnpm-workspace.yaml` on pnpm 11**: registry config (`registry`, `@scope:registry` → `registries`), proxy/SSL (`https-proxy`/`httpsProxy`, `noproxy`/`noProxy`, `strict-ssl`/`strictSsl`). pnpm 11 reads these from `pnpm-workspace.yaml`, not `.npmrc`. On pnpm 10 they can stay in `.npmrc`.
  - **Always migrate**: any other behavior setting (audit, builds, peer deps, resolution mode, etc.).
  - In every case: flag for migration in the report, show the proposed snippet, don't move silently.
  - **Danger check**: if `.npmrc` contains auth/TLS secrets (`_authToken`, `_password`, `key`, etc.) **and** it's tracked by git, flag it as a leak risk. Recommend moving secrets to `${VAR}`-style env interpolation and adding `.npmrc` (or at least the leaked file) to `.gitignore`. Don't fix automatically — show the user what was found and let them decide.

This makes the skill safe to re-run: it never moves the user's existing config without an explicit OK.

In YAML, use the **exact camelCase names** from pnpm's docs (`strictPeerDependencies`, `resolutionMode`, `verifyDepsBeforeRun`, etc.). The kebab-case forms (`strict-peer-dependencies`) are `.npmrc` syntax and must NOT be mixed into YAML.

### 4. Apply the baseline

Apply settings the project's pnpm version supports. Skip any setting whose name doesn't exist in the fetched docs for that pnpm version. Preserve user-tuned non-default values in place but list them in the final report.

#### Version gate (use to pick settings that actually exist)

| Setting | Available from | Notes |
|---|---|---|
| `minimumReleaseAge`, `minimumReleaseAgeExclude` | pnpm 10.16+ | Pattern support 10.17+, version selectors 10.19+ |
| `minimumReleaseAgeIgnoreMissingTime`, `minimumReleaseAgeStrict` | pnpm 11.x | pnpm 11 default for `ignoreMissingTime` is `true` (skip age check when registry metadata lacks `time`). For hardening, **set `false`** so missing-time installs fail loudly. Especially relevant on private registries/mirrors that don't emit `time`. |
| `onlyBuiltDependencies` | pnpm 10.x | **Removed in pnpm 11** — superseded by `allowBuilds` |
| `ignoredBuiltDependencies` | pnpm 10.1+ | **Removed in pnpm 11** — superseded by `allowBuilds`. Don't write on pnpm 10.0.x |
| `onlyBuiltDependenciesFile`, `neverBuiltDependencies`, `ignoreDepScripts` | pnpm 10.x | **All removed in pnpm 11** — surface as migration candidates to `allowBuilds` |
| `allowBuilds` | pnpm 10.26+ | Replaces the entire group above |
| `blockExoticSubdeps` | pnpm 10.26+ | Default `false` in pnpm 10, `true` in pnpm 11 |
| `strictDepBuilds` | pnpm 10.3+ | Default `false` in pnpm 10, `true` in pnpm 11. Don't write on pnpm 10.0–10.2 |
| `trustPolicy` | pnpm 10.21+ | See note below — gates by trust evidence, not by version number |
| `trustPolicyExclude` | pnpm 10.22+ | |
| `trustPolicyIgnoreAfter` | pnpm 10.27+ | |
| `verifyDepsBeforeRun` | pnpm 10.x | Default `install` in pnpm 11 |
| `auditConfig.ignoreCves` | pnpm 10.x | **Removed in pnpm 11** — use `ignoreGhsas` |
| `auditConfig.ignoreGhsas` | pnpm 10.x+, pnpm 11 | Stays |
| `pnpm audit signatures` (CLI) | pnpm 11.1.0+ | Gate CI recommendations on this exact version |

Always cross-check this table against the WebFetch result; pnpm releases often.

#### Baseline (pnpm 10.26+ / 11.x)

```yaml
# pnpm-workspace.yaml — at repo root

# Install-time delay. 7 days = 60 * 24 * 7 = 10080 minutes.
# Buys time for the ecosystem to flag a compromised release before it lands here.
# If the team finds 7 days too slow, drop to 1440 (1 day) — still defeats most fast-yank attacks.
minimumReleaseAge: 10080
minimumReleaseAgeExclude: []
# Add entries for: internal scoped packages (e.g. "@your-org/*"), emergency security fixes,
# or packages your Renovate/Dependabot config needs to flow through immediately.

# Block postinstall / lifecycle scripts of transitive packages by default.
# pnpm 10.26+ / 11.x: allowBuilds is an object map { "<pkg>": true | false } — populated via
# `pnpm approve-builds` as the user audits each. Start empty.
allowBuilds: {}

# Make unapproved build scripts an error, not a warning. (pnpm 11 default is true.)
strictDepBuilds: true

# Reject transitive deps that resolve to git URLs, tarball URLs, or other non-registry sources.
# (pnpm 11 default is true; explicit is fine on pnpm 10.)
blockExoticSubdeps: true

# Verify node_modules matches the lockfile before running scripts.
# Local default "install" auto-syncs. CI should override to "error" — recommend via env var:
#   PNPM_CONFIG_VERIFY_DEPS_BEFORE_RUN=error
verifyDepsBeforeRun: install

# Surface peer dep resolution issues early.
strictPeerDependencies: true

# Audit policy. ignoreGhsas is the forward-compatible field (pnpm 11 dropped ignoreCves).
auditConfig:
  ignoreGhsas: []   # add only with a comment + expiry date
auditLevel: moderate

# Only valid on pnpm 11.x. pnpm 11 defaults this to `true` (skip age check when
# registry metadata lacks `time`). Hardening flips it to `false` so silently-missing
# `time` fields don't bypass minimumReleaseAge.
minimumReleaseAgeIgnoreMissingTime: false
```

For projects still on **pnpm 10.1–10.25** (no `allowBuilds` yet), substitute:
```yaml
onlyBuiltDependencies: []      # allowlist; populate via `pnpm approve-builds`
ignoredBuiltDependencies: []   # blocklist
```

If the existing project uses any of `onlyBuiltDependenciesFile`, `neverBuiltDependencies`, or `ignoreDepScripts`, these are also removed in pnpm 11 alongside `onlyBuiltDependencies` / `ignoredBuiltDependencies`. When the project is on pnpm 11, surface all of them as migration candidates to `allowBuilds`.

For projects on **pnpm 10.x but not 11**, also include `auditConfig.ignoreCves: []` if the WebFetch confirms it exists.

#### Don't add these to the baseline (they need judgment)

- `ignoreScripts: true` — also blocks the project's own scripts. Too destructive as a default.
- `executionEnv.nodeVersion` / `useNodeVersion` — runtime pinning, not supply-chain. Touch only when no `.nvmrc` / `engines.node` / CI Node version exists.
- `trustPolicy` — `no-downgrade` rejects installs where the *trust evidence* (registry signatures, provenance) for an incoming version is weaker than what was previously trusted for that package. It is NOT a version-downgrade blocker. Powerful but can surprise teams whose internal registries don't yet emit signatures consistently. Suggest in the report, don't auto-apply unless asked.
- `packageManagerStrict` / `packageManagerStrictVersion` — version-gated; pnpm 11 renames to `pmOnFail`.

### 5. Run a verifying install

Run `pnpm install` (not `--frozen-lockfile` — the new settings may shift the lockfile).

Expected friction points:
- **Build scripts blocked.** pnpm prints a list of packages whose lifecycle scripts were ignored. Surface the full list. Recommend running `pnpm approve-builds` interactively — it will populate `allowBuilds` (or `onlyBuiltDependencies` on pnpm 10.1–10.25) after the user audits each. Don't add entries yourself.
- **`minimumReleaseAge` blocks a fresh install.** Options: lower the threshold, add the offending package(s) to `minimumReleaseAgeExclude`, or wait.
- **`strictDepBuilds: true` turns existing warnings into errors.** Same triage as build scripts blocked.
- **`blockExoticSubdeps: true` rejects existing git/tarball subdeps.** If there are legitimate ones, surface them — the user may need to fork or vendor.

### 6. Report

Print:
- **Settings added** (name, value, file)
- **Settings already present, left alone** (with current value — the user may want to reconsider)
- **Migration candidates**: existing settings in `package.json#pnpm` or `.npmrc` that should move to `pnpm-workspace.yaml`. Show the proposed snippet; let the user decide. (The skill never moves them silently.)
- **Settings skipped** because the pnpm version is too old (with the minimum version required)
- **New settings from WebFetch** not in this skill's baseline, with what they do and whether you applied them
- **Existing dangerous settings** flagged (e.g., `dangerouslyAllowAllBuilds: true`, `strictPeerDependencies: false`, audit ignores without comments)
- **Postinstall packages blocked** by the new install, awaiting `pnpm approve-builds`
- **Suggested CI additions**: `pnpm install --frozen-lockfile`, `pnpm audit --audit-level moderate`, and on pnpm 11.1.0+ `pnpm audit signatures` (registry signature verification — gate on the exact minor). Also set `PNPM_CONFIG_VERIFY_DEPS_BEFORE_RUN=error` in CI.

Don't commit. This is a behavior change; the user should validate locally and in CI first.

## Notes on individual settings

**minimumReleaseAge** — Protects against the "package published → compromised → yanked within a day" window. 1440 (1 day) defeats most fast-yank attacks; 10080 (1 week) is more conservative. Use `minimumReleaseAgeExclude` for internal scoped packages and any package your bot tooling must roll forward immediately.

**allowBuilds / onlyBuiltDependencies** — Treat additions as a mini code review: at minimum skim the package's `scripts.postinstall`. Prefer driving this via `pnpm approve-builds` so the user sees what they're approving.

**resolutionMode** — `time-based` (pnpm 10+) is a non-trivial behavior change: direct deps resolve to the lowest matching version, and subdeps resolve as of the latest direct dep's publish time. It improves reproducibility but can surprise teams used to "always newest". Don't enable as part of the baseline unless the user asks for reproducibility specifically — call it out in the report instead.

**allowedDeprecatedVersions** — Despite the name, this only mutes deprecation *warnings*. It does NOT block installs. Don't include it in the baseline as a security setting.

**trustPolicy** — `no-downgrade` rejects an incoming version whose trust evidence (signatures / provenance) is weaker than what's already been accepted for that package — a known supply-chain attack pattern where the attacker re-publishes without provenance. It is NOT about semver downgrades. The skill should recommend it, not impose, since internal-registry hygiene varies.

**auditConfig** — Entries in `ignoreGhsas` (or `ignoreCves` on pnpm 10) silence real findings. Each entry needs a justification comment and an expiry date.

**pnpm approve-builds** — On pnpm 10.26+ / 11.x this writes to `allowBuilds`. On pnpm 10.1–10.25 it writes to `onlyBuiltDependencies` / `ignoredBuiltDependencies`. The skill should mention this difference if the user asks where their approvals went.

## Don'ts

- Don't enable `dangerouslyAllowAllBuilds`. The name is a warning.
- Don't silence `strictPeerDependencies` to make a warning go away — fix the peer.
- Don't bulk-add packages to `allowBuilds` / `onlyBuiltDependencies` without reading their postinstall.
- Don't write pnpm settings into `.npmrc` on pnpm 11; only auth/registry belong there.
- Don't mix kebab-case names into YAML — use the camelCase names from the pnpm docs.
- Don't run `pnpm setup` from this skill. It rewrites the user's shell environment and isn't reversible from here. Confirm `packageManager` in `package.json` and Corepack/CI version pinning instead.
- Don't fall back to the in-file baseline silently if WebFetch fails. Say so in the report — the point of the fetch is to stay current.
- Don't commit. Let the user validate first.
