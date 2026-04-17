Scan workspace, detect tech stack, and generate project-specific configuration.

Usage: /nng-init-nanang-ai

## Steps

### 1. Detect Tech Stack

Scan project root for these files (check all in parallel):

**Package managers & languages:**
- `package.json` → Node.js (check for React, Vue, Svelte, Angular, Next.js, Nuxt, etc.)
- `requirements.txt` / `pyproject.toml` / `setup.py` / `Pipfile` → Python
- `go.mod` → Go
- `Cargo.toml` → Rust
- `pom.xml` / `build.gradle` / `build.gradle.kts` → Java/Kotlin
- `Gemfile` → Ruby
- `composer.json` → PHP
- `pubspec.yaml` → Dart/Flutter
- `*.csproj` / `*.sln` → C#/.NET

**Frameworks (from package.json dependencies):**
- `react`, `react-dom` → React
- `react-native`, `expo` → React Native
- `next` → Next.js
- `vue` → Vue
- `svelte` / `@sveltejs/kit` → Svelte/SvelteKit
- `angular` → Angular
- `express` / `fastify` / `hono` / `nestjs` → Node backend
- `django` / `flask` / `fastapi` → Python backend

**Linters & formatters:**
- `.eslintrc*` / `eslint.config.*` → ESLint (read config for rules)
- `.prettierrc*` / `prettier.config.*` → Prettier
- `biome.json` → Biome
- `ruff.toml` / `pyproject.toml [tool.ruff]` → Ruff
- `.rubocop.yml` → RuboCop
- `rustfmt.toml` → Rustfmt

**Test frameworks:**
- `vitest` in deps → Vitest
- `jest` in deps → Jest
- `pytest` / `pyproject.toml [tool.pytest]` → Pytest
- `_test.go` files → Go test
- `rspec` in Gemfile → RSpec
- `phpunit` → PHPUnit

**Build tools:**
- `vite.config.*` → Vite
- `webpack.config.*` → Webpack
- `turbo.json` → Turborepo
- `nx.json` → Nx
- `Makefile` → Make
- `Dockerfile` → Docker

**Other config:**
- `tsconfig.json` → TypeScript (read strict mode, paths)
- `.env*` → Environment variables
- `docker-compose.yml` → Docker Compose
- `vercel.json` / `vercel.ts` → Vercel deployment
- `netlify.toml` → Netlify
- `.github/workflows/` → GitHub Actions CI

### 2. Generate Code Style Rules

Create `.claude/rules/nng-code-style.md` based on detected stack:

- If ESLint/Biome detected → extract key rules (semicolons, quotes, trailing commas)
- If Prettier detected → extract formatting preferences
- If TypeScript → note strict mode, path aliases
- If no linter → generate sensible defaults for detected language
- Include language-specific conventions (naming, imports, etc.)

### 3. Generate Testing Rules

Create `.claude/rules/nng-testing.md` based on detected test framework:

- Test runner command
- Test file location pattern (colocated vs `__tests__/` vs `test/`)
- Naming conventions
- Common mocking patterns for the framework
- Coverage command if available

### 4. Generate Verify Command

Create `.claude/commands/nng-verify.md` that runs the project's specific commands:

```markdown
Run project verification: lint + typecheck + test.

## Steps
1. Run lint: `{detected lint command}`
2. Run typecheck: `{detected typecheck command}`
3. Run tests: `{detected test command}`

Report results. Stop on first failure.
```

### 5. Detect Project Structure

Analyze directory structure and note:
- Source directory (`src/`, `app/`, `lib/`, etc.)
- Monorepo structure if present (packages/, apps/)
- API routes location
- Component structure pattern

### 6. Update CLAUDE.md

Append detected configuration below the `<!-- GENERATED SECTION -->` marker:

```markdown
## Tech Stack
- **Language**: {detected}
- **Framework**: {detected}
- **Build**: {detected}
- **Test**: {detected}
- **Lint**: {detected}

## Project Structure
{detected structure summary}

## Run Commands
- Dev: `{detected dev command}`
- Build: `{detected build command}`
- Test: `{detected test command}`
- Lint: `{detected lint command}`
```

### 7. Report

Output summary:
- Detected stack
- Generated files (list)
- Suggested next steps (e.g., "review generated rules", "customize code-style.md")

## Rules
- NEVER overwrite existing rules — if `.claude/rules/nng-code-style.md` already exists, ask before replacing
- If detection is ambiguous (multiple frameworks), ask user which is primary
- Keep generated files concise — rules, not documentation
- All output in English
