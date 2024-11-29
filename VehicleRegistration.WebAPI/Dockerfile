# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory in the container
WORKDIR /app


# Restore the dependencies (this includes Core, Manager, Infrastructure)
RUN dotnet restore VehicleRegistration.WebAPI/VehicleRegistration.WebAPI.csproj

# Copy all the source code files
COPY . .

# Publish the app to a folder in the container
RUN dotnet publish VehicleRegistration.WebAPI/VehicleRegistration.WebAPI.csproj -c Release -o /app/publish

# Use the official .NET runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

# Set the working directory in the runtime container
WORKDIR /app

# Copy the published app from the build container
COPY --from=build /app/publish .

# Expose the port the app will run on
EXPOSE 7095

# Set the entry point to the web API
ENTRYPOINT ["dotnet", "VehicleRegistration.WebAPI.dll"]
