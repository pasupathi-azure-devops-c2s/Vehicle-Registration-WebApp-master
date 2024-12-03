
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

COPY . ./Vehicle-Web-App

RUN dotnet restore ./Vehicle-Web-App/VehicleRegistration.WebAPI/VehicleRegistration.WebAPI.csproj

RUN dotnet publish ./Vehicle-Web-App/VehicleRegistration.WebAPI/VehicleRegistration.WebAPI.csproj --configuration Release --output /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

COPY --from=build /app/publish /app

WORKDIR /app

EXPOSE 7095

CMD ["dotnet", "VehicleRegistration.WebAPI.dll", "--urls", "http://0.0.0.0:7095"]
