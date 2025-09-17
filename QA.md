# Typix Q&A

## Package Management and Network Isolation

### Q: What happens if I import a Typst package that's not listed in `unstable_typstPackages`?

**A:** The behavior depends on your environment:

#### Development Environment (`nix develop`)
- ✅ **Allowed**: Downloads packages from Typst Universe
- 🔄 **Downloads**: `@preview/tablex:0.0.8` → `41.8 KiB downloaded successfully`  
- 🎯 **Purpose**: Enables experimentation and development

#### Production Build (`nix run .#build`)
- ❌ **Blocked**: Network access prevented by Nix sandbox
- 🛡️ **Error**: `failed to download package (Network Error: OpenSSL error)`
- 📍 **Location**: Points to exact line in source file
- 💡 **Solution**: Add missing package to `unstable_typstPackages` array

#### Example Error Message
```
downloading @preview/tablex:0.0.8
error: failed to download package (Network Error: OpenSSL error)
   ┌─ typst-src/main.typ:19:8
   │
19 │ #import "@preview/tablex:0.0.8"
   │         ^^^^^^^^^^^^^^^^^^^^^^^
```

### Q: How does typix ensure reproducible builds?

**A:** Through multiple layers of isolation:

1. **Nix Sandbox**: Blocks all network access during builds
2. **Package Pinning**: Exact versions with content hashes in `flake.nix`
3. **Pre-fetching**: All packages downloaded at build preparation, not compilation
4. **Transitive Dependencies**: Must be explicitly declared (e.g., `oxifmt` for `cetz`)

### Q: Can I accidentally download packages during CI?

**A:** No. The CI environment uses the same Nix sandbox that blocks network access. Any missing package will cause the build to fail immediately with a clear error message, preventing silent downloads or non-reproducible builds.

### Q: How do I add a new package dependency?

1. **Identify the package**: Note name and version from Typst Universe
2. **Get the hash**: Use `nix-prefetch-url` or let Nix calculate it
3. **Add to flake.nix**:
   ```nix
   unstable_typstPackages = [
     {
       name = "tablex";
       version = "0.0.8";
       hash = "sha256-abc123...";
     }
   ];
   ```
4. **Include transitive dependencies**: Check if the package imports other packages

This design ensures **fail-fast, fail-clear** behavior while maintaining complete build reproducibility.