# Use the official .NET SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Copy the source code to the container's directory
COPY . ./Vehicle-Web-App

# Restore the dependencies specified in the .csproj files
RUN dotnet restore ./Vehicle-Web-App

# Build the application in release mode
RUN dotnet build ./Vehicle-Web-App --configuration Release

# Publish the application
RUN dotnet publish ./Vehicle-Web-App --configuration Release --output /app/publish

# Use the official .NET runtime image for running the application
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Copy the published files from the build image
COPY --from=build /app/publish /app

# Set the working directory
WORKDIR /app

# Expose the port the app will run on
EXPOSE 7066

# Command to run the application
CMD ["dotnet", "VehicleRegistrationWebApp.dll"]
