# UI Garden - Assignment 13: Code Quality Checks

Jashwanth Kopparthi

This is the UI Garden component library from Assignment 12 (React, TypeScript, styled-components, Storybook, Create React App) with code quality checks added to the build process:

- **Prettier**, **ESLint** and **Jest tests** run automatically before every commit using **Husky**.
- The same checks run again on GitHub using **GitHub Actions**, so bypassing the local hook still fails the build.
- A **Dockerfile** builds the production site and serves it at http://localhost:8018.

## Run with Docker (localhost:8018)

Build the image:

```
docker build -t kopparthi_jashwanth_ui_garden_build_checks .
```

Run the container (named as required by the assignment):

```
docker run -d --name kopparthi_jashwanth_coding_assignment13 -p 8018:8018 kopparthi_jashwanth_ui_garden_build_checks
```

Open http://localhost:8018 (or http://127.0.0.1:8018).

Stop and remove it:

```
docker stop kopparthi_jashwanth_coding_assignment13
docker rm kopparthi_jashwanth_coding_assignment13
```

How the Dockerfile works:

1. Stage 1 (`node:20-alpine`) runs `npm ci --ignore-scripts` (Husky is skipped because the image has no `.git`) and `npm run build` to create the production build.
2. Stage 2 (`nginx:1.27-alpine`) copies the build into the working directory `/kopparthi_jashwanth_ui_garden_build_checks`, and `nginx.conf` serves that folder on port 8018.

## Run locally without Docker

```
git clone https://github.com/jkopparthi/kopparthi_jashwanth_ui_garden_build_checks.git
cd kopparthi_jashwanth_ui_garden_build_checks
npm install
npm start
```

`npm install` also runs the `prepare` script, which installs the Husky git hooks. Storybook still works with `npm run storybook` (http://localhost:6006).

## Scripts

| Script                 | What it does                                                        |
| ---------------------- | ------------------------------------------------------------------- |
| `npm run format:check` | Prettier check (fails if any file is not formatted)                 |
| `npm run format`       | Prettier auto-fix                                                   |
| `npm run lint`         | ESLint on `src/**/*.{ts,tsx}` with `--max-warnings=0`               |
| `npm run test:ci`      | Runs all tests once (`CI=true react-scripts test --watchAll=false`) |
| `npm run check`        | Runs all three checks, the same as the hook and CI                  |

## Steps I followed

1. Copied the Assignment 12 project into a new repo `kopparthi_jashwanth_ui_garden_build_checks`.
2. Installed the tools: `npm i -D prettier eslint-config-prettier husky`.
3. **Prettier:** added `.prettierrc` and `.prettierignore`, then ran `npm run format` once to format the whole codebase.
4. **ESLint:** extended `react-app`, `react-app/jest` and `prettier` in `package.json` (`eslintConfig`) so ESLint and Prettier do not conflict. `--max-warnings=0` makes warnings fail too.
5. **Husky:** added `"prepare": "husky"` to `package.json`, ran `npx husky`, and wrote `.husky/pre-commit` (below).
6. **GitHub Actions:** added `.github/workflows/ci.yml`.
7. **Docker:** changed the port to 8018 in `Dockerfile` and `nginx.conf`, and renamed the working directory.

## Husky pre-commit hook

`.husky/pre-commit` runs these in order and stops the commit if any of them fails:

1. `npm run format:check` (Prettier)
2. `npm run lint` (ESLint)
3. `npm run test:ci` (tests)

### Demo: the hook blocks bad commits

Prettier:

```
echo "const   x  =  1" >> src/index.tsx
git commit -am "bad format"      # rejected: Prettier check failed
git checkout src/index.tsx
```

ESLint (an unused variable is a warning, which fails because of `--max-warnings=0`):

```
echo "export const f = () => { const unused = 1; };" >> src/App.tsx
npx prettier --write src/App.tsx
git commit -am "bad lint"        # rejected: ESLint check failed
git checkout src/App.tsx
```

Tests (change an expected value, for example the colour in `src/components/Button/Button.tests.tsx`):

```
git commit -am "bad test"        # rejected: Tests failed
git checkout src/components/Button/Button.tests.tsx
```

## GitHub Actions

Workflow file: `.github/workflows/ci.yml` (name: **Code Quality Checks**). It runs on every push and pull request and does:

1. `npm ci`
2. Prettier check
3. ESLint
4. Tests
5. Production build

If any step fails, the run is marked failed (red X on the commit or pull request) and GitHub emails the person who pushed, so the user is notified that the build failed.

### Demo: bypass the local hook

```
echo "const   x  =  1" >> src/index.tsx
git commit --no-verify -am "bypass hook"
git push
```

Open the repo's **Actions** tab to see the failed "Code Quality Checks" run. To prevent merging, turn on branch protection for `main` and require the `quality-checks` status check.

## Components

Button, Label, Text, Table, TableHeader, TableRow, TableCell, TableFooter, Dropdown, RadioButton, Img, HeroImage and Card. Each has a default and a disabled state, with stories and 2 tests each (27 tests in total).
