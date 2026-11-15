# UI Garden - Assignment 13

Jashwanth Kopparthi

This is my UI Garden component library from Assignment 12 with code quality checks added. Prettier, ESLint and the tests run before every commit using Husky, and again on GitHub using GitHub Actions.

## Run with Docker

Build the image:

```
docker build -t kopparthi_jashwanth_ui_garden_build_checks .
```

Run the container:

```
docker run -d --name kopparthi_jashwanth_coding_assignment13 -p 8018:8018 kopparthi_jashwanth_ui_garden_build_checks
```

Open http://localhost:8018 in the browser.

The Dockerfile builds the production build of the Create React App, then serves it with nginx on port 8018 from the working directory `kopparthi_jashwanth_ui_garden_build_checks`.

## Steps I did

1. Copied my Assignment 12 project into a new repo.
2. Installed the tools: `npm i -D prettier eslint-config-prettier husky`
3. Added Prettier (`.prettierrc`) and formatted the code with `npm run format`.
4. Added `prettier` to the ESLint config in `package.json` and set lint to fail on warnings.
5. Ran `npx husky` and added `.husky/pre-commit` to run Prettier, ESLint and the tests.
6. Added a GitHub Actions workflow in `.github/workflows/ci.yml`.
7. Changed the Dockerfile and nginx config to use port 8018.

## Husky pre-commit

Before each commit, `.husky/pre-commit` runs `npm run format:check`, `npm run lint` and `npm run test:ci`. If one fails, the commit is blocked.

To test it, make a badly formatted change and try to commit. The commit should be rejected with "Prettier check failed".

## GitHub Actions

The workflow runs on every push and pull request. It installs the packages, then runs Prettier, ESLint, the tests and the build. If a step fails, the run shows a red X in the Actions tab and GitHub sends an email. This catches code that was committed with `git commit --no-verify`.

## Run the checks manually

```
npm install
npm run check
```