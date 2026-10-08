# AEVA iOS — Codemagic-ready project

This archive contains the AEVA SwiftUI app and a valid XcodeGen project specification.

## Codemagic

The `codemagic.yaml` workflow installs XcodeGen, generates a fresh Xcode project from `project.yml`, lists the scheme, builds the unsigned iOS app, and uploads the resulting app bundle as an artifact.

This first workflow is a compile check. An unsigned `.app` is not directly installable on an iPhone. Apple signing/export will be configured after the build succeeds.
