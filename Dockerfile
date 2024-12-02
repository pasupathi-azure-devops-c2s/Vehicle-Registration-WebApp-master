# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the solution file and restore the dependencies
COPY . ./
# Restore all dependencies
RUN dotnet restore

# Install the Entity Framework Core tools globally
RUN dotnet tool install --global dotnet-ef --version 9.0.0

# Add the .NET tools to the PATH
ENV PATH="$PATH:/root/.dotnet/tools"

# Copy the rest of the source code into the container
COPY . .

# Set the working directory to the WebAPI project and run database migrations
WORKDIR /app/VehicleRegistration.WebAPI

# Apply migrations to the database
RUN dotnet ef database update 

# Build the application
RUN dotnet build -c Release

# Publish the application to the /out directory
RUN dotnet publish -c Release -o /out

# Stage 2: Runtime (Final image for running the app)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base

# Set the working directory for the app in the final container
WORKDIR /app

# Copy the published app from the build container
COPY --from=build /out .

# Expose the port that the application will run on
EXPOSE 7095

# Set the entry point for the container to run the web application
ENTRYPOINT ["dotnet", "VehicleRegistrationWebAPI.dll"]