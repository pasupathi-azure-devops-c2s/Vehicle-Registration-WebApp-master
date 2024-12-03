# Use the official .NET SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

# Copy the project files for each part of the application and restore dependencies
COPY ["VehicleRegistration.WebAPI/VehicleRegistration.WebAPI.csproj", "VehicleRegistration.WebAPI/"]
COPY ["VehicleRegistration.Core/VehicleRegistration.Core.csproj", "VehicleRegistration.Core/"]
COPY ["VehicleRegistration.Infrastructure/VehicleRegistration.Infrastructure.csproj", "VehicleRegistration.Infrastructure/"]
COPY ["VehicleRegistration.Manager/VehicleRegistration.Manager.csproj", "VehicleRegistration.Manager/"]
COPY ["VehicleRegistrationWebApp/VehicleRegistrationWebApp.csproj", "VehicleRegistrationWebApp/"]

# Restore the NuGet packages
RUN dotnet restore "VehicleRegistration.WebAPI/VehicleRegistration.WebAPI.csproj"

# Copy the rest of the code (after restore)
COPY . .

# Build the application in Release mode and output to /app/build
WORKDIR /src/VehicleRegistration.WebAPI
RUN dotnet build "VehicleRegistration.WebAPI.csproj" -c Release -o /app/build

# Publish the application to a folder for the runtime (optimized for container deployment)
RUN dotnet publish "VehicleRegistration.WebAPI.csproj" -c Release -o /app/publish

# Use the .NET runtime image for the final stage (runtime image is smaller than SDK)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base

WORKDIR /app

# Expose the necessary port (make sure the Web API listens on this port)
EXPOSE 7095/swagger/index.html

# Copy the built and published application from the build stage
COPY --from=build /app/publish .

# Set the environment variable to ensure ASP.NET Core listens on the desired port and all interfaces
ENV ASPNETCORE_URLS=http://+:7095

# Set the entry point to run the Web API
ENTRYPOINT ["dotnet", "VehicleRegistration.WebAPI.dll"]
