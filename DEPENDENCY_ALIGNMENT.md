# TanStack Dependency Alignment & Version Synchronization

This document provides a technical deep-dive into the dependency management strategy used to stabilize the `footbal_api` project. Use this as a reference for maintaining the project's build integrity.

## 1. The Core Problem: Version Fragmentation

In rapidly evolving ecosystems like TanStack, transitive dependencies (dependencies of your dependencies) often resolve to their latest "compatible" versions automatically. However, during the transition from `@tanstack/start` to `@tanstack/react-start`, several breaking changes and export mismatches occurred.

### Symptoms Observed:
- **Missing Exports**: `SyntaxError: The requested module '@tanstack/router-generator' does not provide an export named 'CONSTANTS'`.
- **Runtime Crashes**: Inconsistencies between `router-core` and `react-router` caused internal state mismatches.
- **Build Inconsistencies**: Multiple versions of the same library (e.g., `router-core` v1.120 and v1.144) existing simultaneously in the `node_modules` tree.

## 2. The Solution: Strict Version Overrides

To resolve this, we utilized **pnpm overrides**. This feature allows us to bypass the standard version resolution logic and force every single package in the project—including transitive ones—to use a specific, tested version.

### The "Version 1.120.x" Baseline
We pinned the ecosystem to a consistent baseline (mostly `1.120.20` and its immediate ancestors). This is the last stable "unified" state for this project's configuration.

### Overrides Breakdown (package.json)
The following configuration in `package.json` is the source of truth for the project's stability:

```json
"pnpm": {
  "overrides": {
    "vite": "6.4.1",
    "@tanstack/router-generator": "1.120.20",
    "@tanstack/router-plugin": "1.120.20",
    "@tanstack/react-start-plugin": "1.120.17",
    "@tanstack/start-plugin-core": "1.120.17",
    "@tanstack/react-start-config": "1.120.20",
    "@tanstack/start-config": "1.120.20",
    "@tanstack/server-functions-plugin": "1.120.17",
    "@tanstack/start-server-functions-client": "1.120.19",
    "@tanstack/start-server-functions-server": "1.120.17",
    "@tanstack/start-server-functions-ssr": "1.120.19",
    "@tanstack/start-server-functions-handler": "1.120.19",
    "@tanstack/react-start-client": "1.120.20",
    "@tanstack/react-start-server": "1.120.20",
    "@tanstack/react-start-router-manifest": "1.120.19",
    "@tanstack/start-api-routes": "1.120.19",
    "@tanstack/start-client-core": "1.120.19",
    "@tanstack/start-server-core": "1.120.19",
    "@tanstack/start-server-functions-fetcher": "1.120.19",
    "@tanstack/router-core": "1.120.19",
    "@tanstack/history": "1.120.17",
    "@tanstack/react-store": "0.7.7"
  }
}
```

## 3. Critical Dependencies Explained

| Package | Version | Role |
| :--- | :--- | :--- |
| `router-core` | `1.120.19` | The central logic for routing. Must match `react-router`. |
| `start-server-core` | `1.120.19` | Handles the SSR and Nitro integration logic. |
| `router-plugin` | `1.120.20` | The Vite plugin that generates the route tree. |
| `history` | `1.120.17` | Manages the browser history stack. |

## 4. Maintenance & Upgrade Path

### How to avoid Breaking the Build
1. **Never use `pnpm update` blindly**: This may remove the pinned versions in favor of newer ones that aren't yet compatible with the current project structure.
2. **Adding New Packages**: If you add a TanStack package (e.g., `@tanstack/react-query`), check the `pnpm-lock.yaml` to ensure it isn't pulling in a newer version of `router-core` or `history`. If it is, explicitly add that package to the `overrides`.

### Future Upgrades
The next logical upgrade for this project is a complete shift to the unified `@tanstack/react-start` (v1.x). This will require:
1. Removing all `pnpm overrides`.
2. Updating all imports from `@tanstack/start` to `@tanstack/react-start`.
3. Updating Vite to the latest stable (v6.0+).
4. Updating the folder structure to the standard `app/` convention.

**Note**: Until that migration is performed, the current overrides are **mandatory** for the project to build.
