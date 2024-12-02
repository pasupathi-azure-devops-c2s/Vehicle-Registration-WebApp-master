# Use the official .NET SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

# Copy the VehicleRegistration.WebApp project file and restore dependencies
COPY ["VehicleRegistration.WebAPI/VehicleRegistration.WebAPI.csproj", "VehicleRegistration.WebAPI/"]
COPY ["VehicleRegistration.Core/VehicleRegistration.Core.csproj", "VehicleRegistration.Core/"]
COPY ["VehicleRegistration.Infrastructure/VehicleRegistration.Infrastructure.csproj", "VehicleRegistration.Infrastructure/"]
COPY ["VehicleRegistration.Manager/VehicleRegistration.Manager.csproj", "VehicleRegistration.Manager/"]
COPY ["VehicleRegistrationWebApp/VehicleRegistrationWebApp.csproj", "VehicleRegistrationWebApp/"]
# Restore the NuGet packages
RUN dotnet restore "VehicleRegistration.WebApp/VehicleRegistrationWebApp.csproj"

# Copy the rest of the code
COPY . .

# Set the working directory to the web app project and build it
WORKDIR /src/VehicleRegistration.WebApp
RUN dotnet build "VehicleRegistrationWebApp.csproj" -c Release -o /app/build

# Publish the application to a folder for the runtime
RUN dotnet publish "VehicleRegistrationWebApp.csproj" -c Release -o /app/publish

# Use the .NET runtime image for the final stage
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 7066

# Copy the published application from the build stage
COPY --from=build /app/publish .

# Set the entry point to run the Web App
ENTRYPOINT ["dotnet", "VehicleRegistrationWebApp.dll"]
