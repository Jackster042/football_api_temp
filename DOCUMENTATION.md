# TanStack Start Project Alignment & Deployment Documentation

This document summarizes the comprehensive changes made to the `footbal_api` project on December 31, 2025, to resolve critical version conflicts, align the project structure, and enable successful deployment to Cloudflare Pages.

## 1. Dependency Alignment & Version Synchronization

The primary challenge was a severe version mismatch across the TanStack ecosystem. Different packages were resolving to incompatible versions (e.g., `1.131.x` and `1.120.x`), leading to runtime export errors like `SyntaxError: The requested module ... does not provide an export named 'CONSTANTS'`.

### Action Taken: pnpm Overrides
We implemented strict `pnpm` overrides in `package.json` to force the entire dependency tree to use compatible `1.120.x` versions. This is critical for TanStack Start projects using older `@tanstack/start` packages before they fully transitioned to `@tanstack/react-start`.

**Key Overrides Implemented:**
- `@tanstack/react-router`: `1.120.20`
- `@tanstack/react-start`: `1.120.20`
- `@tanstack/router-core`: `1.120.19`
- `@tanstack/router-plugin`: `1.120.20`
- `@tanstack/start-server-core`: `1.120.19`
- `@tanstack/start-client-core`: `1.120.19`
- `@tanstack/history`: `1.120.17`
- `@tanstack/react-store`: `0.7.7`

## 2. Project Structure & Configuration

The project used a `src/` directory for code, but the default TanStack Start configuration often looks for an `app/` directory.

### app.config.ts
Modified the configuration to explicitly point to `src/` for routes, components, and generated files:
- `appDirectory: './src'`
- `routesDirectory: './src/routes'`
- `generatedRouteTree: './src/routeTree.gen.ts'`

### Entry Points
Created the mandatory entry points required by Vinxi (the underlying bundler for TanStack Start):
- **`src/client.tsx`**: Handles client-side hydration. Added a `default export` of the router to satisfy Vinxi's internal requirements.
- **`src/ssr.tsx`**: Handles server-side rendering using `createStartHandler`.

## 3. Styling & Tailwind CSS 4.0

The project uses Tailwind CSS v4, which introduced significant changes to the build pipeline.

### Alignment & Stability
- Updated `tailwindcss` and `@tailwindcss/vite` to version `4.1.18`.
- Resolved `[@tailwindcss/vite:generate:build] Cannot convert undefined or null to object` errors by ensuring version consistency between the main package and the Vite plugin.

### Live Site Fixes
- **@source Directive**: Explicitly added `@source "./**/*.{ts,tsx}";` to `src/styles.css`. This ensures that Tailwind v4 correctly scans the `src` directory for utility classes in the production build.
- **Root Component Correction**: Switched from `shellComponent` to `component` in `src/routes/__root.tsx`. In version `1.120.20`, `shellComponent` is unsupported, which previously caused the entire HTML shell (including `<Scripts />` and `<HeadContent />`) to be skipped.

## 4. UI & Debugging Improvements

### TanStack Router DevTools
- Fixed a broken import in `__root.tsx`. The code was attempting to import `@tanstack/react-devtools`, which was not installed.
- Switched to the correct `@tanstack/react-router-devtools` and simplified the implementation for better stability.

## 5. Cloudflare Pages Deployment

Resolved deployment errors related to project naming and configuration.

### wrangler.jsonc Updates
- **Name**: Changed to `footbal-api` (Cloudflare requires lowercase and dashes; underscores are invalid).
- **pages_build_output_dir**: Explicitly set to `dist` to guide the deployment process.
- **Compatibility**: Set `compatibility_date` to `2024-12-01` and ensured `nodejs_compat` is enabled for Nitro server functionality.

## 6. How to Maintain This Project

### Building Locally
Use the standard build command:
```bash
pnpm run build
```
This runs `vinxi build` which generates the production bundle in `.vinxi/` and the final deployment output in `dist/`.

### Deployment
Deployment is handled via Wrangler:
```bash
npx wrangler pages deploy
```

### Adding New Dependencies
**Warning**: When adding new TanStack-related dependencies, you must check if they are governed by the `pnpm.overrides` section in `package.json`. If you add a package that brings in a newer version of a core library (like `router-core`), the build may break again. Always aim to pin TanStack versions until a full upgrade to the latest `@tanstack/react-start` (v1.x+) is planned.

---
**Status**: Stable & Deployed
**Environment**: Cloudflare Pages / Nitro
**Framework**: TanStack Start (v1.120.20)
