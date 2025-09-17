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

## Math Equations in HTML Export

### Q: How do I render math equations in Typst HTML export?

**A:** Typst's HTML export doesn't support math equations natively, but there are effective workarounds:

#### **Current Status (2024-2025)**
- ❌ **No native MathML**: Implementation was attempted but closed (PR #5721)
- ⚠️ **HTML export ignores math**: Equations disappear in HTML by default
- ✅ **SVG workaround**: Using `html.frame()` converts math to inline SVGs

#### **Recommended Solution**
```typst
// Math helper function for HTML compatibility
#let math-html(equation) = context {
  if sys.inputs.at("target", default: "pdf") == "html" {
    // Handle inline vs block equations properly
    if equation.has("block") and equation.block == false {
      box(html.frame(equation))  // Inline: keep on same line
    } else {
      html.frame(equation)       // Block: standalone
    }
  } else {
    equation  // Native math for PDF
  }
}

// Usage
Here's inline: #math-html($E = m c^2$) and display:
#math-html($ x = (-b plus.minus sqrt(b^2 - 4a c)) / (2a) $)
```

#### **CSS Styling**
Add CSS to improve math appearance:
```css
/* Block equations: centered */
svg { margin: 1.5em auto; display: block; border-radius: 8px; }
/* Inline equations: aligned with text */
span svg { margin: 0; display: inline-block; vertical-align: middle; }
```

#### **Alternative: Global Show Rules**
For automatic equation handling:
```typst
#show math.equation: it => context {
  if sys.inputs.at("target") == "html" {
    if it.block { html.frame(it) } else { box(html.frame(it)) }
  } else {
    it
  }
}
```

#### **Result**
- **PDF**: Perfect native math rendering
- **HTML**: Math as crisp SVG graphics with proper inline/block behavior
- **Cross-platform**: Works in all browsers that support SVG