# Stage 1: Build Angular app
FROM node:24-alpine AS builder

WORKDIR /app
COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build -- --configuration=production


# Stage 2: Serve with Nginx
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/dist/* /usr/share/nginx/html/

# Copy custom nginx config (optional, for SPA routing)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
