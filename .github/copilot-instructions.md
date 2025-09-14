# Roo Code AI-Powered VS Code Extension

**ALWAYS follow these instructions first** and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

Roo Code is an AI-powered autonomous coding agent that lives in VS Code. It's built as a TypeScript VS Code extension with a React webview UI, organized as a monorepo with multiple packages.

## Working Effectively

### Initial Setup & Dependencies

- **Node.js Version**: 20.19.2 (current: 20.19.5 works but shows warnings)
- **Package Manager**: pnpm@10.8.1 (automatically bootstrapped)
- **Install Dependencies**: `pnpm install` -- takes ~1m 9s. NEVER CANCEL. Set timeout to 3+ minutes.

### Core Development Commands

- **Full Build**: `pnpm bundle` -- First time: ~2m, cached: ~2s. Builds all dependencies.
- **Extension Only**: `pnpm --filter="roo-cline" bundle` -- takes ~3s (needs dependencies built first).
- **Build Webview**: `pnpm --filter @roo-code/vscode-webview build` -- takes ~40s. NEVER CANCEL. Set timeout to 2+ minutes.
- **Run Tests**: `pnpm test` -- takes ~3m 15s. NEVER CANCEL. Set timeout to 10+ minutes.
- **Lint Code**: `pnpm lint` -- takes ~22s. Set timeout to 2+ minutes.
- **Format Code**: `pnpm format` -- takes ~17s. Set timeout to 1+ minute.
- **Type Check**: `pnpm check-types` -- takes ~1m 9s. NEVER CANCEL. Set timeout to 3+ minutes.
- **Build VSIX Package**: `pnpm vsix` -- takes ~2m first time, handles all dependencies. NEVER CANCEL. Set timeout to 5+ minutes.

### Development Workflow

- **Debug Extension**: Press `F5` in VS Code to open Extension Development Host
- **Watch Mode**: Use VS Code task "watch" to auto-rebuild on changes
- **Quick Build**: `pnpm bundle` for fast development builds (uses turbo caching)
- **From Clean State**: First build takes ~2m, subsequent builds use cache (~2s)
- **Development Scripts**:
    - `pnpm --filter @roo-code/vscode-webview dev` - Start webview dev server
    - `cd src && pnpm watch:bundle` - Watch and rebuild extension
    - `npx turbo watch:tsc` - Watch TypeScript compilation

## Validation & Testing

### Pre-commit Validation

- **ALWAYS run before committing**: `pnpm lint && pnpm format && pnpm check-types`
- **CI will fail without these**: The GitHub workflow requires lint/format/typecheck to pass

### Manual Testing Scenarios

- **Extension Loading**: Press F5 and verify Roo Code panel appears in VS Code sidebar
- **Webview Functionality**: Test chat interface, settings, and file operations
- **Bundle Integrity**: After changes, run `pnpm bundle` and verify no errors
- **Complete Build**: Test `pnpm vsix` creates VSIX package in `bin/` directory

### Integration Tests

- **E2E Tests**: Located in `apps/vscode-e2e/` - require API keys in `.env.local`
- **Unit Tests**: Comprehensive test suite covers API providers, core functionality
- **Test Command**: `pnpm test` runs all packages, use `pnpm --filter="roo-cline" test` for extension only

## Build System & Architecture

### Monorepo Structure

```
├── src/                    # Main VS Code extension (roo-cline)
├── webview-ui/            # React webview UI (@roo-code/vscode-webview)
├── packages/              # Shared packages (types, build, cloud, etc.)
├── apps/                  # Applications (e2e tests, web apps)
└── bin/                   # Built VSIX packages
```

### Build Targets

- **Extension Bundle**: esbuild compiles TypeScript → JavaScript bundle
- **Webview UI**: Vite builds React → static assets in `src/webview-ui/build/`
- **VSIX Package**: VS Code extension package for distribution

### Known Build Issues

- **Network Restrictions**: Web apps (`apps/web-*`) fail due to `fonts.googleapis.com` blocking
- **Font Dependencies**: Next.js apps can't fetch Google Fonts in restricted environments
- **Workaround**: Focus on core extension (`src/`) and webview (`webview-ui/`) development

## Common Development Tasks

### Adding New Features

1. **Core Logic**: Add to `src/core/`, `src/api/`, or `src/services/`
2. **UI Components**: Add to `webview-ui/src/components/`
3. **Tests**: Add corresponding tests in `__tests__/` directories
4. **Build & Test**: `pnpm --filter="roo-cline" bundle && pnpm test`

### Debugging Issues

1. **Extension Logs**: Check VS Code Developer Console (Help → Toggle Developer Tools)
2. **Webview Debugging**: Right-click webview → Inspect Element
3. **Build Errors**: Check `pnpm bundle` output for compilation issues
4. **Test Failures**: Run `pnpm --filter="roo-cline" test` for detailed output

### Package Management

- **Add Dependencies**: `pnpm add <package>` in relevant directory
- **Workspace Dependencies**: Use `workspace:^` for internal packages
- **Update Lock**: `pnpm install` after dependency changes

## File Locations & Key Components

### Configuration Files

- **Extension Manifest**: `src/package.json` - VS Code extension configuration
- **Webview Config**: `webview-ui/vite.config.ts` - Vite build settings
- **TypeScript**: `tsconfig.json` (root), `src/tsconfig.json` (extension)
- **ESLint**: `eslint.config.mjs` files in each package
- **VS Code**: `.vscode/launch.json` - Debug configuration

### Core Extension Files

- **Entry Point**: `src/extension.ts` - VS Code extension activation
- **API Providers**: `src/api/providers/` - AI model integrations
- **Core Tools**: `src/core/tools/` - File operations, terminal commands
- **Webview Bridge**: `src/services/` - Communication with React UI

### Common File Operations

- **View Package Scripts**: `grep -A 20 "scripts" package.json`
- **Find Configuration**: `find . -name "*.config.*" -not -path "*/node_modules/*"`
- **Check Build Output**: `ls -la src/dist/` (extension), `ls -la src/webview-ui/build/` (webview)

## Troubleshooting

### Build Issues

- **Bundle Fails**: Check for TypeScript errors with `pnpm check-types`
- **Webview Issues**: Ensure `pnpm --filter @roo-code/vscode-webview build` completes
- **Missing VSIX**: Run `pnpm vsix` and check `bin/` directory

### Runtime Issues

- **Extension Won't Load**: Check VS Code extension logs, verify bundle exists
- **Webview Blank**: Verify webview build completed, check browser console
- **API Errors**: Check if API keys are configured (see `.env.sample`)

### Development Environment

- **Node Version Warning**: Safe to ignore version mismatch (20.19.5 vs 20.19.2)
- **Permission Issues**: Ensure pnpm has write access to workspace
- **Cache Issues**: Run `pnpm clean` then `pnpm install` to reset

## Performance Notes

### Build Times (Measured)

- **Dependencies**: ~1m 9s (pnpm install)
- **Full Build**: ~2m first time, ~2s cached (pnpm bundle)
- **Extension Only**: ~3s (pnpm --filter="roo-cline" bundle - needs deps)
- **Webview Build**: ~40s (React compilation)
- **Full Test Suite**: ~3m 15s (comprehensive testing)
- **VSIX Package**: ~2m (production build with all dependencies)
- **Linting**: ~22s (all packages)
- **Type Checking**: ~1m 9s (all packages)

### Optimization Tips

- **Development**: Use `pnpm bundle` - turbo caching makes subsequent builds fast (~2s)
- **Fresh Builds**: First build takes ~2m, but subsequent builds are cached
- **Iteration**: Focus on `pnpm bundle` for quick extension + webview builds
- **Testing**: Use `pnpm --filter="roo-cline" test` for extension-specific tests
- **CI Prep**: Run `pnpm lint && pnpm format` before push

---

## Quick Reference Commands

```bash
# Setup
pnpm install                                    # ~1m 9s - Install all dependencies

# Development
pnpm bundle                                     # ~2m first time, ~2s cached - Full build
pnpm --filter="roo-cline" bundle               # ~3s - Extension only (needs deps built)
pnpm --filter @roo-code/vscode-webview build   # ~40s - Build webview UI
pnpm --filter="roo-cline" test                 # ~1m - Test extension only

# Quality Assurance
pnpm lint                                       # ~22s - Lint all packages
pnpm format                                     # ~17s - Format all code
pnpm check-types                                # ~1m 9s - TypeScript check

# Release
pnpm vsix                                       # ~2m - Build VSIX package

# Debug
code --extensionDevelopmentPath=./src           # Run extension in new VS Code window
```

Remember: **NEVER CANCEL** long-running commands. Builds may take several minutes, and canceling can corrupt the build state.
