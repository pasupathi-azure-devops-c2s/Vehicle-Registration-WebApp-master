# Use the official .NET SDK image for building the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Copy the source code into the container's directory
COPY . ./Vehicle-Web-App

# Restore the dependencies for the VehicleRegistration.WebAPI project
RUN dotnet restore ./Vehicle-Web-App

# Install the .NET EF CLI tool (needed for database migrations)
# We use this method to ensure the tool is installed in the correct location
RUN dotnet tool install --global dotnet-ef --version 9.0.0

# Set the PATH to include the .NET tools
ENV PATH="$PATH:/root/.dotnet/tools"

# Apply database migrations using EF Core (Ensure this command is relevant to your app setup)
RUN dotnet ef database update --project ./Vehicle-Web-App

# Build the application in release mode and output to /app/publish directory
RUN dotnet publish ./Vehicle-Web-App/VehicleRegistration.WebAPI/VehicleRegistration.WebAPI.csproj --configuration Release --output /app/publish

# Use the official .NET runtime image for running the application
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Copy the published application from the build stage into the runtime container
COPY --from=build /app/publish /app

# Set the working directory to the location where the app is copied
WORKDIR /app

# Expose port 7095 to allow access to the application
EXPOSE 7095

# Define the entry point to run the application on http://0.0.0.0:7095
CMD ["dotnet", "VehicleRegistration.WebAPI.dll", "--urls", "http://0.0.0.0:7095"]
