FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /VehicleRegistrationWebApp

COPY . ./

WORKDIR /

RUN dotnet restore

RUN dotnet publish -c Release -o /WebApp/out

EXPOSE 7066

ENTRYPOINT [ "dotnet", "/WebApp/out/VehicleRegistration_WebApp.dll" ]