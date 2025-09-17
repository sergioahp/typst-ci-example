# TODO

## CI Reproducibility Improvements

### Goal: Use Sandboxed Production Build in CI

Currently the CI uses `nix develop -c typst compile` which allows network access and could download packages from Typst Universe during builds. This reduces reproducibility.

**Current State:**
- CI uses development environment (`nix develop`)
- Network access allowed during compilation
- Missing packages could be silently downloaded
- Less reproducible than pure sandboxed builds

**Target State:**
- CI uses production build (`nix run .#build`) 
- Network access blocked by Nix sandbox
- All dependencies pre-fetched and pinned
- Maximum reproducibility guaranteed

### Investigation Needed

**Question:** Does `nix develop` actually use packages downloaded by Nix already, or does it still download from Typst Universe?

**Test Plan:**
1. Add a package to `unstable_typstPackages` in `flake.nix`
2. Import that package in `typst-src/main.typ`
3. Run `nix develop -c typst compile` and check if:
   - It uses the pre-fetched Nix package
   - Or downloads fresh from Typst Universe
4. Monitor network activity during compilation

**Implementation Steps:**
1. Configure flake to support both PDF and HTML outputs in production build
2. Update CI workflow to use `nix run .#build-pdf` and `nix run .#build-html`
3. Verify no network access during CI builds
4. Test that missing packages cause immediate build failures

This ensures fail-fast, fail-clear behavior while maintaining complete build reproducibility.