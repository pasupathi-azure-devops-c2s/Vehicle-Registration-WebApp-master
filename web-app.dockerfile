
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

COPY . ./app/Vehicle-Web-App

RUN dotnet restore ./app/Vehicle-Web-App

RUN dotnet publish ./app/Vehicle-Web-App/VehicleRegistrationWebApp/VehicleRegistrationWebApp.csproj --configuration Release --output /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

COPY --from=build /app/publish /app

ENV ApiBaseAddress="http://3.110.56.89:7095/"

WORKDIR /app

EXPOSE 7066

ENTRYPOINT ["dotnet", "VehicleRegistrationWebApp.dll"]
