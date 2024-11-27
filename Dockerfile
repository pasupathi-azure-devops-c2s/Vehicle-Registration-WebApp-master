# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the solution file and restore any dependencies (via NuGet)
COPY . ./


# Restore dependencies for both WebApp and Infrastructure (if needed)
RUN dotnet restore

RUN dotnet tool install --global dotnet-ef --version 8.0.0

RUN dotnet --list-sdks

RUN dotnet tool list --global

RUN dotnet ef database update --project /VehicleRegistration.WebAPI/VehicleRegistration.WebAPI.csproj



# Copy the rest of the application files into the container
COPY . .

# Publish the app to the /out directory
RUN dotnet publish VehicleRegistrationWebApp/VehicleRegistrationWebApp.csproj -c Release -o /out

# Define the base image to run the app from
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base

# Set the working directory in the container
WORKDIR /app

# Copy the published files from the build container
COPY --from=build /out .

# Expose the port the app will run on (optional, adjust if needed)
EXPOSE 7066

# Set the entry point for the container to run the web application
ENTRYPOINT ["dotnet", "VehicleRegistrationWebApp.dll"]
