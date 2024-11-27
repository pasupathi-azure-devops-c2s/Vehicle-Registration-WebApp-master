# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory in the container
WORKDIR /app

# Copy only the necessary project files to optimize build layers
COPY VehicleRegistrationWebApp/*.csproj ./VehicleRegistrationWebApp/
COPY VehicleRegistrationWebApp/VehicleRegistrationWebApp.csproj ./  

# Restore the application dependencies
RUN dotnet restore

# Install EF tools locally to the project directory
RUN dotnet tool install dotnet-ef --local

# Copy the rest of the application files into the container
COPY . ./

# Apply database migrations using the locally installed EF tool
RUN ./dotnet-tools/.store/dotnet-ef/8.0.0/tools/net8.0/dotnet-ef database update --project /app/VehicleRegistrationWebApp/VehicleRegistrationWebApp.csproj

# Build the application in Release mode
RUN dotnet build -c Release

# Expose the port that the application will run on
EXPOSE 7066

# Set the entry point for the container to run the web application
ENTRYPOINT ["dotnet", "VehicleRegistrationWebApp.dll"]
