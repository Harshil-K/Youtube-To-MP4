# syntax=docker/dockerfile:1

# Stage 1 – Build frontend
FROM node:20 as frontend-builder
WORKDIR /app
COPY Frontend/my-youtube-app/ ./
RUN npm install && npm run build

# Stage 2 – Backend with FastAPI and ffmpeg
FROM python:3.12-slim

RUN apt-get update && apt-get install -y ffmpeg

WORKDIR /app
COPY Backend ./Backend
COPY Backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy frontend build from stage 1
COPY --from=frontend-builder /app/dist ./frontend

EXPOSE 8000

CMD ["uvicorn", "Backend.main:app", "--host", "0.0.0.0", "--port", "8000"]
