FROM node:18-alpine AS builder
WORKDIR /app

# Cài dependency
COPY package*.json ./
RUN npm ci

# Copy source và buildss
COPY . .
RUN npm run build

# Runtime stage tối giản
FROM node:18-alpine AS runner
WORKDIR /app

# Chỉ cần dependency runtime
COPY --from=builder /app/package*.json ./
RUN npm ci --omit=dev

# Copy code đã build và file cần thiết
COPY --from=builder /app/dist ./dist

ENV NODE_ENV=production
EXPOSE 3000

CMD ["node", "./dist/index.js"]