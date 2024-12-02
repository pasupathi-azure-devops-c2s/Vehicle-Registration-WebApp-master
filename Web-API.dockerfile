# Use the official .NET SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

# Copy the VehicleRegistration.WebAPI project file and restore dependencies
COPY ["VehicleRegistration.WebAPI/VehicleRegistration.WebAPI.csproj", "VehicleRegistration.WebAPI/"]
COPY ["VehicleRegistration.Core/VehicleRegistration.Core.csproj", "VehicleRegistration.Core/"]
COPY ["VehicleRegistration.Infrastructure/VehicleRegistration.Infrastructure.csproj", "VehicleRegistration.Infrastructure/"]
COPY ["VehicleRegistration.Manager/VehicleRegistration.Manager.csproj", "VehicleRegistration.Manager/"]

# Restore the NuGet packages
RUN dotnet restore "VehicleRegistration.WebAPI/VehicleRegistration.WebAPI.csproj"

# Copy the rest of the code
COPY . .

# Set the working directory to the web API project and build it
WORKDIR /src/VehicleRegistration.WebAPI
RUN dotnet build "VehicleRegistration.WebAPI.csproj" -c Release -o /app/build

# Publish the application to a folder for the runtime
RUN dotnet publish "VehicleRegistration.WebAPI.csproj" -c Release -o /app/publish

# Use the .NET runtime image for the final stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 7095

# Copy the published application from the build stage
COPY --from=build /app/publish .

# Set the entry point to run the Web API
ENTRYPOINT ["dotnet", "VehicleRegistration.WebAPI.dll"]
