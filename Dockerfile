# syntax=docker/dockerfile:1

# Stage 1: Build React frontend
FROM node:20 as frontend-builder
WORKDIR /app
COPY frontend ./frontend
WORKDIR /app/frontend
RUN npm install && npm run build

# Stage 2: Build FastAPI backend
FROM python:3.12-slim

# Install ffmpeg system-wide
RUN apt-get update && apt-get install -y ffmpeg

# Copy backend code
WORKDIR /app
COPY backend ./backend
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy built frontend from previous stage
COPY --from=frontend-builder /app/frontend/dist ./frontend

# Expose FastAPI port
EXPOSE 8000

CMD ["uvicorn", "backend.main:app", "--host", "0.0.0.0", "--port", "8000"]
