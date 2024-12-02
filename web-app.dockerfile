# Stage 1: Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory in the container
WORKDIR /VehicleRegistrationWebApp

# Copy all the files into the container
COPY . .

# Restore the dependencies
RUN dotnet restore

# Publish the application to the /WebApp/out directory
RUN dotnet publish -c Release -o /WebApp/out

# Stage 2: Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base

# Set the working directory for the app in the container
WORKDIR /app

# Copy the published app from the build container
COPY --from=build /WebApp/out .

# Expose port 7066 for the application
EXPOSE 7066

# Set the entry point to run the app
ENTRYPOINT ["dotnet", "VehicleRegistration_WebApp.dll"]
