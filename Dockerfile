# syntax=docker/dockerfile:1

# syntax=docker/dockerfile:1

###########################
# Stage 1 – Build React frontend
###########################
FROM node:20 as frontend-builder

# Set working directory
WORKDIR /app

# Copy necessary files
COPY ./Frontend/my-youtube-app/package.json ./package.json
COPY ./Frontend/my-youtube-app/package-lock.json ./package-lock.json
COPY ./Frontend/my-youtube-app/public ./public
COPY ./Frontend/my-youtube-app/src ./src

# Install and build
RUN npm install && npm run build

###########################
# Stage 2 – Backend with FastAPI + ffmpeg
###########################
FROM python:3.12-slim

# Install ffmpeg
RUN apt-get update && apt-get install -y ffmpeg

# Set backend work directory
WORKDIR /app

# Copy backend source code
COPY ./Backend ./Backend
COPY ./Backend/requirements.txt .

# Install backend dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy built frontend from previous stage
COPY --from=frontend-builder /app/build ./frontend

# Expose FastAPI port
EXPOSE 8000

# Start FastAPI app
CMD ["uvicorn", "Backend.main:app", "--host", "0.0.0.0", "--port", "8000"]
