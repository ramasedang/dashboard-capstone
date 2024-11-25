# Step 1: Set up the base image with Node.js on Alpine
FROM node:18-alpine AS builder

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy package.json and package-lock.json to the container
COPY package.json package-lock.json* ./

# Step 4: Install dependencies using npm
RUN npm install --production

# Step 5: Copy the rest of the application files
COPY . .

# Step 6: Build the application for production (if needed)
RUN npm run build

# Step 7: Set up the production environment
FROM node:18-alpine AS runner

# Step 8: Set the working directory inside the container
WORKDIR /app

# Step 9: Copy only necessary files from the builder image
COPY --from=builder /app /app

# Step 10: Expose port 3441 for the Nuxt app
EXPOSE 3441

# Step 11: Command to start the application
CMD ["npm", "run", "preview", "--", "--port", "3441"]
