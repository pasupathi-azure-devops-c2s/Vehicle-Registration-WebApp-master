# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the project files into the container
COPY . ./

# Restore the application dependencies
RUN dotnet restore

# Create the tool manifest (needed for installing local tools)
RUN dotnet new tool-manifest

# Install EF tools locally to the project directory
RUN dotnet tool install dotnet-ef --local

# Apply database migrations using the locally installed EF tool
RUN dotnet-ef database update --project /app/VehicleRegistrationWebApp/VehicleRegistrationWebApp.csproj

# Build the application in Release mode
RUN dotnet build -c Release

# Expose the port that the application will run on
EXPOSE 7066

# Set the entry point for the container to run the web application
ENTRYPOINT ["dotnet", "VehicleRegistrationWebApp.dll"]
