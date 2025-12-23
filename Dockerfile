FROM node:18-alpine AS builder
WORKDIR /app

# Cài dependency
COPY package*.json ./
RUN npm install

# Copy source và build
COPY . .
RUN npm run build

# Runtime stage tối giản
FROM node:18-alpine AS runner
WORKDIR /app

# Chỉ cần dependency runtime
COPY --from=builder /app/package*.json ./
RUN npm install --omit=dev

# Copy code đã build và file cần thiết
COPY --from=builder /app/dist ./dist

ENV NODE_ENV=production
EXPOSE 3000

CMD ["node", "--require", "./dist/tracing.js", "./dist/index.js"]