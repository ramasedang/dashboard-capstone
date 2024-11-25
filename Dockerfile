# Step 1: Set up the base image with Node.js on Alpine
FROM node:18-alpine AS builder

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Install pnpm
RUN npm install -g pnpm

# Step 4: Copy package.json and pnpm-lock.yaml (if applicable) to the container
COPY package.json pnpm-lock.yaml* ./

# Step 5: Install dependencies using pnpm
RUN pnpm install --frozen-lockfile

# Step 6: Copy the rest of the application files
COPY . .

# Step 7: Build the application for production
RUN pnpm build

# Step 8: Set up the production environment
FROM node:18-alpine AS runner

# Step 9: Set the working directory inside the container
WORKDIR /app

# Step 10: Copy only necessary files from the builder image
COPY --from=builder /app /app

# Step 11: Expose port 3441 for the Nuxt app
EXPOSE 3441

# Step 12: Command to start the application
CMD ["pnpm", "preview", "--port", "3441"]
