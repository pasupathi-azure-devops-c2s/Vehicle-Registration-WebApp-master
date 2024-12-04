
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

COPY . ./app/Vehicle-Web-App

RUN dotnet restore ./Vehicle-Web-App

RUN dotnet publish ./Vehicle-Web-App/VehicleRegistrationWebApp/VehicleRegistrationWebApp.csproj --configuration Release --output /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

COPY --from=build /app/publish /app

WORKDIR /app

EXPOSE 7066

CMD ["dotnet", "VehicleRegistrationWebApp.dll", "--urls", "http://0.0.0.0:7066"]
