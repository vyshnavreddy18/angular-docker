# Stage 1: Build
FROM node:16-alpine AS builder

WORKDIR /awesome-ng

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# For Angular 9–11 only (safe to keep if unsure)
RUN npx ngcc --properties es2015 --create-ivy-entry-points

# Copy app source
COPY . .

# ✅ Correct build command
RUN npx ng build --configuration production

# Stage 2: Nginx
FROM nginx:alpine

# Copy nginx config
COPY ./nginx.conf /etc/nginx/nginx.conf

# Clean default nginx html folder
RUN rm -rf /usr/share/nginx/html/*

# Copy built Angular files
COPY --from=builder /awesome-ng/dist/awesome-ng /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
