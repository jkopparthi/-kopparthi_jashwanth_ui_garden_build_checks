# ---------- Stage 1: build the production bundle of the Create React App ----------
FROM node:20-alpine AS build
WORKDIR /app

COPY package.json package-lock.json .npmrc ./
# --ignore-scripts skips Husky's "prepare" script (there is no .git inside the image)
RUN npm ci --ignore-scripts

COPY . .
RUN npm run build

# ---------- Stage 2: serve the production build with nginx on port 8018 ----------
FROM nginx:1.27-alpine

# Site files are hosted from the working directory kopparthi_jashwanth_ui_garden_build_checks
WORKDIR /kopparthi_jashwanth_ui_garden_build_checks
COPY --from=build /app/build .

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8018
CMD ["nginx", "-g", "daemon off;"]
