# Start from a Go base image
FROM golang:1.16 AS builder

# Set the working directory
WORKDIR /app

# Copy the Go module files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# Start from a minimal base image
FROM alpine:latest

# Set the working directory
WORKDIR /app

# Copy the built Go application from the previous stage
COPY --from=builder /app/app .

# Expose the port on which the application listens
EXPOSE 8080

# Define the command to run the application
CMD ["./app"]

